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
            return Card(
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
              )
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            Navigator.pushNamed(context, '/add_reminder');
            _loadReminders();
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