import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:video_player/video_player.dart';

class MyVideoApp extends StatefulWidget {
  @override
  _MyVideoAppState createState() => _MyVideoAppState();
}

class _MyVideoAppState extends State<MyVideoApp> {
  String? _base64;
  late VideoPlayerController _controller;
  final TempFile="";

  Future<void> _pickVideo() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.video,
    );
    if (result != null) {
      File file = File(result.files.single.path!);
      _convertToBase64(file);
    }
  }

  Future<void> _convertToBase64(File file) async {
    List<int> videoBytes = await file.readAsBytes();
    String base64Video = base64Encode(videoBytes);
    setState(() {
      _base64 = base64Video;
    });
    print(_base64);
  }

  Future<void> _playBase64Video() async {
    if (_base64 == null) {
      return;
    }
    List<int> videoBytes = base64Decode(_base64!);
    final tempDir = await getTemporaryDirectory();
    final tempFile = await new File('${tempDir.path}/video.mp4').create();
    await tempFile.writeAsBytes(videoBytes);
  }

  void initState(){
    super.initState();
    this._playBase64Video();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video to Base64'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _pickVideo,
              child: Text('Select Video'),
            ),
            SizedBox(height: 16.0),
            // Text(
            //   _base64 ?? 'No video selected',
            //   style: TextStyle(fontSize: 12.0),
            // ),
            // ElevatedButton(
            //   onPressed: _playBase64Video,
            //   child: Text('Load Base64 Video'),
            // ),
            // SizedBox(height: 16.0),
            // _controller != null && _controller.value.isInitialized
            //     ? AspectRatio(
            //   aspectRatio: _controller.value.aspectRatio,
            //   child: VideoPlayer(_controller),
            // )
            //     : Container(),
          ],
        ),
      ),
    );
  }
}