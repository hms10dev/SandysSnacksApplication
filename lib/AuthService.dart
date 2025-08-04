import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService extends ChangeNotifier {
  User? _user;
  bool get isLoggedIn => _user != null;

  Future<void> signUp(String email, String password, String name) async {
    // Firebase signup call here
    // Save user to Firestore here
  }

  Future<void> signIn(String email, String password) async {
    // Firebase signin call here
  }
}
