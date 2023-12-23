import 'dart:convert';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:signup1/services/DisplayCourses.dart';
import 'package:signup1/signup.dart';
//import 'package:google_sign_in/google_sign_in.dart';
import 'package:signup1/Admin/NavDrawerAdmin.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({Key? key}) : super(key: key);

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {

  final storage = new FlutterSecureStorage();
  String? jwt;
  String userId="";
  bool isLoggedin=true;
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
    // this.getUser();
    // this.getWalletAmount();
    // this.getJoinedMembers();
    try {
      await storage.write(key: "_id", value: userId);
      Map<String, String> allValues = await storage.readAll();
      print(allValues);
    }catch(e){
      print(e);
    }

this.course();
  }

  Future<void> course() async {
    displayCourses course = new displayCourses();
    Future<Response> status = course.dispCourses(userId!);

    status.then((value) {
      print(value.statusCode);
      setState(() {
        x=jsonDecode(value.body);
      });
      print(x);
    });
  }

  void initState(){
    super.initState();
    this.checkAuthentication();
  }

  logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
        HomePage()), (Route<dynamic> route) => false);

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
      body: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Padding(
              padding: EdgeInsets.only(left: 25,right: 25),
          child: Container(
              width: 350,
              height: 200,
              padding: EdgeInsets.only(left: 25,right: 25),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.deepPurple,
              ),
              child: Column(
                  children:[
                    Padding(
                      padding: EdgeInsets.only(left: 10,right: 10,top: 10),
                      child: Text('Monthly Report',style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 30))
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 10,left: 10),
                      child: Text('No of Students joined: 30',style: TextStyle(color: Colors.white),)
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 10,left: 10),
                      child: Text('No of Tutors Joined: 15',style: TextStyle(color: Colors.white)),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 10,left: 10),
                      child: Text('No of Bookings: 35',style: TextStyle(color: Colors.white)),
                    )
                  ]
              )
          )
    ),
          Expanded(child:
          ListView.builder(
              itemCount: x.length,
              shrinkWrap: true,
              itemBuilder: (BuildContext ctx,index) {
                final decodestring = base64Decode(x[index]["course_image"].split(',').last);
                Uint8List encodeedimg = decodestring;
                return Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                        width: 350,
                        height: 300,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.deepPurple,
                        ),
                        child: Column(
                            children:[
                              Padding(
                                padding: EdgeInsets.only(left: 10,right: 10,top: 10),
                                child: Container(
                                  height: 200,
                                  width: 330,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.red,
                                    image: DecorationImage(
                                      image: MemoryImage(encodeedimg),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 10,right: 10,left: 10),
                                child: Text(x[index]["course_name"],style: TextStyle(color: Colors.white),),
                              ),
                              // Padding(
                              //   padding: EdgeInsets.only(top: 10,right: 10,left: 10),
                              //   child: Text(x[index]["topics"][0]["topic_name"],style: TextStyle(color: Colors.white)),
                              // ),
                              Padding(
                                padding: EdgeInsets.only(top: 10,right: 10,left: 10),
                                child: Text(x[index]["course_price"],style: TextStyle(color: Colors.white)),
                              )
                            ]
                        )
                    )
                  ],
                );
              }
          ),
          )
        ],
      )
    );
  }
}

