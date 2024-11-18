class Note {
  final int id;
  final String title;
  final String content;
  final String? imageUrl;
  final String? audioUrl;
  final String? tags;
  final DateTime? reminder;

  Note({
    required this.id,
    required this.title,
    required this.content,
    this.imageUrl,
    this.audioUrl,
    this.tags,
    this.reminder,
  });

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      imageUrl: json['image_url'],
      audioUrl: json['audio_url'],
      tags: json['tags'],
      reminder:
          json['reminder'] != null ? DateTime.parse(json['reminder']) : null,
    );
  }
}
