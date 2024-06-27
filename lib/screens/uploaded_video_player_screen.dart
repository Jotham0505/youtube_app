import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_clone_app/screens/user_profile_screen.dart';
import 'package:youtube_clone_app/values.dart';

class uploaded_video_player_screen extends StatefulWidget {
  final String videoUrl;

  const uploaded_video_player_screen({required this.videoUrl});

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<uploaded_video_player_screen> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  bool _isFullScreen = false;

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

  void _toggleFullScreen() {
    setState(() {
      _isFullScreen = !_isFullScreen;
    });

    if (_isFullScreen) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    } else {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.cast)),
          IconButton(onPressed: () {}, icon: Icon(Icons.notifications_outlined)),
          IconButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen(),)),
            icon: CircleAvatar(
              foregroundImage: NetworkImage(currentUser.profileImageUrl),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: _initializeVideoPlayerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return GestureDetector(
                    onDoubleTap: _toggleFullScreen,
                    child: AspectRatio(
                      aspectRatio: _isFullScreen ? _controller.value.aspectRatio : 16 / 9,
                      child: VideoPlayer(_controller),
                    ),
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
          if (!_isFullScreen) ...[
            SizedBox(height: 10),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                thumbColor: Colors.red, // Customize thumb color
                thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0), // Adjust thumb size
                overlayColor: Colors.red.withOpacity(0.3), // Customize overlay color if needed
                overlayShape: RoundSliderOverlayShape(overlayRadius: 20.0), // Adjust overlay size
              ),
              child: VideoProgressIndicator(
                _controller,
                allowScrubbing: true,
                colors: VideoProgressColors(
                  playedColor: Colors.blue, // Customize played color if needed
                  bufferedColor: Colors.white.withOpacity(0.5), // Customize buffered color if needed
                  backgroundColor: Colors.grey, // Customize background color if needed
                ),
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.replay_10),
                  onPressed: () {
                    setState(() {
                      final newPosition = _controller.value.position - Duration(seconds: 10);
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
                      final newPosition = _controller.value.position + Duration(seconds: 10);
                      _controller.seekTo(newPosition);
                    });
                  },
                ),
                IconButton(
                  icon: Icon(_isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen),
                  onPressed: _toggleFullScreen,
                ),
              ],
            ),
            SizedBox(height: 10),
          ],
        ],
      ),
    );
  }
}

