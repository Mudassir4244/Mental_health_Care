import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mental_healthcare/frontend/customer_interface/loginscreen.dart';

class PracAuth {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 🧩 SIGN UP (Register new user + Assign role)
  Future<User?> practioner_signup({
    required String Fullname,
    required String email,
    required String Password,
    required String Contact_no,
    required String payment_status,
    required String Speciality,
    required String Experience,

    required BuildContext context,
  }) async {
    try {
      // 🔐 Create user in Firebase Auth
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(
            email: email.trim(),
            password: Password.trim(),
          );

      User? user = userCredential.user;

      if (user != null) {
        // 🗂️ Save user info + role in Firestore
        await _firestore.collection('Users').doc(user.uid).set({
          'uid': user.uid,
          'Email': email.trim(),
          'Fullname': Fullname.trim(),
          'Phone Number': Contact_no.trim(),
          'Speciality': Speciality.trim(),
          'Experience': Experience.trim(),
          'Payment Status': payment_status,
          'role': 'Practionar', // 👈 Assign role here
          'createdAt': FieldValue.serverTimestamp(),
        });

        // Get.snackbar("Sign Up!", "Account Created Successfully as Customer");
      }

      return user;
    } on FirebaseAuthException catch (e) {
      _showError(context, e.message ?? "practioner_signup failed");
      return null;
    } catch (e) {
      _showError(context, e.toString());
      return null;
    }
  }

  // 🧩 SIGN IN (Login existing user)
  Future<User?> signIn({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      Get.snackbar("Welcome Back!", "Login Successful");
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      _showError(context, e.message ?? "Sign-in failed");
      return null;
    } catch (e) {
      _showError(context, "Something went wrong");
      return null;
    }
  }

  // 🧩 SIGN OUT
  Future<void> signOut(BuildContext context) async {
    try {
      await _auth.signOut();
      Navigator.push(context, MaterialPageRoute(builder: (_) => LoginScreen()));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Signed out successfully"),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      _showError(context, "Error signing out");
    }
  }

  // 🧩 Current user getter
  User? get currentUser => _auth.currentUser;

  void fetching_user() {}
  // 🧩 Error handling helper
  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }
}
