import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class displayVideos {
  var client = http.Client();
  final storage = new FlutterSecureStorage();

  Future<http.Response> dispVideos(String course_id) async {
    try {
      var response = await client.post(
          Uri.parse("http://10.0.2.2:3000/api/dispVideo"),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "course_id": course_id
          }));
      print(response.body);
      if (response.statusCode == 201) {
        print("201");
        return response;
      }
      else {
        print("in else");
        return response;
      }
    }
    catch (e) {
      print(e);
      return http.Response("error", 404);
    }
    finally {
      client.close();
    }
  }

  Future<http.Response> selVideos(String id) async {
    try {
      var response = await client.post(
          Uri.parse("http://10.0.2.2:3000/api/selVideo"),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "_id": id
          }));
      print(response.body);
      if (response.statusCode == 201) {
        print("201");
        return response;
      }
      else {
        print("in else");
        return response;
      }
    }
    catch (e) {
      print(e);
      return http.Response("error", 404);
    }
    finally {
      client.close();
    }
  }

}