import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:signup1/Admin/NavDrawerAdmin.dart';
import 'package:signup1/services/UserList.dart';

class TutorList extends StatefulWidget {
  const TutorList({Key? key}) : super(key: key);

  @override
  State<TutorList> createState() => _TutorListState();
}

class _TutorListState extends State<TutorList> {
  final storage = new FlutterSecureStorage();
  String userID="";
  List x=[];

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
    });
    print(userID);
    this.userlist();
  }

  Future<void> userlist() async {
    Users user = new Users();
    Future<Response> status = user.usersList("Tutor");

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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        drawer: const NavDrawerAdmin(),
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
        body: ListView.builder(
          itemCount: x.length,
          itemBuilder: (BuildContext ctx,index){
            final decodestring = base64Decode(x[index]["image"].split(',').last);
            Uint8List encodeedimg = decodestring;
            return Card(
              color: Colors.deepPurple,
              elevation: 5,
              margin: EdgeInsets.all(10),
              child: ExpansionTile(
                leading: CircleAvatar(
                    radius: 25.0,
                    child: ClipOval(
                        child: Image.memory(
                          encodeedimg,
                          errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                            return Icon(Icons.person);
                          },
                          fit: BoxFit.cover,
                          width: 100.0,
                          height: 100.0,
                        ))),
                title: Text(x[index]["name"], style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white
                ),
                ),textColor: Colors.white,
                subtitle: Text(
                  'Rating',
                  style: TextStyle(fontSize: 16),
                ),
                trailing: IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.delete),color: Colors.red,),
                // ignore: prefer_const_literals_to_create_immutables
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Text(
                            "Email:" +
                                (x[index]["email"]),
                            style: TextStyle(
                                color: Colors.white
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            "Contact:" +
                                (x[index]["phone"].toString()),
                            style: TextStyle(
                                color: Colors.white
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Row(
                              children:[
                                TextButton(
                                    onPressed: () {},
                                    child: Text(
                                      "Accept",
                                      style: TextStyle(color: Colors.green),
                                    )),
                                TextButton(
                                    onPressed: () {},
                                    child: Text(
                                      "Reject",
                                      style: TextStyle(color: Colors.red),
                                    )),
                              ]
                          )
                        ],
                      )),
                ],
              ),
            );
          },

        )
    );
  }
}
