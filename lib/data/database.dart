import 'package:hive_flutter/hive_flutter.dart';
import 'package:myreminder/utils/reminder.dart';

class ReminderDataBase {
  List<List<dynamic>> reminderList = [];

  //reference our box
  final _myBox = Hive.box('mybox');

  //if app is opended for 1st time ever
  void createInitialData() {
    reminderList = [
      ['Learn Flutter!', '10:30 AM', '9-16-2024', 1, false],
      ['Drink Water!!', '10:30 PM', '9-17-2024', 2, false],
    ];
    updateDataBase();
  }

  //load the data from the database
  void loadData() {
    var data = _myBox.get("ReminderList");

    if (data != null) {
      reminderList = reminderList.map((reminder) {
        if (reminder[3] is! int) {
          print('Correcting type of reminderId');
          reminder[3] = int.tryParse(reminder[3].toString()) ??
              0; //fall back to 0 if conversion fails
        }
        return reminder;
      }).toList();
    }

    // Verify types after loading
    if (reminderList.isNotEmpty) {
      print('Type of reminderId: ${reminderList[0][3].runtimeType}');
    }
  }

  //update the database
  void updateDataBase() {
    _myBox.put("ReminderList", reminderList);
  }
}
