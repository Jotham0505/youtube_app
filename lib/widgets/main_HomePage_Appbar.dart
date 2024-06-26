import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:youtube_clone_app/values.dart';
import 'package:youtube_clone_app/authentication/services/navigation_service.dart';

class MainHomePageAppbar extends StatelessWidget {
  const MainHomePageAppbar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final NavigationService _navigationService = GetIt.instance.get<NavigationService>();
    return SliverAppBar(
      backgroundColor: Colors.black,
      floating: true,
      actions: [
        IconButton(onPressed: (){}, icon: Icon(Icons.cast)),
        IconButton(onPressed: (){}, icon: Icon(Icons.notifications_outlined)),
        IconButton(onPressed: (){}, icon: Icon(Icons.search)),
        IconButton(
          iconSize: 40,
          onPressed: () {
            _navigationService.pushReplacementNamed('/login'); // Navigate to the login screen
          },
          icon: CircleAvatar(foregroundImage: NetworkImage(currentUser.profileImageUrl)),
        ),
      ],
      leading: Padding(
        padding: const EdgeInsets.only(left: 12),
        child: Image.asset('assets/yt_logo_dark.png'),
      ),
      leadingWidth: 100,
    );
  }
}
