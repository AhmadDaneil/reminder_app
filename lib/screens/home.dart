import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
          backgroundColor: Colors.white,
          elevation: 8.0,
          child: const Icon(Icons.add, color: Colors.black,),
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
                title: const Text('Reminders list'),
                onTap:() async{
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/reminder_list');
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