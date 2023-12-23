import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:signup1/User/MyBookings.dart';
import 'package:signup1/User/NavDrawerUser.dart';
import 'package:signup1/services/type.dart';
import 'package:http/http.dart' as http;
import 'package:signup1/widget/inputTextWidget.dart';

import '../widget/InputText.dart';

class Payments extends StatefulWidget {
  const Payments({Key? key}) : super(key: key);

  @override
  State<Payments> createState() => _PaymentsState();
}

class _PaymentsState extends State<Payments> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final storage = new FlutterSecureStorage();
  String userID="",bookingID="";

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
      bookingID=allValues["bookingId"];
    });
    print(userID);
    print(bookingID);
  }

  payment() async {
    if (_formKey.currentState!.validate()) {
      Payment payment = new Payment(bookingID);
      String paymentdata = jsonEncode(payment);
      print(paymentdata);
      var client = http.Client();
      try {
        var response = await client.post(
            Uri.parse('http://10.0.2.2:3000/api/payment'),
            headers: {"Content-Type": "application/json"},
            body: paymentdata);
        print(response.body);
        print(response.statusCode);
        //String res=jsonDecode(response.body);
        //print(res);

        if (response.statusCode == 404) {
          showDialog(context: context, builder: (BuildContext context) {
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
        else {
          print("payment successfull");

          showDialog(context: context, builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Payment Completed'),
              content: Text("Payment Completed"),
              actions: [
                TextButton(
                  child: Text("Ok"),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const MyBookings()),
                    );
                  },
                )
              ],
            );
          });
        }
      }
      catch (e) {
        print(e);
        print(e);
        showDialog(context: context, builder: (BuildContext context) {
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
      body: Center(
        child: Container(
            width: 350,
            height: 500,
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
                        Text('Card Holder'),
                        InputTextWidget(
                          //labelText: "Course Type",
                          icon: Icons.person,
                          hintText: 'Card Holder',
                          obscureText: false,
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if(value!.isEmpty){
                              return "required";
                            }
                            setState(() {
                              //type_name=value;
                            });
                            return null;

                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text('Card Number'),
                        InputTextWidget(
                          //labelText: "Course Type",
                          icon: Icons.credit_card,
                          hintText: 'Card Number',
                          obscureText: false,
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if(value!.isEmpty){
                              return "required";
                            }
                            setState(() {
                              //type_name=value;
                            });
                            return null;

                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [

                            Container(
                              width: 175,
                              height: 90,
                              color: Colors.blueGrey,
                              child: Column(
                              children:[
                            Text('Expiry Date'),
                            InputText(
                              //labelText: "Course Type",
                              icon: Icons.date_range_sharp,
                              hintText: '00/00',
                              obscureText: false,
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                if(value!.isEmpty){
                                  return "required";
                                }
                                setState(() {
                                  //type_name=value;
                                });
                                return null;

                              },
                            ),
                            ]
                            ),
                            ),

                            Container(
                                width: 175,
                                height: 90,
                                color: Colors.blueGrey,
                            child: Column(
                              children:[
                                Text('CVC'),
                              InputText(
                              //labelText: "Course Type",
                              icon: Icons.lock,
                              hintText: '000',
                              obscureText: false,
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                if(value!.isEmpty){
                                  return "required";
                                }
                                setState(() {
                                  //type_name=value;
                                });
                                return null;

                              },
                            ),
                                ]
                            )
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 55.0,
                          child: ElevatedButton(
                            onPressed: payment,
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
                                  "Pay",
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
      // Container(
      //     child: ElevatedButton(
      //         child: const Text("Pay Now"),
      //         onPressed: payment
      //     )
      // ),
    );
  }
}
