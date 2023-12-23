import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:signup1/services/type.dart';
import 'package:signup1/widget/inputTextWidget.dart';
import 'package:http/http.dart' as http;

class AddDocumentAdmin extends StatefulWidget {
  const AddDocumentAdmin({Key? key}) : super(key: key);

  @override
  State<AddDocumentAdmin> createState() => _AddDocumentAdminState();
}

class _AddDocumentAdminState extends State<AddDocumentAdmin> {
  final storage = new FlutterSecureStorage();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _selectedFileBase64;
  File? _selectedFile;
  bool _isFilePickerOpen = false;
  String document_topic="",userId="",courseId="";

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
      userId=allValues["_id"];
      courseId=allValues["courseId"];
    });
    print(userId);
  }

  fileUpload() async {

    if (_isFilePickerOpen) {
      // File picker is already open, do nothing
      return;
    }

    setState(() {
      _isFilePickerOpen = true;
    });

    final result =
    await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    setState(() {
      _isFilePickerOpen = false;
    });

    if (result != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
      });
      print(_selectedFile);
      if (_selectedFile != null) {
        final bytes = await _selectedFile!.readAsBytes();
        final base64String = base64Encode(bytes);

        setState(() {
          _selectedFileBase64 = base64String;
        });
        print(_selectedFileBase64);
      }else{
        print("error");
      }
    }else{
      print("error");
    }
  }

  Future<String?> _openFileExplorer() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null) {
      return result.files.single.path;
    } else {
      // User canceled the picker
      return null;
    }
  }


  addDocument() async {
    if(_formKey.currentState!.validate()){

      Document document=new Document(document_topic,_selectedFileBase64,courseId);
      String documentdata=jsonEncode(document);
      print(documentdata);
      var client = http.Client();
      try{
        var response = await client.post(
            Uri.parse('http://10.0.2.2:3000/api/addDocument'),
            headers: {"Content-Type": "application/json"},
            body:documentdata);
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
    this.checkAuthentication();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
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
                height: 250,
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
                            children: [
                              SizedBox(
                                height: 20,
                              ),
                              InputTextWidget(
                                labelText: "Topic",
                                //icon: Icons.do_not_disturb_on_total_silence,
                                obscureText: false,
                                keyboardType: TextInputType.text,
                                validator: (value) {
                                  if(value!.isEmpty){
                                    return "required";
                                  }
                                  setState(() {
                                    document_topic=value;
                                  });
                                  return null;
                                },
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              ElevatedButton(
                                  onPressed: fileUpload,
                                  child: Text("Upload File")),
                              SizedBox(
                                height: 8,
                              ),
                              Container(
                                height: 55.0,
                                child: ElevatedButton(
                                  onPressed: addDocument,
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
                                        "Submit",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(color: Colors.white, fontSize: 25),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )),
                    ]
                )
            )
        )
    );
  }
}

