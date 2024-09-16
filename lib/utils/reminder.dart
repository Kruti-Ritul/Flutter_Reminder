import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:myreminder/pages/home_page.dart';
import 'package:myreminder/utils/notifications.dart';

class Reminder extends StatelessWidget {
  const Reminder({
    super.key,
    required this.taskName,
    required this.taskTime,
    required this.taskDate,
    required this.reminderId,
    required this.taskCompleted,
    required this.onChanged,
    required this.deleteFunction,
  });

  final String taskName;
  final String taskTime;
  final String taskDate;
  final int reminderId;
  final bool taskCompleted;
  final Function(bool?)? onChanged;
  final Function(BuildContext)? deleteFunction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
        bottom: 0,
      ),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const StretchMotion(),
          children: [
            SlidableAction(
              onPressed: (context) {
                deleteFunction?.call(context);
                Notifications.cancel(reminderId);
              },
              icon: Icons.delete,
              borderRadius: BorderRadius.circular(15),
            ),
          ],
        ),
        child: Container(
          width: 350.0,
          height: 113.0,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.blueAccent[100],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Checkbox(
                    value: taskCompleted,
                    onChanged: onChanged,
                    checkColor: Colors.black,
                    activeColor: Colors.limeAccent[100],
                    side: const BorderSide(color: Colors.black),
                  ),
                  Expanded(
                    child: Text(
                      taskName,
                      style: TextStyle(
                        fontFamily: 'Ariel',
                        fontSize: 18,
                        decoration: taskCompleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    taskTime,
                    style: const TextStyle(
                      fontFamily: 'Ariel',
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    taskDate,
                    style: const TextStyle(
                      fontFamily: 'Ariel',
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
