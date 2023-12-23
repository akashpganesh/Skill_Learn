import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:signup1/User/NavDrawerUser.dart';
import 'package:signup1/services/UpdatePassword.dart';
import 'package:signup1/widget/inputTextWidget.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _confirmPass = TextEditingController();
  final TextEditingController _currentpass = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final storage = new FlutterSecureStorage();
  String userId="",password="",currentpassword="";
  String? jwt;

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

  }

  changePass() async {
    if(_formKey.currentState!.validate()) {
      updatePassword pass = new updatePassword();
      Future<Response> status = pass.updatePass(userId!, password!);

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

    return Scaffold(
      drawer: NavDrawerUser(),
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
     body: Center(
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
            children: [
              SizedBox(
                height: 30.0,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                child: Container(
                  child: Material(
                    elevation: 15.0,
                    shadowColor: Colors.black,
                    borderRadius: BorderRadius.circular(15.0),
                    child: Padding(
                      padding:
                      const EdgeInsets.only(right: 20.0, left: 15.0),
                      child: TextFormField(
                          obscureText: true,
                          autofocus: false,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            icon: Icon(
                              Icons.lock,
                              color: Colors.black,
                              size: 32.0, /*Color(0xff224597)*/
                            ),
                            labelText: "Current Password",
                            labelStyle: TextStyle(
                                color: Colors.black54, fontSize: 18.0),
                            hintText: '',
                            enabledBorder: InputBorder.none,
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black54),
                            ),
                            border: InputBorder.none,
                          ),
                          controller: _currentpass,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'type a password';
                            }
                            setState(() {
                              currentpassword=value!;
                            });
                            return null;
                          }),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                child: Container(
                  child: Material(
                    elevation: 15.0,
                    shadowColor: Colors.black,
                    borderRadius: BorderRadius.circular(15.0),
                    child: Padding(
                      padding:
                      const EdgeInsets.only(right: 20.0, left: 15.0),
                      child: TextFormField(
                          obscureText: true,
                          autofocus: false,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            icon: Icon(
                              Icons.lock,
                              color: Colors.black,
                              size: 32.0, /*Color(0xff224597)*/
                            ),
                            labelText: "New Password",
                            labelStyle: TextStyle(
                                color: Colors.black54, fontSize: 18.0),
                            hintText: '',
                            enabledBorder: InputBorder.none,
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black54),
                            ),
                            border: InputBorder.none,
                          ),
                          controller: _pass,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'type a password';
                            } else if (value.length < 6) {
                              return 'password must be > 6 character';
                            }
                            setState(() {
                              password=value!;
                            });
                            return null;
                          }),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 15.0,
              ),

              Padding(
                padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                child: Container(
                  child: Material(
                    elevation: 15.0,
                    shadowColor: Colors.black,
                    borderRadius: BorderRadius.circular(15.0),
                    child: Padding(
                      padding:
                      const EdgeInsets.only(right: 20.0, left: 15.0),
                      child: TextFormField(
                          obscureText: true,
                          autofocus: false,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            icon: Icon(
                              Icons.lock,
                              color: Colors.black,
                              size: 32.0, /*Color(0xff224597)*/
                            ),
                            labelText: "Enter New Password Again",
                            labelStyle: TextStyle(
                                color: Colors.black54, fontSize: 18.0),
                            hintText: '',
                            enabledBorder: InputBorder.none,
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black54),
                            ),
                            border: InputBorder.none,
                          ),
                          controller: _confirmPass,
                          validator: (value) {
                            if (value!.isEmpty)
                              return 'Confirm password!';
                            if (value != _pass.text)
                              return 'Incorrect password';
                            return null;
                          }),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 15.0,
              ),

              Container(
                height: 55.0,
                child: ElevatedButton(
                  onPressed: changePass,
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
                        "Continue",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 25),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ]
      ),
    )
    )
    );
  }
}
