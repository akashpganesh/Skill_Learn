import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:signup1/Admin/dashboard.dart';
import 'package:signup1/login.dart';
import 'package:signup1/user.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:signup1/widget/inputTextWidget.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _confirmPass = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String name="",email="",phone="",password="",user_type="User",image="";
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool issigned = false;

  Future<void> signUp() async {
    if(_formKey.currentState!.validate()){

      Users user=new Users(name,email,phone,password,image,user_type);
      String userdata=jsonEncode(user);
      print(userdata);
      var client = http.Client();
      try{
        var response = await client.post(
            Uri.parse('http://10.0.2.2:3000/api/register'),
            headers: {"Content-Type": "application/json"},
            body:userdata);
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
              title: Text('Registration Succesfull'),
              content: Text("Registration Succesfull"),
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
            content: Text("Error in signup"),
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
  logout(){

  }
  showError(String errorMsg) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(errorMsg),
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
  getUser() async {
    User? firebaseUser = FirebaseAuth.instance.currentUser;
    await firebaseUser?.reload();

    if (firebaseUser != null) {
      setState(() {
        issigned = true;
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
            DashBoard()), (Route<dynamic> route) => false);

      });
    }
    else{
      print("No user");
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();

  }

  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

      return Scaffold(
        appBar: AppBar(
          title: Text("Sign Up",
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'Segoe UI',
                fontSize: 30,
                shadows: [
                  Shadow(
                    color: const Color(0xba000000),
                    offset: Offset(0, 3),
                    blurRadius: 6,
                  )
                ],
              )),
          //centerTitle: true,
          leading: InkWell(
            onTap: () => Get.to(LoginPage()),
            child: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              color: Colors.white,

              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            width: screenWidth,
            height: screenHeight,
            child: SingleChildScrollView(
              //controller: controller,
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(
                      height: 30.0,
                    ),
                    Text(
                      'Welcome to our home!',
                      style: TextStyle(
                        fontFamily: 'Segoe UI',
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xff000000),

                      ),
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(
                      height: 25.0,
                    ),
                    InputTextWidget(
                        labelText: "Name",
                        icon: Icons.person,
                        obscureText: false,
                        keyboardType: TextInputType.text,
                      validator: (value) {
                        if(value!.isEmpty){
                          return "Name is required";

                        }
                        setState(() {
                          name=value;
                        });
                        return null;

                      },
                      ),
                    SizedBox(
                      height: 12.0,
                    ),
                    InputTextWidget(
                        controller: _emailController,
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
                      },
                    ),
                    SizedBox(
                      height: 12.0,
                    ),
                    InputTextWidget(
                        labelText: "Phone",
                        icon: Icons.phone,
                        obscureText: false,
                        keyboardType: TextInputType.number,
                      validator: (value) {
                        if(value!.isEmpty){
                          return "required";

                        }
                        setState(() {
                          phone=value!;
                        });

                      },
                    ),
                    SizedBox(
                      height: 12.0,
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
                                  labelText: "Password",
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
                                  labelText: "Confirm Password",
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
                    Column(
                      children: [

                        RadioListTile(
                          title: Text("User"),
                          value: "User",
                          groupValue: user_type,
                          onChanged: (value){
                            setState(() {
                              user_type = value.toString();
                            });
                          },
                        ),

                        RadioListTile(
                          title: Text("Tutor"),
                          value: "Tutor",
                          groupValue: user_type,
                          onChanged: (value){
                            setState(() {
                              user_type = value.toString();
                            });
                          },
                        ),
                      ],
                    ),
                    Container(
                      height: 55.0,
                      child: ElevatedButton(
                        onPressed: signUp,
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white,
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
                                    color: Color(0xfff05945),
                                    offset: const Offset(1.1, 1.1),
                                    blurRadius: 10.0),
                              ],
                              color: Color(0xffF05945),
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
            ),
          ),
        ),
      );
  }
}

