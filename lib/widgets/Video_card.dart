import 'package:flutter/material.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:youtube_clone_app/screens/Navigation_screen.dart';
import 'package:youtube_clone_app/values.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VideoCards extends StatelessWidget {
  final VoidCallback ? onTap;
  final bool hasPadding;
  final Video video;
  const VideoCards({super.key, required this.video,  this.hasPadding = false, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read(selectedVideoProvider).state = video;
        context.read(miniPlayerControllerProvider).state.animateToHeight(state: PanelState.MAX);
        if(onTap != null) onTap!();
      },
      child: Column(
        children: [
          Stack(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: hasPadding ? 12:0), 
                child: Image.network(
                  video.thumbnailUrl,
                  height: 220,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                child: Container(
                  color: Colors.black,
                  child: Text(
                    video.duration,
                    style: Theme.of(context)
                        .textTheme
                        .caption!
                        .copyWith(color: Colors.white),
                  ),
                ),
                bottom: 8,
                right: hasPadding ? 20 : 8,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  child: CircleAvatar(
                    foregroundImage: NetworkImage(video.author.profileImageUrl),
                  ),
                  onTap: () => print('Navigate To profile')
                ),
                SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Text(
                          video.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 15),
                        ),
                      ),
                      Flexible(
                        child: Text(
                          "${video.author.username} : ${video.viewCount} : ${timeago.format(video.timestamp)} ",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(child: Icon(Icons.more_vert,size: 20,),onTap: (){},)
              ],
            ),
          )
        ],
      ),
    );
  }
}