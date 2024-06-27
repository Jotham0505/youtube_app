import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:youtube_clone_app/authentication/consts.dart';
import 'package:youtube_clone_app/authentication/screens/login_page.dart';
import 'package:youtube_clone_app/screens/home_screen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final SupabaseClient _supabaseClient = Supabase.instance.client;
  String _userName = '';
  String _profileImageUrl = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchUserProfile();
  }
  

  Future<void> fetchUserProfile() async {
  try {
    final user = _supabaseClient.auth.currentUser;
    if (user == null) {
      // Handle case where user is not logged in
      return;
    }

    final response = await _supabaseClient
        .from('profiles')
        .select('name, profile_image_url')
        .eq('user_id', user.id)
        .single()
        .execute();

    if (response.status == 200) {
      final userProfile = response.data;
      if (userProfile != null) {
        setState(() {
          _userName = userProfile['name'] as String? ?? '';
          _profileImageUrl = userProfile['profile_image_url'] as String? ?? '';
        });
      } else {
        print('No user profile data found');
      }
    } else {
      print('Error fetching user profile:');
    }
  } catch (e) {
    print('Error fetching the user profile: $e');
  }
}




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
              backgroundImage: _profileImageUrl.isNotEmpty ? NetworkImage(_profileImageUrl) as ImageProvider : AssetImage('assets/placeholder.png'),
            ),
            SizedBox(height: 16),
            Text(
              'Jotham Emmanuel Cheeran',
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
               onPressed: () async {
                // Handle sign out
                await _supabaseClient.auth.signOut();
                Navigator.pushReplacementNamed(context, '/login'); // Navigate to login screen
              },
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

class _execute {
}


