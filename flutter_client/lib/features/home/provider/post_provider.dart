import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_client/common/constants/app_constants.dart';
import 'package:flutter_client/common/manager/network_manager.dart';
import 'package:flutter_client/common/models/user_info_model.dart';
import 'package:flutter_client/features/home/models/post_model.dart';

class PostProvider extends ChangeNotifier {
  final Map<String, dynamic> _cachedUsers = {};

  Future<UserInfoModel?> getUserById(String id) async {
    if (_cachedUsers[id] is UserInfoModel) {
      return _cachedUsers[id];
    }

    var res =
        await NormalNetworkManager().getResponseFromUrl('$url/user_by_id/$id');

    if (res.statusCode == 200) {
      _cachedUsers[id] =
          UserInfoModel.fromMap(jsonDecode(res.body) as Map<String, dynamic>);

      return _cachedUsers[id];
    }
    return null;
  }

  List<PostModel> posts = [];

  Future<void> fetchPosts() async {
    var res = await NormalNetworkManager().getResponseFromUrl('$url/get_posts');

    if (res.statusCode != 200) {
      return;
    }

    List<dynamic> d = jsonDecode(res.body) as List<dynamic>;

    posts = List.generate(
      d.length,
      (index) {
        return PostModel.fromMap(d[index] as Map<String, dynamic>);
      },
    );

    notifyListeners();
  }

  Future<bool> createPost({
    required String title,
    required String content,
    required List<String> tags,
  }) async {
    var res = await NormalNetworkManager()
        .postResponseFromUrl('$url/create_post', data: {
      'title': title,
      'content': content,
      'tags': tags,
      'image': "dummy imge for now",
    });

    if (res.statusCode == 200) {
      await fetchPosts();
      return true;
    }

    return false;
  }

  Future<bool> deletePost(String id) async {
    var res = await NormalNetworkManager()
        .deleteResponseFromUrl("$url/delete_post/$id");

    await fetchPosts();

    if (res.statusCode == 200) {
      return true;
    }

    return false;
  }

  Future<List<UserInfoModel>> getUsersByIds(List<String> ids) async {
    List<UserInfoModel> list = [];

    for (var id in ids) {
      var r = await getUserById(id);

      if (r != null) {
        list.add(r);
      }
    }

    return list;
  }
}
