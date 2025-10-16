import 'package:flutter/material.dart';
import 'package:mental_healthcare/customer_interface/loginscreen.dart';
import 'package:mental_healthcare/practioner_interface/prac_homescreen.dart';
import 'package:mental_healthcare/practioner_interface/practioner_fee.dart';
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
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: const Text(
          "Practitioner Registration",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        elevation: 2,
      ),
      body: SingleChildScrollView(
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

                // Qualification
                _buildTextField(
                  controller: _qualificationController,
                  label: "Qualification",
                  icon: Icons.school,
                  validator: (val) =>
                      val!.isEmpty ? "Enter your qualification" : null,
                ),

                // Specialty Dropdown
                const SizedBox(height: 8),
                // Responsive Specialty Dropdown
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
                                : 16, // Responsive font size
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
                                style: TextStyle(
                                  color: AppColors.textColorPrimary,
                                  fontSize: fieldWidth < 350
                                      ? 15
                                      : 15, // Responsive text
                                ),
                                overflow: TextOverflow.ellipsis,
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
                            contentPadding: EdgeInsets.symmetric(
                              vertical: fieldWidth < 350 ? 15 : 14,
                              horizontal: 12,
                            ),
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
                          isExpanded:
                              true, // Prevents text cutoff on small screens
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
                    prefixIcon: const Icon(Icons.lock, color: AppColors.accent),
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
                      borderSide: const BorderSide(color: AppColors.primary),
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
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      // if (_formKey.currentState!.validate()) {
                      //   ScaffoldMessenger.of(context).showSnackBar(
                      //     const SnackBar(
                      //       content: Text(
                      //         "Practitioner Registered Successfully!",
                      //       ),
                      //       backgroundColor: AppColors.success,
                      //     ),
                      //   );
                      // }
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PractionerFee(organizationName: ''),
                        ),
                      );
                    },
                    child: const Text(
                      "Register",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Already have an account
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
