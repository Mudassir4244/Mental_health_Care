// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:mental_healthcare/frontend/widgets/appcolors.dart';

// import 'package:provider/provider.dart';

// /// ------------------------------------------------------------
// /// PROVIDER (ChangeNotifier)
// /// ------------------------------------------------------------
// class SecurityProvider extends ChangeNotifier {
//   final newPasswordController = TextEditingController();
//   final confirmPasswordController = TextEditingController();

//   bool isLoading = false;

//   User? get user => FirebaseAuth.instance.currentUser;

//   /// Change Password
//   Future<void> changePassword(BuildContext context) async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user == null) return;

//     if (newPasswordController.text.length < 6) {
//       _showSnack(
//         context,
//         "Password must be at least 6 characters",
//         AppColors.error,
//       );
//       return;
//     }

//     if (newPasswordController.text != confirmPasswordController.text) {
//       _showSnack(context, "Passwords do not match", AppColors.error);
//       return;
//     }

//     try {
//       isLoading = true;
//       notifyListeners();

//       await user.updatePassword(newPasswordController.text);

//       _showSnack(context, "Password changed successfully", AppColors.success);

//       newPasswordController.clear();
//       confirmPasswordController.clear();
//     } on FirebaseAuthException catch (e) {
//       _showSnack(context, "Error: ${e.message}", AppColors.error);
//     } finally {
//       isLoading = false;
//       notifyListeners();
//     }
//   }

//   /// Send Email Verification
//   Future<void> sendVerificationEmail(BuildContext context) async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user == null) return;
//     try {
//       await user.sendEmailVerification();
//       _showSnack(context, "Verification email sent", AppColors.success);
//     } catch (e) {
//       _showSnack(context, "Failed to send verification email", AppColors.error);
//     }
//   }

//   void clearData() {
//     newPasswordController.clear();
//     confirmPasswordController.clear();
//     isLoading = false;
//     notifyListeners();
//   }

//   /// Helper SnackBar
//   void _showSnack(BuildContext context, String msg, Color color) {
//     ScaffoldMessenger.of(
//       context,
//     ).showSnackBar(SnackBar(content: Text(msg), backgroundColor: color));
//   }

//   @override
//   void dispose() {
//     newPasswordController.dispose();
//     confirmPasswordController.dispose();
//     super.dispose();
//   }
// }

// /// ------------------------------------------------------------
// /// UI SCREEN (SecurityScreen)
// /// ------------------------------------------------------------
// class SecurityScreen extends StatelessWidget {
//   const SecurityScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (_) => SecurityProvider(),
//       child: const _SecurityScreenBody(),
//     );
//   }
// }

// class _SecurityScreenBody extends StatelessWidget {
//   const _SecurityScreenBody();

//   @override
//   Widget build(BuildContext context) {
//     final prov = Provider.of<SecurityProvider>(context);

//     final bool isVerified = prov.user?.emailVerified ?? false;

//     return Scaffold(
//       backgroundColor: AppColors.background,
//       appBar: AppBar(
//         leading: GestureDetector(
//           onTap: () => Navigator.pop(context),
//           child: const Icon(
//             Icons.arrow_back_ios,
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         flexibleSpace: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [AppColors.primary, AppColors.accent],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//           ),
//         ),
//         centerTitle: true,
//         title: const Text(
//           'Security',
//           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//         ),
//         elevation: 0,
//       ),

//       body: LayoutBuilder(
//         builder: (context, constraints) {
//           final maxWidth = constraints.maxWidth;
//           final maxHeight = constraints.maxHeight;

//           return SingleChildScrollView(
//             padding: EdgeInsets.symmetric(
//               horizontal: maxWidth * 0.06,
//               vertical: 22,
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 /// EMAIL CARD
//                 Card(
//                   elevation: 4,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(15),
//                   ),
//                   child: ListTile(
//                     leading: Icon(Icons.email, color: AppColors.primary),
//                     title: Text(
//                       prov.user?.email ?? "Email",
//                       style: const TextStyle(
//                         color: Colors.black,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                     subtitle: Text(
//                       isVerified ? "Verified" : "Not Verified",
//                       style: TextStyle(
//                         color: isVerified ? AppColors.success : AppColors.error,
//                       ),
//                     ),
//                     trailing: isVerified
//                         ? Icon(Icons.verified, color: AppColors.success)
//                         : TextButton(
//                             onPressed: () =>
//                                 prov.sendVerificationEmail(context),
//                             child: Text(
//                               "Verify",
//                               style: TextStyle(
//                                 color: AppColors.primary,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                   ),
//                 ),

//                 SizedBox(height: maxHeight * 0.04),

//                 /// TITLE
//                 Text(
//                   "Change Password",
//                   style: TextStyle(
//                     fontSize: maxWidth * 0.055,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black,
//                   ),
//                 ),

//                 SizedBox(height: maxHeight * 0.02),

//                 /// FIELDS
//                 _buildTextField(
//                   controller: prov.newPasswordController,
//                   label: "New Password",
//                   icon: Icons.lock,
//                   obscureText: true,
//                 ),

//                 SizedBox(height: maxHeight * 0.02),

//                 _buildTextField(
//                   controller: prov.confirmPasswordController,
//                   label: "Confirm Password",
//                   icon: Icons.lock,
//                   obscureText: true,
//                 ),

//                 SizedBox(height: maxHeight * 0.03),

//                 /// BUTTON
//                 prov.isLoading
//                     ? const Center(
//                         child: CircularProgressIndicator(
//                           color: AppColors.primary,
//                         ),
//                       )
//                     : GestureDetector(
//                         onTap: () => prov.changePassword(context),
//                         child: Container(
//                           width: double.infinity,
//                           height: 55,
//                           decoration: BoxDecoration(
//                             gradient: LinearGradient(
//                               colors: [AppColors.primary, AppColors.accent],
//                             ),
//                             borderRadius: BorderRadius.circular(30),
//                           ),
//                           child: Center(
//                             child: Text(
//                               "Change Password",
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: maxWidth * 0.05,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),

//                 SizedBox(height: maxHeight * 0.05),

//                 /// 2FA
//                 Card(
//                   elevation: 4,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(15),
//                   ),
//                   child: ListTile(
//                     leading: Icon(Icons.shield, color: AppColors.primary),
//                     title: const Text(
//                       "Two-Factor Authentication",
//                       style: TextStyle(
//                         color: Colors.black,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                     subtitle: Text(
//                       "Coming soon",
//                       style: TextStyle(color: Colors.black54),
//                     ),
//                     trailing: Icon(Icons.lock, color: Colors.grey.shade600),
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }

//   /// ------------------------------------------------------------
//   /// TEXTFIELD WIDGET
//   /// ------------------------------------------------------------
//   Widget _buildTextField({
//     required TextEditingController controller,
//     required String label,
//     required IconData icon,
//     bool obscureText = false,
//   }) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(15),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 6,
//             offset: const Offset(0, 3),
//           ),
//         ],
//       ),
//       child: TextFormField(
//         controller: controller,
//         obscureText: obscureText,
//         style: const TextStyle(color: Colors.black),
//         decoration: InputDecoration(
//           prefixIcon: Icon(
//             icon,
//             color: controller.text.isNotEmpty ? AppColors.primary : Colors.grey,
//           ),
//           labelText: label,
//           labelStyle: TextStyle(
//             color: controller.text.isNotEmpty ? AppColors.primary : Colors.grey,
//             fontWeight: FontWeight.bold,
//           ),
//           border: InputBorder.none,
//           contentPadding: const EdgeInsets.symmetric(
//             horizontal: 16,
//             vertical: 15,
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mental_healthcare/frontend/widgets/appcolors.dart';
import 'package:mental_healthcare/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// ------------------------------------------------------------
/// PROVIDER (ChangeNotifier)
/// ------------------------------------------------------------
class SecurityProvider extends ChangeNotifier {
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool isLoading = false;

  User? get user => FirebaseAuth.instance.currentUser;

  /// Change Password
  Future<void> changePassword(BuildContext context) async {
    final loc = AppLocalizations.of(context)!;
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    if (newPasswordController.text.length < 6) {
      _showSnack(context, loc.password_min_length, AppColors.error);
      return;
    }

    if (newPasswordController.text != confirmPasswordController.text) {
      _showSnack(context, loc.passwords_do_not_match, AppColors.error);
      return;
    }

    try {
      isLoading = true;
      notifyListeners();

      await user.updatePassword(newPasswordController.text);

      _showSnack(context, loc.password_changed_success, AppColors.success);

      newPasswordController.clear();
      confirmPasswordController.clear();
    } on FirebaseAuthException catch (e) {
      _showSnack(context, "${loc.audio_error}: ${e.message}", AppColors.error);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Send Email Verification
  Future<void> sendVerificationEmail(BuildContext context) async {
    final loc = AppLocalizations.of(context)!;
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      await user.sendEmailVerification();
      _showSnack(context, loc.verification_email_sent, AppColors.success);
    } catch (e) {
      _showSnack(context, loc.verification_email_failed, AppColors.error);
    }
  }

  void clearData() {
    newPasswordController.clear();
    confirmPasswordController.clear();
    isLoading = false;
    notifyListeners();
  }

  /// Helper SnackBar
  void _showSnack(BuildContext context, String msg, Color color) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(msg), backgroundColor: color));
  }

  @override
  void dispose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}

/// ------------------------------------------------------------
/// UI SCREEN (SecurityScreen)
/// ------------------------------------------------------------
class SecurityScreen extends StatelessWidget {
  const SecurityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SecurityProvider(),
      child: const _SecurityScreenBody(),
    );
  }
}

class _SecurityScreenBody extends StatelessWidget {
  const _SecurityScreenBody();

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final prov = Provider.of<SecurityProvider>(context);
    final bool isVerified = prov.user?.emailVerified ?? false;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primary, AppColors.accent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        centerTitle: true,
        title: Text(
          loc.security_title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
      ),

      body: LayoutBuilder(
        builder: (context, constraints) {
          final maxWidth = constraints.maxWidth;
          final maxHeight = constraints.maxHeight;

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: maxWidth * 0.06,
              vertical: 22,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// EMAIL CARD
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    leading: Icon(Icons.email, color: AppColors.primary),
                    title: Text(
                      prov.user?.email ?? "Email",
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      isVerified ? loc.email_verified : loc.email_not_verified,
                      style: TextStyle(
                        color: isVerified ? AppColors.success : AppColors.error,
                      ),
                    ),
                    trailing: isVerified
                        ? Icon(Icons.verified, color: AppColors.success)
                        : TextButton(
                            onPressed: () =>
                                prov.sendVerificationEmail(context),
                            child: Text(
                              loc.verify,
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                  ),
                ),

                SizedBox(height: maxHeight * 0.04),

                /// TITLE
                Text(
                  loc.change_password,
                  style: TextStyle(
                    fontSize: maxWidth * 0.055,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),

                SizedBox(height: maxHeight * 0.02),

                /// FIELDS
                _buildTextField(
                  controller: prov.newPasswordController,
                  label: loc.new_password,
                  icon: Icons.lock,
                  obscureText: true,
                ),

                SizedBox(height: maxHeight * 0.02),

                _buildTextField(
                  controller: prov.confirmPasswordController,
                  label: loc.confirm_password,
                  icon: Icons.lock,
                  obscureText: true,
                ),

                SizedBox(height: maxHeight * 0.03),

                /// BUTTON
                prov.isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      )
                    : GestureDetector(
                        onTap: () => prov.changePassword(context),
                        child: Container(
                          width: double.infinity,
                          height: 55,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [AppColors.primary, AppColors.accent],
                            ),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Center(
                            child: Text(
                              loc.change_password_button,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: maxWidth * 0.05,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),

                SizedBox(height: maxHeight * 0.05),

                /// 2FA
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    leading: Icon(Icons.shield, color: AppColors.primary),
                    title: Text(
                      loc.two_factor_auth,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      loc.coming_soon,
                      style: const TextStyle(color: Colors.black54),
                    ),
                    trailing: Icon(Icons.lock, color: Colors.grey.shade600),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// ------------------------------------------------------------
  /// TEXTFIELD WIDGET (unchanged UI)
  /// ------------------------------------------------------------
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          prefixIcon: Icon(
            icon,
            color: controller.text.isNotEmpty ? AppColors.primary : Colors.grey,
          ),
          labelText: label,
          labelStyle: TextStyle(
            color: controller.text.isNotEmpty ? AppColors.primary : Colors.grey,
            fontWeight: FontWeight.bold,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 15,
          ),
        ),
      ),
    );
  }
}
