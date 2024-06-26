

import 'package:flutter/material.dart';
import 'package:youtube_clone_app/authentication/screens/login_page.dart';
import 'package:youtube_clone_app/authentication/screens/signup_page.dart';
import 'package:youtube_clone_app/screens/Navigation_screen.dart';
import 'package:youtube_clone_app/screens/home_screen.dart';
import 'package:youtube_clone_app/screens/video_screen.dart';


class NavigationService {
  
  late GlobalKey<NavigatorState> _navigatorkey;

  final Map<String,Widget Function(BuildContext)> _routes = {
    "/login" : (context) => LoginPage(),
    "/signup" : (context) => SignupPage(),
    "/Home" : (context) => HomeScreen(),
    "/Video" : (context) => VideoScreen(),
  };

  GlobalKey<NavigatorState> ? get navigatorkey{
    return _navigatorkey;
  }
  Map<String, Widget Function(BuildContext)> get routes{
    return _routes;
  }

  NavigationService(){
    _navigatorkey = GlobalKey<NavigatorState>();
  }

  void pushName(String routename){
    _navigatorkey.currentState?.pushNamed(routename);
  }

  void pushReplacementNamed(String routename){
    _navigatorkey.currentState?.pushReplacementNamed(routename);
  }

  void goBack(){
    _navigatorkey.currentState?.pop();
  }

}