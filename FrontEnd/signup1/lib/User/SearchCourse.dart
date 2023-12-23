import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:signup1/User/NavDrawerUser.dart';
import 'package:signup1/User/courseDetails.dart';
import 'package:signup1/services/DisplayCourses.dart';

class SearchCourse extends StatefulWidget {
  const SearchCourse({Key? key}) : super(key: key);

  @override
  State<SearchCourse> createState() => _SearchCourseState();
}

class _SearchCourseState extends State<SearchCourse> {
  final storage = new FlutterSecureStorage();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String userID="",id="",topic_id="",type_id="";
  List x=[],type=[],topic=[];
  int selectedType=1,selectedTopic=1;

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
    print(allValues);
    print(userID);
    this.disptype();
  }

  Future<void> disptype() async {
    displayCourses coursetype = new displayCourses();
    Future<http.Response> status = coursetype.dispType();

    status.then((value) {
      print(value.statusCode);

      setState(() {
        type=jsonDecode(value.body);
      });
      print(type);
    });
    this.course();
  }

  Future<void> disptopic() async {
    displayCourses coursetopic = new displayCourses();
    Future<http.Response> status = coursetopic.dispTopic(type_id);

    status.then((value) {
      print(value.statusCode);

      setState(() {
        topic=jsonDecode(value.body);
      });
      print(topic);
    });
  }

  Future<void> course() async {
    displayCourses search = new displayCourses();
    Future<http.Response> status = search.searchCourses();

    status.then((value) {
      print(value.statusCode);
      setState(() {
        x=jsonDecode(value.body);
      });
      print(x);
    });
  }

  Future<void> SearchC() async {
    displayCourses searchcourse = new displayCourses();
    Future<http.Response> status = searchcourse.Search(topic_id);

    status.then((value) {
      print(value.statusCode);
      setState(() {
        x=jsonDecode(value.body);
      });
      print(x);
    });
  }

  selCourse() async {
    print("select course");
    try {
      await storage.write(key: "courseId", value: id);
      Map<String, String> allValues = await storage.readAll();
      print(allValues);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CourseDetailsUser()),
      );
    }catch(e){
      print(e);
    }
  }


  void initState(){
    super.initState();
     this.checkAuthentication();
  }


  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    int typeCount=type.length;
    int topicCount=topic.length;
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
        body: Column(
     children:[
       Card(
         color: Colors.deepPurple,
         elevation: 5,
         margin: EdgeInsets.all(10),
         child: ExpansionTile(
           leading: Icon(Icons.search,color: Colors.white,),iconColor: Colors.white,
           title: Text('Search',style: TextStyle(color: Colors.white),),textColor: Colors.white,
           children: <Widget>[
             Form(
                 child: Column(
                   children: [
                     Padding(
                       padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                       child: Container(
                         child: Material(
                           elevation: 15.0,
                           shadowColor: Colors.black,
                           borderRadius: BorderRadius.circular(15.0),
                           child: Padding(
                               padding: const EdgeInsets.only(right: 15.0, left: 15.0),
                               child: Column(
                                   children:[
                                     DropdownButtonFormField(
                                       decoration: const InputDecoration(
                                         labelText: 'Select Type',
                                         labelStyle: TextStyle(color: Colors.black54, fontSize: 18.0),
                                         hintText: 'Select Type',
                                         enabledBorder: InputBorder.none,
                                         focusedBorder: UnderlineInputBorder(
                                           borderSide: BorderSide(color: Colors.black54),
                                         ),
                                         border: InputBorder.none,
                                       ),
                                       isExpanded: true,
                                       hint: Text('select'),
                                       value: selectedType,
                                       onChanged: (newValue) {
                                         setState(() {
                                           selectedType = newValue!;
                                         });
                                       },
                                       items: List.generate(typeCount, (index) {
                                         return DropdownMenuItem(
                                             value: index + 1,
                                             child: Text(type[index]["type_name"]),
                                             onTap: (){
                                               setState(() {
                                                 type_id=type[index]["_id"];
                                               });
                                               disptopic();
                                             }
                                         );
                                       }),
                                     ),
                                   ]
                               )
                           ),
                         ),
                       ),
                     ),
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
                               child:Column(
                                   children:[
                                     DropdownButtonFormField(
                                       decoration: const InputDecoration(
                                         labelText: 'Select Topic',
                                         labelStyle: TextStyle(color: Colors.black54, fontSize: 18.0),
                                         hintText: 'Select Topic',
                                         enabledBorder: InputBorder.none,
                                         focusedBorder: UnderlineInputBorder(
                                           borderSide: BorderSide(color: Colors.black54),
                                         ),
                                         border: InputBorder.none,
                                       ),
                                       value: selectedTopic,
                                       onChanged: (newValue) {
                                         setState(() {
                                           selectedTopic = newValue!;
                                         });
                                       },
                                       items: List.generate(topicCount, (index) {
                                         return DropdownMenuItem(
                                             value: index + 1,
                                             child: Text(topic[index]["topic_name"]),
                                             onTap: (){
                                               setState(() {
                                                 topic_id=topic[index]["_id"];
                                               });
                                             }
                                         );
                                       }),
                                     ),
                                   ]
                               )
                           ),
                         ),
                       ),
                     ),
                     SizedBox(
                       height: 20,
                     ),
                     Container(
                       height: 55.0,
                       child: ElevatedButton(
                         onPressed: SearchC,
                         style: ElevatedButton.styleFrom(
                           primary: Colors.deepPurple,
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
                                     color: Colors.blueGrey,
                                     offset: const Offset(1.1, 1.1),
                                     blurRadius: 10.0),
                               ],
                               color: Colors.blueGrey,
                               borderRadius: BorderRadius.circular(12.0)),
                           child: Container(
                             alignment: Alignment.center,
                             child: Text(
                               "Search",
                               textAlign: TextAlign.center,
                               style: TextStyle(color: Colors.white, fontSize: 25),
                             ),
                           ),
                         ),
                       ),
                     ),
                     SizedBox(
                       height: 10,
                     )
                   ],
                 )
             )
           ],
         ),
       ),
        Expanded(child:
        ListView.builder(
              itemCount: x.length,
              itemBuilder: (BuildContext ctx,index){
                final decodestring = base64Decode(x[index]["course_image"].split(',').last);
                Uint8List encodeedimg = decodestring;
                return Card(
                    color: Colors.deepPurple,
                    child:ListTile(
                        leading: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 25.0,
                            child: ClipOval(
                                child: Image.memory(
                                  encodeedimg,
                                  fit: BoxFit.cover,
                                  width: 100.0,
                                  height: 100.0,
                                )
                            )),
                        title: Text(x[index]["course_name"]),textColor: Colors.white,
                        subtitle: Text(""),
                        onTap: (){
                          setState(() {
                            id=x[index]["_id"];
                          });
                          selCourse();
                        }
                    )
                );
              },

            )
        )
        ]
        )
              );
  }
}
