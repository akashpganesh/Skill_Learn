import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:signup1/User/ChangePassword.dart';
import 'package:signup1/User/EditProfile.dart';
import 'package:signup1/User/NavDrawerUser.dart';

class UserSettings extends StatefulWidget {
  const UserSettings({Key? key}) : super(key: key);

  @override
  State<UserSettings> createState() => _UserSettingsState();
}

class _UserSettingsState extends State<UserSettings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const EditProfile()),
                );
              },
            )
        ),

        Card(
            color: Colors.deepPurple,
            child:ListTile(
              leading: Icon(Icons.password),iconColor: Colors.white,
            title: Text("Edit Password"),textColor: Colors.white,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ChangePassword()),
                );
              },
            )
        ),
      ],
      )
    );
  }
}
