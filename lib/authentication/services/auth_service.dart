import 'dart:io';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  User? _user;
  final SupabaseClient _supabaseClient = Supabase.instance.client;

  User? get user => _user;

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
        print('Error signing in');
        return false;
      }
      _user = response.user;
      return true;
    } catch (e) {
      print('Error signing in: $e');
      return false;
    }
  }

  Future<bool> signUp(String email, String password, String name, File? selectedImage) async {
    const int maxRetries = 3;
    const Duration retryDelay = Duration(seconds: 60);
    int retries = 0;

    while (retries < maxRetries) {
      try {
        final response = await _supabaseClient.auth.signUp(email: email, password: password);
        if (response.session == null) {
          print('Error signing up');
          return false;
        }

        // Upload the selected image if it exists
        if (selectedImage != null) {
          final path = 'public/profiles/${response.user!.id}/profile.png';
          await _supabaseClient.storage.from('avatars').upload(path, selectedImage);
        }

        // Additional user data can be updated after sign-up if needed
        await _supabaseClient.from('users').upsert([
          {
            'id': response.user!.id,
            'name': name,
            // Add more fields as necessary
          }
        ]);

        _user = response.user;
        return true;
      } catch (e) {
        if (e.toString().contains('Email rate limit exceeded')) {
          print('Rate limit exceeded. Please try again later.');
          retries++;
          if (retries >= maxRetries) {
            print('Maximum retry attempts reached. Please try again later.');
            return false;
          }
          await Future.delayed(retryDelay);
        } else {
          print('Error signing up: $e');
          return false;
        }
      }
    }
    return false;
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





