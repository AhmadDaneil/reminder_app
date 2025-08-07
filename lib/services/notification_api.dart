import 'dart:io' show Platform; // Import for Platform check
import 'package:flutter_local_notifications/flutter_local_notifications.dart' as fln;
import 'package:rxdart/rxdart.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:flutter/foundation.dart'; // Import for kIsWeb
import 'package:android_intent_plus/android_intent.dart';


class NotificationApi {
  static final _notifications = fln.FlutterLocalNotificationsPlugin();
  static final onNotifications = BehaviorSubject<String?>();

  static Future<fln.NotificationDetails> _notificationDetails() async {
    return fln.NotificationDetails(
      android: fln.AndroidNotificationDetails(
        'reminder_channel',
        'Reminders',
        channelDescription: 'channel for scheduled reminders',
        importance: fln.Importance.max,
        priority: fln.Priority.high,
      ),
      iOS: fln.DarwinNotificationDetails(),
      macOS: fln.DarwinNotificationDetails(),
    );
  }

  static Future init({bool initScheduled = false}) async {
    // Request permission for Android 13+
    if (!kIsWeb && Platform.isAndroid) {
      final fln.AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          _notifications.resolvePlatformSpecificImplementation<
              fln.AndroidFlutterLocalNotificationsPlugin>();
      print('Android SDK: ${Platform.operatingSystemVersion}');
      
      if (androidImplementation != null) {
        final bool? granted = await androidImplementation.requestNotificationsPermission();
        if (granted != null && granted) {
          print('Notification permission granted for Android!');
        } else {
          print('Notification permission denied for Android.');
          // You might want to show a dialog or inform the user here
          // that notifications won't work without permission.
        }
      }
    }

    if (!kIsWeb && Platform.isIOS) {
      final fln.IOSFlutterLocalNotificationsPlugin? iosImplementation =
      _notifications.resolvePlatformSpecificImplementation<
      fln.IOSFlutterLocalNotificationsPlugin>();

      if(iosImplementation != null) {
        await iosImplementation.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
      }
    }


    final android = fln.AndroidInitializationSettings('@mipmap/ic_launcher');
    final iOS = fln.DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    final settings = fln.InitializationSettings(
      android: android,
      iOS: iOS,
      macOS: iOS,
    );

    await _notifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (fln.NotificationResponse notificationResponse) async {
        onNotifications.add(notificationResponse.payload);
      },
      onDidReceiveBackgroundNotificationResponse: notificationResponseBackgroundHandler,
    );

    if (initScheduled) {
      tz.initializeTimeZones();
      final locationName = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(locationName));
    }
  }

  Future<void> requestExactAlarmPermission() async {
  if (Platform.isAndroid && Platform.version.compareTo('12') >= 0) {
    final AndroidIntent intent = AndroidIntent(
      action: 'android.settings.REQUEST_SCHEDULE_EXACT_ALARM',
    );
    await intent.launch();
  }
}


  @pragma('vm:entry-point')
  static void notificationResponseBackgroundHandler(fln.NotificationResponse notificationResponse) {
    print('Notification action tapped in background: ${notificationResponse.payload}');
  }

  static Future showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
  }) async {
    _notifications.show(
      id,
      title,
      body,
      await _notificationDetails(),
      payload: payload,
    );
  }

  static Future showScheduledNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
    required DateTime scheduleDate,
  }) async {
    try {
    await _notifications.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduleDate, tz.local),
      await _notificationDetails(),
      payload: payload,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: fln.UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: fln.DateTimeComponents.time,
    );
    print('Scheduling notification at: $scheduleDate');
    } catch (e) {
      print('Error scheduling notification: $e');
      }
  }
  


}
