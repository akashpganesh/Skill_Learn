import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:signup1/Tutor/NavDrawerTutor.dart';
import 'package:signup1/services/DisplayCourses.dart';

class TutorDashboard extends StatefulWidget {
  const TutorDashboard({Key? key}) : super(key: key);

  @override
  State<TutorDashboard> createState() => _TutorDashboardState();
}

class _TutorDashboardState extends State<TutorDashboard> {

  final storage = new FlutterSecureStorage();
  final ImagePicker _picker = ImagePicker();
  String? jwt,userid;
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
    print(userId);
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


  logout() async {
    await storage.delete(key: "token");
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);

  }
  void initState(){
    super.initState();
    this.checkAuthentication();
  }

  @override
  Widget build(BuildContext context) {
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
      body: Column(
        children: [
          SizedBox(
            height: 10,
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
      ),
    );
  }
}