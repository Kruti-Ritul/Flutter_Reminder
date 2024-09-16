import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:myreminder/data/database.dart';
import 'package:myreminder/utils/dialog_box.dart';
import 'package:myreminder/utils/notifications.dart';
import 'package:myreminder/utils/reminder.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _myBox = Hive.box('mybox');
  ReminderDataBase db = ReminderDataBase();

  @override
  void initState() {
    super.initState();
    if (_myBox.get("ReminderList") == null) {
      db.createInitialData();
    } else {
      db.loadData();
    }
  }

  void checkBoxChanged(int index, bool? value) {
    print('Index: $index, Value: $value');
    setState(() {
      db.reminderList[index][4] = value ?? false;
    });

    int reminderId = db.reminderList[index][3];

    // If the task is completed (checked), cancel the notification
    if (db.reminderList[index][4]) {
      Notifications.cancel(reminderId);
    } else {
      // If the task is unchecked, re-enable the notification
      String taskName = db.reminderList[index][0];
      String taskTime = db.reminderList[index][1];
      String taskDate = db.reminderList[index][2];

      // Convert the stored date and time back to DateTime objects
      List<String> timeParts = taskTime.split(":");
      int hour = int.parse(timeParts[0]);
      int minute = int.parse(timeParts[1].split(' ')[0]);
      bool isPM = timeParts[1].contains("PM");

      if (isPM && hour != 12) hour += 12;
      if (!isPM && hour == 12) hour = 0;

      List<String> dateParts = taskDate.split("-");
      int day = int.parse(dateParts[0]);
      int month = int.parse(dateParts[1]);
      int year = int.parse(dateParts[2]);

      DateTime scheduledTime = DateTime(year, month, day, hour, minute);

      // Schedule the notification again
      Notifications.startPeriodicscheduledNotifications(
        id: reminderId,
        title: taskName,
        body: 'Reminder to complete daily task',
        payload: "This is periodic data",
        scheduledTime: scheduledTime,
      );
    }

    db.updateDataBase();
  }

  String formatTimeOfDay(TimeOfDay time) {
    final now = DateTime.now();
    final formattedTime =
        DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return formattedTime.hour > 12
        ? '${formattedTime.hour - 12}:${formattedTime.minute.toString().padLeft(2, '0')} PM'
        : '${formattedTime.hour}:${formattedTime.minute.toString().padLeft(2, '0')} AM';
  }

  String formatDateTime(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
  }

  void addReminder(String task, TimeOfDay time, DateTime date) {
    setState(() {
      String formattedTime = formatTimeOfDay(time);
      String formattedDate = formatDateTime(date);
      int reminderId = db.reminderList.length + 1;
      db.reminderList
          .add([task, formattedTime, formattedDate, reminderId, false]);

      final now = DateTime.now();
      final scheduledTime =
          DateTime(date.day, date.month, date.year, time.hour, time.minute);

      // Adjust notification scheduling based on whether the time is today or tomorrow
      final notificationTime = scheduledTime.isBefore(now)
          ? scheduledTime.add(const Duration(days: 1))
          : scheduledTime;

      //cancel any existing notification with the same ID
      Notifications.cancel(reminderId);

      Notifications.startPeriodicscheduledNotifications(
        id: reminderId,
        title: task,
        body: 'Reminder to complete daily task',
        payload: "This is periodic data",
        scheduledTime: notificationTime,
      );
    });

    Notifications.checkScheduledNotifications();
    db.updateDataBase();
  }

  void createNewReminder() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          onSave: (String task, TimeOfDay time, DateTime date) {
            addReminder(task, time, date);
          },
        );
      },
    );
    db.updateDataBase();
  }

  void deleteReminder(int index) {
    int reminderID = db.reminderList[index][3];
    Notifications.cancel(reminderID); //cancel notification before removing it
    setState(() {
      db.reminderList.removeAt(index);
    });
    db.updateDataBase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text("MY REMINDER"),
        ),
        backgroundColor: Colors.limeAccent[100],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: db.reminderList.length,
              itemBuilder: (BuildContext context, index) {
                print(
                    'Type of reminderId: ${db.reminderList[index][3].runtimeType}');
                return Reminder(
                  taskName: db.reminderList[index][0],
                  taskTime: db.reminderList[index][1],
                  taskDate: db.reminderList[index][2],
                  reminderId: db.reminderList[index][3] as int,
                  taskCompleted: db.reminderList[index][4] as bool,
                  onChanged: (value) => checkBoxChanged(index, value),
                  deleteFunction: (context) => deleteReminder(index),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewReminder,
        child: const Icon(Icons.add),
      ),
    );
  }
}
