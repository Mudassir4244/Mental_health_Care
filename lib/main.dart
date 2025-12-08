import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:mental_healthcare/admin/provider%20Classes/quiz_provider.dart';
import 'package:mental_healthcare/admin/provider%20Classes/video_upload_provider.dart';
import 'package:mental_healthcare/app_settings_components/edit_profile.dart';
import 'package:mental_healthcare/backend/splashscreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mental_healthcare/frontend/customer_interface/Activityscreeen.dart';
import 'package:mental_healthcare/frontend/customer_interface/checkin.dart';
import 'package:mental_healthcare/frontend/customer_interface/profilescreen.dart';
import 'package:mental_healthcare/frontend/customer_interface/quizscreen.dart';
import 'package:mental_healthcare/frontend/organization_interface/oraginzation%20owner/create_credenntials.dart';
import 'package:mental_healthcare/frontend/practioner_interface/prac_homescreen.dart';
import 'package:mental_healthcare/frontend/practioner_interface/prac_profile.dart';
import 'package:mental_healthcare/app_settings_components/security_screen.dart';
import 'package:mental_healthcare/payment_process/stripe_const.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => PracProfileProvider()),
        ChangeNotifierProvider(create: (_) => PremiumClientProvider()),
        ChangeNotifierProvider(create: (_) => LoadingProvider()),
        ChangeNotifierProvider(create: (_) => VideoUploadProvider()),
        ChangeNotifierProvider(create: (_) => QuizProvider()),
        ChangeNotifierProvider(create: (_) => FetchQuizProvider()),
        ChangeNotifierProvider(create: (_) => SecurityProvider()),
        ChangeNotifierProvider(create: (_) => EditProfileProvider()),
        ChangeNotifierProvider(create: (_) => ActivityProvider()),
        ChangeNotifierProvider(create: (_) => MoodProvider()),
        // ChangeNotifierProvider(create: (_) => insightprovider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: SplashScreen());
  }
}
