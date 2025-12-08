// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
// import 'package:get/get.dart';
// import 'package:mental_healthcare/backend/oraganization.dart';
// import 'package:mental_healthcare/frontend/organization_interface/oraginzation%20owner/organization_homescreen.dart';
// import 'package:mental_healthcare/frontend/widgets/appcolors.dart';
// import 'package:mental_healthcare/payment_process/stripe_services.dart';

// class CreateOrganizationScreen extends StatefulWidget {
//   const CreateOrganizationScreen({super.key});

//   @override
//   State<CreateOrganizationScreen> createState() =>
//       _CreateOrganizationScreenState();
// }

// class _CreateOrganizationScreenState extends State<CreateOrganizationScreen> {
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   bool Payment_Status = false;
//   final auth = OrganAuth();
//   final stripe = StripServices();

//   bool _isPasswordVisible = false;
//   bool _isLoading = false; // ✅ added for progress indicator

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.background,
//       appBar: AppBar(
//         iconTheme: const IconThemeData(color: Colors.white),
//         leading: IconButton(
//           onPressed: () => Navigator.pop(context),
//           icon: const Icon(Icons.arrow_back_ios),
//         ),
//         title: const Text(
//           "Create Organization",
//           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//         ),
//         centerTitle: true,
//         backgroundColor: AppColors.primary,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(24.0),
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               const SizedBox(height: 40),
//               Icon(
//                 Icons.add_business_rounded,
//                 color: AppColors.primary,
//                 size: 80,
//               ),
//               const SizedBox(height: 30),
//               const Text(
//                 "Create a new organization",
//                 style: TextStyle(
//                   fontSize: 22,
//                   fontWeight: FontWeight.bold,
//                   color: AppColors.textColorPrimary,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 10),
//               const Text(
//                 "Set up your organization to manage your team and resources.",
//                 style: TextStyle(
//                   fontSize: 15,
//                   color: AppColors.textColorSecondary,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 40),

//               // 🏢 Organization Name Field
//               TextField(
//                 controller: nameController,
//                 decoration: InputDecoration(
//                   labelText: "Organization Name",
//                   hintText: "e.g. MindAssist Foundation",
//                   filled: true,
//                   fillColor: Colors.white,
//                   prefixIcon: const Icon(Icons.apartment_rounded),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20),

//               // 📧 Admin Email
//               TextField(
//                 controller: emailController,
//                 decoration: InputDecoration(
//                   labelText: "Admin Email",
//                   hintText: "e.g. admin@mindassist.org",
//                   filled: true,
//                   fillColor: Colors.white,
//                   prefixIcon: const Icon(Icons.email_outlined),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20),

//               // 🔒 Password Field (with visibility toggle)
//               TextField(
//                 controller: passwordController,
//                 obscureText: !_isPasswordVisible,
//                 decoration: InputDecoration(
//                   labelText: "Password",
//                   hintText: "******",
//                   filled: true,
//                   fillColor: Colors.white,
//                   prefixIcon: const Icon(Icons.lock_outline_rounded),
//                   suffixIcon: IconButton(
//                     icon: Icon(
//                       _isPasswordVisible
//                           ? Icons.visibility
//                           : Icons.visibility_off,
//                       color: Colors.grey[600],
//                     ),
//                     onPressed: () {
//                       setState(() {
//                         _isPasswordVisible = !_isPasswordVisible;
//                       });
//                     },
//                   ),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 30),

//               // ✅ Create Button
//               // ✅ Create Button
//               // ✅ Create Button
//               // ✅ Create Button
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: _isLoading
//                       ? null
//                       : () async {
//                           // Validate input fields
//                           if (nameController.text.isEmpty ||
//                               emailController.text.isEmpty ||
//                               passwordController.text.isEmpty) {
//                             Get.snackbar("Error", "Please fill all fields");
//                             return;
//                           }

//                           setState(() => _isLoading = true);

//                           User? createdUser;

//                           try {
//                             // 1️⃣ First, check if email is available
//                             final isAvailable = await auth.isEmailAvailable(
//                               emailController.text,
//                             );

//                             if (!isAvailable) {
//                               if (mounted) {
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   const SnackBar(
//                                     content: Text(
//                                       'This email is already registered. Please use another.',
//                                     ),
//                                     backgroundColor: Colors.red,
//                                   ),
//                                 );
//                               }
//                               return;
//                             }

//                             // 2️⃣ Email is available, create organization with Pending status
//                             createdUser = await auth.create_organization(
//                               orgzanization_name: nameController.text,
//                               organ_admin_email: emailController.text,
//                               password: passwordController.text,
//                               context: context,
//                               payment_status: 'Pending',
//                               role: 'Organization Owner',
//                             );

//                             if (createdUser == null) {
//                               if (mounted) {
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   const SnackBar(
//                                     content: Text(
//                                       'Failed to create organization',
//                                     ),
//                                     backgroundColor: Colors.red,
//                                   ),
//                                 );
//                               }
//                               return;
//                             }

//                             // 3️⃣ Organization created with Pending status, now show payment
//                             await stripe.makepayments(30, 'USD');

//                             // 4️⃣ Payment succeeded, update status to Completed
//                             final paymentUpdated = await auth
//                                 .updatePaymentStatus(createdUser.uid);

//                             if (!paymentUpdated) {
//                               if (mounted) {
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   const SnackBar(
//                                     content: Text(
//                                       'Payment processed but status update failed. Contact support.',
//                                     ),
//                                     backgroundColor: Colors.orange,
//                                   ),
//                                 );
//                               }
//                             }

//                             // 5️⃣ Navigate to home
//                             if (mounted) {
//                               Navigator.pushReplacement(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (_) => organ_owner_homescreen(),
//                                 ),
//                               );

//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 const SnackBar(
//                                   content: Text(
//                                     'Organization created successfully!',
//                                   ),
//                                   backgroundColor: Colors.green,
//                                 ),
//                               );
//                             }
//                           } on StripeException catch (e) {
//                             // Payment cancelled or failed
//                             if (mounted) {
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 SnackBar(
//                                   content: Text(
//                                     'Payment cancelled: ${e.error.localizedMessage ?? 'Unknown error'}',
//                                   ),
//                                   backgroundColor: Colors.orange,
//                                 ),
//                               );
//                             }

//                             // Organization created but payment failed - status remains Pending
//                             debugPrint(
//                               "⚠️ Organization created with Pending status. User ID: ${createdUser?.uid}",
//                             );
//                           } catch (e) {
//                             // Any other error
//                             debugPrint("❌ Error: $e");
//                             if (mounted) {
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 SnackBar(
//                                   content: Text(
//                                     'Failed to create organization: $e',
//                                   ),
//                                   backgroundColor: Colors.red,
//                                 ),
//                               );
//                             }
//                           } finally {
//                             if (mounted) {
//                               setState(() => _isLoading = false);
//                             }
//                           }
//                         },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: AppColors.primary,
//                     padding: const EdgeInsets.symmetric(vertical: 14),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                   child: _isLoading
//                       ? const SizedBox(
//                           height: 24,
//                           width: 24,
//                           child: CircularProgressIndicator(
//                             color: Colors.white,
//                             strokeWidth: 2.5,
//                           ),
//                         )
//                       : const Text(
//                           "Create Organization",
//                           style: TextStyle(
//                             fontSize: 16,
//                             color: Colors.white,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mental_healthcare/backend/oraganization.dart';
import 'package:mental_healthcare/frontend/organization_interface/oraginzation%20owner/organization_homescreen.dart';
import 'package:mental_healthcare/payment_process/stripe_services.dart';

class CreateOrganizationScreen extends StatefulWidget {
  const CreateOrganizationScreen({super.key});

  @override
  State<CreateOrganizationScreen> createState() =>
      _CreateOrganizationScreenState();
}

class _CreateOrganizationScreenState extends State<CreateOrganizationScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final auth = OrganAuth();
  final stripe = StripServices();

  bool _isPasswordVisible = false;
  bool _isLoading = false;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Gradient background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF6A5AE0), Color(0xFF00C2FF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // Circular highlights
          Positioned(
            top: -120,
            left: -60,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.15),
              ),
            ),
          ),
          Positioned(
            bottom: -150,
            right: -80,
            child: Container(
              width: 380,
              height: 380,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.10),
              ),
            ),
          ),

          // Form container
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(color: Colors.white.withOpacity(0.3)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 15,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Icon
                      Icon(
                        Icons.add_business_rounded,
                        color: Colors.white.withOpacity(0.9),
                        size: 80,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Create a New Organization",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Set up your organization to manage your team and resources.",
                        style: TextStyle(fontSize: 15, color: Colors.white70),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 30),

                      // Organization Name
                      _glassInput(
                        controller: nameController,
                        label: "Organization Name",
                        icon: Icons.apartment_rounded,
                      ),
                      const SizedBox(height: 16),

                      // Admin Email
                      _glassInput(
                        controller: emailController,
                        label: "Admin Email",
                        icon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 16),

                      // Password
                      _glassInput(
                        controller: passwordController,
                        label: "Password",
                        icon: Icons.lock_outline_rounded,
                        isPassword: true,
                        visible: _isPasswordVisible,
                        togglePassword: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                      const SizedBox(height: 25),

                      // Create Button
                      GestureDetector(
                        onTap: _isLoading ? null : _handleCreateOrganization,
                        child: Container(
                          height: 55,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF00C2FF), Color(0xFF6A5AE0)],
                            ),
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.25),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Center(
                            child: _isLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : const Text(
                                    "Create Organization",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _glassInput({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
    VoidCallback? togglePassword,
    bool visible = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: isPassword ? !visible : false,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        prefixIcon: Icon(icon, color: Colors.white),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  visible ? Icons.visibility : Icons.visibility_off,
                  color: Colors.white70,
                ),
                onPressed: togglePassword,
              )
            : null,
        filled: true,
        fillColor: Colors.white.withOpacity(0.15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.6)),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 16,
        ),
      ),
    );
  }

  void _handleCreateOrganization() async {
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty) {
      Get.snackbar("Error", "Please fill all fields");
      return;
    }

    setState(() => _isLoading = true);
    User? createdUser;

    try {
      final isAvailable = await auth.isEmailAvailable(emailController.text);

      if (!isAvailable) {
        if (mounted) {
          Get.snackbar("Error", "Email already registered");
        }
        return;
      }

      createdUser = await auth.create_organization(
        orgzanization_name: nameController.text,
        organ_admin_email: emailController.text,
        password: passwordController.text,
        context: context,
        payment_status: 'Pending',
        role: 'Organization Owner',
      );

      if (createdUser == null) throw "Failed to create organization";
      await stripe.makepayments(30, 'USD');
      await auth.updatePaymentStatus(createdUser.uid);

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => organ_owner_homescreen()),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Organization created successfully!"),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        print(e);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Check your Internet and try again"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}
