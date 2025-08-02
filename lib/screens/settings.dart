import 'package:flutter/material.dart';
import 'package:reminder_app/services/settings_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  void _showColorPicker(BuildContext context, {
    required Color initialColor,
    required void Function(Color) onColorSelected,
    required String title,
  }) {
    Color pickerColor = initialColor;

    showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: pickerColor,
            onColorChanged: (color) => pickerColor = color,
            enableAlpha: false,
            labelTypes: [],
            pickerAreaHeightPercent: 0.8,
          ),
        ),
        actions: [
          TextButton(
          onPressed: ()=> Navigator.of(context).pop(),
          child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: (){
              onColorSelected(pickerColor);
              Navigator.of(context).pop();
            },
            child: const Text('Select'),
          )
        ],
      )
    );
  }

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
            Text('App Settings', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color:Theme.of(context).textTheme.bodyMedium!.color)),
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
            const SizedBox(height: 20),
            ElevatedButton(onPressed: () {
              _showColorPicker(context, initialColor: settings.backgroundColor, onColorSelected: settings.setBackgroundColor, title: 'Select Background Color',
              );
            },
            child: const Text('Choose Background Color'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: () {
              _showColorPicker(context, initialColor: settings.fontColor, onColorSelected: settings.setFontColor, title: 'Select Font Color',
              );
            },
            child: const Text('Choose Font Color'),
            ),
          ],
        ),
      ),
    );
  }
}