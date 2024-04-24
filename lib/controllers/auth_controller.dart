import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// The function `register` attempts to create a new user account with email and password
  /// authentication, saves user information to Firestore upon successful registration, and returns a
  /// success message or an error message.
  ///
  /// Args:
  ///   user (UserModel): The `register` function you provided is a method that attempts to register a
  /// user by creating a new user account with email and password using Firebase authentication. It then
  /// saves the user information to Firestore if the registration is successful.
  ///
  /// Returns:
  ///   The `register` function returns a `Future<String?>`. The function will return either
  /// "Successful!" if the registration is successful, or an error message as a string if the
  /// registration fails.
  Future<String?> register(UserModel user) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: user.email,
        password: user.password,
      );

      final uID = userCredential.user?.uid;
      final token = userCredential.credential?.token;

      // If registration successful, save user information to Firestore
      if (userCredential.user != null) {
        await _firestore.collection('users').doc(uID).set({
          'username': user.username,
          'email': user.email,
          'firstName': user.firstName,
          'lastName': user.lastName,
        });
      }

      return 'Successful!';
    } catch (e) {
      return e.toString(); // Return error message if registration fails
    }
  }

  /// The `login` function attempts to sign in a user with the provided email and password, returning
  /// null if successful or an error message if unsuccessful.
  ///
  /// Args:
  ///   email (String): The `email` parameter is a `String` representing the user's email address that
  /// they use to log in.
  ///   password (String): The `password` parameter in the `login` function represents the user's
  /// password that they input when trying to log in. This password is used along with the email to
  /// authenticate the user's identity during the login process.
  ///
  /// Returns:
  ///   The `login` function returns a `Future<String?>`. If the login is successful, it returns `null`.
  /// If there is an error during login, it returns the error message as a `String`.
  Future<String?> login(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      final uID = userCredential.user?.uid;
      return uID; // Return null if login succeeds
    } catch (e) {
      return e.toString(); // Return error message if login fails
    }
  }
}
