import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:signup1/Admin/NavDrawerAdmin.dart';
import 'package:signup1/Tutor/course.dart';
import 'package:signup1/services/DisplayCourses.dart';
import 'package:signup1/widget/inputTextWidget.dart';

class AddCourseAdmin extends StatefulWidget {
  const AddCourseAdmin({Key? key}) : super(key: key);

  @override
  State<AddCourseAdmin> createState() => _AddCourseAdminState();
}

class _AddCourseAdminState extends State<AddCourseAdmin> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String course_name="",course_topic="",course_duration="",course_price="",type_id="",topic_id="";
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool issigned = false;
  List type=[],topic=[];
  int selectedType= 1,selectedTopic= 1;

  final storage = new FlutterSecureStorage();
  String? jwt;
  String userId="",image="";
  bool isLoggedin=true;
  final ImagePicker _picker = ImagePicker();
  XFile? _image;


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
    // this.getUser();
    // this.getWalletAmount();
    // this.getJoinedMembers();
    this.disptype();
  }

  Future<void> disptype() async {
    displayCourses coursetype = new displayCourses();
    Future<http.Response> status = coursetype.dispType();

    status.then((value) {
      print(value.statusCode);

      setState(() {
        type=jsonDecode(value.body);
      });
      print(type);
    });
  }

  Future<void> disptopic() async {
    displayCourses coursetopic = new displayCourses();
    Future<http.Response> status = coursetopic.dispTopic(type_id);

    status.then((value) {
      print(value.statusCode);

      setState(() {
        topic=jsonDecode(value.body);
      });
      print(topic);
    });
  }

  logout() async {
    await storage.delete(key: "token");
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);

  }

  Future cameraImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,

    );

    List<String>? s=pickedFile?.path.toString().split("/");
    // print(s?.length.toString());
    // print(s![s.length-1].split(".")[1]);

    final bytes=await File(pickedFile!.path).readAsBytes();
    final base64=base64Encode(bytes);
    // print(base64);

    var pic="data:image/"+s![s.length-1].split(".")[1]+";base64,"+base64;
    print(pic);



    setState(() {
      _image = pickedFile;
      image = pic;
    });
  }

  encodeToBase64(String path)async{
    final bytes=await File(path).readAsBytes();
    final base64=base64Encode(bytes);
    print(base64);
    return base64;
  }

  void initState(){
    super.initState();
    this.checkAuthentication();
  }


  addCourse() async {
    if(_formKey.currentState!.validate()){

      Courses course=new Courses(course_name,topic_id,course_duration,course_price,userId,image);
      String coursedata=jsonEncode(course);
      print(coursedata);
      var client = http.Client();
      try{
        var response = await client.post(
            Uri.parse('http://10.0.2.2:3000/api/addCourse'),
            headers: {"Content-Type": "application/json"},
            body:coursedata);
        print(response.body);
        print(response.statusCode);
        //String res=jsonDecode(response.body);
        //print(res);

        if(response.statusCode==404){
          showDialog(context: context, builder: (BuildContext context){
            return AlertDialog(
              title: Text('Error'),
              content: Text("error"),
              actions: [
                TextButton(
                  child: Text("Ok"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
        }
        else{
          print("registration successfull");

          showDialog(context: context, builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Registration Completed'),
              content: Text("Registration Completed"),
              actions: [
                TextButton(
                  child: Text("Ok"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
        }
      }
      catch(e){
        print(e);
        print(e);
        showDialog(context: context, builder: (BuildContext context){
          return AlertDialog(
            title: Text('Error'),
            content: Text("Error in registration"),
            actions: [
              TextButton(
                child: Text("Ok"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
      }

    }

  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    int typeCount=type.length;
    int topicCount=topic.length;
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
      body:Center(
      child:Container(
          height: 600,
          width: 350,
          decoration: BoxDecoration(
            color: Colors.blueGrey,
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: ListView(
            children: [
              Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                  Container(
                      child: InputTextWidget(
                        labelText: "Course Name",
                        //icon: Icons.do_not_disturb_on_total_silence,
                        obscureText: false,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if(value!.isEmpty){
                            return "required";
                          }
                          setState(() {
                            course_name=value;
                          });
                          return null;

                        },
                      ),
                  ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                        child: Container(
                          child: Material(
                            elevation: 15.0,
                            shadowColor: Colors.black,
                            borderRadius: BorderRadius.circular(15.0),
                            child: Padding(
                              padding: const EdgeInsets.only(right: 15.0, left: 15.0),
                              child: Column(
                                children:[
                                  DropdownButtonFormField(
                                    decoration: const InputDecoration(
                                      labelText: 'Select Type',
                                      labelStyle: TextStyle(color: Colors.black54, fontSize: 18.0),
                                      hintText: 'Select Type',
                                      enabledBorder: InputBorder.none,
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.black54),
                                      ),
                                      border: InputBorder.none,
                                    ),
                                value: selectedType,
                                onChanged: (newValue) {
                                  setState(() {
                                    selectedType = newValue!;
                                  });
                                },
                                items: List.generate(typeCount, (index) {
                                  return DropdownMenuItem(
                                      value: index + 1,
                                      child: Text(type[index]["type_name"]),
                                      onTap: (){
                                        setState(() {
                                          type_id=type[index]["_id"];
                                        });
                                        disptopic();
                                      }
                                  );
                                }),
                              ),
                              ]
                              )
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                        child: Container(
                          child: Material(
                            elevation: 15.0,
                            shadowColor: Colors.black,
                            borderRadius: BorderRadius.circular(15.0),
                            child: Padding(
                              padding: const EdgeInsets.only(right: 15.0, left: 15.0),
                              child:Column(
                                  children:[
                              DropdownButtonFormField(
                                decoration: const InputDecoration(
                                  labelText: 'Select Topic',
                                  labelStyle: TextStyle(color: Colors.black54, fontSize: 18.0),
                                  hintText: 'Select Topic',
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black54),
                                  ),
                                  border: InputBorder.none,
                                ),
                                value: selectedTopic,
                                onChanged: (newValue) {
                                  setState(() {
                                    selectedTopic = newValue!;
                                  });
                                },
                                items: List.generate(topicCount, (index) {
                                  return DropdownMenuItem(
                                      value: index + 1,
                                      child: Text(topic[index]["topic_name"]),
                                      onTap: (){
                                        setState(() {
                                          topic_id=topic[index]["_id"];
                                        });
                                      }
                                  );
                                }),
                              ),
                              ]
                              )
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        child: InputTextWidget(
                          labelText: "Duration",
                          //icon: Icons.do_not_disturb_on_total_silence,
                          obscureText: false,
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if(value!.isEmpty){
                              return "required";
                            }
                            setState(() {
                              course_duration=value;
                            });
                            return null;

                          },
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        child: InputTextWidget(
                          labelText: "Price",
                          //icon: Icons.do_not_disturb_on_total_silence,
                          obscureText: false,
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if(value!.isEmpty){
                              return "required";
                            }
                            setState(() {
                              course_price=value;
                            });
                            return null;

                          },
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        child: const Text("Add Image"),
                        onPressed: cameraImage,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 55.0,
                        child: ElevatedButton(
                          onPressed: addCourse,
                          style: ElevatedButton.styleFrom(
                            primary: Colors.blueGrey,
                            elevation: 0.0,
                            minimumSize: Size(screenWidth, 150),
                            padding: EdgeInsets.symmetric(horizontal: 30),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(0)),
                            ),
                          ),
                          child: Ink(
                            decoration: BoxDecoration(
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                      color: Colors.deepPurple,
                                      offset: const Offset(1.1, 1.1),
                                      blurRadius: 10.0),
                                ],
                                color: Colors.deepPurple,
                                borderRadius: BorderRadius.circular(12.0)),
                            child: Container(
                              alignment: Alignment.center,
                              child: Text(
                                "Submit",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white, fontSize: 25),
                              ),
                            ),
                          ),
                        ),
                      )



                    ],
                  ))
            ],
          )
      ),
      )
    );
  }
}
