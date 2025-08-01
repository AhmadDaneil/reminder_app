import 'dart:io' show Platform; // Import for Platform check
import 'package:flutter_local_notifications/flutter_local_notifications.dart' as fln;
import 'package:rxdart/rxdart.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:flutter/foundation.dart'; // Import for kIsWeb

class NotificationApi {
  static final _notifications = fln.FlutterLocalNotificationsPlugin();
  static final onNotifications = BehaviorSubject<String?>();

  static Future<fln.NotificationDetails> _notificationDetails() async {
    return fln.NotificationDetails(
      android: fln.AndroidNotificationDetails(
        'channel id',
        'channel name',
        channelDescription: 'channel description',
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


    final android = fln.AndroidInitializationSettings('@mipmap/ic_launcher');
    final iOS = fln.DarwinInitializationSettings();
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
    await _notifications.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduleDate, tz.local),
      await _notificationDetails(),
      payload: payload,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: fln.UILocalNotificationDateInterpretation.absoluteTime,
    );
  }


}
