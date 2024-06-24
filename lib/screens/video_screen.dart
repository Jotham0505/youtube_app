import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:youtube_clone_app/screens/Navigation_screen.dart';
import 'package:youtube_clone_app/values.dart';
import 'package:youtube_clone_app/widgets/Video_card.dart';
import 'package:youtube_clone_app/widgets/video_info.dart';
import 'package:video_player/video_player.dart';

class VideoScreen extends StatefulWidget {
  const VideoScreen({super.key});

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  ScrollController? _scrollController;
  VideoPlayerController? _videoPlayerController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController?.dispose();
    _videoPlayerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Scaffold(
        body: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverToBoxAdapter(
                child: Consumer(
                  builder: (context, watch, _) {
                    final selectedVideo = watch(selectedVideoProvider).state;
                    return SafeArea(
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              selectedVideo != null
                                  ? AspectRatio(
                                      aspectRatio: 16 / 9,
                                      child: VideoPlayerWidget(url: selectedVideo.videoUrl),
                                    )
                                  : Container(),
                              IconButton(
                                onPressed: () => context
                                    .read(miniPlayerControllerProvider)
                                    .state
                                    .animateToHeight(state: PanelState.MIN),
                                icon: Icon(Icons.keyboard_arrow_down),
                                iconSize: 30,
                              ),
                            ],
                          ),
                          if (selectedVideo != null) VideoInfo(video: selectedVideo),
                        ],
                      ),
                    );
                  },
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final video = suggestedVideos[index];
                    return VideoCards(
                      video: video,
                      hasPadding: true,
                      onTap: () => _scrollController!.animateTo(
                        0,
                        duration: Duration(milliseconds: 200),
                        curve: Curves.easeIn,
                      ),
                    );
                  },
                  childCount: suggestedVideos.length,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _initializeVideoPlayer(String vidUrl) {
  _videoPlayerController?.dispose();
  _videoPlayerController = VideoPlayerController.network(vidUrl)
    ..initialize().then((_) {
      setState(() {});
      _videoPlayerController!.play();

      // Set up listener to update progress indicator
      _videoPlayerController!.addListener(() {
        if (mounted) {
          setState(() {});
        }
      });
    }).catchError((error) {
      print('Video initialization error: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to load video: $error")),
      );
    });
}

}



class VideoPlayerWidget extends StatefulWidget {
  final String url;

  const VideoPlayerWidget({Key? key, required this.url}) : super(key: key);

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  double _progress = 0.0; // Track user interaction progress
  double _dragValue = 0.0; // Track drag value for thumb position
  bool _isPlaying = false; // Track current playback state
  bool _isFullScreen = false; // Track fullscreen state
  Duration _duration = Duration(); // Track video duration
  Duration _position = Duration(); // Track current position
  String _timeStamp = ''; // Track formatted timestamp

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.url)
      ..initialize().then((_) {
        setState(() {
          _duration = _controller.value.duration;
        });
        _controller.play();
        _isPlaying = true;

        // Set up listener to update progress indicator and timestamp
        _controller.addListener(() {
          if (mounted) {
            setState(() {
              _progress = _controller.value.position.inMilliseconds /
                  _controller.value.duration.inMilliseconds;
              _position = _controller.value.position;
              _timeStamp = _formatDuration(_position);
            });
          }
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? Stack(
            children: [
              GestureDetector(
                onTap: () {
                  _togglePlayPause();
                },
                child: AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: GestureDetector(
                  onTapDown: _onTapDown,
                  onHorizontalDragUpdate: _onHorizontalDragUpdate,
                  child: Stack(
                    alignment: Alignment.centerLeft,
                    children: [
                      LinearProgressIndicator(
                        value: _progress,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                        backgroundColor: Colors.grey,
                      ),
                      Positioned(
                        left: _dragValue * MediaQuery.of(context).size.width - 8,
                        child: GestureDetector(
                          onHorizontalDragUpdate: _onThumbDragUpdate,
                          child: Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 16.0,
                right: 16.0,
                child: Row(
                  children: [
                    if (!_isPlaying) // Show only if not playing
                      IconButton(
                        icon: Icon(
                          Icons.play_arrow,
                          size: 32.0,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          _togglePlayPause();
                        },
                      ),
                    IconButton(
                      icon: Icon(
                        _isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen,
                        size: 32.0,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        _toggleFullScreen();
                      },
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 16.0,
                left: 16.0,
                child: Text(
                  _timeStamp,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                  ),
                ),
              ),
            ],
          )
        : Center(child: CircularProgressIndicator());
  }

  void _togglePlayPause() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
        _isPlaying = false;
      } else {
        _controller.play();
        _isPlaying = true;
      }
    });
  }

  void _toggleFullScreen() {
    setState(() {
      _isFullScreen = !_isFullScreen;
      _isFullScreen ? _enterFullScreen() : _exitFullScreen();
    });
  }

  void _enterFullScreen() {
    setState(() {
      _isFullScreen = true;
    });

    if (Theme.of(context).platform == TargetPlatform.android) {
      // For Android, use flutter_windowmanager to enter fullscreen
      FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_FULLSCREEN);
    } else if (Theme.of(context).platform == TargetPlatform.iOS) {
      // For iOS, use SystemChrome to set immersive mode
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive, overlays: []);
    }

    // Implement your logic to enter fullscreen mode here
    // For example, you can use Navigator.push to navigate to a fullscreen page
    // or change the orientation of the device, etc.
    // Ensure to handle hiding UI elements like app bar, system UI, etc.
    // Note: This example focuses on UI control and does not handle platform-specific fullscreen APIs.
  }

  void _exitFullScreen() {
    setState(() {
      _isFullScreen = false;
    });

    if (Theme.of(context).platform == TargetPlatform.android) {
      // For Android, clear fullscreen flags using flutter_windowmanager
      FlutterWindowManager.clearFlags(FlutterWindowManager.FLAG_FULLSCREEN);
    } else if (Theme.of(context).platform == TargetPlatform.iOS) {
      // For iOS, set SystemChrome back to default mode
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge, overlays: []);
    }

    // Implement your logic to exit fullscreen mode here
    // For example, you can use Navigator.pop to exit fullscreen page
    // or restore the device orientation, etc.
    // Ensure to handle showing UI elements that were hidden in fullscreen mode.
    // Note: This example focuses on UI control and does not handle platform-specific fullscreen APIs.
  }

  void _onTapDown(TapDownDetails details) {
    _updateDragValue(details.localPosition.dx);
    _seekToDragValue();
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    _updateDragValue(details.localPosition.dx);
    _seekToDragValue();
  }

  void _updateDragValue(double dx) {
    setState(() {
      _dragValue = (dx / MediaQuery.of(context).size.width).clamp(0.0, 1.0);
    });
  }

  void _seekToDragValue() {
    final double newPositionMilliseconds =
        _dragValue * _controller.value.duration.inMilliseconds;
    _controller.seekTo(Duration(milliseconds: newPositionMilliseconds.toInt()));
  }

  void _onThumbDragUpdate(DragUpdateDetails details) {
    double dx = details.localPosition.dx;
    if (dx < 0) {
      dx = 0;
    } else if (dx > MediaQuery.of(context).size.width) {
      dx = MediaQuery.of(context).size.width;
    }
    _updateDragValue(dx);
    _seekToDragValue();
  }

  String _formatDuration(Duration duration) {
    return duration.toString().split('.').first.padLeft(8, "0");
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}



