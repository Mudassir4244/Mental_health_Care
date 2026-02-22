// import 'package:flutter/material.dart';
// import 'package:mental_healthcare/app_settings_components/contact_support.dart';
// import 'package:mental_healthcare/app_settings_components/edit_profile.dart';
// import 'package:mental_healthcare/app_settings_components/manage_subscription.dart';
// import 'package:mental_healthcare/app_settings_components/privacy_policy.dart';
// import 'package:mental_healthcare/app_settings_components/security_screen.dart';
// import 'package:mental_healthcare/frontend/widgets/appcolors.dart';

// class PractSettings extends StatefulWidget {
//   const PractSettings({super.key});

//   @override
//   State<PractSettings> createState() => _PractSettingsState();
// }

// class _PractSettingsState extends State<PractSettings> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xfff8f9fb),
//       appBar: AppBar(
//         flexibleSpace: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [AppColors.primary, AppColors.accent],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//           ),
//         ),
//         leading: IconButton(
//           onPressed: () => Navigator.pop(context),
//           icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
//         ),
//         title: const Text(
//           'Settings ⚙️',
//           style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
//         ),
//         centerTitle: true,
//         elevation: 4,
//       ),

//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Color(0xffe9f5ff), Color(0xfff8f9fb)],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//         ),
//         child: ListView(
//           physics: const BouncingScrollPhysics(),
//           padding: const EdgeInsets.all(16),
//           children: [
//             // 🔹 ACCOUNT SECTION
//             const Text(
//               'Account',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: Color(0xff222B45),
//               ),
//             ),
//             const SizedBox(height: 10),

//             _buildSettingTile(
//               icon: Icons.person_outline,
//               title: 'Edit Profile',
//               subtitle: 'Update your personal information',
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => const EditProfileScreen(),
//                   ),
//                 );
//               },
//             ),

//             _buildSettingTile(
//               icon: Icons.lock_outline,
//               title: 'Security',
//               subtitle: 'Update your account security',
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => const SecurityScreen(),
//                   ),
//                 );
//               },
//             ),

//             _buildSettingTile(
//               icon: Icons.credit_card_outlined,
//               title: 'Manage Subscription',
//               subtitle: 'Upgrade or cancel your plan',
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => const SubscriptionScreen(),
//                   ),
//                 );
//               },
//             ),

//             const SizedBox(height: 24),

//             // 🔹 PRIVACY SECTION
//             const Text(
//               'Privacy',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: Color(0xff222B45),
//               ),
//             ),
//             const SizedBox(height: 10),

//             _buildSettingTile(
//               icon: Icons.privacy_tip_outlined,
//               title: 'Privacy Policy',
//               subtitle: 'View app privacy details',
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => const PrivacyPolicyScreen(),
//                   ),
//                 );
//               },
//             ),

//             const SizedBox(height: 24),

//             // 🔹 HELP SECTION
//             const Text(
//               'Help & Support',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: Color(0xff222B45),
//               ),
//             ),
//             const SizedBox(height: 10),

//             _buildSettingTile(
//               icon: Icons.help_outline_rounded,
//               title: 'FAQ',
//               subtitle: 'Common questions and answers',
//               onTap: () {},
//             ),

//             _buildSettingTile(
//               icon: Icons.support_agent_rounded,
//               title: 'Contact Support',
//               subtitle: 'Get in touch with our support team',
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => const ContactSupportScreen(),
//                   ),
//                 );
//               },
//             ),

//             const SizedBox(height: 30),

//             const SizedBox(height: 30),
//           ],
//         ),
//       ),
//     );
//   }

//   // ----------------------
//   // 🔧 Setting Tile Widget
//   // ----------------------
//   Widget _buildSettingTile({
//     required IconData icon,
//     required String title,
//     String? subtitle,
//     required VoidCallback onTap,
//   }) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 10),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(14),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.12),
//             blurRadius: 6,
//             spreadRadius: 1,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: ListTile(
//         leading: CircleAvatar(
//           backgroundColor: AppColors.primary.withOpacity(0.1),
//           child: Icon(icon, color: AppColors.primary),
//         ),
//         title: Text(
//           title,
//           style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
//         ),
//         subtitle: subtitle != null
//             ? Text(subtitle, style: TextStyle(color: Colors.grey.shade600))
//             : null,
//         trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
//         onTap: onTap,
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:mental_healthcare/app_settings_components/contact_support.dart';
import 'package:mental_healthcare/app_settings_components/manage_subscription.dart';
import 'package:mental_healthcare/app_settings_components/privacy_policy.dart';
import 'package:mental_healthcare/app_settings_components/security_screen.dart';
import 'package:mental_healthcare/frontend/widgets/appcolors.dart';
import 'package:mental_healthcare/l10n/app_localizations.dart';

class PractSettings extends StatefulWidget {
  const PractSettings({super.key});

  @override
  State<PractSettings> createState() => _PractSettingsState();
}

class _PractSettingsState extends State<PractSettings> {
  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xfff8f9fb),
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primary, AppColors.accent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
        title: Text(
          loc.settings_title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
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
            // 🔹 ACCOUNT SECTION
            Text(
              loc.settings_account,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xff222B45),
              ),
            ),
            const SizedBox(height: 10),

            // _buildSettingTile(
            //   icon: Icons.person_outline,
            //   title: loc.settings_edit_profile,
            //   subtitle: loc.settings_edit_profile_sub,
            //   onTap: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) => const EditProfileScreen(),
            //       ),
            //     );
            //   },
            // ),
            _buildSettingTile(
              icon: Icons.lock_outline,
              title: loc.settings_security,
              subtitle: loc.settings_security_sub,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SecurityScreen(),
                  ),
                );
              },
            ),

            _buildSettingTile(
              icon: Icons.credit_card_outlined,
              title: loc.settings_manage_subscription,
              subtitle: loc.settings_manage_subscription_sub,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SubscriptionScreen(),
                  ),
                );
              },
            ),

            const SizedBox(height: 24),

            // 🔹 PRIVACY SECTION
            Text(
              loc.settings_privacy,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xff222B45),
              ),
            ),
            const SizedBox(height: 10),

            _buildSettingTile(
              icon: Icons.privacy_tip_outlined,
              title: loc.settings_privacy_policy,
              subtitle: loc.settings_privacy_policy_sub,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PrivacyPolicyScreen(),
                  ),
                );
              },
            ),

            const SizedBox(height: 24),

            // 🔹 HELP SECTION
            Text(
              loc.settings_help_support,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xff222B45),
              ),
            ),
            const SizedBox(height: 10),

            _buildSettingTile(
              icon: Icons.help_outline_rounded,
              title: loc.settings_faq,
              subtitle: loc.settings_faq_sub,
              onTap: () {},
            ),

            _buildSettingTile(
              icon: Icons.support_agent_rounded,
              title: loc.settings_contact_support,
              subtitle: loc.settings_contact_support_sub,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ContactSupportScreen(),
                  ),
                );
              },
            ),

            const SizedBox(height: 30),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // ----------------------
  // 🔧 Setting Tile Widget (UNCHANGED)
  // ----------------------
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
}
