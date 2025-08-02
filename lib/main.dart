import 'package:flutter/material.dart';
import 'package:reminder_app/screens/add_reminder.dart';
import 'package:reminder_app/screens/reminder_list.dart';
import 'package:reminder_app/screens/loading.dart';
import 'package:reminder_app/screens/home.dart';
import 'package:reminder_app/screens/settings.dart';
import 'package:reminder_app/services/settings_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
    create: (_) => SettingsProvider(),
    child: const MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settings, _){
        return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: settings.isDarkmode ? Brightness.dark : Brightness.light,
        scaffoldBackgroundColor: settings.backgroundColor,
        textTheme: _getTextTheme(settings.fontSize).apply(bodyColor: settings.fontColor,
        displayColor: settings.fontColor,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: settings.backgroundColor,
          iconTheme: IconThemeData(color: settings.fontColor),
          titleTextStyle: TextStyle(
            color: settings.fontColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: IconThemeData(color: settings.fontColor),
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(color: settings.fontColor),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: settings.fontColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: settings.fontColor),
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const Loading(),
        '/home': (context) => const Home(),
        '/reminder_list': (context) => const ReminderList(),
        '/add_reminder': (context) => const AddReminder(),
        '/settings': (context) => const SettingsPage(),
      },
    );
  }
    );
      }
    
  TextTheme _getTextTheme(String size) {
        switch (size) {
          case 'Small':
            return const TextTheme(bodyMedium: TextStyle(fontSize: 14));
          case 'Large':
            return const TextTheme(bodyMedium: TextStyle(fontSize: 20));
          default:
            return const TextTheme(bodyMedium: TextStyle(fontSize: 16));
        }
      }
}

