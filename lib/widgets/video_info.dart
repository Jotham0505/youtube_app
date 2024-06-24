import 'package:flutter/material.dart';
import 'package:youtube_clone_app/values.dart';
import 'package:timeago/timeago.dart' as timeago;

class VideoInfo extends StatelessWidget {
  final Video ? video;
  const VideoInfo({super.key, required this.video});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(video!.title,style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 17),),
          SizedBox(height: 8,),
          Text("${video!.viewCount} views * ${timeago.format(video!.timestamp)}", style: Theme.of(context).textTheme.caption!.copyWith(fontSize: 14),),

          Divider(),
          _ActionsRow(video: video),
          Divider(),
          _AuthorInfo(user: video!.author),
          Divider()
        ],
      ),
    );
  }
}

class _ActionsRow extends StatelessWidget {
  final Video ? video;
  const _ActionsRow({super.key, required this.video});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
      _buildAction(context,Icons.thumb_up_outlined, video!.likes),
      _buildAction(context,Icons.thumb_down_outlined, video!.dislikes),
      _buildAction(context,Icons.reply_outlined, "Share"),
      _buildAction(context,Icons.download_outlined, "Download"),
      _buildAction(context,Icons.library_add_outlined, "Save"),
      ],
    );
  }
}

Widget _buildAction (BuildContext context, IconData icon, String label){
  return GestureDetector(
    onTap: (){},
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon),
        SizedBox(height: 6,),
        Text(label,style: Theme.of(context).textTheme.caption!.copyWith(color: Colors.white),)
      ],
    ),
  );
}


class _AuthorInfo extends StatelessWidget {
  final User ? user;
  const _AuthorInfo({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => print('Navigate to profile Screen'),
      child: Row(
        children: [
          CircleAvatar(
            foregroundImage: NetworkImage(user!.profileImageUrl),
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
                    user!.username,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontSize: 15),
                  ),
                ),
                Flexible(
                  child: Text(
                    "${user!.subscribers} subscribers ",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(fontSize: 14),
                  ),
                ),
                
              ],
            ),
          ),
          TextButton(onPressed: (){}, child: Text('Subscribe',style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.red),))
        ],
      ),
    );
  }
}