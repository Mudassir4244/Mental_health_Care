import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:mental_healthcare/backend/practionar.dart';
import 'package:mental_healthcare/frontend/customer_interface/loginscreen.dart';
import 'package:mental_healthcare/frontend/practioner_interface/prac_homescreen.dart';
import 'package:mental_healthcare/payment_process/stripe_services.dart';
import '../widgets/appcolors.dart'; // adjust path if needed

class PractitionerRegistrationScreen extends StatefulWidget {
  const PractitionerRegistrationScreen({super.key});

  @override
  State<PractitionerRegistrationScreen> createState() =>
      _PractitionerRegistrationScreenState();
}

class _PractitionerRegistrationScreenState
    extends State<PractitionerRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _qualificationController =
      TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isLoading = false; // 🔹 Loading flag

  // Specialties list
  final List<String> specialties = [
    'Clinical Psychologist',
    'Licensed Professional Counselor (LPC)',
    'Licensed Clinical Social Worker (LCSW)',
    'Psychiatrist (MD/DO)',
    'Crisis Intervention Specialist',
    'Certified Peer Specialist',
    'Other Qualified Mental Health Professional',
  ];

  String? _selectedSpecialty;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _qualificationController.dispose();
    _experienceController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = PracAuth();
    final stripe = StripServices();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Practitioner Registration",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        elevation: 2,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Register as Practitioner",
                      style: TextStyle(
                        color: AppColors.sectionTitleColor,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Full Name
                    _buildTextField(
                      controller: _fullNameController,
                      label: "Full Name",
                      icon: Icons.person,
                      validator: (val) =>
                          val!.isEmpty ? "Enter your full name" : null,
                    ),

                    // Email
                    _buildTextField(
                      controller: _emailController,
                      label: "Email",
                      icon: Icons.email,
                      keyboardType: TextInputType.emailAddress,
                      validator: (val) =>
                          val!.isEmpty ? "Enter a valid email" : null,
                    ),

                    // Phone Number
                    _buildTextField(
                      controller: _phoneController,
                      label: "Phone Number",
                      icon: Icons.phone,
                      keyboardType: TextInputType.phone,
                      validator: (val) =>
                          val!.isEmpty ? "Enter your phone number" : null,
                    ),

                    const SizedBox(height: 8),

                    // Specialty Dropdown
                    LayoutBuilder(
                      builder: (context, constraints) {
                        double fieldWidth = constraints.maxWidth;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Select Specialty",
                              style: TextStyle(
                                color: AppColors.textColorPrimary,
                                fontWeight: FontWeight.w600,
                                fontSize: fieldWidth < 350
                                    ? 14
                                    : 16, // Responsive
                              ),
                            ),
                            const SizedBox(height: 6),
                            DropdownButtonFormField<String>(
                              initialValue: _selectedSpecialty,
                              items: specialties.map((specialty) {
                                return DropdownMenuItem(
                                  value: specialty,
                                  child: Text(
                                    specialty,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: AppColors.textColorPrimary,
                                      fontSize: 15,
                                    ),
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedSpecialty = value;
                                });
                              },
                              decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  Icons.psychology,
                                  color: AppColors.accent,
                                ),
                                filled: true,
                                fillColor: AppColors.background,
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: AppColors.primary,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              validator: (value) => value == null
                                  ? "Please select your specialty"
                                  : null,
                              isExpanded: true,
                            ),
                          ],
                        );
                      },
                    ),

                    const SizedBox(height: 16),

                    // Experience
                    _buildTextField(
                      controller: _experienceController,
                      label: "Years of Experience",
                      icon: Icons.timeline,
                      keyboardType: TextInputType.number,
                      validator: (val) =>
                          val!.isEmpty ? "Enter your experience" : null,
                    ),

                    // Password
                    TextFormField(
                      controller: _passwordController,
                      obscureText: !_isPasswordVisible,
                      decoration: InputDecoration(
                        labelText: "Password",
                        prefixIcon: const Icon(
                          Icons.lock,
                          color: AppColors.accent,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: AppColors.accent,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                        filled: true,
                        fillColor: AppColors.background,
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: AppColors.primary,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (val) =>
                          val!.length < 6 ? "Password too short" : null,
                    ),

                    const SizedBox(height: 25),

                    // Register Button
                    // SizedBox(
                    //   width: double.infinity,
                    //   child: ElevatedButton(
                    //     style: ElevatedButton.styleFrom(
                    //       backgroundColor: AppColors.accent,
                    //       foregroundColor: Colors.white,
                    //       padding: const EdgeInsets.symmetric(vertical: 14),
                    //       shape: RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.circular(12),
                    //       ),
                    //     ),
                    //     onPressed: _isLoading
                    //         ? null
                    //         : () async {
                    //             if (!_formKey.currentState!.validate()) return;

                    //             setState(() {
                    //               _isLoading = true;
                    //             });

                    //             try {
                    //               // 1️⃣ First step: Make payment
                    //               await stripe.makepayments(10, "USD");

                    //               // 2️⃣ If payment successful, continue to store data
                    //               await auth.practioner_signup(
                    //                 Fullname: _fullNameController.text,
                    //                 email: _emailController.text,
                    //                 Password: _passwordController.text,
                    //                 Contact_no: _phoneController.text,
                    //                 Speciality: _selectedSpecialty ?? '',
                    //                 Experience: _experienceController.text,
                    //                 context: context,
                    //                 payment_status: 'Completed', ispremium: 'True',
                    //               );

                    //               // 3️⃣ Show success message
                    //               Get.snackbar(
                    //                 "Practitioner",
                    //                 "Signed up successfully as Practitioner",
                    //                 snackPosition: SnackPosition.BOTTOM,
                    //               );

                    //               // 4️⃣ Navigate only after successful signup
                    //               Navigator.pushReplacement(
                    //                 context,
                    //                 MaterialPageRoute(
                    //                   builder: (_) => PracHomescreen(),
                    //                 ),
                    //               );
                    //             } catch (e) {
                    //               // 5️⃣ If payment cancelled or failed, show message
                    //               print("Error: $e");
                    //               ScaffoldMessenger.of(context).showSnackBar(
                    //                 SnackBar(
                    //                   content: Text(
                    //                     e.toString().contains('Canceled')
                    //                         ? 'Payment cancelled by user.'
                    //                         : 'Payment or registration failed: $e',
                    //                   ),
                    //                   backgroundColor: Colors.red,
                    //                 ),
                    //               );
                    //             } finally {
                    //               setState(() {
                    //                 _isLoading = false;
                    //               });
                    //             }
                    //           },

                    //     child: _isLoading
                    //         ? const CircularProgressIndicator(
                    //             color: Colors.white,
                    //           )
                    //         : const Text(
                    //             "Register",
                    //             style: TextStyle(
                    //               fontSize: 16,
                    //               fontWeight: FontWeight.bold,
                    //             ),
                    //           ),
                    //   ),
                    // ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading
                            ? null
                            : () async {
                                // Validate input fields
                                if (_fullNameController.text.isEmpty ||
                                    _emailController.text.isEmpty ||
                                    _passwordController.text.isEmpty ||
                                    _experienceController.text.isEmpty ||
                                    _phoneController.text.isEmpty) {
                                  Get.snackbar(
                                    "Error",
                                    "Please fill all fields",
                                  );
                                  return;
                                }

                                setState(() => _isLoading = true);

                                User? createdUser;

                                try {
                                  // 1️⃣ First, check if email is available
                                  final isAvailable = await auth
                                      .isEmailAvailable(_emailController.text);

                                  if (!isAvailable) {
                                    if (mounted) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
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
                                  createdUser = await auth.create_prac(
                                    Fullname: _fullNameController.text,
                                    email: _emailController.text,
                                    Password: _passwordController.text,
                                    Contact_no: _phoneController.text,
                                    payment_status: "Pending",
                                    Speciality: _selectedSpecialty ?? '',
                                    Experience: _experienceController.text,
                                    context: context,
                                  );
                                  if (createdUser == null) {
                                    if (mounted) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
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
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
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
                                        builder: (_) => PracHomescreen(),
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
                                    "⚠️ Successfully created Practionar. User ID: ${createdUser?.uid}",
                                  );
                                } catch (e) {
                                  // Any other error
                                  debugPrint("❌ Error: $e");
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Failed to create Practionar: $e',
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
                    const SizedBox(height: 20),

                    Center(
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => LoginScreen()),
                          );
                        },
                        child: const Text(
                          "Already have an account? Sign in",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Optional: Overlay loader
          if (_isLoading)
            Container(
              color: Colors.black54,
              child: const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }

  // Reusable textfield builder
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        validator: validator,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: AppColors.accent),
          filled: true,
          fillColor: AppColors.background,
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: AppColors.primary),
            borderRadius: BorderRadius.circular(12),
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
