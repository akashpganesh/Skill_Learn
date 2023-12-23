import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:signup1/Tutor/AddCourse.dart';
import 'package:signup1/Tutor/AddVideo.dart';
import 'package:signup1/Tutor/NavDrawerTutor.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:signup1/Tutor/addDocument.dart';
import 'package:signup1/Tutor/videoplayer.dart';
import 'package:signup1/services/SelectCourse.dart';
import 'package:signup1/services/displayDocuments.dart';
import 'package:signup1/services/displayVideos.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';

class CourseDetails extends StatefulWidget {
  const CourseDetails({Key? key}) : super(key: key);

  @override
  State<CourseDetails> createState() => _CourseDetailsState();
}

class _CourseDetailsState extends State<CourseDetails> {
  String button="1",userId="",courseId="",name="",image="",topic="",videoid="",id="";
  final storage = new FlutterSecureStorage();
  String? jwt,coursejwt;
  List x=[],videos=[],pdf=[];
  String file = "";
  bool isFilePickerOpen = false;

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

    }
    this.video();
  }

  Future<void> video() async {
    displayVideos video = new displayVideos();
    Future<Response> status = video.dispVideos(courseId);

    status.then((value) {
      print(value.statusCode);
      setState(() {
        videos=jsonDecode(value.body);
      });
      print(videos);
    });
    this.documents();
  }

  Future<void> documents() async {
    displayDocuments document = new displayDocuments();
    Future<Response> status = document.dispDocuments(courseId);

    status.then((value) {
      print(value.statusCode);
      setState(() {
        pdf=jsonDecode(value.body);
      });
      print(pdf);
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
        MaterialPageRoute(builder: (context) => const VideoPlayer()),
      );
    }catch(e){
      print(e);
    }
  }

  void selectPdfFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null && result.files.isNotEmpty) {
        final fileBytes = result.files.single.bytes;
        final base64String = base64.encode(fileBytes!);
        setState(() {
          file = base64String;
        });
      }
    }catch(e){}
  }

  void downloadPDF(String base64String) async {
    try {
      final bytes = base64Decode(base64String);
      final fileName = 'example.pdf';
      final dir = await getExternalStorageDirectory();

      final file = File('${dir!.path}/$fileName');
      await file.writeAsBytes(bytes);

      // Open the file.
      await OpenFile.open('${dir.path}/$fileName');
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
      drawer: NavDrawerTutor(),
        backgroundColor: Theme.of(context).primaryColor,
        body: SafeArea(
            child: ListView(
                children: [
                  Container(
                    height: 392,
                      child: ClipRRect(
                          borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(22),
                                bottomRight: Radius.circular(22),
                              ),
                        child: Image.memory(
                                encodeedimg,
                            fit: BoxFit.cover,
                                errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                  return Icon(Icons.image_not_supported);
                                },
                              ),
                      )
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
                      ElevatedButton(
                          onPressed: () {
                  Navigator.push(
                  context,
                   MaterialPageRoute(builder: (context) => const AddVideo()),
                   );
                    },
                          child: Text('Add Video')),
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
                      id=videos[index]["video_id"];
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
          ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddDocument()),
                );
              },
              child: Text('Add Document')),
                    ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      physics: const BouncingScrollPhysics(),
                      itemCount: pdf.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Card(
                            color: Colors.deepPurple,
                            child:ListTile(
                              title: Text(pdf[index]["document_topic"]),textColor: Colors.white,
                              subtitle: Text(''),
                              trailing: IconButton(
                                  onPressed: () {
                                    downloadPDF(pdf[index]["document_file"]);
                                  },
                                  icon: Icon(Icons.file_download)),
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
