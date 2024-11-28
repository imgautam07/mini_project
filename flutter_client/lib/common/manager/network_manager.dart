import 'dart:convert';
import 'dart:io';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class NormalNetworkManager {
  final http.Client client;

  NormalNetworkManager({required this.client});

  Future<http.Response> getResponseFromUrl(
    String url, {
    Map<String, String>? headers,
  }) async {
    try {
      return await client.get(Uri.parse(url), headers: headers);
    } on Exception {
      Fluttertoast.showToast(msg: "Failed to make network call");
      // return http.Response("Failed to resolve", 401);
      throw UnsupportedError("message");
    }
  }

  Future<http.Response> postResponseFromUrl(String url,
      {Map<String, dynamic>? data, Map<String, String>? headers}) async {
    try {
      return await client.post(Uri.parse(url), body: data, headers: headers);
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
      return await client.put(Uri.parse(url), body: data, headers: headers);
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
      return await client.delete(Uri.parse(url), body: data, headers: headers);
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