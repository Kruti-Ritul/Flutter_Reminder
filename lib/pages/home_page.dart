import 'package:flutter/material.dart';
import 'package:myreminder/utils/reminder.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
            );
          }),
    );
  }
}
