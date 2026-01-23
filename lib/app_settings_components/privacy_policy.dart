// import 'package:flutter/material.dart';
// import 'package:mental_healthcare/frontend/widgets/appcolors.dart';

// class PrivacyPolicyScreen extends StatelessWidget {
//   const PrivacyPolicyScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           icon: const Icon(Icons.arrow_back_ios),
//         ),
//         iconTheme: IconThemeData(color: AppColors.cardColor),
//         title: const Text(
//           "Privacy Policy",
//           style: TextStyle(color: Colors.white),
//         ),
//         centerTitle: true,
//         elevation: 0,
//         flexibleSpace: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [AppColors.primary, AppColors.accent],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//           ),
//         ),
//       ),

//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: ListView(
//           children: const [
//             Text(
//               "MindAssist Privacy Policy",
//               style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//             ),

//             SizedBox(height: 16),

//             Text(
//               "We value your privacy. This Privacy Policy explains how MindAssist collects, "
//               "uses, and protects your personal information when you use our services.",
//               style: TextStyle(fontSize: 16, height: 1.5),
//             ),

//             SizedBox(height: 20),

//             Text(
//               "1. Information We Collect",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 8),
//             Text(
//               "- Name, email, and account information\n"
//               "- App usage data to improve user experience\n"
//               "- Messages exchanged with mental health practitioners (encrypted)",
//               style: TextStyle(fontSize: 16, height: 1.5),
//             ),

//             SizedBox(height: 20),

//             Text(
//               "2. How We Use Your Information",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 8),
//             Text(
//               "- To provide mental health support\n"
//               "- To improve app features and performance\n"
//               "- To ensure user safety and compliance with policies",
//               style: TextStyle(fontSize: 16, height: 1.5),
//             ),

//             SizedBox(height: 20),

//             Text(
//               "3. Data Protection",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 8),
//             Text(
//               "We use modern encryption and security protocols to protect user data. "
//               "Your conversations and personal details are kept confidential and never shared with third parties without your consent.",
//               style: TextStyle(fontSize: 16, height: 1.5),
//             ),

//             SizedBox(height: 20),

//             Text(
//               "4. Your Rights",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 8),
//             Text(
//               "- You can request deletion of your data\n"
//               "- You may update your profile anytime\n"
//               "- You can opt out of data collection features",
//               style: TextStyle(fontSize: 16, height: 1.5),
//             ),

//             SizedBox(height: 20),

//             Text(
//               "5. Contact Us",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 8),
//             Text(
//               "If you have any questions regarding this Privacy Policy, "
//               "you may contact our support team at: support@mindassist.app",
//               style: TextStyle(fontSize: 16, height: 1.5),
//             ),

//             SizedBox(height: 30),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:mental_healthcare/frontend/widgets/appcolors.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mental_healthcare/l10n/app_localizations.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        iconTheme: IconThemeData(color: AppColors.cardColor),
        title: Text(
          loc.privacyPolicyTitle,
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        elevation: 0,
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

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              loc.privacyPolicyHeader,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),

            Text(
              loc.privacyPolicyIntro,
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),

            const SizedBox(height: 20),

            Text(
              loc.informationWeCollect,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              loc.informationDetails,
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),

            const SizedBox(height: 20),

            Text(
              loc.howWeUseInfo,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              loc.howWeUseInfoDetails,
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),

            const SizedBox(height: 20),

            Text(
              loc.dataProtection,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              loc.dataProtectionDetails,
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),

            const SizedBox(height: 20),

            Text(
              loc.yourRights,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              loc.yourRightsDetails,
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),

            const SizedBox(height: 20),

            Text(
              loc.contactUs,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              loc.contactDetails,
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
