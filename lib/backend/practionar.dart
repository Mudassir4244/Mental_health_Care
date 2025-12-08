// ignore_for_file: avoid_types_as_parameter_names

import 'dart:core';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mental_healthcare/frontend/customer_interface/loginscreen.dart';

class PracAuth {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 🧩 SIGN UP (Register new user + Assign role)
  // Future<User?> practioner_signup({
  //   required String Fullname,
  //   required String email,
  //   required String Password,
  //   required String Contact_no,
  //   required String payment_status,
  //   required String Speciality,
  //   required String Experience,
  //   required String ispremium,

  //   required BuildContext context,
  // }) async {
  //   try {
  //     // 🔐 Create user in Firebase Auth
  //     UserCredential userCredential = await _auth
  //         .createUserWithEmailAndPassword(
  //           email: email.trim(),
  //           password: Password.trim(),
  //         );

  //     User? user = userCredential.user;

  //     if (user != null) {
  //       // 🗂️ Save user info + role in Firestore
  //       await _firestore.collection('Users').doc(user.uid).set({
  //         'uid': user.uid,
  //         'Email': email.trim(),
  //         'Fullname': Fullname.trim(),
  //         'Phone Number': Contact_no.trim(),
  //         'Speciality': Speciality.trim(),
  //         'Experience': Experience.trim(),
  //         'Payment Status': payment_status,
  //         'role': 'Practionar', // 👈 Assign role here
  //         'Is Premium': ispremium,
  //         'createdAt': FieldValue.serverTimestamp(),
  //       });

  //       // Get.snackbar("Sign Up!", "Account Created Successfully as Customer");
  //     }

  //     return user;
  //   } on FirebaseAuthException catch (e) {
  //     _showError(context, e.message ?? "practioner_signup failed");
  //     return null;
  //   } catch (e) {
  //     _showError(context, e.toString());
  //     return null;
  //   }
  // }
  Future<User?> create_prac({
    required String Fullname,
    required String email,
    required String Password,
    required String Contact_no,
    required String payment_status,
    required String Speciality,
    required String Experience,

    required BuildContext context,
  }) async {
    final FirebaseAuth firebaseauth = FirebaseAuth.instance;
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      // ✅ Create the user directly
      final userCredentials = await firebaseauth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: Password.trim(),
      );

      User? user = userCredentials.user;

      if (user != null) {
        await firestore.collection("Users").doc(user.uid).set({
          'uid': user.uid,
          'email': email.trim(),
          'username': Fullname.trim(),
          'Phone Number': Contact_no.trim(),
          'Speciality': Speciality.trim(),
          'Experience': Experience.trim(),
          'Payment Status': 'Pending',
          'role': 'Practitioner', // 👈 Assign role here

          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      return user;
    } on FirebaseAuthException catch (e) {
      String errorMessage;

      if (e.code == 'email-already-in-use') {
        errorMessage = 'This email is already registered. Please use another.';
      } else if (e.code == 'weak-password') {
        errorMessage = 'The password is too weak.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'The email address is not valid.';
      } else {
        errorMessage = 'Error: ${e.message}';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
      );

      return null;
    } catch (e) {
      debugPrint("Error in create_organization: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
      return null;
    }
  }

  /// Update payment status to Completed after successful payment
  Future<bool> updatePaymentStatus(String userId) async {
    try {
      await _firestore.collection("Users").doc(userId).update({
        "Payment Status": "Completed",
        "Payment Completed at": FieldValue.serverTimestamp(),
      });
      return true;
    } catch (e) {
      debugPrint("Error updating payment status: $e");
      return false;
    }
  }

  /// Check if email is already registered
  Future<bool> isEmailAvailable(String email) async {
    try {
      final querySnapshot = await _firestore
          .collection('Users')
          .where('Organization owner email', isEqualTo: email.trim())
          .limit(1)
          .get();

      return querySnapshot.docs.isEmpty;
    } catch (e) {
      debugPrint("Error checking email availability: $e");
      return false;
    }
  }

  // ignore: non_constant_identifier_names
  Future<Map<String, dynamic>?> fetch_practionor(BuildContext context) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return null;

      final snapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid)
          .get();

      if (snapshot.exists && snapshot.data()?['role'] == "Practitioner") {
        return snapshot.data();
      } else {
        return null;
      }
    } catch (e) {
      _showError(context, "Error while fetching customer");
      return null;
    }
  }

  // 🧩 UPDATE CUSTOMER PROFILE
  Future<void> update_practionar(
    BuildContext context,
    Map<String, dynamic> updatedData,
  ) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        _showError(context, "No user logged in");
        return;
      }

      // ✅ Update Firestore user document
      await _firestore.collection('Users').doc(user.uid).update({
        if (updatedData['username'] != null)
          'username': updatedData['username'],
        if (updatedData['email'] != null) 'email': updatedData['email'],
        if (updatedData['role'] != null) 'role': updatedData['role'],
      });

      // ✅ Securely update Firebase Auth email
      if (updatedData['email'] != null &&
          updatedData['email'].toString().isNotEmpty &&
          updatedData['email'] != user.email) {
        await user.verifyBeforeUpdateEmail(updatedData['email']);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Profile updated successfully"),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      debugPrint("Error updating profile: $e");
      _showError(context, "Failed to update profile: $e");
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

  void fetching_user() {
    FirebaseFirestore.instance
        .collection('Users')
        .where('role', isEqualTo: 'Practionar')
        .get();
  }

  // 🧩 Error handling helper
  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }
}
