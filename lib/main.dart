import 'package:flutter/material.dart';
import 'package:notekeun/ui/note_list.dart';
import 'package:notekeun/ui/new_note.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Note-Taking App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/', // Default route
      routes: {
        '/': (context) => NoteListScreen(), // Notes List as the default screen
        '/create': (context) =>
            CreateNoteScreen(), // Route to Create Note Screen
      },
    );
  }
}
