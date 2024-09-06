import 'package:hive_flutter/hive_flutter.dart';

class ReminderDataBase {
  List reminderList = [];

  //reference our box
  final _myBox = Hive.box('mybox');

  //if app is opended for 1st time ever
  void createInitialData() {
    reminderList = [
      ['Learn Flutter!', '10:30 AM', false],
      ['Drink Water!!', '10:30 PM', false],
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
