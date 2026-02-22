// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:fluttertoast/fluttertoast.dart';

// import 'package:mental_healthcare/frontend/customer_interface/profilescreen.dart';
// import 'package:mental_healthcare/frontend/organization_interface/widgets/organ_widigets.dart'
//     hide Mydrawer;

// import 'package:mental_healthcare/frontend/widgets/appcolors.dart';
// import 'package:mental_healthcare/frontend/widgets/widgets.dart';
// import 'package:provider/provider.dart';

// // --- Color Definitions (Re-added for self-contained file) ---

// // --- Screen Implementation (Dashboard Screen) ---

// class HomeScreen extends StatelessWidget {
//   final String title = 'Home';

//   const HomeScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     DateTime? lastPressed;
//     Map<String, dynamic>? profile;
//     final user = FirebaseAuth.instance.currentUser;
//     final provider = Provider.of<ProfileProvider>(context);
//     final data = provider.profile;
//     final name = data?['username'] ?? user?.displayName ?? "Guest";
//     return WillPopScope(
//       onWillPop: () async {
//         final now = DateTime.now();

//         if (lastPressed == null ||
//             now.difference(lastPressed!) > const Duration(seconds: 2)) {
//           // If pressed for the first time OR after 2 seconds
//           lastPressed = now;
//           Fluttertoast.showToast(msg: "Press again to exit ");
//           return false; // Prevent exiting
//         }
//         // If pressed again within 2 seconds
//         SystemNavigator.pop();
//         return false; // Exit app
//       },

//       child: Scaffold(
//         appBar: AppBar(
//           iconTheme: IconThemeData(color: AppColors.cardColor),
//           leading: Builder(
//             builder: (context) => IconButton(
//               onPressed: () {
//                 Scaffold.of(context).openDrawer();
//               },
//               icon: const Icon(Icons.menu),
//             ),
//           ),
//           centerTitle: true,
//           title: const Text(
//             'MindAssist',
//             style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//           ),
//           flexibleSpace: Container(
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [AppColors.primary, AppColors.accent],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//             ),
//           ),
//         ),
//         backgroundColor: AppColors.background,
//         drawer: Mydrawer(), // ✅ Your custom drawer
//         body: Stack(
//           children: [
//             SafeArea(
//               child: Column(
//                 children: [
//                   Container(
//                     margin: const EdgeInsets.symmetric(
//                       horizontal: 16.0,
//                       vertical: 10.0,
//                     ),
//                     padding: const EdgeInsets.all(20.0),
//                     width: double.infinity,
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                         colors: [AppColors.primary, AppColors.accent],
//                         begin: Alignment.topLeft,
//                         end: Alignment.bottomRight,
//                       ),

//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           "Hello  $name \nWellcome Back!",
//                           // "Hello  ${data?['username']} \nWellcome Back!",
//                           // 'Hello Peter!',
//                           // profile != null
//                           //     ? 'Hello ${data?['username']}!'
//                           //     : 'Hello User!',
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontSize: 24,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         Text(
//                           "How are you doing today?",
//                           style: TextStyle(
//                             color: Colors.white.withOpacity(0.8),
//                             fontSize: 16,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   const Expanded(
//                     child: Padding(
//                       padding: EdgeInsets.all(16.0),
//                       child: FeatureGrid(),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Align(
//               alignment: Alignment.bottomCenter,
//               child: BottomNavBar(currentScreen: title),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import 'package:mental_healthcare/frontend/customer_interface/profilescreen.dart';
import 'package:mental_healthcare/frontend/widgets/appcolors.dart';
import 'package:mental_healthcare/frontend/widgets/widgets.dart';
import 'package:mental_healthcare/l10n/app_localizations.dart';

class HomeScreen extends StatelessWidget {
  final String title = 'Home';

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!; // Localization instance
    DateTime? lastPressed;

    final user = FirebaseAuth.instance.currentUser;
    final provider = Provider.of<ProfileProvider>(context);
    final data = provider.profile;
    final name = data?['username'] ?? user?.displayName ?? l10n.guest;

    return WillPopScope(
      onWillPop: () async {
        final now = DateTime.now();
        if (lastPressed == null ||
            now.difference(lastPressed!) > const Duration(seconds: 2)) {
          lastPressed = now;
          Fluttertoast.showToast(msg: l10n.pressAgainToExit);
          return false;
        }
        SystemNavigator.pop();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: AppColors.cardColor),
          leading: Builder(
            builder: (context) => IconButton(
              onPressed: () => Scaffold.of(context).openDrawer(),
              icon: const Icon(Icons.menu),
            ),
          ),
          centerTitle: true,
          title: Text(
            l10n.appName, // "MindAssist"
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.accent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
        ),
        backgroundColor: AppColors.background,
        drawer:  Mydrawer(),
        body: Stack(
          children: [
            SafeArea(
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 10.0,
                    ),
                    padding: const EdgeInsets.all(20.0),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.primary, AppColors.accent],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${l10n.hello} $name!\n${l10n.welcomeBack}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          l10n.howAreYouToday,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: FeatureGrid(),
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: BottomNavBar(currentScreen: title),
            ),
          ],
        ),
      ),
    );
  }
}
