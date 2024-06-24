import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  ScrollController ? _scrollController;
  VideoPlayerController ? _videoPlayerController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController?.dispose();
    _videoPlayerController?.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){},
      child: Scaffold(
        body: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: CustomScrollView(
            controller: _scrollController,
            shrinkWrap: true,
            slivers: [
              SliverToBoxAdapter(
                child: Consumer(
                  builder: (context, watch, _) {
                    final selectedVideo = watch(selectedVideoProvider).state;
                    if (selectedVideo != null) {
                      _videoPlayerController?.dispose();
                      _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse('https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4'))..initialize().then((_) {setState(() {});
                      _videoPlayerController!.play();
                      });
                    }

                    return SafeArea(
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              _videoPlayerController != null && _videoPlayerController!.value.isInitialized ?
                              AspectRatio(aspectRatio: _videoPlayerController!.value.aspectRatio, child: VideoPlayer(_videoPlayerController!),) :
                              Image.network(selectedVideo!.thumbnailUrl,height: 220,width: double.infinity,fit: BoxFit.cover,),
                              FloatingActionButton(onPressed: (){}, child: Icon(_videoPlayerController!.value.isPlaying ? Icons.pause : Icons.play_arrow),),
                              IconButton(onPressed: () => context.read(miniPlayerControllerProvider).state.animateToHeight(state: PanelState.MIN), icon: Icon(Icons.keyboard_arrow_down), iconSize: 30,)
                            ],
                          ),
                          LinearProgressIndicator(
                            value: _videoPlayerController != null && _videoPlayerController!.value.isInitialized ?
                            _videoPlayerController!.value.position.inMilliseconds / _videoPlayerController!.value.duration.inMilliseconds : 0,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                          ),
                          VideoInfo(video: selectedVideo),
                        ],
                      ),
                    );
                  },
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate((context, index){
                  final video = suggestedVideos[index];
                  return VideoCards(video: video, hasPadding: true,onTap: () => _scrollController!.animateTo(0, duration: Duration(milliseconds: 200), curve: Curves.easeIn),);
                },childCount: suggestedVideos.length),
              )
            ],
          ),
        ),
      ),
    );
  }
}