import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> loginUser({
  required String email,
  required String password,
  required Function(String role) onSuccess,
  required Function(String error) onError,
}) async {
  try {
    // 1️⃣ Sign in the user
    UserCredential userCred = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);

    final uid = userCred.user!.uid;

    // 2️⃣ Fetch user role from Firestore
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .get();

    if (!userDoc.exists) {
      onError("User record not found in Firestore!");
      return;
    }

    final role = userDoc['role'];

    // 3️⃣ Pass role to the callback for navigation
    onSuccess(role);
  } on FirebaseAuthException catch (e) {
    onError(e.message ?? "Login failed");
  }
}
