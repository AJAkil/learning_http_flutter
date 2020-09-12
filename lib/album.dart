import 'dart:convert';
import 'dart:async';

class Album{
  final int userId;
  final int id;
  final String title;
  final String body;

  Album({this.userId, this.id, this.title, this.body});

  factory Album.fromJson(Map<String, dynamic> json){
  return Album(
  userId: json['userId'],
  id: json['id'],
  title: json['title'],
  );
  }

  factory Album.fromJsonPost(Map<String, dynamic> json) {
    return Album(
      id: json['id'],
      title: json['title'],
      body: json['body']
    );
  }
}