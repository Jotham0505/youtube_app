import 'package:flutter/material.dart';

import 'package:video_player/video_player.dart';

class uploaded_video_player_screen extends StatefulWidget {
  final String videoUrl;

  const uploaded_video_player_screen({required this.videoUrl});

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<uploaded_video_player_screen> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..addListener(() {
        setState(() {});
      })
      ..setLooping(true);
    _initializeVideoPlayerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Player'),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: _initializeVideoPlayerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
          VideoProgressIndicator(_controller, allowScrubbing: true),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${_controller.value.position.inMinutes}:${(_controller.value.position.inSeconds % 60).toString().padLeft(2, '0')}',
                style: TextStyle(fontSize: 16),
              ),
              
              IconButton(
                icon: Icon(Icons.replay_10),
                onPressed: () {
                  setState(() {
                    final newPosition =
                        _controller.value.position - Duration(seconds: 10);
                    _controller.seekTo(newPosition);
                  });
                },
              ),

              IconButton(
                icon: Icon(
                  _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                ),
                onPressed: () {
                  setState(() {
                    if (_controller.value.isPlaying) {
                      _controller.pause();
                    } else {
                      _controller.play();
                    }
                  });
                },
              ),
              IconButton(
                icon: Icon(Icons.forward_10),
                onPressed: () {
                  setState(() {
                    final newPosition =
                        _controller.value.position + Duration(seconds: 10);
                    _controller.seekTo(newPosition);
                  });
                },
              ),
            ],
          ),
          SizedBox(height: 5,),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context, widget.videoUrl); // Pop the screen and return true
            },
            child: Text('Push to Explore'),
          ),
        ],
      ),
    );
  }
}
