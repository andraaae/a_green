// lib/a_green/service/alarm_callback.dart

import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin _notif =
    FlutterLocalNotificationsPlugin();

// CALLBACK ALARM — DIPANGGIL DARI ANDROID ALARM MANAGER
Future<void> alarmCallback(int id) async {
  // Pastikan Flutter binding siap (background isolate)
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize plugin di background isolate (minimal)
  // Gunakan drawable/ic_notification jika tersedia (lebih baik)
  const AndroidInitializationSettings androidInit =
      AndroidInitializationSettings('@drawable/ic_notification');

  const InitializationSettings initSettings = InitializationSettings(
    android: androidInit,
  );

  try {
    await _notif.initialize(initSettings);
  } catch (e) {
    const AndroidInitializationSettings fallbackInit =
        AndroidInitializationSettings('@mipmap/launcher_icon');
    const InitializationSettings fallbackSettings = InitializationSettings(
      android: fallbackInit,
    );
    await _notif.initialize(fallbackSettings);
  }

  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'water_alarm',
    'Water Alarm',
    description: 'Shows plant watering alarms',
    importance: Importance.max,
  );

  await _notif
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >()
      ?.createNotificationChannel(channel);

  // Kirim notifikasi
  await _notif.show(
    id,
    "Watering Reminder 🌱",
    "It's time to water your plant!",
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'water_alarm',
        'Water Alarm',
        importance: Importance.max,
        priority: Priority.high,
      ),
    ),
  );
}
