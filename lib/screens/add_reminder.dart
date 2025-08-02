import 'package:flutter/material.dart';

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
  String? _repeat = 'None';

  Future<void> _pickDate() async{
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now(),
    );
    if(picked != null) setState(() => _selectedDate = picked);
  }
  
  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      );
      if(picked !=null) setState(() => _selectedTime = picked);
  }

  void _saveReminder() {
    print('Reminder Saved');
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Reminder'),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _notesController,
              maxLines: 3,
              decoration: const InputDecoration(labelText: 'Notes (optional)'),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: Text(_selectedDate == null
              ? 'Select Date' : '${_selectedDate!.toLocal()}'.split(' ')[0]),
              onTap: _pickDate,
              ),
              ListTile(
              leading: const Icon(Icons.access_time),
              title: Text(_selectedTime == null
              ? 'Select Time' : _selectedTime!.format(context)),
              onTap: _pickTime,
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _repeat,
                items: ['None', 'Daily', 'Weekly', 'Monthly']
                .map((value) => DropdownMenuItem(value: value, child: Text(value)))
                .toList(),
                onChanged: (val) => setState(() => _repeat = val!),
                decoration: const InputDecoration(labelText: 'Repeat'),
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