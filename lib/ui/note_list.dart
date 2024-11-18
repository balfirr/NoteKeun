import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:notekeun/model/note_model.dart';

class NoteListScreen extends StatefulWidget {
  @override
  _NoteListScreenState createState() => _NoteListScreenState();
}

class _NoteListScreenState extends State<NoteListScreen> {
  List<Note> notes = [];

  @override
  void initState() {
    super.initState();
    fetchNotes();
  }

  Future<void> fetchNotes() async {
    final response = await http.get(Uri.parse('http://yourapi.com/notes'));
    if (response.statusCode == 200) {
      final List<dynamic> noteData = jsonDecode(response.body);
      setState(() {
        notes = noteData.map((data) => Note.fromJson(data)).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
      ),
      body: notes.isEmpty
          ? Center(
              child: Text(
                'No notes yet. Click the "+" button to create one!',
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];
                return ListTile(
                  title: Text(note.title),
                  subtitle: Text(note.content),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Navigate to CreateNoteScreen and refresh list upon return
          final result = await Navigator.pushNamed(context, '/create');
          if (result == true) {
            // Refresh the notes list
            fetchNotes();
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

