// import 'package:animate_do/animate_do.dart';
// import 'package:flutter/material.dart';
// import 'package:mental_healthcare/frontend/widgets/appcolors.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:mental_healthcare/frontend/customer_interface/guided_voice_coach.dart';

// class HelpNowScreen extends StatelessWidget {
//   const HelpNowScreen({super.key});

//   Future<void> _makePhoneCall(BuildContext context, String phoneNumber) async {
//     // Sanitize phone number (remove dashes, spaces, etc.)
//     final String cleanNumber = phoneNumber.replaceAll(RegExp(r'[^0-9+]'), '');
//     final Uri launchUri = Uri(scheme: 'tel', path: cleanNumber);

//     try {
//       if (!await launchUrl(launchUri, mode: LaunchMode.externalApplication)) {
//         throw 'Could not launch $launchUri';
//       }
//     } catch (e) {
//       if (context.mounted) {
//         showDialog(
//           context: context,
//           builder: (context) => AlertDialog(
//             title: const Text("Call Failed"),
//             content: Text(
//               "Unable to dial $phoneNumber. This device may not support phone calls (e.g., Simulator/iPad).",
//             ),
//             actions: [
//               TextButton(
//                 onPressed: () => Navigator.pop(context),
//                 child: const Text("OK"),
//               ),
//             ],
//           ),
//         );
//       }
//     }
//   }

//   Future<void> _sendSMS(BuildContext context, String phoneNumber) async {
//     final String cleanNumber = phoneNumber.replaceAll(RegExp(r'[^0-9+]'), '');
//     final Uri launchUri = Uri(scheme: 'sms', path: cleanNumber);
//     try {
//       if (!await launchUrl(launchUri, mode: LaunchMode.externalApplication)) {
//         throw 'Could not launch $launchUri';
//       }
//     } catch (e) {
//       if (context.mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Could not open messaging app')),
//         );
//       }
//     }
//   }

//   void _showSuggestionDialog(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) => Padding(
//         padding: EdgeInsets.only(
//           bottom: MediaQuery.of(context).viewInsets.bottom,
//           left: 20,
//           right: 20,
//           top: 20,
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Center(
//               child: Container(
//                 width: 40,
//                 height: 4,
//                 decoration: BoxDecoration(
//                   color: Colors.grey[300],
//                   borderRadius: BorderRadius.circular(2),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//             const Text(
//               "Suggest a Resource",
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black87,
//               ),
//             ),
//             const SizedBox(height: 10),
//             const Text(
//               "Know a helpful hotline, website, or organization? Let us know!",
//               style: TextStyle(fontSize: 14, color: Colors.black54),
//             ),
//             const SizedBox(height: 20),
//             TextField(
//               decoration: InputDecoration(
//                 hintText: "Enter resource details...",
//                 filled: true,
//                 fillColor: Colors.grey[50],
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: BorderSide.none,
//                 ),
//                 contentPadding: const EdgeInsets.all(16),
//               ),
//               maxLines: 4,
//             ),
//             const SizedBox(height: 20),
//             SizedBox(
//               width: double.infinity,
//               height: 50,
//               child: ElevatedButton(
//                 onPressed: () {
//                   Navigator.pop(context);
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(
//                       content: Text(
//                         "Thank you! We will review your suggestion.",
//                       ),
//                       behavior: SnackBarBehavior.floating,
//                       backgroundColor: Colors.green,
//                     ),
//                   );
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: AppColors.primary,
//                   foregroundColor: Colors.white,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   elevation: 0,
//                 ),
//                 child: const Text(
//                   "Submit Suggestion",
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.background,
//       appBar: AppBar(
//         backgroundColor: AppColors.background,
//         elevation: 0,
//         centerTitle: true,
//         title: const Text(
//           "Help & Support",
//           style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
//         ),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios, color: Colors.black54),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Daily Quote Section
//             FadeInDown(
//               child: Container(
//                 width: double.infinity,
//                 padding: const EdgeInsets.all(20),
//                 margin: const EdgeInsets.only(bottom: 25),
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [
//                       Colors.blueAccent.withValues(alpha: 0.1),
//                       Colors.purpleAccent.withValues(alpha: 0.1),
//                     ],
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                   ),
//                   borderRadius: BorderRadius.circular(16),
//                   border: Border.all(
//                     color: Colors.blueAccent.withValues(alpha: 0.2),
//                   ),
//                 ),
//                 child: const Column(
//                   children: [
//                     Icon(
//                       Icons.format_quote_rounded,
//                       size: 30,
//                       color: Colors.blueAccent,
//                     ),
//                     SizedBox(height: 10),
//                     Text(
//                       "\"You don't have to control your thoughts. You just have to stop letting them control you.\"",
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         fontStyle: FontStyle.italic,
//                         fontSize: 16,
//                         color: Colors.black87,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                     SizedBox(height: 10),
//                     Text(
//                       "- Dan Millman",
//                       style: TextStyle(
//                         fontSize: 14,
//                         color: Colors.black54,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),

//             // Emergency Button
//             FadeInUp(
//               delay: const Duration(milliseconds: 200),
//               child: GestureDetector(
//                 onTap: () => _makePhoneCall(context, '911'),
//                 child: Container(
//                   width: double.infinity,
//                   padding: const EdgeInsets.symmetric(vertical: 20),
//                   decoration: BoxDecoration(
//                     gradient: const LinearGradient(
//                       colors: [Color(0xFFFF512F), Color(0xFFDD2476)],
//                       begin: Alignment.topLeft,
//                       end: Alignment.bottomRight,
//                     ),
//                     borderRadius: BorderRadius.circular(16),
//                     boxShadow: [
//                       BoxShadow(
//                         color: const Color(0xFFDD2476).withValues(alpha: 0.4),
//                         blurRadius: 15,
//                         offset: const Offset(0, 8),
//                       ),
//                     ],
//                   ),
//                   child: const Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(Icons.phone_in_talk, color: Colors.white, size: 28),
//                       SizedBox(width: 12),
//                       Text(
//                         "Emergency Call (911)",
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                           letterSpacing: 0.5,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 30),

//             const Text(
//               "Immediate Support",
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black87,
//               ),
//             ),
//             const SizedBox(height: 15),

//             // Support Options
//             FadeInUp(
//               delay: const Duration(milliseconds: 400),
//               child: Column(
//                 children: [
//                   _buildHelpCard(
//                     context,
//                     icon: Icons.support_agent_rounded,
//                     title: "Suicide & Crisis Lifeline",
//                     subtitle: "Call 988 for free, confidential support",
//                     color: Colors.teal,
//                     onTap: () => _makePhoneCall(context, '988'),
//                   ),
//                   const SizedBox(height: 15),
//                   _buildHelpCard(
//                     context,
//                     icon: Icons.phone_callback_rounded,
//                     title: "Local Crisis Line",
//                     subtitle: "Available 24/7 for emotional support",
//                     color: Colors.orange,
//                     onTap: () => _makePhoneCall(context, '1-800-273-8255'),
//                   ),
//                   const SizedBox(height: 15),
//                   _buildHelpCard(
//                     context,
//                     icon: Icons.message_rounded,
//                     title: "Text a Friend",
//                     subtitle: "Reach out to your trusted contacts",
//                     color: Colors.blue,
//                     onTap: () => _sendSMS(context, ''),
//                   ),
//                   const SizedBox(height: 15),
//                   _buildHelpCard(
//                     context,
//                     icon: Icons.self_improvement_rounded,
//                     title: "Guided Voice Coach",
//                     subtitle: "Calming exercises and meditation",
//                     color: Colors.purple,
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (_) => const GuidedVoiceCoachScreen(),
//                         ),
//                       );
//                     },
//                   ),
//                 ],
//               ),
//             ),

//             const SizedBox(height: 30),

//             // Suggestion Button
//             FadeInUp(
//               delay: const Duration(milliseconds: 600),
//               child: Center(
//                 child: TextButton.icon(
//                   onPressed: () => _showSuggestionDialog(context),
//                   icon: const Icon(
//                     Icons.lightbulb_outline,
//                     color: AppColors.primary,
//                   ),
//                   label: const Text(
//                     "Suggest a Resource",
//                     style: TextStyle(
//                       color: AppColors.primary,
//                       fontWeight: FontWeight.w600,
//                       fontSize: 16,
//                     ),
//                   ),
//                   style: TextButton.styleFrom(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 24,
//                       vertical: 12,
//                     ),
//                     backgroundColor: AppColors.primary.withValues(alpha: 0.1),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(30),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildHelpCard(
//     BuildContext context, {
//     required IconData icon,
//     required String title,
//     required String subtitle,
//     required Color color,
//     required VoidCallback onTap,
//   }) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withValues(alpha: 0.08),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           onTap: onTap,
//           borderRadius: BorderRadius.circular(16),
//           child: Padding(
//             padding: const EdgeInsets.all(16),
//             child: Row(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color: color.withValues(alpha: 0.1),
//                     shape: BoxShape.circle,
//                   ),
//                   child: Icon(icon, color: color, size: 28),
//                 ),
//                 const SizedBox(width: 16),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         title,
//                         style: const TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black87,
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         subtitle,
//                         style: TextStyle(fontSize: 13, color: Colors.grey[600]),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Icon(
//                   Icons.arrow_forward_ios_rounded,
//                   color: Colors.grey[400],
//                   size: 16,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:mental_healthcare/frontend/widgets/appcolors.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mental_healthcare/frontend/customer_interface/guided_voice_coach.dart';
import 'package:mental_healthcare/l10n/app_localizations.dart';

class HelpNowScreen extends StatelessWidget {
  const HelpNowScreen({super.key});

  Future<void> _makePhoneCall(BuildContext context, String phoneNumber) async {
    final l10n = AppLocalizations.of(context)!;

    final String cleanNumber = phoneNumber.replaceAll(RegExp(r'[^0-9+]'), '');
    final Uri launchUri = Uri(scheme: 'tel', path: cleanNumber);

    try {
      if (!await launchUrl(launchUri, mode: LaunchMode.externalApplication)) {
        throw 'Could not launch $launchUri';
      }
    } catch (e) {
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(l10n.callFailed),
            content: Text(l10n.callNotSupported(phoneNumber)),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(l10n.ok),
              ),
            ],
          ),
        );
      }
    }
  }

  Future<void> _sendSMS(BuildContext context, String phoneNumber) async {
    final l10n = AppLocalizations.of(context)!;

    final String cleanNumber = phoneNumber.replaceAll(RegExp(r'[^0-9+]'), '');
    final Uri launchUri = Uri(scheme: 'sms', path: cleanNumber);
    try {
      if (!await launchUrl(launchUri, mode: LaunchMode.externalApplication)) {
        throw 'Could not launch $launchUri';
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.couldNotOpenMessaging)));
      }
    }
  }

  void _showSuggestionDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 20,
          right: 20,
          top: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              l10n.suggestResource,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              l10n.suggestResourceDesc,
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                hintText: l10n.enterResourceDetails,
                filled: true,
                fillColor: Colors.grey[50],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.all(16),
              ),
              maxLines: 4,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.thankYouSuggestion),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  l10n.submitSuggestion,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        title: Text(
          l10n.helpAndSupport,
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black54),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Daily Quote Section
            FadeInDown(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.only(bottom: 25),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.blueAccent.withValues(alpha: 0.1),
                      Colors.purpleAccent.withValues(alpha: 0.1),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.blueAccent.withValues(alpha: 0.2),
                  ),
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.format_quote_rounded,
                      size: 30,
                      color: Colors.blueAccent,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      l10n.dailyQuote, // You can also split the actual quote into localization
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 16,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "- Dan Millman",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Emergency Button
            FadeInUp(
              delay: const Duration(milliseconds: 200),
              child: GestureDetector(
                onTap: () => _makePhoneCall(context, '911'),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFF512F), Color(0xFFDD2476)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFDD2476).withValues(alpha: 0.4),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.phone_in_talk,
                        color: Colors.white,
                        size: 28,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        l10n.emergencyCall('911'),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),

            Text(
              l10n.immediateSupport,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 15),

            // Support Options
            FadeInUp(
              delay: const Duration(milliseconds: 400),
              child: Column(
                children: [
                  _buildHelpCard(
                    context,
                    icon: Icons.support_agent_rounded,
                    title: l10n.suicideCrisis,
                    subtitle: l10n.suicideCrisisDesc,
                    color: Colors.teal,
                    onTap: () => _makePhoneCall(context, '988'),
                  ),
                  const SizedBox(height: 15),
                  _buildHelpCard(
                    context,
                    icon: Icons.phone_callback_rounded,
                    title: l10n.localCrisis,
                    subtitle: l10n.localCrisisDesc,
                    color: Colors.orange,
                    onTap: () => _makePhoneCall(context, '1-800-273-8255'),
                  ),
                  const SizedBox(height: 15),
                  _buildHelpCard(
                    context,
                    icon: Icons.message_rounded,
                    title: l10n.textFriend,
                    subtitle: l10n.textFriendDesc,
                    color: Colors.blue,
                    onTap: () => _sendSMS(context, ''),
                  ),
                  const SizedBox(height: 15),
                  _buildHelpCard(
                    context,
                    icon: Icons.self_improvement_rounded,
                    title: l10n.guidedVoiceCoach,
                    subtitle: l10n.guidedVoiceCoachDesc,
                    color: Colors.purple,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const GuidedVoiceCoachScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Suggestion Button
            FadeInUp(
              delay: const Duration(milliseconds: 600),
              child: Center(
                child: TextButton.icon(
                  onPressed: () => _showSuggestionDialog(context),
                  icon: const Icon(
                    Icons.lightbulb_outline,
                    color: AppColors.primary,
                  ),
                  label: Text(
                    l10n.suggestResource,
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildHelpCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.grey[400],
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
