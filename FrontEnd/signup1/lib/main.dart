import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:signup1/Tutor/videoplayer.dart';
import 'package:signup1/User/Payment.dart';
import 'package:signup1/login.dart';
//import 'package:google_sign_in/google_sign_in.dart';
import 'firebase_options.dart';
import 'package:get/get.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        primaryColor: const Color(0xff29274F),
      ),
      home: LoginPage(),
    );
  }
}
