import 'package:flutter/material.dart';
import 'package:reminder_app/services/settings_provider.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text('App Settings', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SwitchListTile(
              value: settings.isDarkmode, 
              onChanged: (val) => settings.toggleDarkMode,
              title: const Text('Dark Mode'),
              ),
              DropdownButtonFormField<String>(
                value: settings.fontSize,
                items: ['Small', 'Medium', 'Large'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(), 
                onChanged: (val) {
                  if (val != null) settings.setFontSize(val);
                },
                decoration: const InputDecoration(labelText: 'Font Size'),
              ),
          ],
        ),
      ),
    );
  }
}