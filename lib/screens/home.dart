import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reminder_app/services/settings_provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: settings.appBarColor,
        title: const Text('Home'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'No Reminders Yet',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0, color: Theme.of(context).textTheme.bodyMedium!.color),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            Navigator.pushNamed(context, '/add_reminder');
            setState(() {});
          },
          backgroundColor: settings.isDarkmode ?Colors.grey[850] : Colors.grey,
          elevation: 8.0,
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