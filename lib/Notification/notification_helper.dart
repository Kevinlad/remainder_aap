
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../models/remainder_model.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> initializeNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  final bool? result = await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
  
  );

  if (result != null && result) {
    print("Notifications initialized successfully.");
  } else {
    print("Failed to initialize notifications.");
  }

  // Initialize timezone database
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Asia/Kolkata'));
}

tz.TZDateTime _convertToTZDateTime(DateTime dateTime) {
  return tz.TZDateTime.from(dateTime, tz.local);
}

Future<void> scheduleNotification(Reminder reminder) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'your_channel_id',
    'your_channel_name',
    channelDescription: 'your_channel_description',
    importance: Importance.max,
    priority: Priority.high,
  );

  NotificationDetails notificationDetails = NotificationDetails(
    android: androidPlatformChannelSpecifics,
  );

  final tz.TZDateTime scheduledDate = _convertToTZDateTime(reminder.dateTime);

  if (scheduledDate.isBefore(tz.TZDateTime.now(tz.local))) {
    print("Scheduled time is in the past, not scheduling notification.");
    return;
  }

  print(
      "Scheduling notification for ${scheduledDate.toString()} with title: ${reminder.title}");

  await flutterLocalNotificationsPlugin.zonedSchedule(
    reminder.id.hashCode,
    reminder.title,
    reminder.description, scheduledDate,
    notificationDetails,
    androidAllowWhileIdle: true,
    uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
  );
}

Future<void> cancelNotification(String id) async {
  await flutterLocalNotificationsPlugin.cancel(id.hashCode);
  print("Cancelled notification with id: $id");
}
