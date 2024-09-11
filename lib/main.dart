import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:myreminder/pages/home_page.dart';
import 'package:myreminder/utils/notifications.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();
  await Hive.openBox('mybox');

  // Initialize notifications
  await Notifications.init();

  runApp(const MyApp());

  //Notifications.showNotification(id: id, title: title, body: body)
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
