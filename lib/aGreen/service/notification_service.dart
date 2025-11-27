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

  // INIT (WAJIB DIPANGGIL DI MAIN.DART)
  static Future<void> init() async {
    tz.initializeTimeZones();

    // PAKAI ICON NOTIF (bukan launcher)
    const android = AndroidInitializationSettings('@drawable/ic_notification');

    const settings = InitializationSettings(android: android);

    await _notif.initialize(settings);

    // CHANNEL UTAMA (untuk zonedSchedule)
    const AndroidNotificationChannel mainChannel = AndroidNotificationChannel(
      "water_channel",
      "Water Reminder",
      description: "Reminder to water your plants",
      importance: Importance.max,
    );

    // CHANNEL UNTUK BACKGROUND (AlarmManager)
    const AndroidNotificationChannel alarmChannel = AndroidNotificationChannel(
      "water_alarm",
      "Water Alarm",
      description: "Alarm to remind watering even when the app is closed",
      importance: Importance.max,
    );

    final androidPlugin = _notif
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    await androidPlugin?.createNotificationChannel(mainChannel);
    await androidPlugin?.createNotificationChannel(alarmChannel);
  }

  // BUKA PERMISSION EXACT ALARM
  static Future<void> openExactAlarmSettings() async {
    if (!Platform.isAndroid) return;

    final intent = AndroidIntent(
      action: 'android.settings.REQUEST_SCHEDULE_EXACT_ALARM',
    );

    try {
      await intent.launch();
    } catch (e) {
      print("ERROR opening exact alarm settings: $e");
    }
  }

  // 1️⃣ NOTIFIKASI NORMAL (app aktif / background)
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
            priority: Priority.high,
            importance: Importance.max,
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

  // 2️⃣ NOTIFIKASI SAAT APP DI-KILL (AlarmManager)
  static Future<void> scheduleWateringWithAlarm({
    required int id,
    required int days,
    required String plantName,
  }) async {
    await AndroidAlarmManager.oneShot(
      Duration(days: days),
      id,
      alarmCallback,
      exact: true,
      wakeup: true,
    );

    print("Alarm scheduled for plant $plantName in $days days");
  }

  // 3️⃣ TEST NOTIF
  static Future<void> test() async {
    await _notif.show(
      999,
      "Test Notification",
      "Jika muncul, notif sudah aktif ✔️",
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
}
