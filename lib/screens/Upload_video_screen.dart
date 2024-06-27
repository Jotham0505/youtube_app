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
      appBar: AppBar(
        title: Text('Upload Video'),
        backgroundColor: Colors.red,
      ),
      body: Container(
        color: Colors.black,
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                decoration: BoxDecoration(

                ),
                child: ElevatedButton( // used to pick the video from the gallery
                  onPressed: _pickAndUploadVideo,
                  child: Text('Pick Video'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            _videoUrl != null && _controller != null
                ? AspectRatio(
                    aspectRatio: _controller!.value.aspectRatio,
                    child: VideoPlayer(_controller!),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}

