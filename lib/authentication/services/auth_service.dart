import 'dart:io';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class AuthService {
  User? _user;
  final SupabaseClient _supabaseClient = Supabase.instance.client;
  String? _error;
  User? get user => _user;
  String? get error => _error;

  AuthService() {
    _supabaseClient.auth.onAuthStateChange.listen((event) { 
      final session = event.session;
      if (session != null) {
        _user = session.user;
      } else {
        _user = null;
      }
    });
    _user = _supabaseClient.auth.currentUser;
  }

  Future<bool> login(String email, String password) async {
    try {
    final response = await _supabaseClient.auth.signInWithPassword(email: email, password: password);
    if (response.session == null) {
      _error = 'Error signing in: No session returned';
      print(_error);
      return false;
    }
    _user = response.user;
    return true;
  } catch (e) {
    _error = 'Error signing in : $e';
    print(_error);
    return false;
  }
}

  Future<bool> signUp(String email, String password, String name, File? selectedImage) async {
  try {
    // Step 1: Sign up the user with email and password
    final response = await _supabaseClient.auth.signUp(email: email, password: password);
    if (response.user == null) {
      _error = 'Error signing up: No user returned';
      print(_error);
      return false;
    }

    // Step 2: Upload the selected image if it exists
    if (selectedImage != null) {
      final path = 'public/profiles/${response.user!.id}/profile.png';
      await _supabaseClient.storage.from('avatars').upload(path, selectedImage);
    }

    // Step 3: Ensure email is confirmed before proceeding
    if (response.user!.emailConfirmedAt == null) {
      print('Please confirm your email before logging in.');
      return false;
    }

    // Step 4: Upsert additional user data including name
    await _supabaseClient.from('users').upsert([
      {
        'id': response.user!.id,
        'name': name,
        // Add more fields as necessary
      }
    ]);

    // Step 5: Update profile table with name and image URL
    await _supabaseClient.from('profiles').upsert([
      {
        'user_id': response.user!.id,
        'name': name,
        'profile_image_url': 'URL to your uploaded image', // Replace with actual URL or logic to retrieve URL
      }
    ]);

    _user = response.user;
    return true;
  } catch (e) {
    _error = 'Error signing up: $e';
    print(_error);
    return false;
  }
}

  Future<bool> logout() async {
    try {
      await _supabaseClient.auth.signOut();
      _user = null;
      return true;
    } catch (e) {
      print('Error signing out: $e');
      return false;
    }
  }
}





