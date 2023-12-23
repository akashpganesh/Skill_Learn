import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:signup1/Tutor/NavDrawerTutor.dart';

class TutorSettings extends StatefulWidget {
  const TutorSettings({Key? key}) : super(key: key);

  @override
  State<TutorSettings> createState() => _TutorSettingsState();
}

class _TutorSettingsState extends State<TutorSettings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: NavDrawerTutor(),
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
        backgroundColor: Theme.of(context).primaryColor,
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: <Widget>[
            Card(
                color: Colors.deepPurple,
                child:ListTile(
                  leading: Icon(Icons.person),iconColor: Colors.white,
                  title: Text("Edit Profile"),textColor: Colors.white,
                  onTap: () {

                  },
                )
            ),

            Card(
                color: Colors.deepPurple,
                child:ListTile(
                  leading: Icon(Icons.password),iconColor: Colors.white,
                  title: Text("Edit Password"),textColor: Colors.white,
                  onTap: () {

                  },
                )
            ),
          ],
        )
    );
  }
}