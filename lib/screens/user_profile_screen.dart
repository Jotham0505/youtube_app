import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:youtube_clone_app/authentication/consts.dart';
import 'package:youtube_clone_app/authentication/screens/login_page.dart';
import 'package:youtube_clone_app/authentication/services/video_service.dart';

class ProfileScreen extends StatelessWidget {
  final VideoService _videoService = GetIt.instance.get<VideoService>();
  ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
        backgroundColor: Colors.red,
        actions: [
          Drawer(

          )
        ],
      ),
      body: Container(
        color: Colors.black,
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Center(
              child: CircleAvatar(
                radius: 80,
                backgroundImage: NetworkImage(
                  PLACEHOLDER_PFP, // Placeholder image URL
                ),
              ),
            ),
            SizedBox(height: 20),
            ListTile(
              title: Text(
                'Name',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              subtitle: Text(
                'John Doe',
                style: TextStyle(color: Colors.grey),
              ),
              leading: Icon(Icons.person, color: Colors.white),
            ),
            Divider(color: Colors.white),
            ListTile(
              title: Text(
                'Email',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              subtitle: Text(
                'johndoe@example.com',
                style: TextStyle(color: Colors.grey),
              ),
              leading: Icon(Icons.email, color: Colors.white),
            ),
            Divider(color: Colors.white),
            ListTile(
              title: Text(
                'Phone',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              subtitle: Text(
                '+91 123 456 7890',
                style: TextStyle(color: Colors.grey),
              ),
              leading: Icon(Icons.phone, color: Colors.white),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async{
                Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage(),));
              },
              child: Text('Log out'),
              style: ElevatedButton.styleFrom(
                primary: Colors.red
              ),
            ),
          ],
        ),
      )
    );
  }
}