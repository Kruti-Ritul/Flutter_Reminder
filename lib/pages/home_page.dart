import 'package:flutter/material.dart';
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

  void saveNewReminder() {
    setState(() {
      reminderList.add([_controller.text, false]);
      _controller.clear();
    });
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
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: 'Add a New Reminder!',
                    filled: true,
                    fillColor: Colors.grey.shade200,
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),
            ),
            FloatingActionButton(
              onPressed: saveNewReminder,
              child: const Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }
}
