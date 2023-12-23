import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:signup1/Admin/NavDrawerAdmin.dart';
import 'package:signup1/services/type.dart';
import 'package:http/http.dart' as http;
import 'package:signup1/widget/inputTextWidget.dart';

class CourseType extends StatefulWidget {
  const CourseType({Key? key}) : super(key: key);

  @override
  State<CourseType> createState() => _CourseTypeState();
}

class _CourseTypeState extends State<CourseType> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String type_name="";

  addType() async {
    if(_formKey.currentState!.validate()){

      Coursetype type=new Coursetype(type_name);
      String typedata=jsonEncode(type);
      print(typedata);
      var client = http.Client();
      try{
        var response = await client.post(
            Uri.parse('http://10.0.2.2:3000/api/addCoursetype'),
            headers: {"Content-Type": "application/json"},
            body:typedata);
        print(response.body);
        print(response.statusCode);

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
      child: Container(
          width: 350,
          height: 250,
          decoration: BoxDecoration(
            color: Colors.blueGrey,
            borderRadius: BorderRadius.circular(10),
          ),
        // color: Colors.white,
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
                        padding: const EdgeInsets.all(10),
                        child: InputTextWidget(
                          labelText: "Course Type",
                          //icon: Icons.do_not_disturb_on_total_silence,
                          obscureText: false,
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if(value!.isEmpty){
                              return "required";
                            }
                            setState(() {
                              type_name=value;
                            });
                            return null;

                          },
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: 55.0,
                        child: ElevatedButton(
                          onPressed: addType,
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
                                "Save",
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
