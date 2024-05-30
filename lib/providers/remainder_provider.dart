// import 'package:app_remainder/notification_helper.dart';
// import 'package:app_remainder/remainder_model.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class ReminderNotifier extends StateNotifier<List<Reminder>> {
//   ReminderNotifier() : super([]);

//   void addReminder(Reminder reminder) {
//     state = [...state, reminder];
//     print("Adding reminder: ${reminder.title} at ${reminder.dateTime}");
//     scheduleNotification(reminder);
//   }

//   void editReminder(String id, String newTitle, DateTime newDateTime) {
//     state = [
//       for (final reminder in state)
//         if (reminder.id == id)
//           Reminder(title: newTitle, dateTime: newDateTime)
//         else
//           reminder
//     ];
//     cancelNotification(id);
//     final editedReminder = state.firstWhere((reminder) => reminder.id == id);
//     scheduleNotification(editedReminder);
//   }

//   void removeReminder(String id) {
//     state = state.where((reminder) => reminder.id != id).toList();
//     cancelNotification(id);
//   }
// }

// final reminderProvider =
//     StateNotifierProvider<ReminderNotifier, List<Reminder>>((ref) {
//   return ReminderNotifier();
// });

import 'dart:convert';

import 'package:app_remainder/Notification/notification_helper.dart';
import 'package:app_remainder/models/remainder_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final reminderProvider =
    StateNotifierProvider<ReminderNotifier, List<Reminder>>((ref) {
  return ReminderNotifier();
});

class ReminderNotifier extends StateNotifier<List<Reminder>> {
  ReminderNotifier() : super([]) {
    _loadReminders();
  }
  Future<void> _loadReminders() async {
    final prefs = await SharedPreferences.getInstance();
    final remindersString = prefs.getString('reminders') ?? '[]';
    final remindersList = json.decode(remindersString) as List;
    state =
        remindersList.map((reminder) => Reminder.fromJson(reminder)).toList();
  }

  Future<void> _saveReminders() async {
    final prefs = await SharedPreferences.getInstance();
    final remindersString =
        json.encode(state.map((reminder) => reminder.toJson()).toList());
    prefs.setString('reminders', remindersString);
  }

  void addReminder(Reminder reminder) {
    state = [...state, reminder];
    print("Adding reminder: ${reminder.title} at ${reminder.dateTime}");
    _saveReminders();
    scheduleNotification(reminder);
  }

  void editReminder(
      String id, String newTitle, String newDescription, DateTime newDateTime) {
    state = [
      for (final reminder in state)
        if (reminder.id == id)
          Reminder(
              title: newTitle,
              description: newDescription,
              dateTime: newDateTime)
        else
          reminder
    ];
    _saveReminders();
    cancelNotification(id);
    final editedReminder = state.firstWhere((reminder) => reminder.id == id);
    scheduleNotification(editedReminder);
  }

  void removeReminder(String id) {
    state = state.where((reminder) => reminder.id != id).toList();
    _saveReminders();
    cancelNotification(id);
  }
}
