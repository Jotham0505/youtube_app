import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  User ? _user;
  final SupabaseClient _supabaseClient = Supabase.instance.client;

  User ? get user{
    return _user;
  }

  AuthService(){
    _supabaseClient.auth.onAuthStateChange.listen((event) {
      authStateChangesStreamListner;
    },);
  }

  Future<bool> login(String email, String password) async{
    try {
      final response = await _supabaseClient.auth.signInWithPassword(password: password,email: email);
      if (response.user != null) {
        _user = response.user;
        return true;
      }
    } catch (e) {
      print(e);
    }
    return false;
  }

  void authStateChangesStreamListner(AuthChangeEvent event, Session ? session){
    if (session != null) {
      _user = session.user;
    } else {
      _user = null;
    }
  }

  Future<bool> logout() async{
    try {
      await _supabaseClient.auth.signOut();
      _user = null;
      return true;
    } catch (e) {
      print(e);
    }
    return false;
  }
}
