import 'package:flutter/material.dart';
import 'package:myreminder/utils/button.dart';

class DialogBox extends StatefulWidget {
  final Function(String task, TimeOfDay time) onSave;

  const DialogBox({super.key, required this.onSave});

  @override
  _DialogBoxState createState() => _DialogBoxState();
}

class _DialogBoxState extends State<DialogBox> {
  final TextEditingController _controller = TextEditingController();
  TimeOfDay? _selectedTime;

  void showtimepicker(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.limeAccent[100],
      content: Container(
        height: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Input for new reminder
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: "Add New Reminder!",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Time picker button
            FloatingActionButton.extended(
              label: const Text("Pick Time"),
              icon: const Icon(Icons.access_time),
              onPressed: () {
                showtimepicker(context);
              },
            ),

            const SizedBox(height: 20),

            // Display the selected time if any
            if (_selectedTime != null)
              Text(
                "Selected Time: ${_selectedTime!.format(context)}",
                style: const TextStyle(fontSize: 16),
              ),

            const SizedBox(height: 20),

            // Add ButtonWidget for Save and Cancel
            ButtonWidget(
              onSave: () {
                if (_controller.text.isNotEmpty && _selectedTime != null) {
                  widget.onSave(_controller.text, _selectedTime!);
                  Navigator.of(context).pop();
                }
              },
              onCancel: () {
                Navigator.of(context).pop(); // Close the dialog box
              },
            ),
          ],
        ),
      ),
    );
  }
}
