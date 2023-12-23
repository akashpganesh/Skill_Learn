import 'dart:convert';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:signup1/Admin/AddCourse.dart';
import 'package:signup1/Admin/CourseList.dart';
import 'package:signup1/Admin/CourseTopic.dart';
import 'package:signup1/Admin/CourseType.dart';
import 'package:signup1/Admin/MyCoursesAdmin.dart';
import 'package:signup1/Admin/Profile.dart';
import 'package:signup1/Admin/TutorList.dart';
import 'package:signup1/Admin/UsersList.dart';
import 'package:signup1/Admin/dashboard.dart';
import 'package:signup1/login.dart';
import 'package:signup1/services/getuser.dart';

class NavDrawerAdmin extends StatefulWidget {
  const NavDrawerAdmin({Key? key}) : super(key: key);

  @override
  State<NavDrawerAdmin> createState() => _NavDrawerAdminState();
}

class _NavDrawerAdminState extends State<NavDrawerAdmin> {

  final storage = new FlutterSecureStorage();
  String userID="",userName="",userEmail="",image="";

  Future<void> checkAuthentication() async {
    try{
      Map<String, String> allValues = await storage.readAll();
      if(allValues.isEmpty){
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
      }
      else{
        this.getID();


      }
    }catch(e){

    }
  }

  Future<void>getID() async {
    Map<String, dynamic> allValues = await storage.readAll();
    setState(() {
      userID=allValues["_id"];
    });
    print(userID);
    this.getUserName();
  }

  Future<void> getUserName() async {
    print("in get user");
    print(userID);
    getUser get = new getUser();
    Future<Response> status = get.findUser(userID!);

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
                        return Icon(Icons.image_not_supported);
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
            title: Text('Home'),textColor: Colors.white,
            onTap: () {Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const DashBoard()),
            );
            },
          ),
          ListTile(
            leading: Icon(Icons.verified_user),iconColor: Colors.white,
            title: Text('Profile'),textColor: Colors.white,
            onTap:() {Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AdminProfile()),
            );
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),iconColor: Colors.white,
            title: Text('Settings'),textColor: Colors.white,
            onTap: () => {Navigator.of(context).pop()},
          ),
          ExpansionTile(
            leading: Icon(Icons.group,color: Colors.white),iconColor: Colors.white,
            title: Text('Course ',style: TextStyle(color: Colors.white)),textColor: Colors.white,
            children: [
              ListTile(
                leading: Icon(Icons.group),iconColor: Colors.white,
                title: Text('Course Type'),textColor: Colors.white,
                onTap: () {Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CourseType()),
                );
                },
              ),
              ListTile(
                leading: Icon(Icons.group),iconColor: Colors.white,
                title: Text('Course Topic'),textColor: Colors.white,
                onTap: () {Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CourseTopic()),
                );
                },
              ),
              ListTile(
                leading: Icon(Icons.group),iconColor: Colors.white,
                title: Text('Course List'),textColor: Colors.white,
                onTap: () {Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CoursesList()),
                );
                },
              ),
            ],
          ),
          ExpansionTile(
            leading: Icon(Icons.group,color: Colors.white),iconColor: Colors.white,
            title: Text('My Course',style: TextStyle(color: Colors.white)),textColor: Colors.white,
            children: [
              ListTile(
                leading: Icon(Icons.add),iconColor: Colors.white,
                title: Text('Add Course'),textColor: Colors.white,
                onTap: () {Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddCourseAdmin()),
                );
                },
              ),
              ListTile(
                leading: Icon(Icons.group),iconColor: Colors.white,
                title: Text('My Courses'),textColor: Colors.white,
                onTap: () {Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MyCoursesAdmin()),
                );
                },
              ),
            ],
          ),
          ExpansionTile(leading: Icon(Icons.group,color: Colors.white),iconColor: Colors.white,
            title: Text('Users',style: TextStyle(color: Colors.white)),textColor: Colors.white,
            children: [
              ListTile(
                leading: Icon(Icons.group),iconColor: Colors.white,
                title: Text('Users List'),textColor: Colors.white,
                onTap: () {Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const UsersList()),
                );
                },
              ),
              ListTile(
                leading: Icon(Icons.group),iconColor: Colors.white,
                title: Text('Tutor List'),textColor: Colors.white,
                onTap: () {Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TutorList()),
                );
                },
              ),
            ],
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