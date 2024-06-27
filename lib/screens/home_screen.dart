import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:youtube_clone_app/authentication/consts.dart';
import 'package:youtube_clone_app/authentication/services/auth_service.dart';
import 'package:youtube_clone_app/authentication/services/video_service.dart';
import 'package:youtube_clone_app/screens/Upload_video_screen.dart';
import 'package:youtube_clone_app/screens/explore_screen.dart';
import 'package:youtube_clone_app/screens/user_profile_screen.dart';
import 'package:youtube_clone_app/values.dart';
import 'package:youtube_clone_app/widgets/Video_card.dart';
import 'package:youtube_clone_app/widgets/main_HomePage_Appbar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GetIt _getIt = GetIt.instance;
  late AuthService _authService;
  int _currentIndex = 0;
  late VideoService _videoService;
  List<String> _uploadedvideos = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _authService = _getIt.get<AuthService>();
    _videoService = _getIt.get<VideoService>();
  }

  Future<void> _logout() async {
    bool success = await _authService.logout();
    if (success) {
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      // Handle logout failure
      print('Error logging out');
    }
  }

  final screens = [
    Scaffold(
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
                childCount: videos.length,
              ),
            ),
          ),
        ],
      ),
    ),
    Scaffold(body: Center(child: Text('explore'),),),
    UploadScreen(),
    Scaffold(body: Center(child: Text("Subscriptions"))),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedFontSize: 10,
        unselectedFontSize: 10,
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) async{
        
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
            activeIcon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore_outlined),
            label: 'Explore',
            activeIcon: Icon(Icons.explore),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            label: 'Add',
            activeIcon: Icon(Icons.add_circle),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.subscriptions_outlined),
            label: 'Subscriptions',
            activeIcon: Icon(Icons.subscriptions),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.video_library_outlined),
            label: 'Library',
            activeIcon: Icon(Icons.video_library),
          ),
        ],
      ),
    );
  }
}

