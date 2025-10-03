import 'package:flutter/material.dart';
import 'package:mental_healthcare/screens/Traningscreen.dart';
import 'package:mental_healthcare/screens/checkin_screen.dart';
import 'package:mental_healthcare/screens/profilescreen.dart';
import 'package:mental_healthcare/screens/quizscreen.dart';
import 'package:mental_healthcare/screens/insightscreen.dart';
import 'package:mental_healthcare/widgets/appcolors.dart';

// --- Color Definitions (Re-added for self-contained file) ---

// --- Screen Implementation (Dashboard Screen) ---

class HomeScreen extends StatelessWidget {
  final String title = 'Home';
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // 1. Striped Background Layer
          const _StripedBackground(),

          SafeArea(
            child: Column(
              children: [
                // 2. Welcome Banner (uses AppColors.primary)
                const WelcomeBanner(
                  name: 'Peter',
                  message: 'How are you feeling today?',
                ),

                // 3. Main Grid Buttons (uses AppColors.cardColor for background)
                const Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: FeatureGrid(),
                  ),
                ),
              ],
            ),
          ),

          // 4. Bottom Navigation Bar (positioned at the bottom, passes current screen state)
          Align(
            alignment: Alignment.bottomCenter,
            child: BottomNavBar(currentScreen: title),
          ),
        ],
      ),
    );
  }
}

// --- Placeholder Screen for Navigation Demo ---
class PlaceholderScreen extends StatelessWidget {
  final String title;

  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Text(
          'This is the $title Screen.',
          style: const TextStyle(
            fontSize: 20,
            color: AppColors.textColorPrimary,
          ),
        ),
      ),
      // Placing BottomNavBar here for consistency across navigation
      bottomNavigationBar: BottomNavBar(currentScreen: title),
    );
  }
}

// --- Profile Screen (Re-added for full navigation demo) ---
class ProfileScreen extends StatelessWidget {
  final String title = 'Profile';
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          const _StripedBackground(),
          SafeArea(
            bottom: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Minimal header for the profile screen to save space
                Padding(
                  padding: const EdgeInsets.only(
                    left: 16.0,
                    top: 10.0,
                    bottom: 8.0,
                  ),
                  child: Text(
                    'Settings & Profile',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textColorPrimary,
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      'Profile Content Here',
                      style: TextStyle(color: AppColors.primary, fontSize: 18),
                    ),
                  ),
                ),
                const SizedBox(height: 70),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: BottomNavBar(currentScreen: title),
          ),
        ],
      ),
    );
  }
}

// --- Custom Widgets ---

class _StripedBackground extends StatelessWidget {
  const _StripedBackground();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      child: Row(
        children: List.generate(
          30,
          (index) => Container(
            width: 5,
            color: index % 2 == 0
                ? AppColors.background
                : AppColors.stripedColor.withOpacity(0.3),
          ),
        ),
      ),
    );
  }
}

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
        ),
        FeatureTile(
          label: 'CHECK IN',
          illustration: _buildPlaceholderIllustration(Icons.map_outlined),
        ),
        FeatureTile(
          label: 'TRAINING',
          illustration: _buildPlaceholderIllustration(
            Icons.psychology_outlined,
          ),
        ),
        FeatureTile(
          label: 'RESOURCES',
          illustration: _buildPlaceholderIllustration(Icons.source_outlined),
        ),
      ],
    );
  }
}

class FeatureTile extends StatelessWidget {
  final String label;
  final Widget illustration;

  const FeatureTile({
    super.key,
    required this.label,
    required this.illustration,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.cardColor,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(child: Center(child: illustration)),
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

  // Helper function for navigation logic using pushReplacement
  void _handleNavigation(BuildContext context, Widget screen) {
    // Navigator.pushReplacement is used to prevent the back button from accumulating screens
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: const BoxDecoration(color: AppColors.primary),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Home Icon
          _NavItem(
            icon: Icons.home_filled,
            isSelected: currentScreen == 'Home',
            onTap: () => _handleNavigation(context, const HomeScreen()),
          ),
          // Bookmarks Icon
          _NavItem(
            icon: Icons.bookmark_border,
            isSelected: currentScreen == 'Bookmarks',
            onTap: () => _handleNavigation(context, InsightsScreen()),
          ),
          // Training Icon
          _NavItem(
            icon: Icons.school_outlined,
            isSelected: currentScreen == 'Training',
            onTap: () => _handleNavigation(context, TrainingScreen()),
          ),
          // Resources Icon
          _NavItem(
            icon: Icons.layers_outlined,
            isSelected: currentScreen == 'Resources',
            onTap: () => _handleNavigation(context, QuizScreen()),
          ),
          // Profile Icon
          _NavItem(
            icon: Icons.person_outlined,
            isSelected: currentScreen == 'Profile',
            onTap: () => _handleNavigation(context, const Profilescreen()),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final bool isSelected;
  final VoidCallback? onTap; // This is the function passed from the parent

  const _NavItem({required this.icon, this.isSelected = false, this.onTap});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        icon,
        color: isSelected ? Colors.white : Colors.white.withOpacity(0.7),
        size: 28,
      ),
      onPressed: onTap, // Executes the navigation function when pressed
    );
  }
}
