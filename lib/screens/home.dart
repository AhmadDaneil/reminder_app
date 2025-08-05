import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reminder_app/services/settings_provider.dart';
import 'package:reminder_app/services/reminder_model.dart';
import 'package:reminder_app/services/database_helper.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Reminder> reminders = [];

  @override
  void initState() {
    super.initState();
    _loadReminders();
  }
  

  Future<void> _loadReminders() async{
    final data = await DatabaseHelper().getReminders();
    setState(() {
      reminders = data;
    });
  }

  void _showReminderDialog(Reminder reminder) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(reminder.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (reminder.content.isNotEmpty)
            Text('Notes: ${reminder.content}'),
          const SizedBox(height: 8),
          Text('DateTime: ${reminder.content}'),
          Text('Repeat: ${reminder.repeat}'),
          ],
          ),
          actions: [
            TextButton(onPressed: (){
              Navigator.pop(context);
            }, 
            child: const Text('Back'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);

                final result = await Navigator.pushNamed(
                  context,
                  '/add_reminder',
                  arguments: reminder,
                );
                if (result == true) {
                  _loadReminders();
                }
              }, 
              child: Text('Edit'),
              ),
          ],
      )
      );
  }

  Future<void> _deleteReminder(Reminder reminder) async{
    await DatabaseHelper().deleteReminder(reminder.id!);
    _loadReminders();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${reminder.title} deleted'),
      action: SnackBarAction(label: 'Undo', 
      onPressed: () async {
        await DatabaseHelper().insertReminder(reminder);
        _loadReminders();
      }
      ),
      )
      );
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: settings.appBarColor,
        title: const Text('Home'),
        centerTitle: true,
      ),
      body: reminders.isEmpty ? Center(
        child: Text(
          'No Reminders Yet',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0, color: Theme.of(context).textTheme.bodyMedium!.color),
          ),
        ) : ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: reminders.length,
          itemBuilder: (context, index){
            final reminder = reminders[index];
            
            return Dismissible(
              key: Key(reminder.id.toString()),
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: const Icon(Icons.delete, color: Colors.white),
              ), 
              secondaryBackground: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              onDismissed: (direction) {
                _deleteReminder(reminder);
              },
              child: Card(
              elevation: 10.0,
              color: settings.isDarkmode ? Colors.grey[900] : Colors.white,
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                title: Text(
                  reminder.title,
                  style: TextStyle(color: settings.fontColor, fontWeight: FontWeight.bold),
                ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (reminder.content.isNotEmpty)
                  Text(reminder.content, style: TextStyle(color: settings.fontColor),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'DateTime: ${reminder.dateTime}',
                    style: TextStyle(fontSize: 12, color: settings.fontColor),
                  ),
                  Text(
                    'Repeat: ${reminder.repeat}',
                    style: TextStyle(fontSize: 12, color: settings.fontColor),
                  )
                ],
              ),
              trailing: IconButton(icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                _deleteReminder(reminder);
              }
              ),
              onTap: () {
                _showReminderDialog(reminders[index]);
              },
              ),
            ),
              );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final result = await Navigator.pushNamed(context, '/add_reminder');
            if (result == true){
            _loadReminders();
            }
          },
          backgroundColor: settings.isDarkmode ?Colors.grey[850] : Colors.grey,
          elevation: 30.0,
          child: Icon(Icons.add, color: settings.fontColor),
        ),

        drawer: Drawer(
          child: ListView(
            children: [
              ListTile(
                title: const Text('Home'),
                onTap: () async{
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/home');
                  setState(() {});
                },
              ),
              ListTile(
                title: const Text('Notes'),
                onTap:() async{
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/notes');
                  setState(() {});
                },
              ),
              ListTile(
                title: const Text('Settings'),
                onTap:() async{
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/settings');
                  setState(() {});
                },
              ),
            ],
          )
        ),
    );
  }
}