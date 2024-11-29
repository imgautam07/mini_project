import 'dart:convert';
import 'dart:developer';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class UserInfoModel {
  String id;
  String name;
  List<String> professions;
  List<String> friends;
  String experience;
  List<String> technologies;
  UserInfoModel({
    required this.id,
    required this.name,
    required this.professions,
    required this.friends,
    required this.experience,
    required this.technologies,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'professions': professions,
      'friends': friends,
      'experience': experience,
      'technologies': technologies,
    };
  }

  factory UserInfoModel.fromMap(Map<String, dynamic> map) {
    return UserInfoModel(
      id: (map['id'] as Map<String, dynamic>)['id']['String'],
      name: map['name'] as String,
      professions: List<String>.from(map['professions'] as List<dynamic>),
      friends: List<String>.from(map['friends'] as List<dynamic>),
      experience: map['experience'] as String,
      technologies: List<String>.from(map['technologies'] as List<dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserInfoModel.fromJson(String source) =>
      UserInfoModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
