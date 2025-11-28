// lib/a_green/service/notification_service.dart

import 'dart:io';
import 'package:a_green/aGreen/service/alarm_callback.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:android_intent_plus/android_intent.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notif =
      FlutterLocalNotificationsPlugin();

  // INIT — dipanggil dari main.dart
  static Future<void> init() async {
    tz.initializeTimeZones();

    // coba pakai icon notifikasi custom, kalau gagal fallback ke launcher
    AndroidInitializationSettings androidSettings;
    try {
      androidSettings = const AndroidInitializationSettings('@drawable/ic_notification');
    } catch (_) {
      androidSettings = const AndroidInitializationSettings('@mipmap/launcher_icon');
    }

    final settings = InitializationSettings(android: androidSettings);

    try {
      await _notif.initialize(settings);
    } catch (e) {
      // fallback attempt
      final fallback = const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/launcher_icon'),
      );
      await _notif.initialize(fallback);
    }

    // CHANNEL utama (untuk zonedSchedule / show)
    const AndroidNotificationChannel channelMain = AndroidNotificationChannel(
      "water_channel",
      "Water Reminder",
      description: "Normal water reminder",
      importance: Importance.max,
    );

    // CHANNEL untuk background alarm (callback)
    const AndroidNotificationChannel channelAlarm = AndroidNotificationChannel(
      "water_alarm",
      "Water Alarm",
      description: "Alarm that triggers even if app is closed",
      importance: Importance.max,
    );

    final androidPlugin =
        _notif.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

    await androidPlugin?.createNotificationChannel(channelMain);
    await androidPlugin?.createNotificationChannel(channelAlarm);
  }

  // Open exact alarm permission settings (Android 12+)
  static Future<void> openExactAlarmSettings() async {
    if (!Platform.isAndroid) return;
    try {
      await AndroidIntent(action: 'android.settings.REQUEST_SCHEDULE_EXACT_ALARM')
          .launch();
    } catch (e) {
      print("ERROR opening exact alarm settings: $e");
    }
  }

  // NORMAL: jadwalkan notifikasi (app hidup / background)
  static Future<void> scheduleWateringNotification({
    required int id,
    required String plantName,
    required int days,
  }) async {
    final scheduledDate = tz.TZDateTime.now(tz.local).add(Duration(days: days));

    try {
      await _notif.zonedSchedule(
        id,
        "Time to water $plantName 🌱",
        "Your plant needs watering today.",
        scheduledDate,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            "water_channel",
            "Water Reminder",
            importance: Importance.max,
            priority: Priority.high,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: null,
      );
    } catch (e) {
      print("ZonedSchedule Error: $e");
      await openExactAlarmSettings();
    }
  }

  // KILL-SAFE: jadwalkan alarm via AndroidAlarmManager (notif muncul walau app di-kill)
  static Future<void> scheduleWateringWithAlarm({
    required int id,
    required int days,
    required String plantName,
  }) async {
    try {
      await AndroidAlarmManager.oneShot(
        Duration(days: days),
        id,
        alarmCallback,
        exact: true,
        wakeup: true,
      );
      print("Alarm scheduled (kill-safe) for $plantName in $days days");
    } catch (e) {
      print("AlarmManager Error: $e");
      await openExactAlarmSettings();
    }
  }

  // Langsung tampilkan notifikasi (test)
  static Future<void> test() async {
    await _notif.show(
      999,
      "Plant successfully added",
      "Now you have a new family 🌱",
      const NotificationDetails(
        android: AndroidNotificationDetails(
          "water_channel",
          "Water Reminder",
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
    );
  }

  // TESTABLE: jadwalkan alarm singkat (duration kecil — pakai untuk testing)
  static Future<void> scheduleWateringTestable({
    required int id,
    required String plantName,
    required Duration duration,
  }) async {
    try {
      await AndroidAlarmManager.oneShot(
        duration,
        id,
        alarmCallback,
        exact: true,
        wakeup: true,
      );
      print("TEST ALARM scheduled in ${duration.inSeconds}s for $plantName");
    } catch (e) {
      print("AlarmManager Error (TEST): $e");
      await openExactAlarmSettings();
    }
  }
}
