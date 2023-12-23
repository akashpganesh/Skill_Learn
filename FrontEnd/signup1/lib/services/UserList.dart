import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Users{
  var client=http.Client();
  final storage = new FlutterSecureStorage();
  Future<http.Response> usersList(String user_type) async {

    try {
      var response = await client.post(
          Uri.parse("http://10.0.2.2:3000/api/dispUsers"),
          headers: {"Content-Type": "application/json"},
          body:jsonEncode({
            "user_type":user_type
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

}