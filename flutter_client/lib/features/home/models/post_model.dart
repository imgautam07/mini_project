// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PostModel {
  final String id;
  final String userId;
  final String title;
  String content;
  final List<String> tags;
  final String image;
  final DateTime createdAt;
  final int likesCount;
  final int commentsCount;

  PostModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.content,
    required this.tags,
    required this.image,
    required this.createdAt,
    required this.likesCount,
    required this.commentsCount,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'user_id': userId,
      'title': title,
      'content': content,
      'tags': tags,
      'image': image,
      'created_at': createdAt.toString(),
      'likes_count': likesCount,
      'comments_count': commentsCount,
    };
  }

  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      id: (map['id'] as Map<String, dynamic>)['id']['String'],
      userId: map['user_id'] as String,
      title: map['title'] as String,
      content: map['content'] as String,
      tags: List<String>.from(map['tags'] as List<dynamic>),
      image: map['image'] as String,
      createdAt: DateTime.parse(map['created_at']),
      likesCount: map['likes_count'] as int,
      commentsCount: map['comments_count'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory PostModel.fromJson(String source) =>
      PostModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
