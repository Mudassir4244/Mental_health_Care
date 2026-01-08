import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:mental_healthcare/frontend/customer_interface/homescreen.dart';

class geustauth{
  Future<void> continueAsGuest() async {
  try {
    // 1. Sign in anonymously
    UserCredential userCredential =
        await FirebaseAuth.instance.signInAnonymously();

    User? user = userCredential.user;

    if (user == null) {
      print("Guest login failed: User is null");
      return;
    }

    // 2. Save Guest Role in Firestore
    await FirebaseFirestore.instance.collection('Users').doc(user.uid).set({
      'userid': user.uid,
      'role': 'Guest',
      'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    print("Guest logged in: ${user.uid}");
    Get.snackbar("Guest Login", "You are logged in as Guest");

    // 3. Navigate to home
    Get.offAll(() => HomeScreen());

  } catch (e) {
    print("Error in guest login: $e");
    Get.snackbar("Error", e.toString());
  }
}

}

