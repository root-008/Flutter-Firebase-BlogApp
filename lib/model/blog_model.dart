import 'package:cloud_firestore/cloud_firestore.dart';

class Blog {
  String? id;
  String title;
  String author;
  String text;
  DateTime time;
  String category;
  String authorId;
  int? views = 0;

  Blog(
      {this.id,
      required this.title,
      required this.author,
      required this.text,
      required this.time,
      required this.category,
      required this.authorId,
      this.views});

  factory Blog.fromJson(Map<String, dynamic> json) {
    return Blog(
      id: json['id'],
      title: json['title'],
      author: json['author'],
      text: json['text'],
      time: (json['time']).toDate(),
      category: json['category'],
      authorId: json['authorId'],
      views: json['views'],
    );
  }

  toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'text': text,
      'time': Timestamp.fromDate(time),
      'category': category,
      'authorId': authorId,
      'views': views,
    };
  }
}
