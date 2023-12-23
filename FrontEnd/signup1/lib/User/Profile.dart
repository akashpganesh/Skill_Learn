import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:signup1/User/ChangePassword.dart';
import 'package:signup1/User/EditProfile.dart';
import 'package:signup1/User/NavDrawerUser.dart';
import 'package:signup1/services/getuser.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final storage = new FlutterSecureStorage();
  String userId="",
      userName="",
      userEmail="",
      image="",
      userPhone="";
  String? jwt;

  Future<void> checkAuthentication() async {
    try{
      Map<String, String> allValues = await storage.readAll();
      if(allValues.isEmpty){
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
      }
      else{
        this.getToken();


      }
    }catch(e){

    }
  }

  Future<void>getToken() async {
    String normalizedSource;
    String userid;
    Map<String, String> allValues = await storage.readAll();
    setState(() {
      jwt=allValues["token"];
    });
    normalizedSource = base64Url.normalize(allValues["token"]!.split(".")[1]);
    userid= json.decode(utf8.decode(base64Url.decode(normalizedSource)))["_id"];
    print(userid);
    setState(() {
      userId=userid;
    });
    this.getUserName();


  }
  Future<void> getUserName() async {
    print("in get user");
    print(userId);
    getUser get = new getUser();
    Future<Response> status = get.findUser(userId!);

    status.then((value) {
      print(value.body);
      Map<String, dynamic> x = jsonDecode(value.body);
      print(x["user"]);
      print(x["name"]);
      print(x["email"]);
      setState(() {
        userName=x["name"];
        userEmail=x["email"];
        image=x["image"];
        userPhone=x["phone"].toString();
      });
    });
  }

  void initState(){
    super.initState();
    this.checkAuthentication();
  }
  @override
  Widget build(BuildContext context) {
    final decodestring = base64Decode(image.split(',').last);
    Uint8List encodeedimg = decodestring;
    return Scaffold(
        drawer: NavDrawerUser(),
        backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(
          title: Padding(
              padding: EdgeInsets.only(left: 30),
              child: Container(
                  height: 50,
                  width: 200,
                  child:Image.asset('asset/dashboard/logo.png')
              )
          )
        ),
        body: Center(
            child:Container(
                height: 500,
                width: 350,
                decoration: BoxDecoration(
                  color: Colors.blueGrey,
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: ListView(
                    children: [
                      SizedBox(
                        height: 30.0,
                      ),
                      CircleAvatar(
                        backgroundColor: Colors.black,
                        radius: 80,
                        child: CircleAvatar(
                            radius: 75,
                            child: ClipOval(
                                child: Image.memory(
                                  encodeedimg,
                                  errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                    return Icon(Icons.person);
                                  },
                                  fit: BoxFit.cover,
                                  width: 190.0,
                                  height: 190.0,
                                )
                              )
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                        child: Container(
                          child: Material(
                            elevation: 15.0,
                            shadowColor: Colors.black,
                            borderRadius: BorderRadius.circular(15.0),
                            child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: Text('Name: '+userName,
                                style: TextStyle(
                                  fontSize: 20,
                                ),),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                        child: Container(
                          child: Material(
                            elevation: 15.0,
                            shadowColor: Colors.black,
                            borderRadius: BorderRadius.circular(15.0),
                            child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: Text( "Email: " +userEmail,
                                style: TextStyle(
                                  fontSize: 20,
                                ),),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                        child: Container(
                          child: Material(
                            elevation: 15.0,
                            shadowColor: Colors.black,
                            borderRadius: BorderRadius.circular(15.0),
                            child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: Text('Phone: '+userPhone,
                                style: TextStyle(
                                  fontSize: 20,
                                ),),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Row(
                        children:[
                          SizedBox(
                            width: 40.0,
                          ),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const EditProfile()),
                            );
                          },
                          child: Text("Edit Profile")),
                          SizedBox(
                            width: 20.0,
                          ),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const ChangePassword()),
                            );
                          },
                          child: Text("Change Password")),
                          ]
                      )
                    ]
                )
            )
        )
    );
  }
}
