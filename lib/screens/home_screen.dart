import 'package:flutter/material.dart';
import 'package:youtube_clone_app/values.dart';
import 'package:youtube_clone_app/widgets/Video_card.dart';
import 'package:youtube_clone_app/widgets/main_HomePage_Appbar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          MainHomePageAppbar(), // main app bar
          SliverPadding(
            padding: EdgeInsets.only(bottom: 60),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final video = videos[index];
                  return VideoCards(video: video);
                },
                childCount: videos.length
              ),
            ),
          )
        ],
      ),
    );
  }
}
