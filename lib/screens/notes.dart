import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reminder_app/services/settings_provider.dart';
import 'package:reminder_app/services/database_helper.dart';
import 'package:reminder_app/services/note_model.dart';

class Notes extends StatefulWidget {
  const Notes({super.key});

  @override
  State<Notes> createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  List<Note> notes = [];

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async{
    final data = await DatabaseHelper().getNotes();
    for (var note in data) {
      print("Note: ${note.title}, ${note.content}, ${note.createdAt}");
    }
    setState(() {
      notes = data;
    });
  }

  Future<void> _deleteNote(Note note) async{
    await DatabaseHelper().deleteNote(note.id!);
    _loadNotes();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${note.title} deleted'),
      action: SnackBarAction(label: 'Undo', 
      onPressed: () async {
        await DatabaseHelper().insertNote(note);
        _loadNotes();
      }
      ),
      )
      );
  }

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
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12)
                ),
              ),
            ),
            const SizedBox(height: 16),

            Expanded(
              child: ListView.builder(
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  final note = notes[index];

                  return Dismissible(
                    key: Key(note.id.toString()),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) async {
                      await _deleteNote(note);
                    }, 
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.only(right: 20),
                      child: Icon(Icons.delete, color: Colors.white),
                    ),
                    child: Card(
                    color: settings.isDarkmode ? Colors.grey[850] : Colors.grey,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(
                        notes[index].title,
                        style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        notes[index].content,
                        style: TextStyle(
                          color: textColor,
                        ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      ),
                      trailing: IconButton(icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        _deleteNote(note);
                      },
                    ),
                    onTap: (){},
                    ),
                    )
                  );
                }
              ),
            ),
          ]
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async{
          final result = await Navigator.pushNamed(context, '/add_notes');
          if (result == true){
            _loadNotes();
          }
        },
        backgroundColor: settings.appBarColor,
        child: Icon(Icons.add, color: settings.fontColor),
        ),
    );
  }
}