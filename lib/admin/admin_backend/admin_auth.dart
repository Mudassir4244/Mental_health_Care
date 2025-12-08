import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mental_healthcare/admin/admin_homescreen.dart';

class AdminLogin {
  Future<void> performLogin(
    String email,
    String password,
    BuildContext context,
  ) async {
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Please fill all fields")));
      return;
    }

    try {
      // Sign-in using Firebase Auth
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      String uid = userCredential.user!.uid;

      // Fetch user role from Firestore
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection("admin")
          .doc(uid)
          .get();

      if (!snapshot.exists) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("User data not found")));
        return;
      }

      String role = snapshot['role'];

      if (role == "Admin") {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => AdminHomescreen()),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Access denied. Not an admin")));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }
}
