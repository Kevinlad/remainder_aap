import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'add_remainder.dart';
import '../providers/remainder_provider.dart';

class HomeScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reminders = ref.watch(reminderProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Reminders'),
      ),
      body: ListView.builder(
        itemCount: reminders.length,
        itemBuilder: (context, index) {
          final reminder = reminders[index];
          return ListTile(
              title: Text(
                reminder.title,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text('${reminder.dateTime}\n${reminder.description}'),
              onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          AddEditReminderScreen(reminder: reminder),
                    ),
                  ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                AddEditReminderScreen(reminder: reminder),
                          ),
                        );
                      },
                      icon: Icon(Icons.edit)),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      ref
                          .read(reminderProvider.notifier)
                          .removeReminder(reminder.id);
                    },
                  ),
                ],
              ));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddEditReminderScreen(),
          ),
        ),
        child: Icon(Icons.add),
      ),
    );
  }
}
