import 'package:flutter/material.dart';
import 'package:mental_healthcare/practioner_interface/widgets/pract_custom_wdgets.dart';
import 'package:mental_healthcare/widgets/appcolors.dart';

class PractSettings extends StatefulWidget {
  const PractSettings({super.key});

  @override
  State<PractSettings> createState() => _PractSettingsState();
}

class _PractSettingsState extends State<PractSettings> {
  bool _darkMode = false;
  bool _notificationsEnabled = true;
  bool _autoUpdates = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff8f9fb),
      appBar: AppBar(
        title: const Text(
          'Settings ⚙️',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        elevation: 4,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xffe9f5ff), Color(0xfff8f9fb)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16),
          children: [
            // Account Section
            const Text(
              'Account',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xff222B45),
              ),
            ),
            const SizedBox(height: 10),
            _buildSettingTile(
              icon: Icons.person_outline,
              title: 'Edit Profile',
              subtitle: 'Update your personal information',
              onTap: () {},
            ),
            _buildSettingTile(
              icon: Icons.lock_outline,
              title: 'Change Password',
              subtitle: 'Update your account security',
              onTap: () {},
            ),
            _buildSettingTile(
              icon: Icons.credit_card_outlined,
              title: 'Manage Subscription',
              subtitle: 'Upgrade or cancel your plan',
              onTap: () {},
            ),

            const SizedBox(height: 24),

            // Notification Section
            const Text(
              'Notifications',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xff222B45),
              ),
            ),
            const SizedBox(height: 10),
            _buildSwitchTile(
              icon: Icons.notifications_active_outlined,
              title: 'Push Notifications',
              value: _notificationsEnabled,
              onChanged: (val) {
                setState(() => _notificationsEnabled = val);
              },
            ),
            _buildSwitchTile(
              icon: Icons.system_update_alt_rounded,
              title: 'Auto Updates',
              value: _autoUpdates,
              onChanged: (val) {
                setState(() => _autoUpdates = val);
              },
            ),

            const SizedBox(height: 24),

            // App Preferences Section
            const Text(
              'App Preferences',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xff222B45),
              ),
            ),
            const SizedBox(height: 10),
            _buildSwitchTile(
              icon: Icons.dark_mode_outlined,
              title: 'Dark Mode',
              value: _darkMode,
              onChanged: (val) {
                setState(() => _darkMode = val);
              },
            ),
            _buildSettingTile(
              icon: Icons.language_rounded,
              title: 'Language',
              subtitle: 'English (US)',
              onTap: () {},
            ),
            _buildSettingTile(
              icon: Icons.privacy_tip_outlined,
              title: 'Privacy Policy',
              subtitle: 'View app privacy details',
              onTap: () {},
            ),

            const SizedBox(height: 24),

            // Help Section
            const Text(
              'Help & Support',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xff222B45),
              ),
            ),
            const SizedBox(height: 10),
            _buildSettingTile(
              icon: Icons.help_outline_rounded,
              title: 'FAQ',
              subtitle: 'Common questions and answers',
              onTap: () {},
            ),
            _buildSettingTile(
              icon: Icons.support_agent_rounded,
              title: 'Contact Support',
              subtitle: 'Get in touch with our support team',
              onTap: () {},
            ),

            const SizedBox(height: 30),

            // Logout Button
            Center(
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.logout_rounded, color: Colors.white),
                label: const Text(
                  'Log Out',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
      bottomNavigationBar: prac_bottomNavbbar(currentScreen: 'Settings'),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.12),
            blurRadius: 6,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.primary.withOpacity(0.1),
          child: Icon(icon, color: AppColors.primary),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        subtitle: subtitle != null
            ? Text(subtitle, style: TextStyle(color: Colors.grey.shade600))
            : null,
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
        onTap: onTap,
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.12),
            blurRadius: 6,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SwitchListTile(
        activeThumbColor: AppColors.primary,
        secondary: CircleAvatar(
          backgroundColor: AppColors.primary.withOpacity(0.1),
          child: Icon(icon, color: AppColors.primary),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}
