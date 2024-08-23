import 'package:flutter/material.dart';
import 'package:myreminder/utils/reminder.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  List reminderList = [
    ['Learn Flutter', false],
    ['Drink Water!', false],
    ['Complete REMINDER APP!', false]
  ];

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
            );
          }),
    );
  }
}
