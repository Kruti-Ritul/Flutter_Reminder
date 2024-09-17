import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myreminder/utils/button.dart';
import 'package:myreminder/utils/notifications.dart';

class DialogBox extends StatefulWidget {
  final Function(String task, TimeOfDay time, DateTime date) onSave;

  const DialogBox({super.key, required this.onSave});

  @override
  _DialogBoxState createState() => _DialogBoxState();
}

class _DialogBoxState extends State<DialogBox> {
  final TextEditingController _controller = TextEditingController();
  DateTime? _selectedDate;
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

  Future<void> showdatepicker(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color.fromARGB(255, 122, 178, 178),
      content: SizedBox(
        height: 380,
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

            //Date Picker Button
            FloatingActionButton.extended(
              backgroundColor: const Color.fromARGB(255, 205, 232, 229),
              label: const Text("Pick Date"),
              icon: const Icon(Icons.calendar_today),
              onPressed: () {
                showdatepicker(context);
              },
            ),

            const SizedBox(height: 20),

            // Display the selected date if any
            if (_selectedDate != null)
              Text(
                "Selected Date: ${DateFormat.yMd().format(_selectedDate!)}",
                style: const TextStyle(fontSize: 16),
              ),

            const SizedBox(height: 20),

            // Time picker button
            FloatingActionButton.extended(
              backgroundColor: const Color.fromARGB(255, 205, 232, 229),
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
                if (_controller.text.isNotEmpty &&
                    _selectedTime != null &&
                    _selectedDate != null) {
                  widget.onSave(
                      _controller.text, _selectedTime!, _selectedDate!);
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
