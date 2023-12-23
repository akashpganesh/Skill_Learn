import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:signup1/User/NavDrawerUser.dart';
import 'package:signup1/services/type.dart';
import 'package:http/http.dart' as http;

class BookingCourse extends StatefulWidget {
  const BookingCourse({Key? key}) : super(key: key);

  @override
  State<BookingCourse> createState() => _BookingCourseState();
}

class _BookingCourseState extends State<BookingCourse> {
  final storage = new FlutterSecureStorage();
  String userID="",courseID="";

  Future<void> checkAuthentication() async {
    try{
      Map<String, String> allValues = await storage.readAll();
      if(allValues.isEmpty){
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
      }
      else{
        this.getID();


      }
    }catch(e){

    }
  }

  Future<void>getID() async {
    Map<String, dynamic> allValues = await storage.readAll();
    setState(() {
      userID=allValues["_id"];
      courseID=allValues["courseId"];
    });
    print(userID);
    print(courseID);
  }

   bookCourse() async {

      Booking booking=new Booking(userID,courseID);
      String bookingdata=jsonEncode(booking);
      print(bookingdata);
      var client = http.Client();
      try{
        var response = await client.post(
            Uri.parse('http://10.0.2.2:3000/api/bookingCourse'),
            headers: {"Content-Type": "application/json"},
            body:bookingdata);
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
          print("payment successfull");

          showDialog(context: context, builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Payment Completed'),
              content: Text("Payment Completed"),
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
            content: Text("Error in payment"),
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

  void initState(){
    super.initState();
    this.checkAuthentication();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        drawer: NavDrawerUser(),
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
        body:  Center(
          child:Container(
              height: 250,
              width: 350,
              decoration: BoxDecoration(
                color: Colors.blueGrey,
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: ListView(
                children: [
                  Row(
                    children: [
                      Padding(
                      padding: EdgeInsets.only(left: 10,top: 10),
                      child: Container(
                        height: 150,
                        width: 150,
                        color: Colors.red,
                      ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Container(
                        child: Column(
                          children: [
                            Text('Course Name'),
                            SizedBox(
                              height: 20,
                            ),
                            Text('Course Topic'),
                            SizedBox(
                              height: 20,
                            ),
                            Text('Course Price')
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 55.0,
                    child: ElevatedButton(
                      onPressed: bookCourse,
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
                            "Book Now",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white, fontSize: 25),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              )
          ),
        )
    );
  }
}
