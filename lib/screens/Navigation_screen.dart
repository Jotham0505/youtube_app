import 'package:flutter/material.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:youtube_clone_app/screens/home_screen.dart';
import 'package:youtube_clone_app/screens/video_screen.dart';
import 'package:youtube_clone_app/values.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeago/timeago.dart';

final selectedVideoProvider = StateProvider<Video?>(
    (ref) => null); // this is the key to managing the state of the app and helps to select the video

final miniPlayerControllerProvider = StateProvider.autoDispose<MiniplayerController>((ref) => MiniplayerController());

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int _currentIndex = 0;
  static const double _playerMinHeight = 60.0;

  final screens = [
    HomeScreen(),
    Scaffold(body: Center(child: Text("Explore"))),
    Scaffold(body: Center(child: Text("Add"))),
    Scaffold(body: Center(child: Text("Subscriptions"))),
    Scaffold(body: Center(child: Text("Library"))),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer(
        builder: (context, watch, _) {
          final selectedVideo = watch(selectedVideoProvider).state;
          final MiniplayerController = watch(miniPlayerControllerProvider).state;
          return Stack(
            // this is mainly used to help create a list of videos
            children: screens
                .asMap()
                .map(
                  (index, screen) => MapEntry(
                    index,
                    Offstage(
                      offstage: _currentIndex != index,
                      child: screen,
                    ),
                  ),
                )
                .values
                .toList()
              ..add(
                Offstage(
                  // responisble for the miniplayer to draggable
                  offstage: selectedVideo == null,
                  child: Miniplayer(
                    controller: MiniplayerController,
                    maxHeight: MediaQuery.of(context).size.height,
                    minHeight: _playerMinHeight,
                    builder: (double height, double percentage) {
                      if (selectedVideo == null) {
                        return SizedBox.shrink();
                      }
                      if (height <= _playerMinHeight + 50)
                      return Container(
                          color: Colors.black,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Image.network(
                                    selectedVideo.thumbnailUrl,
                                    height: _playerMinHeight - 4.0,
                                    width: 120.0,
                                    fit: BoxFit.cover,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Flexible(
                                            child: Text(
                                              selectedVideo.title,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall!
                                                  .copyWith(fontWeight: FontWeight.w500,color: Colors.white),
                                            ),
                                          ),
                                          Flexible(
                                            child: Text(
                                              selectedVideo.author.username,
                                              overflow: TextOverflow.ellipsis,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall!
                                                  .copyWith(fontSize: 14),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {},
                                    icon: Icon(Icons.play_arrow),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      context.read(selectedVideoProvider).state = null;
                                    },
                                    icon: Icon(Icons.close),
                                  ),
                                ],
                              ),
                              LinearProgressIndicator(
                                value: 0.4,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.red),
                              ),
                            ],
                          ));
                          return VideoScreen();
                    },
                  ),
                ),
              ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedFontSize: 10,
        unselectedFontSize: 10,
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
            activeIcon: Icon(
              Icons.home,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore_outlined),
            label: 'Explore',
            activeIcon: Icon(
              Icons.explore,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            label: 'Add',
            activeIcon: Icon(
              Icons.add_circle,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.subscriptions_outlined),
            label: 'Subscriptions',
            activeIcon: Icon(
              Icons.subscriptions,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.video_library_outlined),
            label: 'Library',
            activeIcon: Icon(
              Icons.video_library,
            ),
          ),
        ],
      ),
    );
  }
}
