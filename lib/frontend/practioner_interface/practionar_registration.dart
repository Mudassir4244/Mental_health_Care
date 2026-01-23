import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mental_healthcare/backend/practionar.dart';
import 'package:mental_healthcare/cloudinary/cloudinary_service.dart';
import 'package:mental_healthcare/frontend/customer_interface/choice_screen.dart';
import 'package:mental_healthcare/frontend/customer_interface/loginscreen.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:mental_healthcare/frontend/widgets/error_handler.dart';
import 'package:mental_healthcare/frontend/practioner_interface/practitioner_onboarding.dart';

class PractitionerRegistrationScreen extends StatefulWidget {
  const PractitionerRegistrationScreen({super.key});

  @override
  State<PractitionerRegistrationScreen> createState() =>
      _PractitionerRegistrationScreenState();
}

class _PractitionerRegistrationScreenState
    extends State<PractitionerRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isLoading = false;

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

  File? _profileImage;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _experienceController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _pickProfileImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _profileImage = File(picked.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = PracAuth();

    return WillPopScope(
      onWillPop: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ChoiceScreen()),
        );
        return Future.value(false);
      },
      child: Scaffold(
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
                padding: const EdgeInsets.all(14),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: Container(
                    padding: const EdgeInsets.all(14),
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
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          // Profile picture
                          GestureDetector(
                            onTap: _pickProfileImage,
                            child: CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.white24,
                              backgroundImage: _profileImage != null
                                  ? FileImage(_profileImage!)
                                  : null,
                              child: _profileImage == null
                                  ? const Icon(
                                      Icons.add_a_photo,
                                      size: 40,
                                      color: Colors.white70,
                                    )
                                  : null,
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Title
                          const Text(
                            "Register as Practitioner",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Full Name
                          _glassInput(
                            controller: _fullNameController,
                            label: "Full Name",
                            icon: Icons.person,
                            validator: (val) =>
                                val!.isEmpty ? "Full Name required" : null,
                          ),
                          const SizedBox(height: 16),

                          // Email
                          _glassInput(
                            controller: _emailController,
                            label: "Email",
                            icon: Icons.email,
                            keyboardType: TextInputType.emailAddress,
                            validator: (val) =>
                                val!.isEmpty || !val.contains("@")
                                ? "Enter valid email"
                                : null,
                          ),
                          const SizedBox(height: 16),

                          // Phone
                          _glassInput(
                            controller: _phoneController,
                            label: "Phone Number",
                            icon: Icons.phone,
                            keyboardType: TextInputType.phone,
                            validator: (val) =>
                                val!.isEmpty ? "Phone required" : null,
                          ),
                          const SizedBox(height: 16),

                          // Specialty Dropdown (Fixed overlay)
                          _glassDropdown(),
                          const SizedBox(height: 16),

                          // Experience
                          _glassInput(
                            controller: _experienceController,
                            label: "Years of Experience",
                            icon: Icons.timeline,
                            keyboardType: TextInputType.number,
                            validator: (val) =>
                                val!.isEmpty ? "Experience required" : null,
                          ),
                          const SizedBox(height: 16),

                          // Password
                          _glassInput(
                            controller: _passwordController,
                            label: "Password",
                            icon: Icons.lock,
                            isPassword: true,
                            togglePassword: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                            visible: _isPasswordVisible,
                            validator: (val) => val!.length < 6
                                ? "Password must be at least 6 characters"
                                : null,
                          ),
                          const SizedBox(height: 25),

                          // Register Button
                          GestureDetector(
                            onTap: _isLoading
                                ? null
                                : () => _handleRegistration(auth),
                            child: Container(
                              height: 55,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF00C2FF),
                                    Color(0xFF6A5AE0),
                                  ],
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
                                        "Register",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Sign in link
                          Center(
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const LoginScreen(),
                                  ),
                                );
                              },
                              child: const Text(
                                "Already have an account? Sign in",
                                style: TextStyle(
                                  color: Colors.white70,
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
              ),
            ),

            if (_isLoading)
              Container(
                color: Colors.black54,
                child: const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              ),
          ],
        ),
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
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: isPassword ? !visible : false,
        validator: validator,
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
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 16,
          ),
        ),
      ),
    );
  }

  Widget _glassDropdown() {
    return Container(
      height: 55,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButtonFormField2<String>(
          value: _selectedSpecialty,
          decoration: const InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          ),
          isExpanded: true,
          hint: const Text(
            'Select Specialty',
            style: TextStyle(color: Colors.white70),
          ),
          items: specialties
              .map(
                (s) => DropdownMenuItem<String>(
                  value: s,
                  child: Text(
                    s,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              )
              .toList(),
          onChanged: (val) => setState(() => _selectedSpecialty = val),
          validator: (val) =>
              val == null ? "Please select your specialty" : null,
          dropdownStyleData: DropdownStyleData(
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleRegistration(PracAuth auth) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    User? createdUser;
    final Now = DateTime.now();
    final expirydate = Now.add(Duration(days: 30));

    final imageurl = _profileImage == null
        ? ""
        : await CloudinaryService().uploadImage(_profileImage!);
    try {
      // Removed isEmailAvailable check to avoid permission errors blocking registration.
      // Uniqueness is enforced by FirebaseAuth's createUserWithEmailAndPassword.

      createdUser = await auth.create_prac(
        Fullname: _fullNameController.text,
        email: _emailController.text,
        Password: _passwordController.text,
        Contact_no: _phoneController.text,
        payment_status: "Pending",
        Speciality: _selectedSpecialty ?? '',
        Experience: _experienceController.text,
        context: context,
        subs_start_Date: Timestamp.now().toString(),
        subs_end_Date: expirydate.timeZoneName,
        ImageUrl: imageurl,
      );

      if (createdUser == null) throw "Failed to create practitioner";

      // Navigate to Onboarding instead of immediate payment
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const PractitionerOnboardingScreen(),
          ),
        );
        ErrorHandler.showSuccessSnackBar(
          context,
          "Account created! Please complete onboarding.",
        );
      }
    } catch (e) {
      if (mounted) {
        ErrorHandler.showErrorDialog(
          context,
          "Registration Error",
          e.toString(),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}
