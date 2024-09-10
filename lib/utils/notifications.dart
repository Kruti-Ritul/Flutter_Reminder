import 'package:myreminder/utils/reminder.dart';
import 'package:myreminder/pages/home_page.dart';
import 'package:myreminder/data/database.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class Notifications {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Initialize notifications Permission
  static Future<void> initialize() async {
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: AndroidInitializationSettings('mipmap/ic_launcher'),
    );

    await _notificationsPlugin.initialize(initializationSettings);

    if (await _notificationsPlugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()
            ?.areNotificationsEnabled() ==
        false) {
      await _notificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
    }
  }

  Future<void> createNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'channel 2', // id
      'Main Channel', // title
      description:
          'This channel is used for important notifications.', // description
      importance: Importance.max,
    );

    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  // Show a notification immediately
  static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    const NotificationDetails notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'channel 2', // Channel ID
        'Main Channel', // Channel name
        channelDescription: 'Channel for reminders', // Channel description
        importance: Importance.max,
        priority: Priority.high,
        playSound: true, // Play sound on notification
      ),
    );
    //Notifications.showNotification(id: id, title: title, body: body);
    await _notificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails,
    );
  }

  // Schedule a notification for a future time
  static Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
  }) async {
    tz.initializeTimeZones();

    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);

    // Convert scheduledTime to local time zone
    final tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      scheduledTime.year,
      scheduledTime.month,
      scheduledTime.day,
      scheduledTime.hour,
      scheduledTime.minute,
    );

    //if (scheduledDate.isBefore(now)) {
    // If the scheduled time is in the past, don't schedule
    //print(
    //  'Cannot schedule notification in the past. Scheduled time: $scheduledDate, current time: $now');
    //return;
    // }

    print('Scheduling notification with title: $title, at: $scheduledDate');
    print(
        'Notification scheduled for (local time): ${scheduledDate.toLocal()}');
    print('Notification scheduled for (UTC): ${scheduledDate.toUtc()}');

    const NotificationDetails notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'channel 2', // Channel ID
        'Main Channel', // Channel name
        channelDescription: 'Channel for reminders', // Channel description
        importance: Importance.max,
        priority: Priority.high,
        playSound: true, // Play sound on notification
      ),
    );

    await _notificationsPlugin.zonedSchedule(
      2,
      title,
      body,
      scheduledDate,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.wallClockTime,
    );

    print(
        'Notification scheduled for (local time): ${scheduledDate.toLocal()}');
    print('Notification scheduled for (UTC): ${scheduledDate.toUtc()}');
  }
}
