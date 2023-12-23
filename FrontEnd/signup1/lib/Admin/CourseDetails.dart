import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:signup1/Admin/NavDrawerAdmin.dart';
import 'package:signup1/User/NavDrawerUser.dart';
import 'package:signup1/User/VideoPlayerUser.dart';
import 'package:signup1/services/SelectCourse.dart';
import 'package:signup1/services/displayVideos.dart';

class CourseDetailsAdmin extends StatefulWidget {
  const CourseDetailsAdmin({Key? key}) : super(key: key);

  @override
  State<CourseDetailsAdmin> createState() => _CourseDetailsAdminState();
}

class _CourseDetailsAdminState extends State<CourseDetailsAdmin> {
  String button="1",userId="",courseId="",name="",image="",topic="",videoid="",id="";
  final storage = new FlutterSecureStorage();
  List x=[],videos=[];

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
    print(courseId);
    this.SelCourse();
  }

  Future<void> SelCourse() async {
    try {
      SelCourses course = new SelCourses();
      Future<Response> status = course.SelectCourse(courseId!);

      status.then((value) {
        print(value.statusCode);

        setState(() {
          x = jsonDecode(value.body);
          name = x[0]["course_name"];
          image = x[0]["course_image"];
          topic = x[0]["topics"][0]["topic_name"];
        });
        print(x);
      });
    }catch(e){
      print(e);
    }
    this.video();
  }

  Future<void> video() async {
    displayVideos video = new displayVideos();
    Future<Response> status = video.dispVideos(courseId!);

    status.then((value) {
      print(value.statusCode);
      setState(() {
        videos=jsonDecode(value.body);
      });
      print(videos);
    });
  }

  selVideo() async {
    print("select video");
    try {
      await storage.write(key: "videoId", value: videoid);
      await storage.write(key: "vid_id", value: id);
      Map<String, String> allValues = await storage.readAll();
      print(allValues);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const VideoPlayerUser()),
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
    final decodestring = base64Decode(image.split(',').last);
    Uint8List encodeedimg = decodestring;
    return Scaffold(
        drawer: NavDrawerAdmin(),
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
                          topic,

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
                    padding: EdgeInsets.symmetric(),
                    height: 50,
                    child: ListView(
                        scrollDirection: Axis.horizontal,
                        children:[
                          Container(
                            width: 195,
                            child: Card(
                              color: Colors.blue,
                              child: ListTile(
                                title: Center(child: Text('Videos')),
                                onTap: () {
                                  setState(() {
                                    button = "1";
                                    print(button);
                                  });
                                },
                              ),
                            ),
                          ),
                          Container(
                            width: 195,
                            child: Card(
                              color: Colors.blue,
                              child: ListTile(
                                title: Center(child: Text('Documents')),
                                onTap: () {
                                  setState(() {
                                    button = "2";
                                    print(button);
                                  });
                                },
                              ),
                            ),
                          ),
                        ]
                    ),
                  ),
                  Column(children: <Widget>[
                    if (button=="1")
                      Column(
                          children: [
                            ListView.builder(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              physics: const BouncingScrollPhysics(),
                              itemCount: videos.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return Card(
                                    color: Colors.deepPurple,
                                    child:ListTile(
                                      leading: CircleAvatar(),
                                      title: Text(videos[index]["video_topic"]),textColor: Colors.white,
                                      subtitle: Text(videos[index]["video_discription"]),
                                      onTap: (){
                                        setState(() {
                                          videoid=videos[index]["_id"];
                                        });
                                        selVideo();
                                      },
                                    )
                                );
                              },
                            )
                          ]
                      )  else if(button=="2")
                      Column(
                          children: [
                            ListView.builder(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              physics: const BouncingScrollPhysics(),
                              itemCount: 0,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return Card(
                                    color: Colors.deepPurple,
                                    child:ListTile(
                                      title: Text(''),textColor: Colors.white,
                                      subtitle: Text(''),
                                      onTap: () {},
                                    )
                                );
                              },
                            )
                          ]
                      )
                  ]
                  )
                ]
            )
        )
    );
  }
}
