import 'package:flutter/material.dart';
import 'package:reminder_app/screens/add_reminder.dart';
import 'package:reminder_app/screens/reminder_list.dart';
import 'package:reminder_app/screens/loading.dart';
import 'package:reminder_app/screens/home.dart';
import 'package:reminder_app/screens/settings.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const Loading(),
        '/home': (context) => const Home(),
        '/reminder_list': (context) => const ReminderList(),
        '/add_reminder': (context) => const AddReminder(),
        '/settings': (context) => const Settings(),
      },
    );
  }
}

