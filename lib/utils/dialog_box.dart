import 'package:flutter/material.dart';

class DialogBox extends StatelessWidget {
  const DialogBox({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.limeAccent[100],
      content: Container(
        height: 200,
        child: Column(
          children: [
            //input for new reminder
            TextField(
              decoration: InputDecoration(
                hintText: "Add New Reminder!",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),

            //buttons -> save+cancel
          ],
        ),
      ),
    );
  }
}
