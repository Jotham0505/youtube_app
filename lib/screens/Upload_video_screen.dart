import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_clone_app/authentication/services/video_service.dart';
import 'package:youtube_clone_app/screens/uploaded_video_player_screen.dart';
// Update with the correct import path

class UploadScreen extends StatefulWidget {
  const UploadScreen({Key? key}) : super(key: key);

  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  final GetIt _getIt = GetIt.instance;
  late VideoService _videoService;
  String? _videoUrl;
  VideoPlayerController? _controller;

  @override
  void initState() {
    super.initState();
    _videoService = _getIt.get<VideoService>();
  }

  Future<void> _pickAndUploadVideo() async {
    File? video = await _videoService.pickVideoFromGallery();
    if (video != null) {
      String? videoUrl = await _videoService.uploadVideo(video);
      if (videoUrl != null) {
        Navigator.push(context,MaterialPageRoute(builder: (context) => uploaded_video_player_screen(videoUrl: videoUrl)));
        print('Video uploaded to: $videoUrl');
      } else {
        print('Failed to upload video');
      }
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(onPressed: (){}, icon: Icon(Icons.arrow_back)),
        title: Text('Upload Video'),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: const Color.fromARGB(255, 255, 0, 0),
                  padding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 60.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                
                onPressed: _pickAndUploadVideo,
                child: Column(
                  children: [
                    Icon(Icons.video_library, size: 50, color: Colors.white),
                    SizedBox(height: 10),
                    Text(
                      'Videos',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Upload new videos.',
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

