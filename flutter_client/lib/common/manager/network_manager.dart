import 'dart:convert';
import 'dart:io';

import 'package:flutter_client/common/manager/local_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class NormalNetworkManager {
  NormalNetworkManager();

  Future<http.Response> getResponseFromUrl(
    String url, {
    Map<String, String>? headers,
  }) async {
    try {
      String? token = await LocalDataManager.getToken();
      if (token != null) {
        headers ??= {};
        headers[HttpHeaders.authorizationHeader] = 'Bearer $token';
        headers['content-type'] = 'application/json';
        headers['Accept'] = '*/*';
      }

      return await http.get(Uri.parse(url), headers: headers);
    } on Exception {
      Fluttertoast.showToast(msg: "Failed to make network call");
      // return http.Response("Failed to resolve", 401);
      throw UnsupportedError("message");
    }
  }

  Future<http.Response> postResponseFromUrl(String url,
      {Map<String, dynamic>? data, Map<String, String>? headers}) async {
    try {
      String? token = await LocalDataManager.getToken();
      if (token != null) {
        headers ??= {};
        headers['Authorization'] = 'Bearer $token';
      }
      return await http.post(Uri.parse(url),
          body: jsonEncode(data), headers: headers);
    } on Exception catch (e) {
      Fluttertoast.showToast(msg: "Failed to make network call");
      // return http.Response("Failed to resolve", 401);
      throw UnsupportedError(
          "Failed to make network call due to ${e.toString()}");
    }
  }

  Future<http.Response> putResponseFromUrl(String url,
      {Map<String, dynamic>? data, Map<String, String>? headers}) async {
    try {
      String? token = await LocalDataManager.getToken();
      if (token != null) {
        headers ??= {};
        headers['Authorization'] = 'Bearer $token';
      }
      return await http.put(Uri.parse(url), body: data, headers: headers);
    } on Exception catch (e) {
      Fluttertoast.showToast(msg: "Failed to make network call");
      // return http.Response("Failed to resolve", 401);
      throw UnsupportedError(
          "Failed to make network call due to ${e.toString()}");
    }
  }

  Future<http.Response> deleteResponseFromUrl(String url,
      {Map<String, dynamic>? data, Map<String, String>? headers}) async {
    try {
      String? token = await LocalDataManager.getToken();
      if (token != null) {
        headers ??= {};
        headers['Authorization'] = 'Bearer $token';
      }
      return await http.delete(Uri.parse(url), body: data, headers: headers);
    } on Exception {
      Fluttertoast.showToast(msg: "Failed to make network call");
      // return http.Response("Failed to resolve", 401);
      throw UnsupportedError("message");
    }
  }
}

class MultipartNetworkManager {
  final http.MultipartRequest request;

  MultipartNetworkManager({required this.request});

  Future<http.StreamedResponse> makeRequest({
    required Map<String, dynamic> data,
    required Map<String, dynamic> headers,
    required List<File> files,
    required String fileKey,
  }) async {
    try {
      String? token = await LocalDataManager.getToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
      for (var k in data.keys) {
        request.fields[k] = data[k];
      }
      for (var k in headers.keys) {
        request.headers[k] = headers[k];
      }

      for (var i = 0; i < files.length; i++) {
        request.files.add(
          await http.MultipartFile.fromPath(
            fileKey,
            files[i].path,
          ),
        );
      }

      return request.send();
    } on Exception {
      return http.StreamedResponse(const Stream.empty(), 401);
    }
  }
}

class CustomResponse {
  bool hasError;
  String message;
  dynamic data;
  int code;
  CustomResponse({
    required this.hasError,
    required this.message,
    required this.code,
    this.data,
  });

  @override
  String toString() {
    return jsonEncode({
      "hasError": hasError,
      "message": message,
      "statusCode": code,
      "data": "$data",
    });
  }
}
