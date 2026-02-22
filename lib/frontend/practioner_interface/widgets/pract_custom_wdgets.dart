// ignore_for_file: dead_code

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mental_healthcare/backend/practionar.dart';
import 'package:mental_healthcare/frontend/chats/screens/chat_list_screen.dart';
import 'package:mental_healthcare/frontend/customer_interface/Activityscreeen.dart';
import 'package:mental_healthcare/frontend/customer_interface/checkin.dart';
import 'package:mental_healthcare/frontend/customer_interface/finding_therapist.dart';
import 'package:mental_healthcare/frontend/customer_interface/helpnow.dart';
import 'package:mental_healthcare/frontend/customer_interface/insightscreen.dart';
import 'package:mental_healthcare/frontend/customer_interface/loginscreen.dart';
import 'package:mental_healthcare/app_settings_components/settings.dart';
import 'package:mental_healthcare/frontend/practioner_interface/prac_homescreen.dart';
import 'package:mental_healthcare/frontend/practioner_interface/prac_profile.dart';
import 'package:mental_healthcare/frontend/practioner_interface/practitionar_training.dart';
import 'package:mental_healthcare/frontend/widgets/appcolors.dart';
import 'package:mental_healthcare/l10n/app_localizations.dart';
import 'package:mental_healthcare/main.dart';
import 'package:mental_healthcare/resources/resources_screen.dart';
import 'package:provider/provider.dart';

class WelcomeBanner extends StatelessWidget {
  final String name;
  final String message;
  final String currentuserID;
  const WelcomeBanner({
    super.key,
    required this.name,
    required this.message,
    required this.currentuserID,
  });

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
    final l10n = AppLocalizations.of(context)!;

    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 16.0,
      mainAxisSpacing: 16.0,
      shrinkWrap: true,
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
            MaterialPageRoute(builder: (_) => PractitionarTraining()),
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

class prac_bottomNavbbar extends StatelessWidget {
  final String currentScreen;
  final auth = PracAuth();
  final Map<String, dynamic> clientData;
  prac_bottomNavbbar({
    super.key,
    required this.currentScreen,
    required this.clientData,
  });

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
            onTap: () => _handleNavigation(context, const PracHomescreen()),
          ),
          _NavItem(
            icon: Icons.message,
            label: "Inbox",
            isSelected: currentScreen == 'Inbox',
            onTap: () => _handleNavigation(
              context,
              const InboxScreen(isPractitioner: true),
            ),
          ),
          _NavItem(
            icon: Icons.model_training,
            label: "Training",
            isSelected: currentScreen == 'Training',
            onTap: () =>
                _handleNavigation(context, const PractitionarTraining()),
          ),
          _NavItem(
            icon: Icons.person_outline,
            label: "Profile",
            isSelected: currentScreen == 'Profile',
            onTap: () => _handleNavigation(context, const PracProfile()),
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

class prac_drawer extends StatefulWidget {
  const prac_drawer({super.key});

  @override
  State<prac_drawer> createState() => _PracDrawerState();
}

class _PracDrawerState extends State<prac_drawer> {
  User? get user => FirebaseAuth.instance.currentUser;
  final provider = PracProfileProvider();
  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? iconColor,
    Color? textColor,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: (iconColor ?? AppColors.primary).withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor ?? AppColors.primary, size: 22),
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
    Map<String, dynamic>? profile;
    final provider = Provider.of<PracProfileProvider>(context);
    final data = provider.profile;
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
            padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
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
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 35,
                        backgroundColor: Colors.white,
                        backgroundImage: data?['ImageUrl'] != null
                            ? NetworkImage(data?['ImageUrl'])
                            : null,
                        child: data?['ImageUrl'] == null
                            ? Text(
                                user?.email?.substring(0, 1).toUpperCase() ??
                                    "P",
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              )
                            : null,
                      ),
                    ),
                    SizedBox(width: 40),
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
                Text(
                  data?['username'] ?? user?.displayName ?? "Practitioner",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  user?.email ?? "Welcome back",
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // Drawer items
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(
                  icon: Icons.bookmark_outline,
                  title: AppLocalizations.of(context)!.checkIn,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => CheckInScreen()),
                    );
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.local_activity_outlined,
                  title: AppLocalizations.of(context)!.helpNow,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => HelpNowScreen()),
                    );
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.insights_outlined,
                  title: AppLocalizations.of(context)!.insights,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => Insightscreen()),
                    );
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.calendar_month_outlined,
                  title: AppLocalizations.of(context)!.activities,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => FullActivityScreen()),
                    );
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.person_search_outlined,
                  title: AppLocalizations.of(context)!.otherPractitioner,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => FindingTherapist()),
                    );
                  },
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Divider(height: 1),
                ),
                _buildDrawerItem(
                  icon: Icons.settings_outlined,
                  title: AppLocalizations.of(context)!.settings,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => PractSettings()),
                    );
                  },
                ),
              ],
            ),
          ),

          // Logout Button
          Padding(
            padding: const EdgeInsets.only(bottom: 20, top: 10),
            child: _buildDrawerItem(
              icon: Icons.logout_rounded,
              title: AppLocalizations.of(context)!.logout,
              iconColor: Colors.redAccent,
              textColor: Colors.redAccent,
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      title: const Text(
                        'Logout',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      content: const Text(
                        'Are you sure you want to logout?',
                        style: TextStyle(fontSize: 16),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            PracAuth()
                                .signOut(context)
                                .then((Value) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => LoginScreen(),
                                    ),
                                  );
                                  Get.snackbar(
                                    "Logout",
                                    'Logout Successfully ',
                                    backgroundColor: Colors.white.withValues(
                                      alpha: 0.7,
                                    ),
                                  );
                                })
                                .onError((error, stackTrace) {
                                  Get.snackbar(
                                    "Error in logging out",
                                    error.toString(),
                                    backgroundColor: Colors.white.withValues(
                                      alpha: 0.7,
                                    ),
                                  );
                                });
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
              },
            ),
          ),
        ],
      ),
    );
  }
}
