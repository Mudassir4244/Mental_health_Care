// ignore_for_file: avoid_types_as_parameter_names

import 'dart:core';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mental_healthcare/frontend/customer_interface/checkin.dart';
import 'package:mental_healthcare/frontend/customer_interface/loginscreen.dart';
import 'package:mental_healthcare/frontend/customer_interface/profilescreen.dart';
import 'package:mental_healthcare/frontend/practioner_interface/prac_homescreen.dart';
import 'package:mental_healthcare/frontend/practioner_interface/prac_profile.dart';
import 'package:provider/provider.dart';
import 'package:mental_healthcare/frontend/customer_interface/Activityscreeen.dart';
import 'package:mental_healthcare/app_settings_components/edit_profile.dart';
import 'package:mental_healthcare/app_settings_components/security_screen.dart';
import 'package:mental_healthcare/frontend/customer_interface/quizscreen.dart';
import 'package:mental_healthcare/admin/provider%20Classes/quiz_provider.dart';
import 'package:mental_healthcare/admin/provider%20Classes/video_upload_provider.dart';

class PracAuth {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> create_prac({
    required String Fullname,
    required String email,
    required String Password,
    required String Contact_no,
    required String payment_status,
    required String Speciality,
    required String Experience,
    required String subs_start_Date,
    required String subs_end_Date,
    required String ImageUrl,
    required BuildContext context,
  }) async {
    final FirebaseAuth firebaseauth = FirebaseAuth.instance;
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final now = DateTime.now();
    final expiryDate = now.add(Duration(days: 30));
    try {
      // ✅ Create the user directly
      final userCredentials = await firebaseauth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: Password.trim(),
      );

      User? user = userCredentials.user;
      await userCredentials.user!.updateDisplayName(Fullname);
      await userCredentials.user!.reload();
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
          'Preferred Payment Method': 'Not Selected',
          'createdAt': FieldValue.serverTimestamp(),
          'Subscription Start Date': 'Not Yet',
          'Subscription End Date': 'No Yet',
          'ImageUrl': ImageUrl,
        });
      }

      return user;
    } on FirebaseAuthException catch (e) {
      String errorMessage;

      if (e.code == 'email-already-in-use') {
        // Try to identify the role of the existing user
        try {
          final query = await firestore
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
          // If we can't query (permission denied), fall back to generic message
          errorMessage = 'This email is already registered. Please login.';
        }
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
        "Subscription Start Date": FieldValue.serverTimestamp(),
        "Subscription End Date": Timestamp.fromDate(
          DateTime.now().add(const Duration(days: 30)),
        ),
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
          .where('email', isEqualTo: email.trim())
          .limit(1)
          .get();

      return querySnapshot.docs.isEmpty;
    } catch (e) {
      debugPrint("Error checking email availability: $e");
      // Return true (available) on error to fail open and let Auth handle it
      return true;
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
        if (updatedData['Phone Number'] != null)
          'Phone Number': updatedData['Phone Number'],
        if (updatedData['Speciality'] != null)
          'Speciality': updatedData['Speciality'],
        if (updatedData['Experience'] != null)
          'Experience': updatedData['Experience'],
        if (updatedData['About'] != null) 'About': updatedData['About'],
        if (updatedData['ImageUrl'] != null)
          'ImageUrl': updatedData['ImageUrl'],
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
      // Clear local profile data before signing out
      // Try to clear both providers just in case
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
        .where('role', isEqualTo: 'Practitioner')
        .get();
  }

  // 🧩 Error handling helper
  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  // Future<void> checkAndExpireSubscription() async {
  //   final user = _auth.currentUser;
  //   if (user == null) return;

  //   final doc = await _firestore.collection('Users').doc(user.uid).get();
  //   if (!doc.exists) return;

  //   final data = doc.data()!;
  //   final Timestamp? endTimestamp = data['Subscription End Date'];
  //   if (endTimestamp == null) return;

  //   final DateTime subscriptionEnd = endTimestamp.toDate();
  //   final DateTime now = DateTime.now();

  //   // ✅ THIS is the only logic needed
  //   if (now.isAfter(subscriptionEnd) && data['Payment Status'] == 'Completed') {
  //     await _firestore.collection('Users').doc(user.uid).update({
  //       'Payment Status': 'Pending',
  //     });
  //   }
  // }
  Future<void> checkAndExpireSubscription() async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      final doc = await _firestore
          .collection('Users')
          .doc(user.uid)
          .get(const GetOptions(source: Source.server));

      if (!doc.exists) return;

      final data = doc.data();
      if (data == null) return;

      final Timestamp? endTimestamp = data['Subscription End Date'];
      if (endTimestamp == null) return;

      final DateTime subscriptionEnd = endTimestamp.toDate();
      final DateTime now = DateTime.now();

      if (now.isAfter(subscriptionEnd) &&
          data['Payment Status'] == 'Completed') {
        await _firestore.collection('Users').doc(user.uid).update({
          'Payment Status': 'Pending',
        });
      }
    } on FirebaseException catch (e) {
      // 🔑 THIS PREVENTS EXECUTION PAUSE
      debugPrint('Subscription check failed: ${e.code} - ${e.message}');

      // Silently ignore — transient error
    } catch (e) {
      debugPrint('Unexpected error: $e');
    }
  }
}
