import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';

import '../models/user_model.dart';

class AuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String?> register(UserModel user) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: user.email,
        password: user.password,
      );

      final uID = userCredential.user?.uid;
      final token = userCredential.credential?.token;
      // If registration successful, you can save additional user data to Firestore here
      // return null; // Return null if registration succeeds
      return uID;
    } catch (e) {
      return e.toString(); // Return error message if registration fails
    }
  }
}
