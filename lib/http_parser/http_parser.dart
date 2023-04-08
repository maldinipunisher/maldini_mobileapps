import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class HttpParser {
  Future<Response?> httpGet(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      return response;
    } on HttpException catch (_) {
      rethrow;
    }
  }

  Future<Response?> httpDelete(String url) async {
    try {
      final response = await http.delete(Uri.parse(url));
      return response;
    } on HttpException catch (_) {
      rethrow;
    }
  }

  Future<Response?> httpPost(String url, {Object? body}) async {
    try {
      final response = await http.post(Uri.parse(url),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(body));
      return response;
    } on HttpException catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<Response?> httpPut(String url, {Object? body}) async {
    try {
      final response = await http.put(Uri.parse(url),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(body));
      return response;
    } on HttpException catch (_) {
      rethrow;
    }
  }
}
