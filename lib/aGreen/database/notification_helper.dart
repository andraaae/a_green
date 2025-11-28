import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationHelper {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// Inisialisasi notifikasi
  static Future<void> init() async {
    // setup timezone
    tz.initializeTimeZones();

    // android setup
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // ios setup
    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await _notificationsPlugin.initialize(initializationSettings);
  }

  /// Menjadwalkan notifikasi penyiraman tanaman
  static Future<void> scheduleWateringNotification({
    required String plantName,
    required int daysInterval,
  }) async {
    final scheduledDate = tz.TZDateTime.now(tz.local).add(Duration(days: daysInterval));

    await _notificationsPlugin.zonedSchedule(
      plantName.hashCode,
      'Time to water your plant 🌱',
      "It's time to water $plantName again!",
      scheduledDate,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'watering_channel',
          'Plant Watering Reminders',
          channelDescription: 'Reminders to water your plants',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  /// Batalkan semua notifikasi
  static Future<void> cancelAll() async {
    await _notificationsPlugin.cancelAll();
  }
  
  
}
