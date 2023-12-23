import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:signup1/User/NavDrawerUser.dart';
import 'package:signup1/User/Booking.dart';
import 'package:signup1/services/SelectCourse.dart';

class CourseDetailsUser extends StatefulWidget {
  const CourseDetailsUser({Key? key}) : super(key: key);

  @override
  State<CourseDetailsUser> createState() => _CourseDetailsUserState();
}

class _CourseDetailsUserState extends State<CourseDetailsUser> {
  final storage = new FlutterSecureStorage();
  String userID="",specialization="",name="",image="",courseID="";
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
      courseID=allValues["courseId"];
    });
    print(userID);
    print(courseID);
    this.SelCourse();
  }

  Future<void> SelCourse() async {
    SelCourses course = new SelCourses();
    Future<Response> status = course.SelectCourse(courseID!);

    status.then((value) {
      print(value.statusCode);

      setState(() {
        x=jsonDecode(value.body);
        name=x[0]["course_name"];
        image=x[0]["course_image"];
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
    final decodestring = base64Decode(image.split(',').last);
    Uint8List encodeedimg = decodestring;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        drawer: NavDrawerUser(),
        backgroundColor: Theme.of(context).primaryColor,
        body: SafeArea(
            child: ListView(
                children: [
                  Container(
                    height: 392,
                    child: Image.memory(
                      encodeedimg,
                      errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                        return Icon(Icons.image_not_supported);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                      top: 22,
                      right: 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RatingBar.builder(
                            initialRating: 3,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemSize: 18,
                            itemPadding: const EdgeInsets.symmetric(horizontal: 1),
                            itemBuilder: ((context, _) => const Icon(
                              Icons.star,
                              color: Color(0xFFF4C465),
                            )),
                            onRatingUpdate: (rating) {
                              print(rating);
                            }),
                        const SizedBox(
                          height: 11,
                        ),
                        Text(
                          name,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.roboto(
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            fontSize: 25,
                          ),
                        ),
                        Text(
                          "",
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.roboto(
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(
                          height: 29,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: 112.5,
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        child: Container(
                                          height: 45,
                                          width: 45,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white,
                                            image: DecorationImage(
                                              image: AssetImage(
                                                'asset/dashboard/img_user1.png',
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        left: 22.5,
                                        child: Container(
                                          height: 45,
                                          width: 45,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white,
                                            image: DecorationImage(
                                              image: AssetImage(
                                                'asset/dashboard/img_user2.png',
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        left: 45,
                                        child: Container(
                                          height: 45,
                                          width: 45,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white,
                                            image: DecorationImage(
                                              image: AssetImage(
                                                'asset/dashboard/img_user3.png',
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        left: 67.5,
                                        child: Container(
                                          height: 45,
                                          width: 45,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white,
                                            image: DecorationImage(
                                              image: AssetImage(
                                                'asset/dashboard/img_user4.png',
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  width: 12,
                                ),
                                Text(
                                  '+28K Members',
                                  style: GoogleFonts.roboto(
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0XFFCACACA),
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              height: 47,
                              width: 54,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color: const Color(0xFF353567),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15,
                                  vertical: 12,
                                ),
                                child: SvgPicture.asset(
                                  'asset/dashboard/icon_like.svg',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 51,
                  ),
                  Container(
                    height: 55.0,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const BookingCourse()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xff29274F),
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
                ]
            )
        )

    );
  }
}
