import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoApp extends StatefulWidget {
  final String videoUrl;

  const VideoApp({Key? key, required this.videoUrl}) : super(key: key);

  @override
  _VideoAppState createState() => _VideoAppState();
}

class _VideoAppState extends State<VideoApp> {
  late VideoPlayerController _controller;
  late bool _isFullScreen;
  late double _currentSliderValue;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {});
      });

    _isFullScreen = false;
    _currentSliderValue = 0.0;

    _controller.addListener(() {
      if (_controller.value.isPlaying) {
        setState(() {
          _currentSliderValue = _controller.value.position.inSeconds.toDouble();
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _playPauseVideo() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
      } else {
        _controller.play();
      }
    });
  }

  void _toggleFullScreen() {
    setState(() {
      _isFullScreen = !_isFullScreen;
    });
  }

  void _onSliderChanged(double value) {
    setState(() {
      _currentSliderValue = value;
    });
    final Duration position = Duration(seconds: value.toInt());
    _controller.seekTo(position);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _controller.value.isInitialized
            ? Stack(
                children: [
                  AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  ),
                  if (!_controller.value.isPlaying)
                    Center(
                      child: IconButton(
                        icon: Icon(Icons.play_arrow),
                        onPressed: _playPauseVideo,
                      ),
                    ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: _controller.value.isPlaying
                              ? Icon(Icons.pause)
                              : Icon(Icons.play_arrow),
                          onPressed: _playPauseVideo,
                        ),
                        Slider(
                          value: _currentSliderValue,
                          min: 0,
                          max: _controller.value.duration.inSeconds.toDouble(),
                          onChanged: _onSliderChanged,
                          activeColor: Colors.red,
                          inactiveColor: Colors.grey,
                        ),
                        IconButton(
                          icon: _isFullScreen
                              ? Icon(Icons.fullscreen_exit)
                              : Icon(Icons.fullscreen),
                          onPressed: _toggleFullScreen,
                        ),
                      ],
                    ),
                  ),
                ],
              )
            : CircularProgressIndicator(),
      ),
    );
  }
}
