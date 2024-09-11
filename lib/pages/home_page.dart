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
    setState(() {
      db.reminderList[index][2] = value ?? false;
    });
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

  void addReminder(String task, TimeOfDay time) {
    setState(() {
      String formattedTime = formatTimeOfDay(time);
      db.reminderList.add([task, formattedTime, false]);

      //final now = DateTime.now();
      //final scheduledTime =
      //DateTime(now.year, now.month, now.day, time.hour, time.minute);

      // Adjust notification scheduling based on whether the time is today or tomorrow
      //final notificationTime = scheduledTime.isBefore(now)
      //? scheduledTime.add(const Duration(days: 1))
      //: scheduledTime;

      Notifications.showperiodicNotifications(
        title: "Periodic",
        body: 'This is Periodic Notification',
        payload: "This is periodic data",
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
          onSave: (String task, TimeOfDay time) {
            addReminder(task, time);
          },
        );
      },
    );
    db.updateDataBase();
  }

  void deleteReminder(int index) {
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
                return Reminder(
                  taskName: db.reminderList[index][0],
                  taskTime: db.reminderList[index][1],
                  taskCompleted: db.reminderList[index][2],
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
