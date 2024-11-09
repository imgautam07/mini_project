import 'dart:async';
import 'dart:io';

import 'package:flutter_client/common/constants/app_strings.dart';
import 'package:flutter/material.dart';

class AuthServices extends ChangeNotifier {
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
  Future<String> accountStatus() async {
    if (isLoading) return AppStrings.error;
    isLoading = true;
    notifyListeners();

    isLoading = false;

    notifyListeners();

    return AppStrings.ok;
  }

  Future<void> postProfile({
    String? name,
    Map<String, dynamic>? data,
    File? image,
  }) async {
    Map<String, dynamic> cont = {};

    await accountStatus();
  }

  Future<String> login({
    required String mail,
    required String password,
  }) async {
    if (isLoading) return AppStrings.error;
    isLoading = true;
    notifyListeners();
    return AppStrings.ok;
  }

  Future<void> logout() async {
    isLoading = false;
    notifyListeners();
  }
}
