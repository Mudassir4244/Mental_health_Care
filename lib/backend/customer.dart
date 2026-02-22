// ignore_for_file: unused_import

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mental_healthcare/frontend/customer_interface/homescreen.dart';
import 'package:mental_healthcare/frontend/customer_interface/checkin.dart';
import 'package:mental_healthcare/frontend/customer_interface/loginscreen.dart';
import 'package:mental_healthcare/frontend/customer_interface/profilescreen.dart';
import 'package:mental_healthcare/frontend/practioner_interface/prac_homescreen.dart';
import 'package:mental_healthcare/frontend/practioner_interface/prac_profile.dart';
import 'package:mental_healthcare/frontend/widgets/error_handler.dart';
import 'package:provider/provider.dart';
import 'package:mental_healthcare/frontend/customer_interface/Activityscreeen.dart';
import 'package:mental_healthcare/app_settings_components/edit_profile.dart';
import 'package:mental_healthcare/app_settings_components/security_screen.dart';
import 'package:mental_healthcare/frontend/customer_interface/quizscreen.dart';
import 'package:mental_healthcare/admin/provider%20Classes/quiz_provider.dart';
import 'package:mental_healthcare/admin/provider%20Classes/video_upload_provider.dart';

class Authentication {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 🧩 SIGN UP (Register new user + Assign role)
  Future<User?> signUp({
    required String username,
    required String email,
    required String password,
    required String ImageUrl,
    required BuildContext context,
  }) async {
    try {
      // Create user
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      // Update displayName
      await credential.user!.updateDisplayName(username);
      await credential.user!.reload();
      final now = DateTime.now();
      final expiryDate = now.add(const Duration(days: 30));
      // 🔥 Get the fresh updated user
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Store extra info in Firestore
        await _firestore.collection('Users').doc(user.uid).set({
          'uid': user.uid,
          'email': email.trim(),
          'Payment Status': 'Pending',
          'username': username,
          'role': 'customer',
          'createdAt': FieldValue.serverTimestamp(),
          'Preferred Payment Method': 'Not Selected',
          'Subscription Start Date': 'Not Yet',
          'Subscription End Date': 'No Yet',
          'ImageUrl': ImageUrl,
        });

        ErrorHandler.showSuccessSnackBar(
          context,
          "Account created successfully as Customer",
        );
      }

      return user;
    } on FirebaseAuthException catch (e) {
      String errorMessage = e.message ?? "Signup failed";

      if (e.code == 'email-already-in-use') {
        try {
          final query = await _firestore
              .collection('Users')
              .where('email', isEqualTo: email.trim())
              .get();

          if (query.docs.isNotEmpty) {
            final role = query.docs.first.data()['role'];
            errorMessage = 'Account already exists as $role. Please login.';
          } else {
            errorMessage =
                'This email is already registered. Please use another.';
          }
        } catch (_) {
          errorMessage = 'This email is already registered. Please login.';
        }
      }

      _showError(context, errorMessage);
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

      ErrorHandler.showSuccessSnackBar(context, "Login Successful");
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
  Future<void> signout(BuildContext context) async {
    try {
      // Clear local profile data before signing out
      try {
        Provider.of<ProfileProvider>(context, listen: false).clearProfile();
      } catch (_) {}

      try {
        Provider.of<PracProfileProvider>(context, listen: false).clearProfile();
      } catch (_) {}

      try {
        Provider.of<PremiumClientProvider>(context, listen: false).clear();
      } catch (_) {}

      try {
        Provider.of<MoodProvider>(context, listen: false).clearMoods();
      } catch (_) {}

      try {
        Provider.of<ActivityProvider>(context, listen: false).clearData();
      } catch (_) {}

      try {
        Provider.of<EditProfileProvider>(context, listen: false).clearData();
      } catch (_) {}

      try {
        Provider.of<SecurityProvider>(context, listen: false).clearData();
      } catch (_) {}

      try {
        Provider.of<QuizListProvider>(context, listen: false).clearQuiz();
      } catch (_) {}

      try {
        Provider.of<QuizProvider>(context, listen: false).clearQuiz();
      } catch (_) {}

      try {
        Provider.of<VideoUploadProvider>(context, listen: false).deleteVideo();
      } catch (_) {}

      await _auth.signOut();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => LoginScreen()),
        (route) => false,
      );
      ErrorHandler.showSuccessSnackBar(context, "Signed out successfully");
    } catch (e) {
      _showError(context, "Error signing out");
    }
  }

  // 🧩 FETCH CUSTOMER DATA
  Future<Map<String, dynamic>?> fetchcustomer(BuildContext context) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return null;

      final snapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid)
          .get();

      if (snapshot.exists && snapshot.data()?['role'] == "customer" ||
          snapshot.data()?['role'] == "Organization Employee") {
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
  Future<void> updateCustomer(
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
        if (updatedData['ImageUrl'] != null)
          'ImageUrl': updatedData['ImageUrl'],
        if (updatedData['username']) 'username': updatedData['username'],

        if (updatedData['email'] != null) 'email': updatedData['email'],
        if (updatedData['role'] != null) 'role': updatedData['role'],
      });

      // ✅ Securely update Firebase Auth email
      if (updatedData['email'] != null &&
          updatedData['email'].toString().isNotEmpty &&
          updatedData['email'] != user.email) {
        await user.verifyBeforeUpdateEmail(updatedData['email']);
      }

      ErrorHandler.showSuccessSnackBar(context, "Profile updated successfully");
    } catch (e) {
      debugPrint("Error updating profile: $e");
      // _showError(context, "Failed to update profile: $e");
    }
  }

  // 🧩 Current user getter
  User? get currentUser => _auth.currentUser;

  // 🧩 Error handling helper
  void _showError(BuildContext context, String message) {
    ErrorHandler.showErrorDialog(context, "Error", message);
  }

  void dispose() {
    // Clean up any resources if needed
  }
  Future<void> reading_completed({required int module_no}) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    try {
      await _firestore.collection('reading').doc(uid).set(
        {
          'uid': uid,
          'module_no $module_no': 'Completed',
          'reading_completed': true,
        },
        SetOptions(merge: true), // safer, doesn't overwrite other fields
      );
      print("Reading status updated!");
    } catch (e) {
      print("Error updating reading status: $e");
    }
  }
}
