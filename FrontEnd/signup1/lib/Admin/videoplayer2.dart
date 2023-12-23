import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:signup1/services/SelectComment.dart';
import 'package:signup1/services/displayVideos.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class TutorVideoPlayer extends StatefulWidget {
  const TutorVideoPlayer({Key? key}) : super(key: key);

  @override
  State<TutorVideoPlayer> createState() => _TutorVideoPlayerState();
}

class _TutorVideoPlayerState extends State<TutorVideoPlayer> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  String id="";
  List comments=[];
  final storage = new FlutterSecureStorage();
  String userID="",videoid="",topic="",discription="",comment="",reply="",commentid="";
  late YoutubePlayerController _controller;
  final StreamController<String> _videoIdController = StreamController<String>();

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
      videoid=allValues["videoId"];
    });
    print(userID);
    print(videoid);
    this.SelCourse();
  }

  Future<void> SelCourse() async {
    try {
      displayVideos video = new displayVideos();
      Future<http.Response> status = video.selVideos(videoid);

      status.then((value) {
        print(value.body);
        Map<String, dynamic> x = jsonDecode(value.body);
        print(x["video"]);
        print(x["video_topic"]);
        print(x["video_discription"]);
        print(x["video_id"]);
        String VideoId=x["video_id"];
        setState(() {
          id = x["video_id"];
          topic = x["video_topic"];
          discription = x["video_discription"];
          _controller.load(VideoId);
        });
        print(id);
        updateVideoId(x["video_id"]);
      });
      this.selComment();
    }catch(e){}
  }

  void updateVideoId(String videoId) {
    setState(() {
      _controller.load(videoId);
    });
  }

  // void _onPlayerReady() {
  //   // The YouTube player controller is ready to receive method calls
  //   _controller.play();
  // }
  //
  // void _onError(String error) {
  //   print(error);
  // }



  Future<void> selComment() async {
    selectComments comment = new selectComments();
    Future<http.Response> status = comment.displayComments(videoid);

    status.then((value) {
      print(value.statusCode);
      setState(() {
        comments=jsonDecode(value.body);
      });
      print(comments);
    });
  }

  void initState(){
    super.initState();
    this.checkAuthentication();

    _controller = YoutubePlayerController(
      initialVideoId: id,
      flags: YoutubePlayerFlags(
          autoPlay: true
      ),
      // )..addListener(() {
      //   if (_controller.value.isReady) {
      //     _onPlayerReady();
      //   } else if (_controller.value.hasError) {
      //     //_onError(_controller.value.errorDescription);
      //   }
      // }
    );
  }

  @override
  Widget build(BuildContext context) {
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
        body: Column(
            children: [
              YoutubePlayerBuilder(
                player: YoutubePlayer(
                  controller: _controller,
                ),
                builder: (context, player) {
                  return Column(
                    children: [
                      // some widgets
                      player,
                      //some other widgets
                    ],
                  );
                },
              ),
              Card(
                  color: const Color(0xff29274F),
                  child:ListTile(
                    title: Text(topic),textColor: Colors.white,
                    subtitle: Text(discription),
                    trailing: ElevatedButton(
                      onPressed: () {
                        updateVideoId(id);
                      },
                      child: const Icon(Icons.replay_rounded),
                    ),
                  )
              ),
              Expanded(child:
              ListView.builder(
                itemCount: comments.length,
                itemBuilder: (BuildContext ctx,index){

                  // final decodestring = base64Decode(x[index]["course_image"].split(',').last);
                  // Uint8List encodeedimg = decodestring;
                  // return Card(
                  //     color: Colors.deepPurple,
                  //     child:ListTile(
                  //         leading: CircleAvatar(
                  //             // backgroundColor: Colors.white,
                  //             // radius: 25.0,
                  //             // child: ClipOval(
                  //             //     child: Image.memory(
                  //             //       encodeedimg,
                  //             //       fit: BoxFit.cover,
                  //             //       width: 100.0,
                  //             //       height: 100.0,
                  //             //     )
                  //             // )
                  //        ),
                  //         title: Text(comments[index]["comment"]),textColor: Colors.white,
                  //         subtitle: Text(""),
                  //         onTap: (){
                  //           setState(() {
                  //             //id=x[index]["_id"];
                  //           });
                  //           //selCourse();
                  //         }
                  //     )
                  // );
                  return Card(
                    color: Colors.deepPurple,
                    elevation: 5,
                    margin: EdgeInsets.all(10),
                    child: ExpansionTile(
                      leading: CircleAvatar(
                        // radius: 25.0,
                        // child: ClipOval(
                        //     child: Image.memory(
                        //       encodeedimg,
                        //       errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                        //         return Icon(Icons.person);
                        //       },
                        //       fit: BoxFit.cover,
                        //       width: 100.0,
                        //       height: 100.0,
                        //     ))
                      ),
                      title: Text(comments[index]["comment"], style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                      ),
                      ),textColor: Colors.white,
                      subtitle: Text('', style: TextStyle(
                          color: Colors.white
                      )),
                      trailing: IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.keyboard_arrow_down),color: Colors.white),
                      // ignore: prefer_const_literals_to_create_immutables
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.all(16),
                            child: Column(
                              children: [
                                Form(
                                    key: _form,
                                    child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Card(
                                              color: Colors.deepPurple,
                                              elevation: 5,
                                              margin: EdgeInsets.all(10),
                                              child: ListTile(
                                                  leading: CircleAvatar(),
                                                  title: comments[index]["replys"].isEmpty ? Text("") :
                                                  Text(comments[index]["replys"][0]["reply"]),textColor: Colors.white
                                              )
                                          )

                                        ]
                                    )
                                ),
                              ],
                            )),
                      ],
                    ),
                  );
                },

              )
              )
            ]
        )
    );
  }

}