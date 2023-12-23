import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class userStatus{
  var client=http.Client();
  final storage = new FlutterSecureStorage();
  Future<http.Response> acceptUser(String id,String user_status) async {

    try {
      var response = await client.post(
          Uri.parse("http://10.0.2.2:3000/api/updateProfile"),
          headers: {"Content-Type": "application/json"},
          body:jsonEncode({
            "_id":id,
            "user_status":user_status,
          }));
      //print(response.body);
      if(response.statusCode==201){
        Map<String, dynamic> x=jsonDecode(response.body);
        print(x["user"]);
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