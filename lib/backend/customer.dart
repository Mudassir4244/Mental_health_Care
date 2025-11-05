// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:mental_healthcare/frontend/customer_interface/loginscreen.dart';

// class Authentication {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   // 🧩 SIGN UP (Register new user + Assign role)
//   Future<User?> signUp({
//     required String username,
//     required String email,
//     required String password,
//     required BuildContext context,
//   }) async {
//     try {
//       // 🔐 Create user in Firebase Auth
//       UserCredential userCredential = await _auth
//           .createUserWithEmailAndPassword(
//             email: email.trim(),
//             password: password.trim(),
//           );

//       User? user = userCredential.user;

//       if (user != null) {
//         // 🗂️ Save user info + role in Firestore
//         await _firestore.collection('Users').doc(user.uid).set({
//           'uid': user.uid,
//           'email': email.trim(),
//           'username': username,
//           'role': 'customer', // 👈 Assign role here
//           'createdAt': FieldValue.serverTimestamp(),
//         });

//         Get.snackbar("Sign Up!", "Account Created Successfully as Customer");
//       }

//       return user;
//     } on FirebaseAuthException catch (e) {
//       _showError(context, e.message ?? "Signup failed");
//       return null;
//     } catch (e) {
//       _showError(context, e.toString());
//       return null;
//     }
//   }

//   // 🧩 SIGN IN (Login existing user)
//   Future<User?> signIn({
//     required String email,
//     required String password,
//     required BuildContext context,
//   }) async {
//     try {
//       UserCredential userCredential = await _auth.signInWithEmailAndPassword(
//         email: email.trim(),
//         password: password.trim(),
//       );

//       Get.snackbar("Welcome Back!", "Login Successful");
//       return userCredential.user;
//     } on FirebaseAuthException catch (e) {
//       _showError(context, e.message ?? "Sign-in failed");
//       return null;
//     } catch (e) {
//       _showError(context, "Something went wrong");
//       return null;
//     }
//   }

//   // 🧩 SIGN OUT
//   Future<void> signOut(BuildContext context) async {
//     try {
//       await _auth.signOut();
//       Navigator.push(context, MaterialPageRoute(builder: (_) => LoginScreen()));
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text("Signed out successfully"),
//           backgroundColor: Colors.green,
//         ),
//       );
//     } catch (e) {
//       _showError(context, "Error signing out");
//     }
//   }

//   Future<Map<String, dynamic>?> fetchcustomer(BuildContext context) async {
//     try {
//       final user = FirebaseAuth.instance.currentUser;
//       if (user == null) return null;
//       final snapshot = await FirebaseFirestore.instance
//           .collection('Users')
//           .doc(user.uid)
//           .get();
//       if (snapshot.exists && snapshot.data()?['role'] == "customer")
//         return snapshot.data();
//       else {
//         return null;
//       }
//     } catch (e) {
//       _showError(context, "Error while fetching customer");
//     }
//   }

//   // 🧩 Current user getter
//   User? get currentUser => _auth.currentUser;

//   // 🧩 Error handling helper
//   void _showError(BuildContext context, String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(message), backgroundColor: Colors.red),
//     );
//   }
// }
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mental_healthcare/frontend/customer_interface/loginscreen.dart';

class Authentication {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 🧩 SIGN UP (Register new user + Assign role)
  Future<User?> signUp({
    required String username,
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      // 🔐 Create user in Firebase Auth
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(
            email: email.trim(),
            password: password.trim(),
          );

      User? user = userCredential.user;

      if (user != null) {
        // 🗂️ Save user info + role in Firestore
        await _firestore.collection('Users').doc(user.uid).set({
          'uid': user.uid,
          'email': email.trim(),
          'username': username,
          'role': 'customer', // 👈 Assign role here
          'createdAt': FieldValue.serverTimestamp(),
        });

        Get.snackbar("Sign Up!", "Account Created Successfully as Customer");
      }

      return user;
    } on FirebaseAuthException catch (e) {
      _showError(context, e.message ?? "Signup failed");
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

  // 🧩 FETCH CUSTOMER DATA
  Future<Map<String, dynamic>?> fetchcustomer(BuildContext context) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return null;

      final snapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid)
          .get();

      if (snapshot.exists && snapshot.data()?['role'] == "customer") {
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

  // 🧩 Current user getter
  User? get currentUser => _auth.currentUser;

  // 🧩 Error handling helper
  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }
}
