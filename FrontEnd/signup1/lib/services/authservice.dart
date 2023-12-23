import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Authentication{
  var client=http.Client();
  final storage = new FlutterSecureStorage();
  Future<http.Response> loginUser(String email,String password) async {

    try {
      var response = await client.post(
          Uri.parse("http://10.0.2.2:3000/api/login"),
          headers: {"Content-Type": "application/json"},
          body:jsonEncode({
            "email":email,
            "password":password
          }));
      //print(response.body);
      if(response.statusCode==201){
        Map<String, dynamic> x=jsonDecode(response.body);
        print(x["token"]);
        print(x["user"]);
        await storage.write(key: "token", value: x["token"]);
        Map<String, String> allValues = await storage.readAll();
        print(allValues);


        return response;
      }
      else{
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