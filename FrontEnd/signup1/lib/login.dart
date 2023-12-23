import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/interceptors/get_modifiers.dart';
import 'package:http/http.dart' as http;
import 'package:signup1/Admin/dashboard.dart';
import 'package:signup1/Tutor/TutorDashboard.dart';
import 'package:signup1/User/UserDashboard.dart';
import 'package:signup1/services/authservice.dart';
import 'package:signup1/signup.dart';
import 'package:signup1/widget/inputTextWidget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _pwdController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  //final snackBar = SnackBar(content: Text('email ou mot de passe incorrect'));
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String name = "",
      email = "",
      phone = "",
      password = "";
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool issigned = false;

  logIn() async {
    print("in login");
   try {
     if (_formKey.currentState!.validate()) {
       Authentication auth = new Authentication();
       Future<http.Response> status = auth.loginUser(email!, password!);


       status.then((value) {
         if (value.statusCode != 201) {
           showDialog(context: context, builder: (BuildContext context) {
             return AlertDialog(
               title: Text("Oops!"),
               content: Text("error"),
               actions: <Widget>[
                 ElevatedButton(onPressed: () {
                   Navigator.of(context).pop();
                 }, child: Text("Ok"))
               ],
             );
           });
         }
         else {
           print("in else");
           Map<String, dynamic> x = jsonDecode(value.body);
           print(x["user"]["user_type"]);
           if (x["user"]["user_type"] == "Admin") {
             print("admin");
             Navigator.of(context).pushAndRemoveUntil(
                 MaterialPageRoute(builder: (context) =>
                     DashBoard()), (Route<dynamic> route) => false);
           }
           else if (x["user"]["user_type"] == "Tutor") {
             print("tutor");
             Navigator.of(context).pushAndRemoveUntil(
                 MaterialPageRoute(builder: (context) =>
                     TutorDashboard()), (Route<dynamic> route) => false);
           }
           else if (x["user"]["user_type"] == "User") {
             print("user");
             Navigator.of(context).pushAndRemoveUntil(
                 MaterialPageRoute(builder: (context) =>
                     UserDashboard()), (Route<dynamic> route) => false);
           }
         }
       });
       status.then((value1) =>
       {
         if(value1.statusCode != 201){
           print("in 1")
         }
         else
           {
           }
       });
     }
     else {
       print("Form error");
     }
   }catch(e){
     print(e);
   }
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
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) =>
                DashBoard()), (Route<dynamic> route) => false);
      });
    }
  }

  // signInWithGoogle() async {
  //   await GoogleSignIn().signOut();
  //   User? firebaseUser = FirebaseAuth.instance.currentUser;
  //   await GoogleSignIn().signIn().then((value) async {
  //     final GoogleSignInAuthentication? googleAuth = await value?.authentication;
  //
  //     // Create a new credential
  //     final credential = GoogleAuthProvider.credential(
  //       accessToken: googleAuth?.accessToken,
  //       idToken: googleAuth?.idToken,
  //     );
  //     FirebaseAuth.instance.signInWithCredential(credential);
  //
  //     print(FirebaseAuth.instance.currentUser);
  //     this.getUser();
  //
  //   });
  //
  //
  //
  //
  //   // Once signed in, return the UserCredential
  //   // return await FirebaseAuth.instance.signInWithCredential(credential);
  // }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
  }

  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final double r = (175 / 360); //  rapport for web test(304 / 540);
    final coverHeight = screenWidth * r;
    bool _pinned = false;
    bool _snap = false;
    bool _floating = false;

    final widgetList = [
      Row(
        children: [
          SizedBox(
            width: 28,
          ),
          Text(
            'Login',
            style: TextStyle(
              fontFamily: 'Segoe UI',
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: const Color(0xff000000),

            ),
            textAlign: TextAlign.left,
          ),
        ],
      ),
      SizedBox(
        height: 12.0,
      ),
      Form(
          key: _formKey,
          child: Column(
            children: [
           InputTextWidget(
                  controller: _emailController,
                  labelText: "Email",
                  icon: Icons.email,
                  obscureText: false,
                  keyboardType: TextInputType.emailAddress,
             validator: (value) {
               if (value!.isEmpty) {
                 return 'Email is Required!';
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
                  controller: _pwdController,
                  labelText: "Password",
                  icon: Icons.lock,
                  obscureText: true,
                  keyboardType: TextInputType.text,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Password is Required!';
                  }
                  setState(() {
                    password=value!;
                  });
                },),
              Padding(
                padding: const EdgeInsets.only(right: 25.0, top: 10.0),
                child: Align(
                    alignment: Alignment.topRight,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {},
                        child: Text(
                          "forgot password?",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700]),
                        ),
                      ),
                    )),
              ),
              SizedBox(
                height: 15.0,
              ),
              Container(
                height: 55.0,
                child: ElevatedButton(
                  onPressed: logIn,
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
                              color: Colors.red,
                              offset: const Offset(1.1, 1.1),
                              blurRadius: 10.0),
                        ],
                        color: Colors.red, // Color(0xffF05945),
                        borderRadius: BorderRadius.circular(12.0)),
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        "Sign In",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 25),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )),
      SizedBox(
        height: 15.0,
      ),
      Wrap(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 30.0, right: 10.0, top: 15.0),
            child: Container(
              decoration: BoxDecoration(
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: Colors.grey, //Color(0xfff05945),
                        offset: const Offset(0, 0),
                        blurRadius: 5.0),
                  ],
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0)),
              width: (screenWidth / 2) - 40,
              height: 55,
              child: Material(
                borderRadius: BorderRadius.circular(12.0),
                child: InkWell(
                  onTap: () {
                    print("facebook tapped");
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Image.asset("asset/login/fb.png", fit: BoxFit.cover),
                        SizedBox(
                          width: 7.0,
                        ),
                        Text("Sign in with\nfacebook")
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 30.0, top: 15.0),
            child: Container(
              decoration: BoxDecoration(
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: Colors.grey, //Color(0xfff05945),
                        offset: const Offset(0, 0),
                        blurRadius: 5.0),
                  ],
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0)),
              width: (screenWidth / 2) - 40,
              height: 55,
              child: Material(
                borderRadius: BorderRadius.circular(12.0),
                child: InkWell(
                  onTap: () {
                    print("google tapped");
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Image.asset("asset/login/google.png",
                            fit: BoxFit.cover),
                        SizedBox(
                          width: 7.0,
                        ),
                        Text("Sign in with\nGoogle")
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      SizedBox(
        height: 15.0,
      ),
    ];
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        //leading: Icon(Icons.arrow_back),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            pinned: _pinned,
            snap: _snap,
            floating: _floating,
            expandedHeight: coverHeight - 25, //304,
            backgroundColor: Color(0xFFdccdb4),
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              background:
              Image.asset("asset/login/main.png", fit: BoxFit.cover),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(

                  ),
                  gradient: LinearGradient(
                      colors: <Color>[Colors.deepOrangeAccent, Colors.deepOrangeAccent])

              ),
              width: screenWidth,
              height: 25,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    width: screenWidth,
                    height: 25,
                    decoration: BoxDecoration(
                      color: Colors.white,

                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(30.0),
                        topRight: const Radius.circular(30.0),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          SliverList(
              delegate:
              SliverChildBuilderDelegate((BuildContext context, int index) {
                return widgetList[index];
              }, childCount: widgetList.length))
        ],
      ),
      bottomNavigationBar: Stack(
        children: [
          new Container(
            height: 50.0,
            color: Colors.white,
            child: Center(
                child: Wrap(
                  children: [
                    Text(
                      "Don't have an account?  ",
                      style: TextStyle(
                          color: Colors.grey[600], fontWeight: FontWeight.bold),
                    ),
                    Material(
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                                HomePage()));
                          },
                          child: Text(
                            "Sign Up",
                            style: TextStyle(
                              color: Colors.blue[800],
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        )),
                  ],
                )),
          ),
        ],
      ),
    );
  }
}