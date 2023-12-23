import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:signup1/Admin/NavDrawerAdmin.dart';
import 'package:signup1/services/DisplayCourses.dart';
import 'package:signup1/services/type.dart';
import 'package:signup1/widget/inputTextWidget.dart';

class CourseTopic extends StatefulWidget {
  const CourseTopic({Key? key}) : super(key: key);

  @override
  State<CourseTopic> createState() => _CourseTopicState();
}

class _CourseTopicState extends State<CourseTopic> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String typeid="",topic_name="",type_id="";
  List x=[];
  int selectedItem = 1;

  Future<void> disptype() async {
    displayCourses type = new displayCourses();
    Future<http.Response> status = type.dispType();

    status.then((value) {
      print(value.statusCode);

      setState(() {
        x=jsonDecode(value.body);
      });
      print(x);
    });
  }

  addTopic() async {
    if(_formKey.currentState!.validate()){

      Topic topic=new Topic(topic_name,type_id);
      String topicdata=jsonEncode(topic);
      print(topicdata);
      var client = http.Client();
      try{
        var response = await client.post(
            Uri.parse('http://10.0.2.2:3000/api/addTopic'),
            headers: {"Content-Type": "application/json"},
            body:topicdata);
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

  void initState(){
    super.initState();
    this.disptype();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    int itemCount=x.length;
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
        height: 300,
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
                      Padding(
                        padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                        child: Container(
                          child: Material(
                            elevation: 15.0,
                            shadowColor: Colors.black,
                            borderRadius: BorderRadius.circular(15.0),
                            child: Padding(
                              padding: const EdgeInsets.only(right: 15.0, left: 15.0),
                              child:
                              DropdownButton(
                          value: selectedItem,
                          onChanged: (newValue) {
                            setState(() {
                              selectedItem = newValue!;
                            });
                          },
                          items: List.generate(itemCount, (index) {
                            return DropdownMenuItem(
                              value: index + 1,
                              child: Text(x[index]["type_name"]),
                                onTap: (){
                                  setState(() {
                                    type_id=x[index]["_id"];
                                  });
                                }
                            );
                          }),
                        ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        child: InputTextWidget(
                          labelText: "Course Topic",
                          //icon: Icons.do_not_disturb_on_total_silence,
                          obscureText: false,
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if(value!.isEmpty){
                              return "required";
                            }
                            setState(() {
                              topic_name=value;
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
                          onPressed: addTopic,
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
