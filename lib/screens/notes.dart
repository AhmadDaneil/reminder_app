import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reminder_app/services/settings_provider.dart';

class Notes extends StatefulWidget {
  const Notes({super.key});

  @override
  State<Notes> createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    final bgColor = settings.backgroundColor;
    final textColor = settings.fontColor;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: settings.appBarColor,
        title: Text(
          'My Notes',
          style: TextStyle(color: textColor),
          ),
        centerTitle: true,
        iconTheme: IconThemeData(color: settings.fontColor),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search, color: textColor),
                hintText: 'Search Notes...',
                hintStyle: TextStyle(color: textColor),
                filled: true,
                fillColor: settings.isDarkmode? Colors.grey[850]: Colors.white54,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12)
                ),
              ),
            ),
            const SizedBox(height: 16),

            Expanded(
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Card(
                    color: settings.isDarkmode ? Colors.grey[850] : Colors.white54,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(
                        'Note Title $index',
                        style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        'This is short preview',
                        style: TextStyle(
                          color: textColor,
                        ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Icon(Icons.arrow_forward_ios, color: textColor),
                      onTap: () {
                        
                      },
                    ),
                  );
                }
                )
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.pushNamed(context, '/add_notes');
            setState(() {});
        },
        backgroundColor: settings.appBarColor,
        child: Icon(Icons.add, color: settings.fontColor),
        ),
    );
  }
}