import 'package:flutter/material.dart';
import 'package:youtube_clone_app/authentication/consts.dart';
import 'package:youtube_clone_app/authentication/screens/login_page.dart';
import 'package:youtube_clone_app/screens/home_screen.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color.fromARGB(255, 255, 0, 0)),
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen(),)),
        ),
        actions: [
          IconButton(
          icon: Icon(Icons.more_vert, color: Color.fromARGB(255, 255, 0, 0)),
          onPressed: () {},
        ),
        ],
      ),
      body: Container(
        color: Colors.black,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(PLACEHOLDER_PFP),
            ),
            SizedBox(height: 16),
            Text(
              'David Robinson',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 32),
            ListTile(
              leading: Icon(Icons.person, color: const Color.fromARGB(255, 255, 0, 0)),
              title: Text('Email', style: TextStyle(color: Colors.white)),
              trailing: Icon(Icons.arrow_forward_ios, color: Color.fromARGB(255, 255, 0, 0)),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.security, color: Color.fromARGB(255, 255, 0, 0)),
              title: Text('Security', style: TextStyle(color: Colors.white)),
              trailing: Icon(Icons.arrow_forward_ios, color: Color.fromARGB(255, 255, 0, 0)),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.dark_mode, color: Color.fromARGB(255, 255, 0, 0)),
              title: Text('Dark Mode', style: TextStyle(color: Colors.white)),
              trailing: Icon(Icons.arrow_forward_ios, color: Color.fromARGB(255, 255, 0, 0)),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.notifications, color: Color.fromARGB(255, 255, 0, 0)),
              title: Text('Notifications', style: TextStyle(color: Colors.white)),
              trailing: Icon(Icons.arrow_forward_ios, color: Color.fromARGB(255, 255, 0, 0)),
              onTap: () {},
            ),
            SizedBox(
              height: 50,
            ),
            ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage())),
              style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(255, 255, 0, 0),
                padding: EdgeInsets.symmetric(horizontal: 60, vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                'Sign Out',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ProfileScreen(),
  ));
}
