import 'package:hive_flutter/hive_flutter.dart';

class ReminderDataBase {
  List reminderList = [];

  //reference our box
  final _myBox = Hive.box('mybox');

  //if app is opended for 1st time ever
  void createInitialData() {
    reminderList = [
      ['Learn Flutter!', '10:30 AM', '9-16-2024', 1, false],
      ['Drink Water!!', '10:30 PM', '9-17-2024', 2, false],
    ];
  }

  //load the data from the database
  void loadData() {
    reminderList = _myBox.get("ReminderList");
  }

  //update the database
  void updateDataBase() {
    _myBox.put("ReminderList", reminderList);
  }
}
