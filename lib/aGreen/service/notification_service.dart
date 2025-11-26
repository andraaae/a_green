import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notif =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    tz.initializeTimeZones();

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');

    const settings = InitializationSettings(
      android: android,
    );

    await _notif.initialize(settings);
  }

  static Future<void> scheduleWateringNotification({
    required int id,
    required String plantName,
    required int days,
  }) async {
    final scheduledDate =
        tz.TZDateTime.now(tz.local).add(Duration(days: days));

    await _notif.zonedSchedule(
      id,
      "Time to water $plantName 🌱",
      "Your plant needs watering today.",
      scheduledDate,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          "water_channel",
          "Water Reminder",
          channelDescription: "Notification for watering plants",
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),

      // Wajib di versions baru:
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      // uiLocalNotificationDateInterpretation:
      //     UILocalNotificationDateInterpretation.absoluteTime,
      // DUA PARAMETER INI SUDAH DIHAPUS DI VERSI BARU:
     
      
      matchDateTimeComponents: null,
    );
  }
}
