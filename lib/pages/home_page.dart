import 'package:flutter/material.dart';
import 'package:myreminder/utils/dialog_box.dart';
import 'package:myreminder/utils/reminder.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _controller = TextEditingController();

  List reminderList = [
    ['Learn Flutter', '10:30 AM', false],
    ['Drink Water!', '3:15 PM', false],
  ];

  void checkBoxChanged(int index, bool? value) {
    setState(() {
      reminderList[index][2] = value ?? false;
    });
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
      reminderList.add([task, formattedTime, false]);
    });
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
  }

  void deleteReminder(int index) {
    setState(() {
      reminderList.removeAt(index);
    });
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
            // Allow ListView to take up remaining space
            child: ListView.builder(
              itemCount: reminderList.length,
              itemBuilder: (BuildContext context, index) {
                return Reminder(
                  taskName: reminderList[index][0],
                  taskTime: reminderList[index][1],
                  taskCompleted: reminderList[index][2],
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
