import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:signup1/User/course_detail_screen.dart';
import 'package:signup1/login.dart';
import 'package:signup1/User/NavDrawerUser.dart';
import 'package:signup1/services/DisplayCourses.dart';
import 'package:signup1/signup.dart';
import 'package:signup1/widget/my_horizontal_list.dart';
import 'package:signup1/widget/my_vertical_list.dart';

class UserDashboard extends StatefulWidget {
  const UserDashboard({Key? key}) : super(key: key);

  @override
  State<UserDashboard> createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {

  final storage = new FlutterSecureStorage();
  final ImagePicker _picker = ImagePicker();
  String? jwt;
  String userId="";
  bool isLoggedin=true;
  XFile? _image;
  List x=[];



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
    });
  }
  encodeToBase64(String path)async{
    final bytes=await File(path).readAsBytes();
    final base64=base64Encode(bytes);
    print(base64);
    return base64;
  }

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
    Future<Response> status = course.CourseList();

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
      drawer: NavDrawerUser(),
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(left: 20, right: 20),
          physics: const BouncingScrollPhysics(),
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 50,
                  width: 200,
               child:Image.asset('asset/dashboard/logo.png')
                )
              ],
            ),
            const SizedBox(
              height: 22,
            ),
            SizedBox(
              height: 349,
              child: ListView.builder(
                itemCount: x.length,
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  final decodestring = base64Decode(x[index]["course_image"].split(',').last);
                  Uint8List encodeedimg = decodestring;
                  return Row(
                    children:[
                      SizedBox(
                        width: 20,
                      ),
                      Container(
                    width: 246,
                    height: 349,
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
                          width: 226,
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
                    Padding(
                      padding: EdgeInsets.only(top: 10,right: 10,left: 10),
                      child: Text(x[index]["topics"][0]["topic_name"],style: TextStyle(color: Colors.white)),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10,right: 10,left: 10),
                      child: Text(x[index]["course_price"],style: TextStyle(color: Colors.white)),
                    )
                  ]
                        )
                  )
                  ]
                  );
                },
              ),
            ),
            const SizedBox(
              height: 34,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Free online class',
                  style: GoogleFonts.roboto(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 25,
                  ),
                ),
                Text(
                  'From over 80 lectures',
                  style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF9C9A9A),
                    fontSize: 14,
                  ),
                ),
              ],
            ),

            ListView.builder(
              itemCount: x.length,
              shrinkWrap: true,
              itemBuilder: ((context, index){
                final decodestring = base64Decode(x[index]["course_image"].split(',').last);
                Uint8List encodeedimg = decodestring;
                return Column(
                  children:[
                    SizedBox(
                      height: 20,
                    ),
                //     Container(
                //   height: 75,
                //   width: 350,
                //   decoration: BoxDecoration(
                //     borderRadius: BorderRadius.circular(10),
                //     color: Colors.deepPurple,
                //   ),
                //       child: Row(
                // children:[
                //       Padding(
                //         padding: EdgeInsets.only(left: 10,right: 240,top: 5,bottom: 5),
                //         child: Container(
                //           height: 50,
                //           width: 100,
                //           decoration: BoxDecoration(
                //             borderRadius: BorderRadius.circular(10),
                //             color: Colors.red,
                //           ),
                //         ),
                //       ),
                //   Expanded(
                //     child: Padding(
                //       padding: const EdgeInsets.only(right: 10,left: 100),
                //       child: Text(
                //         'Your text goes here',
                //         // textAlign: TextAlign.right,
                //         style: TextStyle(
                //           color: Colors.white,
                //           fontSize: 18,
                //           fontWeight: FontWeight.bold,
                //         ),
                //       ),
                //     ),
                //   ),
                // ]
                //       )
                // )
                    Card(
                        color: Colors.deepPurple,
                        child:ListTile(
                            leading:Container(

                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.red,
                            image: DecorationImage(
                              image: MemoryImage(encodeedimg),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                            title: Text(x[index]["course_name"]),textColor: Colors.white,
                            subtitle: Text(x[index]["course_price"]),
                            trailing: IconButton(
                              icon: Icon(Icons.play_circle),
                              onPressed: () {
                                // do something when the button is pressed
                              },
                            ),
                            onTap: (){
                              // setState(() {
                              //   id=x[index]["_id"];
                              // });
                              // selCourse();
                            }
                        )
                    )
                ]
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}




