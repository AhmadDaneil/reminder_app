import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reminder_app/services/settings_provider.dart';
import 'package:reminder_app/services/database_helper.dart';
import 'package:reminder_app/services/reminder_model.dart'; // Make sure this exists

class AddReminder extends StatefulWidget {
  const AddReminder({super.key});

  @override
  State<AddReminder> createState() => _AddReminderState();
}

class _AddReminderState extends State<AddReminder> {
  final _titleController = TextEditingController();
  final _notesController = TextEditingController();

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String _repeat = 'None';

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) setState(() => _selectedTime = picked);
  }

  Future<void> _saveReminder() async {
    if (_titleController.text.isEmpty || _selectedDate == null || _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    final DateTime combinedDateTime = DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
      _selectedTime!.hour,
      _selectedTime!.minute,
    );

    final reminder = Reminder(
      title: _titleController.text,
      content: _notesController.text,
      dateTime: combinedDateTime.toIso8601String(),
      repeat: _repeat,
    );

    await DatabaseHelper().insertReminder(reminder);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    final textColor = settings.fontColor;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: settings.appBarColor,
        iconTheme: IconThemeData(color: settings.fontColor),
        title: Text('Add Reminder', style: TextStyle(color: settings.fontColor)),
        centerTitle: true,
      ),
      backgroundColor: settings.backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title', labelStyle: TextStyle(color: textColor)),
              style: TextStyle(color: textColor),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _notesController,
              maxLines: 3,
              decoration: InputDecoration(labelText: 'Notes (optional)', labelStyle: TextStyle(color: textColor)),
              style: TextStyle(color: textColor),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: Icon(Icons.calendar_today, color: textColor),
              title: Text(
                _selectedDate == null
                    ? 'Select Date'
                    : '${_selectedDate!.toLocal()}'.split(' ')[0],
                style: TextStyle(color: textColor),
              ),
              onTap: _pickDate,
            ),
            ListTile(
              leading: Icon(Icons.access_time, color: textColor),
              title: Text(
                _selectedTime == null
                    ? 'Select Time'
                    : _selectedTime!.format(context),
                style: TextStyle(color: textColor),
              ),
              onTap: _pickTime,
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _repeat,
              items: ['None', 'Daily', 'Weekly', 'Monthly']
                  .map((value) => DropdownMenuItem(
                        value: value,
                        child: Text(value, style: TextStyle(color: textColor)),
                      ))
                  .toList(),
              onChanged: (val) => setState(() => _repeat = val!),
              decoration: InputDecoration(
                labelText: 'Repeat',
                labelStyle: TextStyle(color: textColor),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: textColor),
                ),
              ),
              dropdownColor: settings.backgroundColor,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _saveReminder,
              icon: const Icon(Icons.save),
              label: const Text('Save Reminder'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
