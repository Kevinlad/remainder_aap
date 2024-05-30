import 'package:uuid/uuid.dart';

class Reminder {
  final String id;
  String title;
  DateTime dateTime;
  String description;

  Reminder(
      {required this.title, required this.dateTime, required this.description, String? id,})
      : id = Uuid().v4();

  void update(String title, DateTime dateTime, String description) {
    this.title = title;
    this.dateTime = dateTime;
    this.description = description;
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dateTime': dateTime.toIso8601String(),
    };
  }

  static Reminder fromJson(Map<String, dynamic> json) {
    return Reminder(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      dateTime: DateTime.parse(json['dateTime']),
    );
  }
}
