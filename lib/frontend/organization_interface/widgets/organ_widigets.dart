// ignore_for_file: dead_code

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mental_healthcare/backend/oraganization.dart';
import 'package:mental_healthcare/app_settings_components/settings.dart';
import 'package:mental_healthcare/frontend/organization_interface/oraginzation%20owner/added_users.dart';
import 'package:mental_healthcare/frontend/organization_interface/oraginzation%20owner/organ_profile.dart';
import 'package:mental_healthcare/frontend/organization_interface/oraginzation%20owner/organization_homescreen.dart';
import 'package:mental_healthcare/frontend/widgets/appcolors.dart';

class WelcomeBanner extends StatelessWidget {
  final String name;
  final String message;

  const WelcomeBanner({super.key, required this.name, required this.message});

  @override
  Widget build(BuildContext context) {
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
            'Hello $name!',
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
//           ontap: () {},
//           imagepath: 'assets/helpnow.png',
//         ),
//         FeatureTile(
//           label: 'CHECK IN',
//           illustration: _buildPlaceholderIllustration(Icons.map_outlined),
//           ontap: () {},
//           imagepath: 'assets/checkin.png',
//         ),
//         FeatureTile(
//           label: 'TRAINING',
//           illustration: _buildPlaceholderIllustration(
//             Icons.psychology_outlined,
//           ),
//           ontap: () {},
//           imagepath: 'assets/training.png',
//         ),
//         FeatureTile(
//           label: 'RESOURCES',
//           illustration: _buildPlaceholderIllustration(Icons.source_outlined),
//           ontap: () {},
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

// --- Navigation Implementation ---

class organ_bottomNavbbar extends StatelessWidget {
  final String currentScreen;
  const organ_bottomNavbbar({super.key, required this.currentScreen});

  // Navigation helper
  void _handleNavigation(BuildContext context, Widget screen) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
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
            label: "Home",
            isSelected: currentScreen == 'Home',
            onTap: () =>
                _handleNavigation(context, const organ_owner_homescreen()),
          ),
          // _NavItem(
          //   icon: Icons.message,
          //   label: "Inbox",
          //   isSelected: currentScreen == 'Inbox',
          //   onTap: () => _handleNavigation(context, const OrganationInbox()),
          // ),
          // _NavItem(
          //   icon: Icons.model_training,
          //   label: "Training",
          //   isSelected: currentScreen == 'Training',
          //   onTap: () =>
          //       _handleNavigation(context, const PractitionarTraining()),
          // ),
          _NavItem(
            icon: Icons.person_outline,
            label: "Profile",
            isSelected: currentScreen == 'Profile',
            onTap: () => _handleNavigation(context, const OrganProfile()),
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
    final Color iconColor = isSelected ? Colors.white : Colors.white70;
    final double iconSize = isSelected ? 30 : 26;
    final FontWeight fontWeight = isSelected
        ? FontWeight.bold
        : FontWeight.normal;

    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(30),
        splashColor: Colors.white24,
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: iconColor, size: iconSize),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: iconColor,
                fontSize: 12,
                fontWeight: fontWeight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Mydrawer extends StatefulWidget {
  const Mydrawer({super.key});

  @override
  State<Mydrawer> createState() => _MydrawerState();
}

class _MydrawerState extends State<Mydrawer> {
  final OrganAuth auth = OrganAuth();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String userName = "Organization";
  String userEmail = "";

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      final doc = await _firestore.collection('Users').doc(user.uid).get();
      if (doc.exists) {
        final data = doc.data()!;
        if (mounted) {
          setState(() {
            userName =
                data['Organization name'] ?? data['username'] ?? "Organization";
            userEmail = data['email'] ?? user.email ?? "";
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: Column(
          children: [
            // Custom Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 40, 20, 30),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primary, AppColors.accent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.3),
                    ),
                    child: CircleAvatar(
                      radius: 35,
                      backgroundColor: Colors.white,
                      child: Text(
                        userName.isNotEmpty ? userName[0].toUpperCase() : "O",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    userName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    userEmail,
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),

            // Menu Items
            Expanded(
              child: Container(
                color: Colors.grey[50],
                child: ListView(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 10,
                  ),
                  children: [
                    _buildDrawerItem(
                      icon: Icons.person_add_alt_1_rounded,
                      title: 'Add User',
                      subtitle: 'Manage organization members',
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => AddedUsers()),
                        );
                      },
                    ),
                    _buildDrawerItem(
                      icon: Icons.settings_rounded,
                      title: 'Settings',
                      subtitle: 'App preferences & account',
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => PractSettings()),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            // Footer / Logout
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Divider(color: Colors.grey[200]),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.logout_rounded,
                        color: Colors.red,
                      ),
                    ),
                    title: const Text(
                      'Logout',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    onTap: () {
                      _showLogoutDialog(context);
                    },
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Version 1.0.0",
                    style: TextStyle(color: Colors.grey[400], fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppColors.primary),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Color(0xff222B45),
          ),
        ),
        subtitle: subtitle != null
            ? Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  subtitle,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              )
            : null,
        trailing: Icon(
          Icons.arrow_forward_ios_rounded,
          size: 16,
          color: Colors.grey[300],
        ),
        onTap: onTap,
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Logout',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                auth.signOut(context);
              },
              child: const Text(
                'Logout',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}
