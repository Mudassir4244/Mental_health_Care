// // // ignore_for_file: dead_code

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:mental_healthcare/backend/customer.dart';
// import 'package:mental_healthcare/frontend/chats/screens/chat_list_screen.dart';
// import 'package:mental_healthcare/frontend/customer_interface/Traningscreen.dart';
// import 'package:mental_healthcare/frontend/customer_interface/checkin.dart';
// import 'package:mental_healthcare/frontend/customer_interface/Activityscreeen.dart';
// import 'package:mental_healthcare/frontend/customer_interface/helpnow.dart';
// import 'package:mental_healthcare/frontend/customer_interface/homescreen.dart';
// import 'package:mental_healthcare/frontend/customer_interface/insightscreen.dart';
// import 'package:mental_healthcare/frontend/customer_interface/loginscreen.dart';
// import 'package:mental_healthcare/frontend/customer_interface/profilescreen.dart';
// import 'package:mental_healthcare/frontend/customer_interface/quizscreen.dart';
// import 'package:mental_healthcare/resources/resources_screen.dart';
// import 'package:mental_healthcare/app_settings_components/settings.dart';
// import 'package:mental_healthcare/frontend/widgets/appcolors.dart';
// import 'package:provider/provider.dart';

// class WelcomeBanner extends StatelessWidget {
//   final String name;
//   final String message;

//   const WelcomeBanner({super.key, required this.name, required this.message});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
//       padding: const EdgeInsets.all(20.0),
//       width: double.infinity,
//       decoration: BoxDecoration(
//         color: AppColors.primary,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Hello $name!',
//             style: const TextStyle(
//               color: Colors.white,
//               fontSize: 24,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             message,
//             style: TextStyle(
//               color: Colors.white.withOpacity(0.8),
//               fontSize: 16,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class FeatureGrid extends StatelessWidget {
//   const FeatureGrid({super.key});

//   Widget _buildPlaceholderIllustration(IconData icon) {
//     return Icon(icon, size: 60, color: AppColors.primary.withOpacity(0.7));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GridView.count(
//       crossAxisCount: 2,
//       crossAxisSpacing: 16.0,
//       mainAxisSpacing: 16.0,
//       physics: const NeverScrollableScrollPhysics(),
//       children: [
//         FeatureTile(
//           label: 'HELP NOW',
//           illustration: _buildPlaceholderIllustration(Icons.handshake_outlined),
//           ontap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (_) => HelpNowScreen()),
//             );
//           },
//           imagepath: 'assets/helpnow.png',
//         ),
//         FeatureTile(
//           label: 'CHECK IN',
//           illustration: _buildPlaceholderIllustration(Icons.map_outlined),
//           ontap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (_) => CheckInScreen()),
//             );
//           },
//           imagepath: 'assets/checkin.png',
//         ),
//         FeatureTile(
//           label: 'TRAINING',
//           illustration: _buildPlaceholderIllustration(
//             Icons.psychology_outlined,
//           ),
//           ontap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (_) => Traningscreen()),
//             );
//           },
//           imagepath: 'assets/training.png',
//         ),
//         FeatureTile(
//           label: 'TOOLS AND RECOURCES',
//           illustration: _buildPlaceholderIllustration(Icons.source_outlined),
//           ontap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (_) => ResourcesScreen()),
//             );
//           },
//           imagepath: 'assets/resources.png',
//         ),
//       ],
//     );
//   }
// }

// class FeatureTile extends StatelessWidget {
//   final String label;
//   final Widget illustration;
//   final VoidCallback ontap;
//   final String imagepath;
//   const FeatureTile({
//     super.key,
//     required this.label,
//     required this.illustration,
//     required this.ontap,
//     required this.imagepath,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       color: AppColors.cardColor,
//       elevation: 4,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//       child: InkWell(
//         onTap: ontap,
//         borderRadius: BorderRadius.circular(15),
//         child: Padding(
//           padding: const EdgeInsets.all(12.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               Expanded(child: Image.asset(imagepath)),
//               const SizedBox(height: 8),
//               Text(
//                 label,
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   color: AppColors.primary,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 14,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// // --- Navigation Implementation ---

// class BottomNavBar extends StatelessWidget {
//   final String currentScreen;
//   const BottomNavBar({super.key, required this.currentScreen});

//   // Navigation helper
//   void _handleNavigation(BuildContext context, Widget screen) {
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (context) => screen),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.all(12),
//       height: 75,
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [AppColors.primary, AppColors.accent],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),

//         borderRadius: BorderRadius.circular(30),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.15),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: [
//           _NavItem(
//             icon: Icons.home_filled,
//             label: "Home",
//             isSelected: currentScreen == 'Home',
//             onTap: () => _handleNavigation(context, const HomeScreen()),
//           ),
//           _NavItem(
//             icon: Icons.message,
//             label: "Inbox",
//             isSelected: currentScreen == 'Inbox',
//             onTap: () {
//               if (FirebaseAuth.instance.currentUser == null) {
//                 showDialog(
//                   context: context,
//                   builder: (context) => AlertDialog(
//                     title: const Text("Access Restricted"),
//                     content: const Text("You must login to access messages."),
//                     actions: [
//                       TextButton(
//                         onPressed: () => Navigator.pop(context),
//                         child: const Text("Cancel"),
//                       ),
//                       ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: AppColors.primary,
//                         ),
//                         onPressed: () {
//                           Navigator.pop(context); // Close dialog
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (_) => const LoginScreen(),
//                             ),
//                           );
//                         },
//                         child: const Text(
//                           "Login",
//                           style: TextStyle(color: Colors.white),
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//               } else {
//                 _handleNavigation(context, InboxScreen());
//               }
//             },
//           ),
//           _NavItem(
//             icon: Icons.model_training,
//             label: "Training",
//             isSelected: currentScreen == 'Training',
//             onTap: () => _handleNavigation(context, Traningscreen()),
//           ),
//           _NavItem(
//             icon: Icons.person_outline,
//             label: "Profile",
//             isSelected: currentScreen == 'Profile',
//             onTap: () => _handleNavigation(context, Profilescreen()),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _NavItem extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final bool isSelected;
//   final VoidCallback onTap;

//   const _NavItem({
//     required this.icon,
//     required this.label,
//     required this.isSelected,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final Color iconColor = isSelected ? Colors.white : Colors.white70;
//     final double iconSize = isSelected ? 30 : 26;
//     final FontWeight fontWeight = isSelected
//         ? FontWeight.bold
//         : FontWeight.normal;

//     return Expanded(
//       child: InkWell(
//         borderRadius: BorderRadius.circular(30),
//         splashColor: Colors.white24,
//         onTap: onTap,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(icon, color: iconColor, size: iconSize),
//             const SizedBox(height: 4),
//             Text(
//               label,
//               style: TextStyle(
//                 color: iconColor,
//                 fontSize: 12,
//                 fontWeight: fontWeight,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class Mydrawer extends StatefulWidget {
//   const Mydrawer({super.key});

//   @override
//   State<Mydrawer> createState() => _MydrawerState();
// }

// class _MydrawerState extends State<Mydrawer> {
//   final Authentication auth = Authentication();

//   // Helper to get current user - called in build to ensure freshness
//   User? get user => FirebaseAuth.instance.currentUser;

//   void _handleGuestAccess(BuildContext context, VoidCallback onAuthenticated) {
//     if (user == null) {
//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: const Text("Access Restricted"),
//           content: const Text("You must login to access this feature."),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text("Cancel"),
//             ),
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: AppColors.primary,
//               ),
//               onPressed: () {
//                 Navigator.pop(context); // Close dialog
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (_) => const LoginScreen()),
//                 );
//               },
//               child: const Text("Login", style: TextStyle(color: Colors.white)),
//             ),
//           ],
//         ),
//       );
//     } else {
//       onAuthenticated();
//     }
//   }

//   Widget _buildDrawerItem({
//     required IconData icon,
//     required String title,
//     required VoidCallback onTap,
//     Color? iconColor,
//     Color? textColor,
//   }) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//       decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
//       child: ListTile(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//         onTap: onTap,
//         contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
//         leading: Container(
//           padding: const EdgeInsets.all(8),
//           decoration: BoxDecoration(
//             color: (iconColor ?? AppColors.primary).withValues(alpha: 0.1),
//             shape: BoxShape.circle,
//           ),
//           child: Icon(icon, color: iconColor ?? AppColors.primary, size: 22),
//         ),
//         title: Text(
//           title,
//           style: TextStyle(
//             color: textColor ?? Colors.black87,
//             fontSize: 15,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         trailing: Icon(
//           Icons.arrow_forward_ios,
//           size: 14,
//           color: Colors.grey.shade400,
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final User? user = FirebaseAuth.instance.currentUser;
//     final provider = Provider.of<ProfileProvider>(context);
//     final data = provider.profile;
//     final name = data?['username'] ?? user?.displayName ?? "Guest";
//     return Drawer(
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.only(
//           topRight: Radius.circular(20),
//           bottomRight: Radius.circular(20),
//         ),
//       ),
//       child: Column(
//         children: [
//           // Custom Header
//           Container(
//             padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
//             width: double.infinity,
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [AppColors.primary, AppColors.accent],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     Container(
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         border: Border.all(color: Colors.white, width: 2),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black.withValues(alpha: 0.1),
//                             blurRadius: 8,
//                             offset: const Offset(0, 3),
//                           ),
//                         ],
//                       ),
//                       child: CircleAvatar(
//                         radius: 35,
//                         backgroundColor: Colors.white,
//                         backgroundImage: data?['ImageUrl'] != null
//                             ? NetworkImage(data?['ImageUrl'])
//                             : AssetImage('assets/default_profile.png')
//                                   as ImageProvider,
//                         // backgroundImage: data?['ImageUrl'] != null
//                         //     ? NetworkImage(data?['ImageUrl'])
//                         //     : null,
//                         // child: data?['ImageUrl'] == null
//                         //     ? Icon(Icons.person, size: 50, color: AppColors.primary)
//                         //     : user?.photoURL == null
//                         //     ? Text(
//                         //         user?.email?.substring(0, 1).toUpperCase() ?? "G",
//                         //         style: TextStyle(
//                         //           fontSize: 30,
//                         //           fontWeight: FontWeight.bold,
//                         //           color: AppColors.primary,
//                         //         ),
//                         //       )
//                         //     : null,
//                       ),
//                     ),
//                     SizedBox(width: 120),
//                     IconButton(
//                       icon: Icon(Icons.language, color: Colors.white, size: 40),
//                       onPressed: () {},
//                     ),
//                   ],
//                 ),

//                 const SizedBox(height: 15),
//                 Row(
//                   children: [
//                     Text(
//                       '$name',
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     SizedBox(width: 6),
//                     provider.isPremium
//                         ? Icon(Icons.verified, color: Colors.white)
//                         : SizedBox(),
//                   ],
//                 ),
//                 const SizedBox(height: 5),
//                 Text(
//                   user?.email ?? "Sign in to access all features",
//                   style: TextStyle(
//                     color: Colors.white.withValues(alpha: 0.8),
//                     fontSize: 14,
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           const SizedBox(height: 10),

//           // Drawer Items
//           Expanded(
//             child: ListView(
//               padding: EdgeInsets.zero,
//               children: [
//                 _buildDrawerItem(
//                   icon: Icons.bookmark_outline,
//                   title: 'Insights',
//                   onTap: () {
//                     _handleGuestAccess(context, () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (_) => Insightscreen()),
//                       );
//                     });
//                   },
//                 ),
//                 _buildDrawerItem(
//                   icon: Icons.local_activity_outlined,
//                   title: 'Activities',
//                   onTap: () {
//                     _handleGuestAccess(context, () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (_) => FullActivityScreen()),
//                       );
//                     });
//                   },
//                 ),
//                 _buildDrawerItem(
//                   icon: Icons.quiz_outlined,
//                   title: 'Quiz',
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => QuizScreen()),
//                     );
//                   },
//                 ),
//                 // _buildDrawerItem(
//                 //   icon: Icons.admin_panel_settings_outlined,
//                 //   title: 'Admin Panel',
//                 //   onTap: () {
//                 //     Navigator.push(
//                 //       context,
//                 //       MaterialPageRoute(
//                 //         builder: (context) => AdminHomescreen(),
//                 //       ),
//                 //     );
//                 //   },
//                 // ),
//                 // _buildDrawerItem(
//                 //   icon: Icons.quiz_outlined,
//                 //   title: 'Weekly Mood',
//                 //   onTap: () {
//                 //     Navigator.push(
//                 //       context,
//                 //       MaterialPageRoute(
//                 //         builder: (context) => WeeklyMoodFrequencyGraph(),
//                 //       ),
//                 //     );
//                 //   },
//                 // ),
//                 const Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
//                   child: Divider(height: 1),
//                 ),
//                 _buildDrawerItem(
//                   icon: Icons.settings_outlined,
//                   title: 'Settings',
//                   onTap: () {
//                     _handleGuestAccess(context, () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (_) => PractSettings()),
//                       );
//                     });
//                   },
//                 ),
//               ],
//             ),
//           ),

//           // Logout Button
//           Padding(
//             padding: const EdgeInsets.only(bottom: 20, top: 10),
//             child: _buildDrawerItem(
//               icon: Icons.logout_rounded,
//               title: 'Logout',
//               iconColor: Colors.redAccent,
//               textColor: Colors.redAccent,
//               onTap: () {
//                 showDialog(
//                   context: context,
//                   builder: (BuildContext context) {
//                     return AlertDialog(
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(15),
//                       ),
//                       title: const Text(
//                         'Logout',
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                       content: const Text(
//                         'Are you sure you want to logout?',
//                         style: TextStyle(fontSize: 16),
//                       ),
//                       actions: [
//                         TextButton(
//                           onPressed: () => Navigator.pop(context),
//                           child: const Text(
//                             'Cancel',
//                             style: TextStyle(color: Colors.grey),
//                           ),
//                         ),
//                         ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.redAccent,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                           ),
//                           onPressed: () {
//                             auth.signout(context);
//                           },
//                           child: const Text(
//                             'Logout',
//                             style: TextStyle(color: Colors.white),
//                           ),
//                         ),
//                       ],
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
// ignore_for_file: dead_code

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // <-- important
import 'package:mental_healthcare/backend/customer.dart';
import 'package:mental_healthcare/frontend/chats/screens/chat_list_screen.dart';
import 'package:mental_healthcare/frontend/customer_interface/Traningscreen.dart';
import 'package:mental_healthcare/frontend/customer_interface/checkin.dart';
import 'package:mental_healthcare/frontend/customer_interface/Activityscreeen.dart';
import 'package:mental_healthcare/frontend/customer_interface/helpnow.dart';
import 'package:mental_healthcare/frontend/customer_interface/homescreen.dart';
import 'package:mental_healthcare/frontend/customer_interface/insightscreen.dart';
import 'package:mental_healthcare/frontend/customer_interface/loginscreen.dart';
import 'package:mental_healthcare/frontend/customer_interface/profilescreen.dart';
import 'package:mental_healthcare/frontend/customer_interface/quizscreen.dart';
import 'package:mental_healthcare/l10n/app_localizations.dart';
import 'package:mental_healthcare/main.dart';
import 'package:mental_healthcare/resources/resources_screen.dart';
import 'package:mental_healthcare/app_settings_components/settings.dart';
import 'package:mental_healthcare/frontend/widgets/appcolors.dart';
import 'package:provider/provider.dart';

class WelcomeBanner extends StatelessWidget {
  final String name;
  final String message;

  const WelcomeBanner({super.key, required this.name, required this.message});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      padding: const EdgeInsets.all(20.0),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.helloUser(name),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

class FeatureGrid extends StatelessWidget {
  const FeatureGrid({super.key});

  Widget _buildPlaceholderIllustration(IconData icon) {
    return Icon(icon, size: 60, color: AppColors.primary.withOpacity(0.7));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 16.0,
      mainAxisSpacing: 16.0,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        FeatureTile(
          label: l10n.helpNow,
          illustration: _buildPlaceholderIllustration(Icons.handshake_outlined),
          ontap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => HelpNowScreen()),
          ),
          imagepath: 'assets/helpnow.png',
        ),
        FeatureTile(
          label: l10n.checkIn,
          illustration: _buildPlaceholderIllustration(Icons.map_outlined),
          ontap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => CheckInScreen()),
          ),
          imagepath: 'assets/checkin.png',
        ),
        FeatureTile(
          label: l10n.training,
          illustration: _buildPlaceholderIllustration(
            Icons.psychology_outlined,
          ),
          ontap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => Traningscreen()),
          ),
          imagepath: 'assets/training.png',
        ),
        FeatureTile(
          label: l10n.toolsAndResources,
          illustration: _buildPlaceholderIllustration(Icons.source_outlined),
          ontap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => ResourcesScreen()),
          ),
          imagepath: 'assets/resources.png',
        ),
      ],
    );
  }
}

class Mydrawer extends StatefulWidget {
  const Mydrawer({super.key});

  @override
  State<Mydrawer> createState() => _MydrawerState();
}

class _MydrawerState extends State<Mydrawer> {
  final Authentication auth = Authentication();

  User? get user => FirebaseAuth.instance.currentUser;

  void _handleGuestAccess(BuildContext context, VoidCallback onAuthenticated) {
    final l10n = AppLocalizations.of(context)!;
    if (user == null) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(l10n.accessRestricted),
          content: Text(l10n.loginRequiredMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.cancel),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
              ),
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              },
              child: Text(
                l10n.login,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      );
    } else {
      onAuthenticated();
    }
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? iconColor,
    Color? textColor,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        onTap: onTap,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: (iconColor ?? AppColors.primary).withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.person,
            color: iconColor ?? AppColors.primary,
            size: 22,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: textColor ?? Colors.black87,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 14,
          color: Colors.grey.shade400,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final provider = Provider.of<ProfileProvider>(context);
    final data = provider.profile;
    final name = data?['username'] ?? user?.displayName ?? l10n.guest;

    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Custom Header
          Container(
            padding: EdgeInsets.fromLTRB(20, 60, 20, 20),
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.accent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 35,
                        backgroundColor: Colors.white,
                        backgroundImage:
                            (data?['ImageUrl'] != null &&
                                data!['ImageUrl'].toString().isNotEmpty)
                            ? NetworkImage(data['ImageUrl'])
                            : null,
                        child:
                            (data?['ImageUrl'] == null ||
                                data!['ImageUrl'].toString().isEmpty)
                            ? Icon(
                                Icons.person,
                                size: 50,
                                color: AppColors.primary,
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(width: 50),
                    Align(
                      alignment: Alignment.topRight,
                      child: DropdownButton<Locale>(
                        underline: const SizedBox(),
                        icon: Icon(
                          Icons.language,
                          color: AppColors.textColorPrimary,
                          size: 40,
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: Locale('en'),
                            child: Text('English'),
                          ),
                          DropdownMenuItem(
                            value: Locale('es'),
                            child: Text('Español'),
                          ),
                          DropdownMenuItem(
                            value: Locale('de'),
                            child: Text('Deutsch'),
                          ),
                        ],
                        onChanged: (locale) {
                          if (locale != null) {
                            MyApp.setLocale(context, locale);
                            // The screen will automatically rebuild due to the key change
                            setState(() {}); // This triggers rebuild
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 6),
                    provider.isPremium
                        ? const Icon(Icons.verified, color: Colors.white)
                        : const SizedBox(),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  user?.email ?? l10n.signInToAccessAllFeatures,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // Drawer Items
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(
                  icon: Icons.bookmark_outline,
                  title: l10n.insights,
                  onTap: () => _handleGuestAccess(context, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => Insightscreen()),
                    );
                  }),
                ),
                _buildDrawerItem(
                  icon: Icons.local_activity_outlined,
                  title: l10n.activities,
                  onTap: () => _handleGuestAccess(context, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => FullActivityScreen()),
                    );
                  }),
                ),
                _buildDrawerItem(
                  icon: Icons.quiz_outlined,
                  title: l10n.quiz,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => QuizScreen()),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Divider(height: 1),
                ),
                _buildDrawerItem(
                  icon: Icons.settings_outlined,
                  title: l10n.settings,
                  onTap: () => _handleGuestAccess(context, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => PractSettings()),
                    );
                  }),
                ),
              ],
            ),
          ),

          // Logout Button
          Padding(
            padding: const EdgeInsets.only(bottom: 20, top: 10),
            child: _buildDrawerItem(
              icon: Icons.logout_rounded,
              title: l10n.logout,
              iconColor: Colors.redAccent,
              textColor: Colors.redAccent,
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    title: Text(
                      l10n.logout,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    content: Text(
                      l10n.logoutConfirmation,
                      style: const TextStyle(fontSize: 16),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          l10n.cancel,
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () => auth.signout(context),
                        child: Text(
                          l10n.logout,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class FeatureTile extends StatelessWidget {
  final String label;
  final Widget illustration;
  final VoidCallback ontap;
  final String imagepath;

  const FeatureTile({
    super.key,
    required this.label,
    required this.illustration,
    required this.ontap,
    required this.imagepath,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.cardColor,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: ontap,
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(child: Image.asset(imagepath)),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- Navigation Implementation ---

class BottomNavBar extends StatelessWidget {
  final String currentScreen;
  const BottomNavBar({super.key, required this.currentScreen});

  void _handleNavigation(BuildContext context, Widget screen) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      margin: const EdgeInsets.all(12),
      height: 75,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.accent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavItem(
            icon: Icons.home_filled,
            label: l10n.home,
            isSelected: currentScreen == 'Home',
            onTap: () => _handleNavigation(context, const HomeScreen()),
          ),
          _NavItem(
            icon: Icons.message,
            label: l10n.inbox,
            isSelected: currentScreen == 'Inbox',
            onTap: () {
              if (FirebaseAuth.instance.currentUser == null) {
                _showAccessRestrictedDialog(context);
              } else {
                _handleNavigation(context, InboxScreen());
              }
            },
          ),
          _NavItem(
            icon: Icons.model_training,
            label: l10n.training,
            isSelected: currentScreen == 'Training',
            onTap: () => _handleNavigation(context, Traningscreen()),
          ),
          _NavItem(
            icon: Icons.person_outline,
            label: l10n.profile,
            isSelected: currentScreen == 'Profile',
            onTap: () => _handleNavigation(context, Profilescreen()),
          ),
        ],
      ),
    );
  }

  void _showAccessRestrictedDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(l10n.accessRestricted),
        content: Text(l10n.loginRequiredMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
            child: Text(
              l10n.login,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? Colors.white : Colors.white70;

    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(30),
        splashColor: Colors.white24,
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: isSelected ? 30 : 26),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(color: color, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
