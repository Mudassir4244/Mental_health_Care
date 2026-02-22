import 'package:flutter/material.dart';

class AdminSettingsScreen extends StatefulWidget {
  const AdminSettingsScreen({super.key});

  @override
  State<AdminSettingsScreen> createState() => _AdminSettingsScreenState();
}

class _AdminSettingsScreenState extends State<AdminSettingsScreen> {
  // Toggle states
  bool darkMode = false;
  bool pushNotifications = true;
  bool emailNotifications = true;
  bool autoCompressUploads = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff4f7fb),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            // const Text(
            //   "Settings",
            //   style: TextStyle(
            //     fontSize: 28,
            //     fontWeight: FontWeight.bold,
            //     letterSpacing: 0.5,
            //   ),
            // ),
            const SizedBox(height: 20),

            // -------- PROFILE --------
            _buildSettingsCard(
              title: "Profile",
              icon: Icons.person,
              color1: const Color(0xff6a11cb),
              color2: const Color(0xff2575fc),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.edit),
                    title: const Text("Edit Profile"),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: const Icon(Icons.lock),
                    title: const Text("Change Password"),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: const Icon(Icons.logout),
                    title: const Text("Logout"),
                    onTap: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // -------- APP CONFIG --------
            _buildSettingsCard(
              title: "App Configuration",
              icon: Icons.settings,
              color1: const Color(0xff11998e),
              color2: const Color(0xff38ef7d),
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text("Dark Mode"),
                    value: darkMode,
                    onChanged: (val) => setState(() => darkMode = val),
                  ),
                  SwitchListTile(
                    title: const Text("Auto-Compress Uploads"),
                    value: autoCompressUploads,
                    onChanged: (val) =>
                        setState(() => autoCompressUploads = val),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // -------- NOTIFICATIONS --------
            _buildSettingsCard(
              title: "Notifications",
              icon: Icons.notifications,
              color1: const Color(0xffee0979),
              color2: const Color(0xffff6a00),
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text("Push Notifications"),
                    value: pushNotifications,
                    onChanged: (val) => setState(() => pushNotifications = val),
                  ),
                  SwitchListTile(
                    title: const Text("Email Notifications"),
                    value: emailNotifications,
                    onChanged: (val) =>
                        setState(() => emailNotifications = val),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // -------- USER MANAGEMENT --------
            _buildSettingsCard(
              title: "User Management",
              icon: Icons.group,
              color1: const Color(0xfff7971e),
              color2: const Color(0xffffd200),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.admin_panel_settings),
                    title: const Text("Roles & Permissions"),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: const Icon(Icons.person_add),
                    title: const Text("Default User Settings"),
                    onTap: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // -------- DATA & REPORTS --------
            _buildSettingsCard(
              title: "Data & Reports",
              icon: Icons.insert_chart_outlined,
              color1: const Color(0xfffc4a1a),
              color2: const Color(0xfff7b733),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.download),
                    title: const Text("Export Reports"),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: const Icon(Icons.backup),
                    title: const Text("Database Backup"),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: const Icon(Icons.history),
                    title: const Text("Activity Logs"),
                    onTap: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // -------- SUPPORT / ABOUT --------
            _buildSettingsCard(
              title: "Support & About",
              icon: Icons.help_outline,
              color1: const Color(0xff36d1dc),
              color2: const Color(0xff5b86e5),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.support_agent),
                    title: const Text("Contact Support"),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: const Icon(Icons.info_outline),
                    title: const Text("App Info"),
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ********** REUSABLE GRADIENT CARD **********
  Widget _buildSettingsCard({
    required String title,
    required IconData icon,
    required Color color1,
    required Color color2,
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color1.withOpacity(0.85), color2.withOpacity(0.85)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: color1.withOpacity(0.3),
            blurRadius: 12,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ExpansionTile(
        iconColor: Colors.white,
        collapsedIconColor: Colors.white,
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.white.withOpacity(0.22),
              child: Icon(icon, color: Colors.white),
            ),
            const SizedBox(width: 15),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        children: [child],
      ),
    );
  }
}
