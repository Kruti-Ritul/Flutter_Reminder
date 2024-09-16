import 'dart:async';
import 'package:flutter/material.dart';
import 'package:myreminder/utils/reminder.dart';
import 'package:myreminder/pages/home_page.dart';
import 'package:myreminder/data/database.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class Notifications {
  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static bool _timeZoneInitialized = false;

  //Notification plugin initialization
  static Future init() async {
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      onDidReceiveLocalNotification: (id, title, body, payload) {},
    );
    const LinuxInitializationSettings initializationSettingsLinux =
        LinuxInitializationSettings(defaultActionName: 'Open notification');
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsDarwin,
            linux: initializationSettingsLinux);
    _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {},
    );
    _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  //show a simple notification
  static Future showSimpleNotification({
    required String title,
    required String body,
    required String payload,
  }) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('your channel id', 'your channel name',
            channelDescription: 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await _flutterLocalNotificationsPlugin
        .show(0, title, body, notificationDetails, payload: payload);
  }
/*
  //Periodic Notification at regular intervals
  static Future showperiodicNotifications({
    required String title,
    required String body,
    required String payload,
  }) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('channel 2', 'your channel name',
            channelDescription: 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    try {
      await _flutterLocalNotificationsPlugin.periodicallyShow(
          1, title, body, RepeatInterval.everyMinute, notificationDetails,
          payload: payload);
      print('Periodic notification scheduled successfully');
    } catch (e) {
      print('Error scheduling periodic notification: $e');
    }
    Future.delayed(Duration(seconds: 5));
  }

  */

  static Future<void> checkScheduledNotifications() async {
    final List<PendingNotificationRequest> pendingNotifications =
        await _flutterLocalNotificationsPlugin.pendingNotificationRequests();
    print('Pending notifications: ${pendingNotifications.length}');
    for (var notification in pendingNotifications) {
      print(
          'ID: ${notification.id}, Title: ${notification.title}, Body: ${notification.body}');
    }
  }

  /*

  // Schedule a notification every 10 seconds
  //static Timer? _notificationTimer;
  static void startPeriodicNotifications({
    required String title,
    required String body,
    required String payload,
  }) {
    _notificationTimer =
        Timer.periodic(Duration(minutes: 1), (Timer timer) async {
      await _flutterLocalNotificationsPlugin.show(
        0,
        title,
        body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'Main Channel',
            'your_channel_name',
            channelDescription: 'your_channel_description',
            importance: Importance.max,
            priority: Priority.high,
            //ticker: 'ticker',
            playSound: true,
            enableVibration: true,
          ),
        ),
        payload: payload,
      );
      print('Notification scheduled successfully every 10 seconds');
    });
  }

*/

  // close a specific channel notification

  static Future<void> cancel(int id) async {
    await _flutterLocalNotificationsPlugin.cancel(id);
    print('Notification with ID $id canceled');

    //cancelling timer to stop future notifications
    _notificationTimer?.cancel(); //stops the periodic timer
    _notificationTimer = null; //resets timer object
  }

  //Cancel all Notification (i will use this in future)
  static Future cancelAll() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
    _notificationTimer?.cancel();
    _notificationTimer = null;
  }

/*
  //schedule a local Notification
  static void scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
    required String payload,
  }) async {
    //ensure timezone initialization during start of the app
    if (!_timeZoneInitialized) {
      tz.initializeTimeZones();
      _timeZoneInitialized = true;
    }

    final tz.TZDateTime tzScheduledTime =
        tz.TZDateTime.from(scheduledTime, tz.local);

    const String notificationChannelId = 'my_channel_id';

    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      notificationChannelId,
      'my_channel_name',
      channelDescription: 'your_channel_description',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      playSound: true,
      enableVibration: true,
    );

    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tzScheduledTime,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: payload,
      matchDateTimeComponents: DateTimeComponents.time,
    );
    print('Notifications scheduled for $scheduledTime');
    print('Notification Channel ID: $notificationChannelId');
  }
*/

// Another try on scheduled notifications

  static int _secondsUntilNextOccurrence(DateTime scheduledTime) {
    final now = DateTime.now();
    DateTime targetTime = DateTime(
        now.year, now.month, now.day, scheduledTime.hour, scheduledTime.minute);

    // If the scheduled time has already passed today, schedule for tomorrow
    if (targetTime.isBefore(now)) {
      targetTime = targetTime.add(Duration(days: 1));
    }

    return targetTime.difference(now).inSeconds;
  }

  static Timer? _notificationTimer;

  static void startPeriodicscheduledNotifications({
    required int id,
    required String title,
    required String body,
    required String payload,
    required DateTime scheduledTime,
  }) {
    final secondsUntilNextOccurrence =
        _secondsUntilNextOccurrence(scheduledTime);

    // Schedule the first notification
    Timer(Duration(seconds: secondsUntilNextOccurrence), () async {
      await _flutterLocalNotificationsPlugin.show(
        id,
        title,
        body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'Main Channel',
            'your_channel_name',
            channelDescription: 'your_channel_description',
            importance: Importance.max,
            priority: Priority.high,
            playSound: true,
            enableVibration: true,
          ),
        ),
        payload: payload,
      );
      print(
          'Notification scheduled successfully for ${scheduledTime.hour}:${scheduledTime.minute}');
    });

    // Set up periodic notifications to repeat daily
    _notificationTimer = Timer.periodic(Duration(days: 1), (Timer timer) async {
      await _flutterLocalNotificationsPlugin.show(
        id,
        title,
        body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'Main Channel',
            'your_channel_name',
            channelDescription: 'your_channel_description',
            importance: Importance.max,
            priority: Priority.high,
            playSound: true,
            enableVibration: true,
          ),
        ),
        payload: payload,
      );
      print(
          'Notification scheduled successfully every day at ${scheduledTime.hour}:${scheduledTime.minute}');
    });
  }
}
