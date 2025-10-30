import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:mental_healthcare/backend/keeping_logedin.dart';
import 'package:mental_healthcare/frontend/customer_interface/splashscreens/onboarding_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey =
      'pk_test_51RllN7KTVo1cJDmgvXqh3QEusrdLJZgcXVVLXDYHTjiKodvpPKYEL0yr1CjOE5g8BlVMdRtx8xm0rd106mwXRmRb00ipBzUwmP';

  Stripe.instance.applySettings;
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
