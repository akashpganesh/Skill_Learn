import 'dart:convert';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:signup1/Tutor/AddCourse.dart';
import 'package:signup1/Tutor/Profile.dart';
import 'package:signup1/Tutor/Settings.dart';
import 'package:signup1/Tutor/TutorCourses.dart';
import 'package:signup1/Tutor/TutorDashboard.dart';
import 'package:signup1/Tutor/videoplayer.dart';
import 'package:signup1/login.dart';
import 'package:signup1/services/getuser.dart';

class NavDrawerTutor extends StatefulWidget {
  const NavDrawerTutor({Key? key}) : super(key: key);

  @override
  State<NavDrawerTutor> createState() => _NavDrawerTutorState();
}

class _NavDrawerTutorState extends State<NavDrawerTutor> {
  final storage = new FlutterSecureStorage();
  String userId="",
      userName="",
      userEmail="",
      image="";
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
      });
    });
  }

  void initState(){
    super.initState();
    this.checkAuthentication();
  }

  logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
        LoginPage()), (Route<dynamic> route) => false);

  }

  @override
  Widget build(BuildContext context) {
    final decodestring = base64Decode(image.split(',').last);
    Uint8List encodeedimg = decodestring;
    return Drawer(
      backgroundColor: Theme.of(context).primaryColor,
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(userName),
            accountEmail: Text(userEmail),
            currentAccountPicture: CircleAvatar(
                child: ClipOval(
                    child: Image.memory(
                      encodeedimg,
                      errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                        return Icon(Icons.person);
                      },
                      fit: BoxFit.cover,
                      width: 100.0,
                      height: 100.0,
                    ))
            ),
            decoration: BoxDecoration(
              color: Colors.blue,
              image: DecorationImage(
                image: AssetImage('asset/bgimg1.webp'),
                fit: BoxFit.fill,
              ),
            ),
            /*otherAccountsPictures: [
              CircleAvatar(
                backgroundColor: Colors.white,
                backgroundImage: NetworkImage(
                    "https://randomuser.me/api/portraits/women/74.jpg"),
              ),
              CircleAvatar(
                backgroundColor: Colors.white,
                backgroundImage: NetworkImage(
                    "https://randomuser.me/api/portraits/men/47.jpg"),
              ),
            ],*/
          ),
          ListTile(
            leading: Icon(Icons.home),iconColor: Colors.white,
            title: Text('Welcome'),textColor: Colors.white,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TutorDashboard()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.verified_user),iconColor: Colors.white,
            title: Text('Profile'),textColor: Colors.white,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TutorProfile()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),iconColor: Colors.white,
            title: Text('Settings'),textColor: Colors.white,
            onTap: () {Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const TutorSettings()),
            );
              },
          ),
          ListTile(
            leading: Icon(Icons.add),iconColor: Colors.white,
            title: Text('Add Course'),textColor: Colors.white,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddCourse()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.book),iconColor: Colors.white,
            title: Text('My Courses'),textColor: Colors.white,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TutorCourses()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.border_color),iconColor: Colors.white,
            title: Text('Feedback'),textColor: Colors.white,
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),iconColor: Colors.white,
            title: Text('Logout'),textColor: Colors.white,
            onTap: logout,
          ),
        ],
      ),
    );
  }
}