// ignore_for_file: dead_code

import 'package:flutter/material.dart';
import 'package:mental_healthcare/backend/cus_auth.dart';
import 'package:mental_healthcare/frontend/customer_interface/Traningscreen.dart';
import 'package:mental_healthcare/frontend/customer_interface/checkin.dart';
import 'package:mental_healthcare/frontend/customer_interface/checkin_screen.dart';
import 'package:mental_healthcare/frontend/customer_interface/hlepnow.dart';
import 'package:mental_healthcare/frontend/customer_interface/homescreen.dart';
import 'package:mental_healthcare/frontend/chats/inboxscreen.dart';
import 'package:mental_healthcare/frontend/customer_interface/insightscreen.dart';
import 'package:mental_healthcare/frontend/customer_interface/profilescreen.dart';
import 'package:mental_healthcare/frontend/customer_interface/quizscreen.dart';
import 'package:mental_healthcare/frontend/customer_interface/resources_screen.dart';
import 'package:mental_healthcare/frontend/customer_interface/settings.dart';
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

class FeatureGrid extends StatelessWidget {
  const FeatureGrid({super.key});

  Widget _buildPlaceholderIllustration(IconData icon) {
    return Icon(icon, size: 60, color: AppColors.primary.withOpacity(0.7));
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 16.0,
      mainAxisSpacing: 16.0,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        FeatureTile(
          label: 'HELP NOW',
          illustration: _buildPlaceholderIllustration(Icons.handshake_outlined),
          ontap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => HelpNowScreen()),
            );
          },
          imagepath: 'assets/helpnow.png',
        ),
        FeatureTile(
          label: 'CHECK IN',
          illustration: _buildPlaceholderIllustration(Icons.map_outlined),
          ontap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => CheckInScreen()),
            );
          },
          imagepath: 'assets/checkin.png',
        ),
        FeatureTile(
          label: 'TRAINING',
          illustration: _buildPlaceholderIllustration(
            Icons.psychology_outlined,
          ),
          ontap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => TrainingScreen()),
            );
          },
          imagepath: 'assets/training.png',
        ),
        FeatureTile(
          label: 'RESOURCES',
          illustration: _buildPlaceholderIllustration(Icons.source_outlined),
          ontap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ResourcesScreen()),
            );
          },
          imagepath: 'assets/resources.png',
        ),
      ],
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
        color: AppColors.primary,
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
            onTap: () => _handleNavigation(context, const HomeScreen()),
          ),
          _NavItem(
            icon: Icons.message,
            label: "Inbox",
            isSelected: currentScreen == 'Inbox',
            onTap: () => _handleNavigation(context, const InboxScreen()),
          ),
          _NavItem(
            icon: Icons.model_training,
            label: "Training",
            isSelected: currentScreen == 'Training',
            onTap: () => _handleNavigation(context, const TrainingScreen()),
          ),
          _NavItem(
            icon: Icons.person_outline,
            label: "Profile",
            isSelected: currentScreen == 'Profile',
            onTap: () => _handleNavigation(context, Profilescreen()),
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

  _NavItem({
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
  final Authentication auth = Authentication();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: AppColors.primary),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  'Mind Asist',
                  style: TextStyle(
                    color: AppColors.cardColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ),

            // Drawer items
            ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => InsightsScreen()),
                );
              },
              leading: const Icon(Icons.bookmark),
              title: const Text('Insight Screen'),
            ),
            const Divider(),
            ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ActivityScreen()),
                );
              },
              leading: const Icon(Icons.local_activity),
              title: const Text('Activity Screen'),
            ),
            const Divider(),
            ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => QuizScreen()),
                );
              },
              title: const Text('Quiz Screen'),
              leading: const Icon(Icons.quiz),
            ),
            const Divider(),
            ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => PractSettings()),
                );
              },
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
            ),

            // 👇 Pushes logout to bottom
            const Spacer(),

            ListTile(
              onTap: () {
                auth.signOut(context);

                // your logout logic here
              },
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Logout', style: TextStyle(color: Colors.red)),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
