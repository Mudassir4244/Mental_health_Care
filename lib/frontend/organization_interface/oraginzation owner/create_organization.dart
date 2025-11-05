// // ignore_for_file: dead_code, use_key_in_widget_constructors

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:mental_healthcare/backend/organ_auth.dart';
// import 'package:mental_healthcare/frontend/organization_interface/oraginzation%20owner/organization_fee.dart';
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
//   final auth = OrganAuth();
//   final stripe = StripServices();
//   bool _isPasswordVisible = false;

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
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: () async {
//                     // Validate basic input first
//                     if (nameController.text.isEmpty ||
//                         emailController.text.isEmpty ||
//                         passwordController.text.isEmpty) {
//                       Get.snackbar("Error", "Please fill all fields");
//                       return;
//                     }

//                     try {
//                       // 1️⃣ Step 1: Start payment process
//                       await stripe.makepayments(30, "USD");

//                       // 2️⃣ Step 2: Only if payment succeeds, save data
//                       await auth.create_organization(
//                         orgzanization_name: nameController.text,
//                         organ_admin_email: emailController.text,
//                         password: passwordController.text,
//                         context: context,
//                         payment_status: 'Completed',
//                       );

//                       // 3️⃣ Step 3: Show success message
//                       Get.snackbar(
//                         'Organization',
//                         'Organization Created Successfully',
//                         snackPosition: SnackPosition.BOTTOM,
//                       );

//                       // 4️⃣ Step 4: Navigate to Home Screen
//                       Navigator.pushReplacement(
//                         context,
//                         MaterialPageRoute(
//                           builder: (_) => organ_owner_homescreen(),
//                         ),
//                       );
//                     } catch (e) {
//                       // 5️⃣ Step 5: Handle payment cancel or error
//                       print("❌ Error: $e");
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(
//                           content: Text(
//                             e.toString().contains('cancel')
//                                 ? 'Payment cancelled by user.'
//                                 : 'Payment or creation failed: $e',
//                           ),
//                           backgroundColor: Colors.red,
//                         ),
//                       );
//                     }
//                   },

//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: AppColors.primary,
//                     padding: const EdgeInsets.symmetric(vertical: 14),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                   child: const Text(
//                     "Create Organization",
//                     style: TextStyle(
//                       fontSize: 16,
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
// ignore_for_file: dead_code, use_key_in_widget_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:mental_healthcare/backend/oraganization.dart';
import 'package:mental_healthcare/frontend/organization_interface/oraginzation%20owner/organization_homescreen.dart';
import 'package:mental_healthcare/frontend/widgets/appcolors.dart';
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
  bool Payment_Status = false;
  final auth = OrganAuth();
  final stripe = StripServices();

  bool _isPasswordVisible = false;
  bool _isLoading = false; // ✅ added for progress indicator

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: const Text(
          "Create Organization",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 40),
              Icon(
                Icons.add_business_rounded,
                color: AppColors.primary,
                size: 80,
              ),
              const SizedBox(height: 30),
              const Text(
                "Create a new organization",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textColorPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                "Set up your organization to manage your team and resources.",
                style: TextStyle(
                  fontSize: 15,
                  color: AppColors.textColorSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              // 🏢 Organization Name Field
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: "Organization Name",
                  hintText: "e.g. MindAssist Foundation",
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: const Icon(Icons.apartment_rounded),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // 📧 Admin Email
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: "Admin Email",
                  hintText: "e.g. admin@mindassist.org",
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: const Icon(Icons.email_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // 🔒 Password Field (with visibility toggle)
              TextField(
                controller: passwordController,
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                  labelText: "Password",
                  hintText: "******",
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: const Icon(Icons.lock_outline_rounded),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.grey[600],
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // ✅ Create Button
              // ✅ Create Button
              // ✅ Create Button
              // ✅ Create Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () async {
                          // Validate input fields
                          if (nameController.text.isEmpty ||
                              emailController.text.isEmpty ||
                              passwordController.text.isEmpty) {
                            Get.snackbar("Error", "Please fill all fields");
                            return;
                          }

                          setState(() => _isLoading = true);

                          User? createdUser;

                          try {
                            // 1️⃣ First, check if email is available
                            final isAvailable = await auth.isEmailAvailable(
                              emailController.text,
                            );

                            if (!isAvailable) {
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'This email is already registered. Please use another.',
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                              return;
                            }

                            // 2️⃣ Email is available, create organization with Pending status
                            createdUser = await auth.create_organization(
                              orgzanization_name: nameController.text,
                              organ_admin_email: emailController.text,
                              password: passwordController.text,
                              context: context,
                              payment_status: 'Pending',
                              role: 'Organization Owner',
                            );

                            if (createdUser == null) {
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Failed to create organization',
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                              return;
                            }

                            // 3️⃣ Organization created with Pending status, now show payment
                            await stripe.makepayments(30, 'USD');

                            // 4️⃣ Payment succeeded, update status to Completed
                            final paymentUpdated = await auth
                                .updatePaymentStatus(createdUser.uid);

                            if (!paymentUpdated) {
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Payment processed but status update failed. Contact support.',
                                    ),
                                    backgroundColor: Colors.orange,
                                  ),
                                );
                              }
                            }

                            // 5️⃣ Navigate to home
                            if (mounted) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => organ_owner_homescreen(),
                                ),
                              );

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Organization created successfully!',
                                  ),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            }
                          } on StripeException catch (e) {
                            // Payment cancelled or failed
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Payment cancelled: ${e.error.localizedMessage ?? 'Unknown error'}',
                                  ),
                                  backgroundColor: Colors.orange,
                                ),
                              );
                            }

                            // Organization created but payment failed - status remains Pending
                            debugPrint(
                              "⚠️ Organization created with Pending status. User ID: ${createdUser?.uid}",
                            );
                          } catch (e) {
                            // Any other error
                            debugPrint("❌ Error: $e");
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Failed to create organization: $e',
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          } finally {
                            if (mounted) {
                              setState(() => _isLoading = false);
                            }
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : const Text(
                          "Create Organization",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
