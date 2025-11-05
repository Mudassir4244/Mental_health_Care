import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mental_healthcare/frontend/organization_interface/oraginzation%20owner/organization_homescreen.dart';
import 'package:mental_healthcare/payment_process/stripe_services.dart';

class OrganAuth {
  final FirebaseAuth _firebaseauth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final stripe = StripServices();
  final user = FirebaseAuth.instance.currentUser;
  bool payment_status = false;

  /// Creates organization owner account and writes a Users document.
  /// Returns the created Firebase [User] on success, otherwise null.
  /// Creates organization owner account with Pending payment status
  Future<User?> create_organization({
    required String orgzanization_name,
    required String organ_admin_email,
    required String password,
    required String role,
    required BuildContext context,
    required String payment_status,
  }) async {
    final FirebaseAuth firebaseauth = FirebaseAuth.instance;
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      // ✅ Create the user directly
      final userCredentials = await firebaseauth.createUserWithEmailAndPassword(
        email: organ_admin_email.trim(),
        password: password.trim(),
      );

      User? organization = userCredentials.user;

      if (organization != null) {
        await firestore.collection("Users").doc(organization.uid).set({
          "Organization Id": organization.uid.trim(),
          "Organization name": orgzanization_name.trim(),
          "Organization owner email": organ_admin_email.trim(),
          "role": "Organization Owner",
          "Payment Status": "Pending", // ✅ Always starts as Pending
          "Created at": FieldValue.serverTimestamp(),
          "Created by": _firebaseauth.currentUser!.uid,
        });
      }

      return organization;
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

  // ta (Map) if exists and role matches, otherwise null.
  Future<Map<String, dynamic>?> fetch_organowner(BuildContext context) async {
    try {
      // final user = _firebaseauth.currentUser;
      if (user == null) return null;

      // First try by document ID (UID)
      final doc = await _firestore.collection('Users').doc(user?.uid).get();

      if (doc.exists) {
        final data = doc.data();
        if (data != null && data['role'] == "Organization Owner") {
          return data;
        }
      }

      // If not found, try by matching the email field
      final query = await _firestore.collection('Users').get();

      if (query.docs.isNotEmpty) {
        final data = query.docs.first.data();
        if (data['role'] == "Organization Owner") {
          return data;
        }
      }

      return null;
    } catch (e, st) {
      debugPrint("Error fetching organization owner: $e");
      debugPrintStack(stackTrace: st);
      return null;
    }
  }

  /// Sign out helper with snackbars on success/failure.

  // placeholder if you need it later
  Future<Map<String, dynamic>?> fetch_organ_employee(
    BuildContext context,
  ) async {
    try {
      final user = _firebaseauth.currentUser;
      if (user == null) {
        print('No user logged in');
        return null;
      }

      final snapshot = await _firestore.collection("Users").doc(user.uid).get();

      if (snapshot.exists) {
        final data = snapshot.data();
        print('Fetched user data: $data');

        // ✅ Fix: compare correctly
        if (data?['role'] == 'Oganization Employee') {
          return data;
        } else {
          print('Role mismatch: ${data?['role']}');
          return null;
        }
      } else {
        print('No user document found for ${user.uid}');
        return null;
      }
    } catch (e, st) {
      print('Error fetching organ: $e\n$st');
      return null;
    }
  }

  Future<User?> add_user({
    required String Username,
    required String Useremail,
    required String Userpassword,
    required BuildContext context,
  }) async {
    final FirebaseAuth firebaseauth = FirebaseAuth.instance;
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      // ✅ Create employee account
      final userCredentials = await firebaseauth.createUserWithEmailAndPassword(
        email: Useremail.trim(),
        password: Userpassword.trim(),
      );

      User? newEmployee = userCredentials.user;

      if (newEmployee != null) {
        // ✅ Get current logged-in organization owner
        final String currentOwnerId = FirebaseAuth.instance.currentUser!.uid;

        await firestore.collection("Users").doc(newEmployee.uid).set({
          "Created by": currentOwnerId, // 🔥 Must match Stream query
          "Username": Username.trim(),
          "Email": Useremail.trim(),
          "Password": Userpassword.trim(),
          "role": "Organization Employee",
          "Payment Status": "Completed",
          "Created at": FieldValue.serverTimestamp(),
        });
      }

      return newEmployee;
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
      debugPrint("Error in add_user: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
      return null;
    }
  }

  // ignore: non_constant_identifier_names
}
