import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_client/common/constants/app_constants.dart';
import 'package:flutter_client/common/manager/local_manager.dart';
import 'package:flutter_client/common/manager/network_manager.dart';
import 'package:flutter_client/common/models/user_info_model.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AuthServices extends ChangeNotifier {
  UserInfoModel? userInfoModel;

  List<String> techOptions = [
    'Flutter',
    'React',
    'Rust',
    'Angular',
    'Vue',
    'Svelte',
    'Next',
    'Node',
    'Express',
    'Django',
    'Flask',
    'Ruby',
    'Swift',
    'Kotlin',
    'Go',
    'Java',
    'TypeScript',
    'GraphQL',
  ];

  bool isLoading = false;

  Future<bool> postProfile(Map<String, dynamic> data) async {
    await NormalNetworkManager()
        .postResponseFromUrl("$url/update_profile", data: data);

    return await accountStatus();
  }

  Future<bool> login({
    required String mail,
    required String password,
  }) async {
    var res = await NormalNetworkManager().postResponseFromUrl(
      "$url/login",
      data: {
        "email": mail,
        "password": password,
      },
    );

    if (res.statusCode == 200) {
      await LocalDataManager.storeToken(jsonDecode(res.body)['token']);
      return true;
    }

    isLoading = true;
    notifyListeners();
    return false;
  }

  Future<void> logout() async {
    isLoading = false;
    await LocalDataManager.deleteToken();
    userInfoModel = null;
    notifyListeners();
  }

  Future<bool> signup({
    required String email,
    required String password,
  }) async {
    var res = await NormalNetworkManager().postResponseFromUrl(
      "$url/signup",
      data: {
        "email": email,
        "password": password,
      },
    );

    if (res.statusCode == 200) {
      await LocalDataManager.storeToken(jsonDecode(res.body)['token']);

      return true;
    }

    return false;
  }

  Future<bool> accountStatus() async {
    var res =
        await NormalNetworkManager().getResponseFromUrl('$url/get_profile');

    if (res.statusCode == 200) {
      userInfoModel = UserInfoModel.fromMap(jsonDecode(res.body));
      notifyListeners();
      return true;
    }

    return false;
  }

  Future<bool> addFriend(String uid) async {
    var res =
        await NormalNetworkManager().putResponseFromUrl('$url/add_friend/$uid');

    if (res.statusCode == 200) {
      await accountStatus();
      return true;
    }

    Fluttertoast.showToast(msg: "Faidled add friend");
    return false;
  }
}
