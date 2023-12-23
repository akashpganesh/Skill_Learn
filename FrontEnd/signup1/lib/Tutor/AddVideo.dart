import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:signup1/Tutor/NavDrawerTutor.dart';
import 'package:signup1/services/type.dart';
import 'package:http/http.dart' as http;
import 'package:signup1/widget/inputTextWidget.dart';

class AddVideo extends StatefulWidget {
  const AddVideo({Key? key}) : super(key: key);

  @override
  State<AddVideo> createState() => _AddVideoState();
}

class _AddVideoState extends State<AddVideo> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final storage = new FlutterSecureStorage();
  String userID = "",
      courseID = "",
      video_topic = "",
      video_id = "",
      video_discription = "",
      video_url = "";

  Future<void> checkAuthentication() async {
    try {
      Map<String, String> allValues = await storage.readAll();
      if (allValues.isEmpty) {
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
      }
      else {
        this.getID();
      }
    } catch (e) {

    }
  }

  Future<void> getID() async {
    Map<String, dynamic> allValues = await storage.readAll();
    setState(() {
      userID = allValues["_id"];
      courseID = allValues["courseId"];
    });
    print(userID);
  }


  addVideo() async {
    if(_formKey.currentState!.validate()){

      String? getYoutubeVideoId(String url) {
        RegExp regExp = new RegExp(
            r'^(?:https?:\/\/)?(?:www\.)?youtu(?:be\.com\/watch\?v=|\.be\/)([\w\-]+)(?:\S+)?$');
        RegExpMatch? match = regExp.firstMatch(url);
        return match?.group(1);
      }
      String? ID=getYoutubeVideoId(video_url);
      setState(() {
        video_id=ID!;
      });


      Video video=new Video(video_topic,video_id,video_discription,courseID);
      String coursedata=jsonEncode(video);
      print(coursedata);
      var client = http.Client();
      try{
        var response = await client.post(
            Uri.parse('http://10.0.2.2:3000/api/addVideo'),
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

  void initState(){
  super.initState();
  this.checkAuthentication();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      drawer: NavDrawerTutor(),
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
              height: 350,
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
                          InputTextWidget(
                            labelText: "Topic",
                            //icon: Icons.do_not_disturb_on_total_silence,
                            obscureText: false,
                            keyboardType: TextInputType.text,
                            validator: (value) {
                              if(value!.isEmpty){
                                return "required";
                              }
                              setState(() {
                                video_topic=value;
                              });
                              return null;
                              },
                          ),
                      SizedBox(
                        height: 20,
                      ),
                      InputTextWidget(
                        labelText: "Enter URL",
                        //icon: Icons.do_not_disturb_on_total_silence,
                        obscureText: false,
                        keyboardType: TextInputType.url,
                        validator: (value) {
                          if(value!.isEmpty){
                            return "required";
                          }
                          setState(() {
                            video_url=value;
                          });
                          return null;

                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      InputTextWidget(
                        labelText: "Discription",
                        //icon: Icons.do_not_disturb_on_total_silence,
                        obscureText: false,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if(value!.isEmpty){
                            return "required";
                          }
                          setState(() {
                            video_discription=value;
                          });
                          return null;

                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: 55.0,
                        child: ElevatedButton(
                          onPressed: addVideo,
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
