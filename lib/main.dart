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
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Define theme mode state (light or dark)
  bool _isDarkTheme = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: _isDarkTheme ? darkTheme : lightTheme, // Toggle between themes
      home: HomePage(
        onToggleTheme: () {
          setState(() {
            _isDarkTheme = !_isDarkTheme;
          });
        },
      ),
    );
  }
}

// Define light theme
final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light, // Ensure brightness matches
  primarySwatch: Colors.pink,
  colorScheme: ColorScheme.fromSwatch(
    brightness: Brightness.light, // Ensure brightness matches
  ).copyWith(secondary: Colors.pinkAccent),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.pink,
    titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Colors.pinkAccent,
  ),
);

// Define dark theme
final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark, // Ensure brightness matches
  primarySwatch: Colors.grey,
  colorScheme: ColorScheme.fromSwatch(
    brightness: Brightness.dark, // Ensure brightness matches
  ).copyWith(secondary: Colors.blueGrey),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.grey,
    titleTextStyle: TextStyle(color: Colors.black, fontSize: 20),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Color.fromARGB(255, 77, 134, 156),
  ),
);
