import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:signup1/User/MyCourseDetails.dart';
import 'package:signup1/User/NavDrawerUser.dart';
import 'package:signup1/services/DisplayCourses.dart';

class MyCourses extends StatefulWidget {
  const MyCourses({Key? key}) : super(key: key);

  @override
  State<MyCourses> createState() => _MyCoursesState();
}

class _MyCoursesState extends State<MyCourses> {
  final storage = new FlutterSecureStorage();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String userID="",id="";
  List x=[];

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
    this.course();
  }

  Future<void> course() async {
    displayCourses course = new displayCourses();
    Future<Response> status = course.myCourses(userID);

    status.then((value) {
      print(value.statusCode);
      setState(() {
        x=jsonDecode(value.body);
      });
      print(x);
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
        MaterialPageRoute(builder: (context) => const MyCourseDetails()),
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
        drawer: NavDrawerUser(),
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
                final decodestring = base64Decode(x[index]["courses"][0]["course_image"].split(',').last);
                Uint8List encodeedimg = decodestring;
                //print(x[index]["course_details"][0]["course_image"]);
                return Card(
                    color: Colors.deepPurple,
                    child:ListTile(
                        leading: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 25.0,
                            child: ClipOval(
                                child: Image.memory(
                                  encodeedimg,
                                  fit: BoxFit.cover,
                                  width: 100.0,
                                  height: 100.0,
                                ))),
                        title: Text(x[index]["courses"][0]["course_name"]),textColor: Colors.white,
                        subtitle: Text(""),
                        onTap: (){
                          setState(() {
                            id=x[index]["courses"][0]["_id"];
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
