// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously, unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mental_healthcare/frontend/customer_interface/checkin.dart';
import 'package:mental_healthcare/frontend/customer_interface/loginscreen.dart';
import 'package:mental_healthcare/frontend/customer_interface/profilescreen.dart';
import 'package:mental_healthcare/frontend/practioner_interface/prac_homescreen.dart';
import 'package:mental_healthcare/frontend/practioner_interface/prac_profile.dart';
import 'package:mental_healthcare/payment_process/stripe_services.dart';
import 'package:provider/provider.dart';
import 'package:mental_healthcare/frontend/customer_interface/Activityscreeen.dart';
import 'package:mental_healthcare/admin/provider%20Classes/quiz_provider.dart';
import 'package:mental_healthcare/admin/provider%20Classes/video_upload_provider.dart';
import 'package:mental_healthcare/app_settings_components/edit_profile.dart';
import 'package:mental_healthcare/app_settings_components/security_screen.dart';
import 'package:mental_healthcare/frontend/customer_interface/quizscreen.dart';

class OrganAuth {
  final FirebaseAuth _firebaseauth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final stripe = StripeServices();
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
    final now = DateTime.now();
    final expiryDate = now.add(const Duration(days: 30));
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
          "email": organ_admin_email.trim(),
          "role": "Organization Owner",
          "Payment Status": "Pending", // ✅ Always starts as Pending
          // "Created at": FieldValue.serverTimestamp(),
          "Created by": _firebaseauth.currentUser!.uid,
          'Subscription Start Date': Timestamp.fromDate(now),
          'Subscription End Date': Timestamp.fromDate(expiryDate),
          
        });
      }

      return organization;
    } on FirebaseAuthException catch (e) {
      String errorMessage;

      if (e.code == 'email-already-in-use') {
        try {
          final query = await firestore
              .collection('Users')
              .where('email', isEqualTo: organ_admin_email.trim())
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
          // duration: Duration(seconds: 30),
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

  // ta (Map) if exists and role matches, otherwise null.
  Future<Map<String, dynamic>?> fetch_organowner(BuildContext context) async {
    try {
      // final user = _firebaseauth.currentUser;
      if (user == null) return null;

      // First try by document ID (UID)
      final doc = await _firestore.collection('Users').doc(user?.uid).get();

      if (doc.exists) {
        final data = doc.data();
        if (data != null &&
            data['role']?.toString().toLowerCase() == "organization owner") {
          return data;
        }
      }

      // If not found, try by matching the email field
      final query = await _firestore.collection('Users').get();

      if (query.docs.isNotEmpty) {
        final data = query.docs.first.data();
        if (data['role']?.toString().toLowerCase() == "organization owner") {
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
  Future<void> signOut(BuildContext context) async {
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
        Provider.of<QuizProvider>(context, listen: false).clearQuiz();
      } catch (_) {}

      try {
        Provider.of<VideoUploadProvider>(context, listen: false).deleteVideo();
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

      await _firebaseauth.signOut();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Signed out successfully"),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      debugPrint("Error signing out: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Error signing out"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

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
        if (data?['role']?.toString().toLowerCase() ==
            'organization employee') {
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

  Future<void> add_user({
  required String Username,
  required String Useremail,
  required String Userpassword,
  required BuildContext context,
  required String payment_status,
}) async {
  final FirebaseAuth primaryAuth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  try {
    /// ✅ OWNER MUST BE LOGGED IN
    final currentOwner = primaryAuth.currentUser;
    if (currentOwner == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No organization owner logged in.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    /// 🔥 COUNT EXISTING EMPLOYEES
    final employeeSnapshot = await firestore
        .collection("Users")
        .where("organizationOwnerId", isEqualTo: currentOwner.uid)
        .where("role", isEqualTo: "Organization Employee")
        .get();

    final int employeeCount = employeeSnapshot.docs.length;

    const int freeLimit = 15;

    /// 🚫 BLOCK IF PAYMENT REQUIRED
    if (employeeCount >= freeLimit && payment_status != "Completed") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Free employee limit reached. Please complete payment to add more users.',
          ),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    /// ✅ GET ORGANIZATION NAME
    final ownerDoc =
        await firestore.collection("Users").doc(currentOwner.uid).get();

    String organizationName = "Unknown Organization";
    if (ownerDoc.exists && ownerDoc.data() != null) {
      organizationName =
          ownerDoc.data()!["Organization name"] ?? organizationName;
    }

    /// 🔐 CREATE SECONDARY AUTH INSTANCE
    final secondaryApp = await Firebase.initializeApp(
      name: 'SecondaryApp-${DateTime.now().millisecondsSinceEpoch}',
      options: Firebase.app().options,
    );

    final FirebaseAuth secondaryAuth =
        FirebaseAuth.instanceFor(app: secondaryApp);

    /// 👤 CREATE EMPLOYEE ACCOUNT
    final userCredential = await secondaryAuth.createUserWithEmailAndPassword(
      email: Useremail.trim(),
      password: Userpassword.trim(),
    );

    final newUser = userCredential.user;

    if (newUser != null) {
      await newUser.updateDisplayName(Username.trim());

      /// 💾 SAVE EMPLOYEE DATA
      await firestore.collection("Users").doc(newUser.uid).set({
        "organizationOwnerId": currentOwner.uid,
        "Created by": currentOwner.uid,
        "Organization name": organizationName,
        "username": Username.trim(),
        "email": Useremail.trim(),
        "Password": Userpassword.trim(),
        "role": "Organization Employee",
        "Payment Status": payment_status,
        "isPaidUser": employeeCount >= freeLimit,
        "Created at": FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Employee added successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      
    }

    /// 🧹 CLEANUP SECONDARY SESSION
    await secondaryAuth.signOut();
    await secondaryApp.delete();
  } on FirebaseAuthException catch (e) {
    String errorMessage;

    if (e.code == 'email-already-in-use') {
      errorMessage = 'This email is already registered.';
    } else if (e.code == 'weak-password') {
      errorMessage = 'The password is too weak.';
    } else if (e.code == 'invalid-email') {
      errorMessage = 'Invalid email address.';
    } else {
      errorMessage = e.message ?? 'Authentication error';
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
    );
  } catch (e) {
    debugPrint("Error in add_user: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error: ${e.toString()}'),
        backgroundColor: Colors.red,
      ),
    );
  }
}

  //   Future<void> add_user({
  //   required String Username,
  //   required String Useremail,
  //   required String Userpassword,
  //   required BuildContext context,
  //   required String payment_status,
  // }) async {
  //   final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  //   final FirebaseFirestore firestore = FirebaseFirestore.instance;

  //   // 🔥 Get the fresh updated user
  //   User? user = FirebaseAuth.instance.currentUser;

  //   try {
  //     // ✅ Save the current owner session before creating a new user
  //     final currentOwner = firebaseAuth.currentUser;

  //     if (currentOwner == null) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(
  //           content: Text('No organization owner logged in.'),
  //           backgroundColor: Colors.red,
  //         ),
  //       );
  //       return;
  //     }

  //     // ✅ Get current organization details
  //     final ownerDoc = await firestore
  //         .collection("Users")
  //         .doc(currentOwner.uid)
  //         .get();

  //     String organizationName = "Unknown Organization";

  //     if (ownerDoc.exists && ownerDoc.data() != null) {
  //       organizationName =
  //           ownerDoc.data()!["Organization name"] ?? organizationName;
  //     }

  //     // ✅ Create new user with a secondary FirebaseAuth instance
  //     // final secondaryAuth = FirebaseAuth.instanceFor(
  //     //   app: await Firebase.initializeApp(
  //     //     name: 'SecondaryApp',
  //     //     options: Firebase.app().options,
  //     //   ),
  //     // );

  //     final userCredential = await firebaseAuth.createUserWithEmailAndPassword(
  //       email: Useremail.trim(),
  //       password: Userpassword.trim(),
  //     );
  //     await userCredential.user!.updateDisplayName(Username.trim());
  //     await userCredential.user!.reload();

  //     final loginUser = await firebaseAuth
  //         .signInWithEmailAndPassword(email: Useremail, password: Userpassword)
  //         .then((value) {
  //           Get.snackbar('Login', "  ");
  //         });
  //     final newUser = userCredential.user;

  //     if (newUser != null) {
  //       // ✅ Save employee data in Firestore
  //       await firestore.collection("Users").doc(newUser.uid).set({
  //         "Created by": currentOwner.uid,
  //         "Organization name": organizationName,
  //         "username": Username.trim(),
  //         "email": Useremail.trim(),
  //         "Password": Userpassword.trim(),
  //         "role": "Organization Employee",
  //         "Payment Status": payment_status,
  //         "Created at": FieldValue.serverTimestamp(),
  //       });

  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(
  //           content: Text('User credentials created successfully!'),
  //           backgroundColor: Colors.green,
  //         ),
  //       );
  //     }

  //     // ✅ Important: Sign out secondary instance (not the owner)
  //     // await secondaryAuth.signOut();
  //     // await secondaryAuth.app.delete();
  //   } on FirebaseAuthException catch (e) {
  //     String errorMessage;

  //     if (e.code == 'email-already-in-use') {
  //       errorMessage = 'This email is already registered.';
  //     } else if (e.code == 'weak-password') {
  //       errorMessage = 'The password is too weak.';
  //     } else if (e.code == 'invalid-email') {
  //       errorMessage = 'Invalid email address.';
  //     } else {
  //       errorMessage = 'Error: ${e.message}';
  //     }

  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
  //     );
  //   } catch (e) {
  //     debugPrint("Error in add_user: $e");
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('Error: ${e.toString()}'),
  //         backgroundColor: Colors.red,
  //       ),
  //     );
  //   }
  // }


}
