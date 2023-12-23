import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:signup1/Admin/CourseDetails.dart';
import 'package:signup1/Admin/NavDrawerAdmin.dart';
import 'package:signup1/Tutor/CourseDetails.dart';
import 'package:signup1/services/DisplayCourses.dart';

class CoursesList extends StatefulWidget {
  const CoursesList({Key? key}) : super(key: key);

  @override
  State<CoursesList> createState() => _CoursesListState();
}

class _CoursesListState extends State<CoursesList> {
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
    Future<Response> status = course.CourseList();

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
        MaterialPageRoute(builder: (context) => const CourseDetailsAdmin()),
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
                // return Card(
                //     color: Colors.deepPurple,
                //     child:ListTile(
                //         leading: CircleAvatar(
                //             backgroundColor: Colors.white,
                //             radius: 25.0,
                //             child: ClipOval(
                //                 child: Image.memory(
                //                   encodeedimg,
                //                   fit: BoxFit.cover,
                //                   width: 100.0,
                //                   height: 100.0,
                //                 ))),
                //         title: Text(x[index]["course_name"]),textColor: Colors.white,
                //         subtitle: Text(""),
                //         onTap: (){
                //           setState(() {
                //             id=x[index]["_id"];
                //           });
                //           selCourse();
                //         }
                //     )
                // );
                return Card(
                  color: Colors.deepPurple,
                  elevation: 5,
                  margin: EdgeInsets.all(10),
                  child: ExpansionTile(
                    leading: CircleAvatar(
                        radius: 25.0,
                        child: ClipOval(
                            child: Image.memory(
                              encodeedimg,
                              errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                return Icon(Icons.person);
                              },
                              fit: BoxFit.cover,
                              width: 100.0,
                              height: 100.0,
                            ))),
                    title: Text(x[index]["course_name"], style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                    ),
                    ),textColor: Colors.white,
                    subtitle: Text(x[index]["topics"][0]["topic_name"], style: TextStyle(
                        color: Colors.white
                    )),
                    trailing: ElevatedButton(
                      onPressed: (){
                        setState(() {
                          id=x[index]["_id"];
                        });
                        selCourse();
                      },
                      child: Text('Open'),
                    ),
                    // ignore: prefer_const_literals_to_create_immutables
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Text(
                                "Course Type:" +
                                    (x[index]["type"][0]["type_name"]),
                                style: TextStyle(
                                    color: Colors.white
                                ),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                "Topic:" +
                                    (x[index]["topics"][0]["topic_name"]),
                                style: TextStyle(
                                    color: Colors.white
                                ),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Row(
                                  children:[
                                    TextButton(
                                        onPressed: () {},
                                        child: Text(
                                          "Accept",
                                          style: TextStyle(color: Colors.green),
                                        )),
                                    TextButton(
                                        onPressed: () {},
                                        child: Text(
                                          "Reject",
                                          style: TextStyle(color: Colors.red),
                                        )),
                                    IconButton(
                                      onPressed: () {},
                                      icon: Icon(Icons.delete),color: Colors.red),
                                  ]
                              )
                            ],
                          )),
                    ],
                  ),
                );
              },

            )
        )
    );
  }
}
