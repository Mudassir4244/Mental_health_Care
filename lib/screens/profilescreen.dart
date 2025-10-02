import 'package:flutter/material.dart';
import 'package:mental_healthcare/screens/homescreen.dart';
import 'package:mental_healthcare/widgets/appcolors.dart';

// --- Color Definitions (Re-added for self-contained file) ---

// --- Screen Implementation (Dashboard Screen) ---



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

// --- Profile Screen (Detailed Implementation based on image) ---
class Profilescreen extends StatelessWidget {
  final String title = 'Profile';
  const Profilescreen({super.key});

  // Helper widget to simulate the striped background pattern from the image
  Widget _buildStripedBackground() {
    return Container(
      color: AppColors.background,
      child: Row(
        // Create repeating vertical stripes
        children: List.generate(
          30, // Create 30 stripes
          (index) => Container(
            width: 5,
            // Alternate between background color and a slightly darker, opaque stripe color
            color: index % 2 == 0
                ? AppColors.background
                : AppColors.stripedColor.withOpacity(0.3),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // 1. Striped Background Layer
          _buildStripedBackground(),

          SafeArea(
            bottom: false, // Prevents bottom padding obscuring the nav bar
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Custom App Bar with back button
                const ProfileAppBar(),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 2. User Profile Card
                        const ProfileCard(
                          name: 'Peter Parker',
                          email: 'peterparker@example.com',
                        ),

                        const SizedBox(height: 24),

                        // 3. Preferences Section
                        const SectionTitle(title: 'Preferences'),
                        const SizedBox(height: 8),
                        const PreferencesCard(),

                        const SizedBox(height: 24),

                        // 4. Subscriptions Section
                        const SectionTitle(title: 'Subscriptions'),
                        const SizedBox(height: 8),
                        const SubscriptionCard(),

                        const SizedBox(
                          height: 100,
                        ), // Padding above the bottom nav bar
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 5. Bottom Navigation Bar
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

class ProfileAppBar extends StatelessWidget {
  const ProfileAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, top: 10.0, bottom: 8.0),
      child: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios,
          color: AppColors.textColorPrimary,
          size: 24,
        ),
        onPressed: () {
          // Navigates back, typically to the HomeScreen if Profile was pushed on top
          // Note: In the BottomNavBar, we use pushReplacement, so a normal back won't work easily here.
          // For simplicity, we'll navigate back to Home.
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        },
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Text(
        title,
        style: const TextStyle(
          color: AppColors.sectionTitleColor,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class ProfileCard extends StatelessWidget {
  final String name;
  final String email;

  const ProfileCard({super.key, required this.name, required this.email});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Placeholder for the Avatar Image
          const CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white,
            // Using a simple person icon for the avatar
            child: Icon(Icons.person, size: 40, color: AppColors.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  email,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          // Edit Icon
          IconButton(
            icon: const Icon(
              Icons.edit_outlined,
              color: Colors.white,
              size: 20,
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

class PreferencesCard extends StatelessWidget {
  const PreferencesCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.cardColor,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        children: [
          _buildPreferenceItem(
            icon: Icons.language_outlined,
            title: 'Language',
            trailingText: 'English',
            isLast: false,
          ),
          _buildPreferenceItem(
            icon: Icons.help_outline,
            title: 'Help & Support',
            isLast: false,
          ),
          _buildPreferenceItem(
            icon: Icons.favorite_border,
            title: 'About App',
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildPreferenceItem({
    required IconData icon,
    required String title,
    String? trailingText,
    required bool isLast,
  }) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: AppColors.primary),
          title: Text(title, style: const TextStyle(fontSize: 16)),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (trailingText != null)
                Text(
                  trailingText,
                  style: const TextStyle(color: AppColors.textColorSecondary),
                ),
              const Icon(
                Icons.chevron_right,
                color: AppColors.textColorSecondary,
              ),
            ],
          ),
          onTap: () {},
        ),
        if (!isLast)
          const Divider(height: 1, indent: 60, color: AppColors.stripedColor),
      ],
    );
  }
}

class SubscriptionCard extends StatelessWidget {
  const SubscriptionCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.cardColor,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.star_outline,
                      color: AppColors.primary,
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Current Tier',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 32.0),
                  child: Text(
                    'Free',
                    style: TextStyle(
                      color: AppColors.textColorSecondary,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),

            // Upgrade Button
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent, // Use accent color
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
              child: const Text(
                'UPGRADE',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ),
          ],
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
            onTap: () => _handleNavigation(
              context,
              const PlaceholderScreen(title: "Bookmarks"),
            ),
          ),
          // Training Icon
          _NavItem(
            icon: Icons.school_outlined,
            isSelected: currentScreen == 'Training',
            onTap: () => _handleNavigation(
              context,
              const PlaceholderScreen(title: "Training"),
            ),
          ),
          // Resources Icon
          _NavItem(
            icon: Icons.layers_outlined,
            isSelected: currentScreen == 'Resources',
            onTap: () => _handleNavigation(
              context,
              const PlaceholderScreen(title: "Resources"),
            ),
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
