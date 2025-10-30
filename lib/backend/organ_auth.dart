import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_notifier.dart';

class OrganAuth {
  final _firebaseauth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  Future<User?> create_organization({
    required String orgzanization_name,
    required String organ_admin_email,
    required String password,
    required String payment_status,
    required BuildContext context,
  }) async {
    try {
      UserCredential _usercredentials = await _firebaseauth
          .createUserWithEmailAndPassword(
            email: organ_admin_email.trim(),
            password: password.trim(),
          );
      User? user = _usercredentials.user;
      if (user != null) {
        await _firestore
            .collection("Users")
            .doc(user.uid)
            .set({
              "User id": user.uid.trim(),
              "Oraganization name": orgzanization_name.trim(),
              "Organization owner email": organ_admin_email.trim(),
              "role": "Oragnization Owner",
              "Payment Status": payment_status.trim(),
              "Created at ": FieldValue.serverTimestamp(),
            })
            .then((Value) {
              Get.snackbar("Ognization", "Organization Created Successfull");
            });
      }
      return user;
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Something went wrong try again')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Something went wrong try again')));
    }
  }

  Future<void> signout(BuildContext context) async {
    await _firebaseauth
        .signOut()
        .then((ValueKey) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Sign Out Successfully')));
        })
        .onError((e, StackTrace) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error in Signingout')));
        });
  }

  Future<void> fetchuser() async {}
}
