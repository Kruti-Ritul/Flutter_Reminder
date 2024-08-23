import 'package:flutter/material.dart';

class Reminder extends StatelessWidget {
  const Reminder(
      {super.key,
      required this.taskName,
      required this.taskCompleted,
      this.onChanged});

  final String taskName;
  final bool taskCompleted;
  final Function(bool?)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
        bottom: 0,
      ),
      child: Container(
        width: 350.0,
        height: 80.0,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.blueAccent[100],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Checkbox(
              value: taskCompleted,
              onChanged: onChanged,
              checkColor: Colors.black,
              activeColor: Colors.limeAccent[100],
              side: BorderSide(color: Colors.black),
            ),
            Text(
              taskName,
              style: TextStyle(
                fontFamily: 'Ariel',
                fontSize: 18,
                decoration: taskCompleted
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
