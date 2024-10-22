import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final VoidCallback onSave;
  final VoidCallback onCancel;

  const ButtonWidget({required this.onSave, required this.onCancel, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Cancel Button
        ElevatedButton(
          onPressed: onCancel,
          style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 238, 247, 255)),
          child: const Text("Cancel"),
        ),

        const SizedBox(width: 10),

        // Save Button
        ElevatedButton(
          onPressed: onSave,
          style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 238, 247, 255)),
          child: const Text("Save"),
        ),
      ],
    );
  }
}
