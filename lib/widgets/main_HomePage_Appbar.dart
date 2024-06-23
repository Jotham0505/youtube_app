import 'package:flutter/material.dart';
import 'package:youtube_clone_app/values.dart';

class MainHomePageAppbar extends StatelessWidget {
  const MainHomePageAppbar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.black,
      floating: true,
      actions: [
        IconButton(onPressed: (){}, icon: Icon(Icons.cast),),
        IconButton(onPressed: (){}, icon: Icon(Icons.notifications_outlined),),
        IconButton(onPressed: (){}, icon: Icon(Icons.search),),
        IconButton(iconSize: 40,onPressed: (){}, icon: CircleAvatar(foregroundImage: NetworkImage(currentUser.profileImageUrl))),
      ],
      leading: Padding(
        padding: const EdgeInsets.only(left: 12),
        child: Image.asset('assets/yt_logo_dark.png'),
      ),
      leadingWidth: 100,
    );
  }
}