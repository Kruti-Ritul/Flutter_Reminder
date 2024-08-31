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
    ['Learn Flutter', false],
    ['Drink Water!', false],
    //['Complete REMINDER APP!', false]
  ];

  void checkBoxChanged(int index) {
    setState(() {
      reminderList[index][1] = !reminderList[index][1];
    });
  }

  void createNewReminder() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox();
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
      body: ListView.builder(
        itemCount: reminderList.length,
        itemBuilder: (BuildContext context, index) {
          return Reminder(
            taskName: reminderList[index][0],
            taskCompleted: reminderList[index][1],
            onChanged: (value) => checkBoxChanged(index),
            deleteFunction: (context) => deleteReminder(index),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewReminder,
        child: const Icon(Icons.add),
      ),
    );
  }
}
