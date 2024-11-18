import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

class CreateNoteScreen extends StatefulWidget {
  @override
  _CreateNoteScreenState createState() => _CreateNoteScreenState();
}

class _CreateNoteScreenState extends State<CreateNoteScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  File? _imageFile;
  File? _audioFile;

  final _apiUrl = 'http://yourapi.com/notes'; // Replace with your API URL

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickAudio() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.audio);
    if (result != null && result.files.single.path != null) {
      setState(() {
        _audioFile = File(result.files.single.path!);
      });
    }
  }

  Future<void> _createNote() async {
    if (_titleController.text.isEmpty || _contentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Title and content cannot be empty')),
      );
      return;
    }

    final request = http.MultipartRequest('POST', Uri.parse(_apiUrl));
    request.fields['title'] = _titleController.text;
    request.fields['content'] = _contentController.text;

    if (_imageFile != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'image',
        _imageFile!.path,
      ));
    }

    if (_audioFile != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'audio',
        _audioFile!.path,
      ));
    }

    final response = await request.send();
    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Note created successfully')),
      );
      Navigator.pop(context, true); // Pass success result
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create note')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Note')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _contentController,
              decoration: InputDecoration(labelText: 'Content'),
              maxLines: 5,
            ),
            SizedBox(height: 16),
            Row(
              children: [
                ElevatedButton.icon(
                  icon: Icon(Icons.image),
                  label: Text('Pick Image'),
                  onPressed: _pickImage,
                ),
                SizedBox(width: 10),
                ElevatedButton.icon(
                  icon: Icon(Icons.audiotrack),
                  label: Text('Pick Audio'),
                  onPressed: _pickAudio,
                ),
              ],
            ),
            if (_imageFile != null)
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child:
                    Text('Image selected: ${_imageFile!.path.split('/').last}'),
              ),
            if (_audioFile != null)
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child:
                    Text('Audio selected: ${_audioFile!.path.split('/').last}'),
              ),
            Spacer(),
            ElevatedButton(
              onPressed: _createNote,
              child: Text('Save Note'),
            ),
          ],
        ),
      ),
    );
  }
}
