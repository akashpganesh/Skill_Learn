import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class displayCourses{
  var client=http.Client();
  final storage = new FlutterSecureStorage();
  Future<http.Response> dispCourses(String tutor_id) async {

    try {
      var response = await client.post(
          Uri.parse("http://10.0.2.2:3000/api/dispCourse"),
          headers: {"Content-Type": "application/json"},
          body:jsonEncode({
            "tutor_id":tutor_id
          }));
      print(response.body);
      if(response.statusCode==201){
        print("201");
        return response;
      }
      else{
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

  Future<http.Response> dispType() async {

    try {
      var response = await client.post(
          Uri.parse("http://10.0.2.2:3000/api/dispType"),
          headers: {"Content-Type": "application/json"},
          body:jsonEncode({

          }));
      print(response.body);
      if(response.statusCode==201){
        print("201");
        return response;
      }
      else{
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

  Future<http.Response> searchCourses() async {

    try {
      var response = await client.post(
          Uri.parse("http://10.0.2.2:3000/api/searchCourse"),
          headers: {"Content-Type": "application/json"},
          body:jsonEncode({

          }));
      print(response.body);
      if(response.statusCode==201){
        print("201");
        return response;
      }
      else{
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

  Future<http.Response> myCourses(String user_id) async {

    try {
      var response = await client.post(
          Uri.parse("http://10.0.2.2:3000/api/getCourse"),
          headers: {"Content-Type": "application/json"},
          body:jsonEncode({
            "user_id":user_id
          }));
      print(response.body);
      if(response.statusCode==201){
        print("201");
        return response;
      }
      else{
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

  Future<http.Response> dispTopic(String type_id) async {

    try {
      var response = await client.post(
          Uri.parse("http://10.0.2.2:3000/api/dispTopic"),
          headers: {"Content-Type": "application/json"},
          body:jsonEncode({
            "type_id":type_id
          }));
      print(response.body);
      if(response.statusCode==201){
        print("201");
        return response;
      }
      else{
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

  Future<http.Response> myBookings(String user_id) async {

    try {
      var response = await client.post(
          Uri.parse("http://10.0.2.2:3000/api/getBookings"),
          headers: {"Content-Type": "application/json"},
          body:jsonEncode({
            "user_id":user_id
          }));
      print(response.body);
      if(response.statusCode==201){
        print("201");
        return response;
      }
      else{
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

  Future<http.Response> Search(String topic_id) async {
    try {
      var response = await client.post(
          Uri.parse("http://10.0.2.2:3000/api/search"),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "topic_id": topic_id
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

  Future<http.Response> CourseList() async {
    try {
      var response = await client.post(
          Uri.parse("http://10.0.2.2:3000/api/courseList"),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({

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