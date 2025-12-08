// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
// import 'package:get/get.dart';
// import 'package:mental_healthcare/backend/practionar.dart';
// import 'package:mental_healthcare/frontend/customer_interface/loginscreen.dart';
// import 'package:mental_healthcare/frontend/practioner_interface/prac_homescreen.dart';
// import 'package:mental_healthcare/payment_process/stripe_services.dart';
// import '../widgets/appcolors.dart'; // adjust path if needed

// class PractitionerRegistrationScreen extends StatefulWidget {
//   const PractitionerRegistrationScreen({super.key});

//   @override
//   State<PractitionerRegistrationScreen> createState() =>
//       _PractitionerRegistrationScreenState();
// }

// class _PractitionerRegistrationScreenState
//     extends State<PractitionerRegistrationScreen> {
//   final _formKey = GlobalKey<FormState>();

//   // Controllers
//   final TextEditingController _fullNameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _phoneController = TextEditingController();
//   final TextEditingController _qualificationController =
//       TextEditingController();
//   final TextEditingController _experienceController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();

//   bool _isPasswordVisible = false;
//   bool _isLoading = false; // 🔹 Loading flag

//   // Specialties list
//   final List<String> specialties = [
//     'Clinical Psychologist',
//     'Licensed Professional Counselor (LPC)',
//     'Licensed Clinical Social Worker (LCSW)',
//     'Psychiatrist (MD/DO)',
//     'Crisis Intervention Specialist',
//     'Certified Peer Specialist',
//     'Other Qualified Mental Health Professional',
//   ];

//   String? _selectedSpecialty;

//   @override
//   void dispose() {
//     _fullNameController.dispose();
//     _emailController.dispose();
//     _phoneController.dispose();
//     _qualificationController.dispose();
//     _experienceController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final auth = PracAuth();
//     final stripe = StripServices();

//     return Scaffold(
//       backgroundColor: AppColors.background,
//       appBar: AppBar(
//         iconTheme: const IconThemeData(color: Colors.white),
//         title: const Text(
//           "Practitioner Registration",
//           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//         ),
//         centerTitle: true,
//         backgroundColor: AppColors.primary,
//         elevation: 2,
//       ),
//       body: Stack(
//         children: [
//           SingleChildScrollView(
//             padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
//             child: Padding(
//               padding: const EdgeInsets.all(10.0),
//               child: Form(
//                 key: _formKey,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       "Register as Practitioner",
//                       style: TextStyle(
//                         color: AppColors.sectionTitleColor,
//                         fontSize: 22,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 20),

//                     // Full Name
//                     _buildTextField(
//                       controller: _fullNameController,
//                       label: "Full Name",
//                       icon: Icons.person,
//                       validator: (val) =>
//                           val!.isEmpty ? "Enter your full name" : null,
//                     ),

//                     // Email
//                     _buildTextField(
//                       controller: _emailController,
//                       label: "Email",
//                       icon: Icons.email,
//                       keyboardType: TextInputType.emailAddress,
//                       validator: (val) =>
//                           val!.isEmpty ? "Enter a valid email" : null,
//                     ),

//                     // Phone Number
//                     _buildTextField(
//                       controller: _phoneController,
//                       label: "Phone Number",
//                       icon: Icons.phone,
//                       keyboardType: TextInputType.phone,
//                       validator: (val) =>
//                           val!.isEmpty ? "Enter your phone number" : null,
//                     ),

//                     const SizedBox(height: 8),

//                     // Specialty Dropdown
//                     LayoutBuilder(
//                       builder: (context, constraints) {
//                         double fieldWidth = constraints.maxWidth;
//                         return Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               "Select Specialty",
//                               style: TextStyle(
//                                 color: AppColors.textColorPrimary,
//                                 fontWeight: FontWeight.w600,
//                                 fontSize: fieldWidth < 350
//                                     ? 14
//                                     : 16, // Responsive
//                               ),
//                             ),
//                             const SizedBox(height: 6),
//                             DropdownButtonFormField<String>(
//                               initialValue: _selectedSpecialty,
//                               items: specialties.map((specialty) {
//                                 return DropdownMenuItem(
//                                   value: specialty,
//                                   child: Text(
//                                     specialty,
//                                     overflow: TextOverflow.ellipsis,
//                                     style: TextStyle(
//                                       color: AppColors.textColorPrimary,
//                                       fontSize: 15,
//                                     ),
//                                   ),
//                                 );
//                               }).toList(),
//                               onChanged: (value) {
//                                 setState(() {
//                                   _selectedSpecialty = value;
//                                 });
//                               },
//                               decoration: InputDecoration(
//                                 prefixIcon: const Icon(
//                                   Icons.psychology,
//                                   color: AppColors.accent,
//                                 ),
//                                 filled: true,
//                                 fillColor: AppColors.background,
//                                 focusedBorder: OutlineInputBorder(
//                                   borderSide: const BorderSide(
//                                     color: AppColors.primary,
//                                   ),
//                                   borderRadius: BorderRadius.circular(12),
//                                 ),
//                                 border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(12),
//                                 ),
//                               ),
//                               validator: (value) => value == null
//                                   ? "Please select your specialty"
//                                   : null,
//                               isExpanded: true,
//                             ),
//                           ],
//                         );
//                       },
//                     ),

//                     const SizedBox(height: 16),

//                     // Experience
//                     _buildTextField(
//                       controller: _experienceController,
//                       label: "Years of Experience",
//                       icon: Icons.timeline,
//                       keyboardType: TextInputType.number,
//                       validator: (val) =>
//                           val!.isEmpty ? "Enter your experience" : null,
//                     ),

//                     // Password
//                     TextFormField(
//                       controller: _passwordController,
//                       obscureText: !_isPasswordVisible,
//                       decoration: InputDecoration(
//                         labelText: "Password",
//                         prefixIcon: const Icon(
//                           Icons.lock,
//                           color: AppColors.accent,
//                         ),
//                         suffixIcon: IconButton(
//                           icon: Icon(
//                             _isPasswordVisible
//                                 ? Icons.visibility
//                                 : Icons.visibility_off,
//                             color: AppColors.accent,
//                           ),
//                           onPressed: () {
//                             setState(() {
//                               _isPasswordVisible = !_isPasswordVisible;
//                             });
//                           },
//                         ),
//                         filled: true,
//                         fillColor: AppColors.background,
//                         focusedBorder: OutlineInputBorder(
//                           borderSide: const BorderSide(
//                             color: AppColors.primary,
//                           ),
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                       ),
//                       validator: (val) =>
//                           val!.length < 6 ? "Password too short" : null,
//                     ),

//                     const SizedBox(height: 25),

//                     SizedBox(
//                       width: double.infinity,
//                       child: ElevatedButton(
//                         onPressed: _isLoading
//                             ? null
//                             : () async {
//                                 // Validate input fields
//                                 if (_fullNameController.text.isEmpty ||
//                                     _emailController.text.isEmpty ||
//                                     _passwordController.text.isEmpty ||
//                                     _experienceController.text.isEmpty ||
//                                     _phoneController.text.isEmpty) {
//                                   Get.snackbar(
//                                     "Error",
//                                     "Please fill all fields",
//                                   );
//                                   return;
//                                 }

//                                 setState(() => _isLoading = true);

//                                 User? createdUser;

//                                 try {
//                                   // 1️⃣ First, check if email is available
//                                   final isAvailable = await auth
//                                       .isEmailAvailable(_emailController.text);

//                                   if (!isAvailable) {
//                                     if (mounted) {
//                                       ScaffoldMessenger.of(
//                                         context,
//                                       ).showSnackBar(
//                                         const SnackBar(
//                                           content: Text(
//                                             'This email is already registered. Please use another.',
//                                           ),
//                                           backgroundColor: Colors.red,
//                                         ),
//                                       );
//                                     }
//                                     return;
//                                   }

//                                   // 2️⃣ Email is available, create organization with Pending status
//                                   createdUser = await auth.create_prac(
//                                     Fullname: _fullNameController.text,
//                                     email: _emailController.text,
//                                     Password: _passwordController.text,
//                                     Contact_no: _phoneController.text,
//                                     payment_status: "Pending",
//                                     Speciality: _selectedSpecialty ?? '',
//                                     Experience: _experienceController.text,
//                                     context: context,
//                                   );
//                                   if (createdUser == null) {
//                                     if (mounted) {
//                                       ScaffoldMessenger.of(
//                                         context,
//                                       ).showSnackBar(
//                                         const SnackBar(
//                                           content: Text(
//                                             'Failed to create organization',
//                                           ),
//                                           backgroundColor: Colors.red,
//                                         ),
//                                       );
//                                     }
//                                     return;
//                                   }

//                                   // 3️⃣ Organization created with Pending status, now show payment
//                                   await stripe.makepayments(30, 'USD');

//                                   // 4️⃣ Payment succeeded, update status to Completed
//                                   final paymentUpdated = await auth
//                                       .updatePaymentStatus(createdUser.uid);

//                                   if (!paymentUpdated) {
//                                     if (mounted) {
//                                       ScaffoldMessenger.of(
//                                         context,
//                                       ).showSnackBar(
//                                         const SnackBar(
//                                           content: Text(
//                                             'Payment processed but status update failed. Contact support.',
//                                           ),
//                                           backgroundColor: Colors.orange,
//                                         ),
//                                       );
//                                     }
//                                   }

//                                   // 5️⃣ Navigate to home
//                                   if (mounted) {
//                                     Navigator.pushReplacement(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder: (_) => PracHomescreen(),
//                                       ),
//                                     );

//                                     ScaffoldMessenger.of(context).showSnackBar(
//                                       const SnackBar(
//                                         content: Text(
//                                           'Successfully registered as Practitioner!',
//                                         ),
//                                         backgroundColor: Colors.green,
//                                       ),
//                                     );
//                                   }
//                                 } on StripeException catch (e) {
//                                   // Payment cancelled or failed
//                                   if (mounted) {
//                                     ScaffoldMessenger.of(context).showSnackBar(
//                                       SnackBar(
//                                         content: Text(
//                                           'Payment cancelled: ${e.error.localizedMessage ?? 'Unknown error'}',
//                                         ),
//                                         backgroundColor: Colors.orange,
//                                       ),
//                                     );
//                                   }

//                                   // Organization created but payment failed - status remains Pending
//                                   debugPrint(
//                                     "⚠️ Successfully created Practionar. User ID: ${createdUser?.uid}",
//                                   );
//                                 } catch (e) {
//                                   // Any other error
//                                   debugPrint("❌ Error: $e");
//                                   if (mounted) {
//                                     ScaffoldMessenger.of(context).showSnackBar(
//                                       SnackBar(
//                                         content: Text(
//                                           'Failed to create Practionar: $e',
//                                         ),
//                                         backgroundColor: Colors.red,
//                                       ),
//                                     );
//                                   }
//                                 } finally {
//                                   if (mounted) {
//                                     setState(() => _isLoading = false);
//                                   }
//                                 }
//                               },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: AppColors.primary,
//                           padding: const EdgeInsets.symmetric(vertical: 14),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                         ),
//                         child: _isLoading
//                             ? const SizedBox(
//                                 height: 24,
//                                 width: 24,
//                                 child: CircularProgressIndicator(
//                                   color: Colors.white,
//                                   strokeWidth: 2.5,
//                                 ),
//                               )
//                             : const Text(
//                                 "Register as Practitioner",
//                                 style: TextStyle(
//                                   fontSize: 16,
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                       ),
//                     ),
//                     const SizedBox(height: 20),

//                     Center(
//                       child: TextButton(
//                         onPressed: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(builder: (_) => LoginScreen()),
//                           );
//                         },
//                         child: const Text(
//                           "Already have an account? Sign in",
//                           style: TextStyle(
//                             color: Colors.black,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),

//           // Optional: Overlay loader
//           if (_isLoading)
//             Container(
//               color: Colors.black54,
//               child: const Center(
//                 child: CircularProgressIndicator(color: Colors.white),
//               ),
//             ),
//         ],
//       ),
//     );
//   }

//   // Reusable textfield builder
//   Widget _buildTextField({
//     required TextEditingController controller,
//     required String label,
//     required IconData icon,
//     String? Function(String?)? validator,
//     TextInputType keyboardType = TextInputType.text,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 16.0),
//       child: TextFormField(
//         controller: controller,
//         validator: validator,
//         keyboardType: keyboardType,
//         decoration: InputDecoration(
//           labelText: label,
//           prefixIcon: Icon(icon, color: AppColors.accent),
//           filled: true,
//           fillColor: AppColors.background,
//           focusedBorder: OutlineInputBorder(
//             borderSide: const BorderSide(color: AppColors.primary),
//             borderRadius: BorderRadius.circular(12),
//           ),
//           border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//         ),
//       ),
//     );
//   }
// }
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mental_healthcare/backend/practionar.dart';
import 'package:mental_healthcare/frontend/customer_interface/choice_screen.dart';
import 'package:mental_healthcare/frontend/customer_interface/loginscreen.dart';
import 'package:mental_healthcare/frontend/practioner_interface/prac_homescreen.dart';
import 'package:mental_healthcare/payment_process/stripe_services.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

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
    final stripe = StripServices();

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
                                : () => _handleRegistration(auth, stripe),
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
    return TextFormField(
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

  Widget _glassDropdown() {
    return SizedBox(
      height: 55,
      child: DropdownButtonHideUnderline(
        child: DropdownButtonFormField2<String>(
          value: _selectedSpecialty,
          decoration: InputDecoration(
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
                    style: TextStyle(color: Colors.white),
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

  Future<void> _handleRegistration(PracAuth auth, StripServices stripe) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    User? createdUser;

    try {
      final isAvailable = await auth.isEmailAvailable(_emailController.text);
      if (!isAvailable) {
        if (mounted) Get.snackbar("Error", "Email already registered");
        return;
      }

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

      if (createdUser == null) throw "Failed to create practitioner";

      await stripe.makepayments(30, 'USD');
      await auth.updatePaymentStatus(createdUser.uid);

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => PracHomescreen()),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Successfully registered as Practitioner!"),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}
