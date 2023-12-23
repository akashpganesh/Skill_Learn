import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:signup1/Admin/MyCourseDetails.dart';
import 'package:signup1/Admin/NavDrawerAdmin.dart';
import 'package:signup1/Tutor/CourseDetails.dart';
import 'package:signup1/services/DisplayCourses.dart';

class MyCoursesAdmin extends StatefulWidget {
  const MyCoursesAdmin({Key? key}) : super(key: key);

  @override
  State<MyCoursesAdmin> createState() => _MyCoursesAdminState();
}

class _MyCoursesAdminState extends State<MyCoursesAdmin> {
  final storage = new FlutterSecureStorage();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String userId="",CourseName="",id="",token="";
  String? jwt;
  List x=[];

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
    this.course();

  }

  Future<void> course() async {
    displayCourses course = new displayCourses();
    Future<Response> status = course.dispCourses(userId!);

    status.then((value) {
      print(value.statusCode);
      // print(value.body);
      setState(() {
        x=jsonDecode(value.body);
      });
      print(x);
      // print(x["course_name"]);
      // print(x["course_specialization"]);
      // setState(() {
      //   CourseName=x["course_name"];
      //   specialization=x["course_specialization"];
      // });
    });
  }

  selCourse() async {
    print("select course");
    try {
      await storage.write(key: "courseId", value: id);
      Map<String, String> allValues = await storage.readAll();
      print(allValues);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MyCourseDetailsAdmin()),
      );
    }catch(e){
      print(e);
    }
  }


  void initState(){
    super.initState();
    this.checkAuthentication();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        drawer: NavDrawerAdmin(),
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
        body:Form(
            key: _formKey,
            child: ListView.builder(
              itemCount: x.length,
              itemBuilder: (BuildContext ctx,index){
                final decodestring = base64Decode(x[index]["course_image"].split(',').last);
                Uint8List encodeedimg = decodestring;
                return Card(
                    color: Colors.deepPurple,
                    child:ListTile(
                        leading: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 25.0,
                            backgroundImage: AssetImage('asset/user.jpg'),
                            child: ClipOval(
                                child: Image.memory(
                                  encodeedimg,
                                  fit: BoxFit.cover,
                                  width: 100.0,
                                  height: 100.0,
                                ))),
                        title: Text(x[index]["course_name"]),textColor: Colors.white,
                        subtitle: Text(""),
                        onTap: (){
                          setState(() {
                            id=x[index]["_id"];
                          });
                          selCourse();
                        }
                    )
                );
              },

            )
        )
    );
  }
}
