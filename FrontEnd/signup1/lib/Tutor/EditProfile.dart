import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:signup1/Tutor/NavDrawerTutor.dart';
import 'package:signup1/services/UpdateProfile.dart';
import 'package:signup1/services/getuser.dart';
import 'package:signup1/widget/inputTextWidget.dart';

class TutorEditProfile extends StatefulWidget {
  const TutorEditProfile({Key? key}) : super(key: key);

  @override
  State<TutorEditProfile> createState() => _TutorEditProfileState();
}

class _TutorEditProfileState extends State<TutorEditProfile> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final storage = new FlutterSecureStorage();
  final ImagePicker _picker = ImagePicker();
  XFile? _image;
  String userId="",name="",email="",phone="",image="",userImage="",userName="",userEmail="",userPhone="";
  String? jwt;

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
        userPhone=x["phone"].toString();
        userImage=x["image"];

      });
    });
  }

  EditProf() async {
    if(_formKey.currentState!.validate()) {
      updateProfile pass = new updateProfile();
      Future<Response> status = pass.updateProf(userId!,name!,email!,phone!,image!);

      status.then((value) {
        print(value.body);
      });
    }
  }

  void initState(){
    super.initState();
    this.checkAuthentication();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final decodestring = base64Decode(userImage.split(',').last);
    Uint8List encodeedimg = decodestring;
    return Scaffold(
      drawer: NavDrawerTutor(),
      backgroundColor: Theme.of(context).primaryColor,
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
      body: Container(
        child: ListView(
          children: [
            Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(
                      height: 30.0,
                    ),
                    CircleAvatar(
                      backgroundColor: Colors.black,
                      radius: 80,
                      child: CircleAvatar(
                          radius: 75,
                          child: ClipOval(
                              child: Image.memory(
                                encodeedimg,
                                errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                  return Icon(Icons.person,size: 100,);
                                },
                                fit: BoxFit.cover,
                                width: 190.0,
                                height: 190.0,
                              ))
                      ),
                    ),
                    IconButton(
                        onPressed: cameraImage,
                        icon: Icon(Icons.camera)),
                    SizedBox(
                      height: 25.0,
                    ),
                    InputTextWidget(
                      initialValue: userName,
                      labelText: "Name",
                      icon: Icons.person,
                      obscureText: false,
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if(value!.isEmpty){
                          return "Name is required";

                        }
                        setState(() {
                          name=value!;
                        });
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 12.0,
                    ),
                    InputTextWidget(
                      initialValue: userEmail,
                      labelText: "Email",
                      icon: Icons.email,
                      obscureText: false,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if(value!.isEmpty){
                          return "Email is required";

                        }
                        setState(() {
                          email=value!;
                        });
                        return null;

                      },
                    ),
                    SizedBox(
                      height: 12.0,
                    ),
                    InputTextWidget(
                      initialValue: userPhone,
                      labelText: "Phone",
                      icon: Icons.phone,
                      obscureText: false,
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if(value!.isEmpty){
                          return "required";

                        }
                        setState(() {
                          phone=value!;
                        });
                        return null;

                      },
                    ),
                    SizedBox(
                      height: 25.0,
                    ),
                    Container(
                      height: 55.0,
                      child: ElevatedButton(
                        onPressed: EditProf,
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xff29274F),
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
                              "Save",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white, fontSize: 25),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                )
            )
          ],
        ),
      ),
    );
  }
}