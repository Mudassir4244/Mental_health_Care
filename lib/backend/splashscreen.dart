import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mental_healthcare/admin/admin_homescreen.dart';
import 'package:mental_healthcare/backend/practionar.dart';
import 'package:mental_healthcare/frontend/customer_interface/homescreen.dart';
import 'package:mental_healthcare/frontend/customer_interface/loginscreen.dart';
import 'package:mental_healthcare/frontend/customer_interface/splashscreens/onboarding_screen.dart';
import 'package:mental_healthcare/frontend/organization_interface/oraginzation%20owner/organization_homescreen.dart';
import 'package:mental_healthcare/frontend/practioner_interface/prac_homescreen.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();
//     _checkLogin();
//   }

//   Future<void> _checkLogin() async {
//     await Future.delayed(const Duration(seconds: 2)); // Optional splash delay

//     User? user = FirebaseAuth.instance.currentUser;
//     final auth = PracAuth();
//     if (user != null) {
//       // User already logged in — fetch their role
//       final doc = await FirebaseFirestore.instance
//           .collection('Users')
//           .doc(user.uid)
//           .get();
//       await auth.checkAndExpireSubscription();
//       if (doc.exists) {
//         final role = doc['role'];
//         final String normalizedRole = role?.toString().toLowerCase() ?? '';
//         final payementStatus = doc['Payment Status'];

//         if (normalizedRole == 'customer') {
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (_) => const HomeScreen()),
//           );
//         } else if (normalizedRole == 'organization owner' &&
//             payementStatus == 'Completed') {
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (_) => const organ_owner_homescreen()),
//           );
//         } else if (normalizedRole == 'organization employee') {
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (_) => const HomeScreen()),
//           );
//         } else if (normalizedRole == 'practitioner' &&
//             payementStatus == 'Completed') {
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (_) => const PracHomescreen()),

//           );
//         } else if (normalizedRole == 'admin') {
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (_) => const AdminHomescreen()),
//           );
//         } else {
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (_) => const LoginScreen()),
//           );
//         }
//       } else {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (_) => const OnboardingScreen()),
//         );
//       }
//     } else {
//       // User not logged in
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (_) => const OnboardingScreen()),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(body: Center(child: CircularProgressIndicator()));
//   }
// }
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  Future<void> _checkLogin() async {
    await Future.delayed(const Duration(seconds: 2));

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const OnboardingScreen()),
      );
      return;
    }

    try {
      final doc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid)
          .get(const GetOptions(source: Source.server));

      final auth = PracAuth();
      await auth.checkAndExpireSubscription();

      if (!doc.exists) {
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const OnboardingScreen()),
        );
        return;
      }

      final role = doc['role']?.toString().toLowerCase() ?? '';
      final paymentStatus = doc['Payment Status'];

      if (!mounted) return;

      if (role == 'customer') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      } else if (role == 'organization owner' && paymentStatus == 'Completed') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const organ_owner_homescreen()),
        );
      } else if (role == 'organization employee') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      } else if (role == 'practitioner' && paymentStatus == 'Completed') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const PracHomescreen()),
        );
      } else if (role == 'admin') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const AdminHomescreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
    } on FirebaseException catch (e) {
      // 🔑 THIS PREVENTS THE PAUSE
      debugPrint('Firestore error: ${e.code}');

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const OnboardingScreen()),
      );
    } catch (e) {
      debugPrint('Unknown error: $e');

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const OnboardingScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
