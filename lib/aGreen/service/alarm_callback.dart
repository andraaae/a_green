import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// ⚠ WAJIB: buat instance baru untuk background isolate
final FlutterLocalNotificationsPlugin _notif =
    FlutterLocalNotificationsPlugin();

Future<void> alarmCallback(int id) async {
  // WAJIB agar plugin bisa dipakai di background isolate
  WidgetsFlutterBinding.ensureInitialized();

  // WAJIB: initialize ulang di background
  const AndroidInitializationSettings androidInit =
      AndroidInitializationSettings('@mipmap/launcher_icon');

  const InitializationSettings initSettings =
      InitializationSettings(android: androidInit);

  await _notif.initialize(initSettings);

  // WAJIB: register channel ulang di background isolate
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'water_alarm',
    'Water Alarm',
    description: 'Shows plant watering alarms',
    importance: Importance.max,
  );

  await _notif
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  // ⬅️ BARU: kirim notif
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
