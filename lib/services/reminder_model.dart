class Reminder{
  final int? id;
  final String title;
  final String content;
  final DateTime dateTime;
  final String repeat;

  Reminder({
    this.id,
    required this.title,
    required this.content,
    required this.dateTime,
    required this.repeat,
  });

  Map<String, dynamic> toMap(){
    return {
      'id' : id,
      'title' : title,
      'content' : content,
      'dateTime' : dateTime.toIso8601String(),
      'repeat' : repeat,
    };
  } 

  factory Reminder.fromMap(Map<String, dynamic> map) {
    return Reminder(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      dateTime: DateTime.parse(map['dateTime']),
      repeat: map['repeat'],
    );
  }
}