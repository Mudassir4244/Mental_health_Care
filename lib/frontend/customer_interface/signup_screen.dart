// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:mental_healthcare/backend/customer.dart';
// import 'package:mental_healthcare/cloudinary/cloudinary_service.dart';
// import 'package:mental_healthcare/frontend/customer_interface/homescreen.dart';
// import 'package:mental_healthcare/frontend/customer_interface/loginscreen.dart';
// import 'package:mental_healthcare/frontend/widgets/appcolors.dart';

// class SignupScreen extends StatefulWidget {
//   const SignupScreen({super.key});

//   @override
//   State<SignupScreen> createState() => _SignupScreenState();
// }

// class _SignupScreenState extends State<SignupScreen> {
//   File? _selectedImage;
//   final ImagePicker _picker = ImagePicker();

//   /// Pick image from gallery
//   Future<void> _pickImage() async {
//     final XFile? pickedFile = await _picker.pickImage(
//       source: ImageSource.gallery,
//     );

//     if (pickedFile != null) {
//       setState(() {
//         _selectedImage = File(pickedFile.path);
//       });
//     }
//   }

//   final _formKey = GlobalKey<FormState>();
//   final Authentication _authService = Authentication();

//   final TextEditingController _usernameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();

//   bool _isLoading = false;
//   bool _isPasswordVisible = false;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           // 🌈 Beautiful Gradient Background
//           Container(
//             decoration: const BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [AppColors.primary, AppColors.accent],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//             ),
//           ),

//           // 🟣 Curved Top & Bottom Circles
//           Positioned(
//             top: -120,
//             left: -60,
//             child: Container(
//               width: 350,
//               height: 350,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: Colors.white.withOpacity(0.15),
//               ),
//             ),
//           ),
//           Positioned(
//             bottom: -150,
//             right: -80,
//             child: Container(
//               width: 380,
//               height: 380,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: Colors.white.withOpacity(0.10),
//               ),
//             ),
//           ),

//           // 🌟 Glass Container
//           Center(
//             child: Padding(
//               padding: const EdgeInsets.all(24),
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(25),
//                 child: Container(
//                   padding: const EdgeInsets.all(24),
//                   decoration: BoxDecoration(
//                     color: Colors.white.withOpacity(0.15),
//                     borderRadius: BorderRadius.circular(25),
//                     border: Border.all(color: Colors.white.withOpacity(0.3)),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.15),
//                         blurRadius: 15,
//                         offset: const Offset(0, 6),
//                       ),
//                     ],
//                   ),
//                   child: SingleChildScrollView(
//                     child: Column(
//                       children: [
//                         // 👤 Logo Circle
//                         Stack(
//                           children: [
//                             CircleAvatar(
//                               radius: 80,
//                               backgroundColor: Colors.white.withOpacity(0.2),

//                               /// Show image if selected, otherwise icon
//                               backgroundImage: _selectedImage != null
//                                   ? FileImage(_selectedImage!)
//                                   : null,

//                               child: _selectedImage == null
//                                   ? const Icon(
//                                       Icons.person,
//                                       size: 60,
//                                       color: Colors.white,
//                                     )
//                                   : null,
//                             ),
//                             Positioned(
//                               right: 0,
//                               bottom: 0,
//                               child: IconButton(
//                                 onPressed: _pickImage,
//                                 icon: Icon(
//                                   Icons.photo_camera,
//                                   color: Colors.black,
//                                   size: 30,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),

//                         const SizedBox(height: 20),

//                         // ✨ Title
//                         const Text(
//                           "Create Account",
//                           style: TextStyle(
//                             fontSize: 28,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white,
//                             shadows: [
//                               Shadow(
//                                 color: Colors.black26,
//                                 offset: Offset(0, 2),
//                                 blurRadius: 4,
//                               ),
//                             ],
//                           ),
//                         ),
//                         const SizedBox(height: 10),
//                         const Text(
//                           "Sign up to get started",
//                           style: TextStyle(color: Colors.white70, fontSize: 16),
//                         ),
//                         const SizedBox(height: 30),

//                         // 🧑 Username Field
//                         _glassInput(
//                           controller: _usernameController,
//                           label: "Username",
//                           icon: Icons.person,
//                         ),
//                         const SizedBox(height: 20),

//                         // 📧 Email Field
//                         _glassInput(
//                           controller: _emailController,
//                           label: "Email",
//                           icon: Icons.email,
//                         ),
//                         const SizedBox(height: 20),

//                         // 🔒 Password Field
//                         _glassInput(
//                           controller: _passwordController,
//                           label: "Password",
//                           icon: Icons.lock,
//                           isPassword: true,
//                           togglePassword: () {
//                             setState(
//                               () => _isPasswordVisible = !_isPasswordVisible,
//                             );
//                           },
//                           visible: _isPasswordVisible,
//                         ),
//                         const SizedBox(height: 25),

//                         // 🚀 Sign Up Button
//                         GestureDetector(
//                           onTap: _isLoading ? null : _handleSignUp,
//                           child: Container(
//                             height: 55,
//                             width: double.infinity,
//                             decoration: BoxDecoration(
//                               gradient: const LinearGradient(
//                                 colors: [AppColors.accent, AppColors.primary],
//                                 begin: Alignment.topLeft,
//                                 end: Alignment.bottomRight,
//                               ),
//                               borderRadius: BorderRadius.circular(15),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Colors.black.withOpacity(0.25),
//                                   blurRadius: 12,
//                                   offset: const Offset(0, 4),
//                                 ),
//                               ],
//                             ),
//                             child: Center(
//                               child: _isLoading
//                                   ? const CircularProgressIndicator(
//                                       color: Colors.white,
//                                     )
//                                   : const Text(
//                                       "Sign Up",
//                                       style: TextStyle(
//                                         color: Colors.white,
//                                         fontSize: 18,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 20),

//                         // 🔙 Login Link
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             const Text(
//                               "Already have an account?",
//                               style: TextStyle(color: Colors.white70),
//                             ),
//                             TextButton(
//                               onPressed: () => Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (_) => LoginScreen(),
//                                 ),
//                               ),
//                               child: const Text(
//                                 "Login",
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // 🌟 Glass Input Field
//   Widget _glassInput({
//     required TextEditingController controller,
//     required String label,
//     required IconData icon,
//     bool isPassword = false,
//     VoidCallback? togglePassword,
//     bool visible = false,
//   }) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.15),
//         borderRadius: BorderRadius.circular(15),
//         border: Border.all(color: Colors.white.withOpacity(0.3)),
//       ),
//       child: TextField(
//         controller: controller,
//         obscureText: isPassword ? !visible : false,
//         style: const TextStyle(color: Colors.white),
//         decoration: InputDecoration(
//           labelText: label,
//           labelStyle: const TextStyle(color: Colors.white70),
//           prefixIcon: Icon(icon, color: Colors.white),
//           suffixIcon: isPassword
//               ? IconButton(
//                   icon: Icon(
//                     visible ? Icons.visibility : Icons.visibility_off,
//                     color: Colors.white70,
//                   ),
//                   onPressed: togglePassword,
//                 )
//               : null,
//           border: InputBorder.none,
//           contentPadding: const EdgeInsets.symmetric(
//             horizontal: 18,
//             vertical: 16,
//           ),
//         ),
//       ),
//     );
//   }

//   Future<void> _handleSignUp() async {
//     setState(() => _isLoading = true);
//     final imageurl = _selectedImage == null
//         ? ""
//         : await CloudinaryService().uploadImage(_selectedImage!);
//     final user = await _authService.signUp(
//       email: _emailController.text.trim(),
//       password: _passwordController.text.trim(),
//       context: context,
//       username: _usernameController.text.trim(),
//       ImageUrl: imageurl,
//     );
//     setState(() => _isLoading = false);
//     if (user != null && mounted) {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (_) => const HomeScreen()),
//       );
//     }
//   }
// }
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:mental_healthcare/backend/customer.dart';
import 'package:mental_healthcare/cloudinary/cloudinary_service.dart';
import 'package:mental_healthcare/frontend/customer_interface/homescreen.dart';
import 'package:mental_healthcare/frontend/customer_interface/loginscreen.dart';
import 'package:mental_healthcare/frontend/widgets/appcolors.dart';
import 'package:mental_healthcare/l10n/app_localizations.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  final Authentication _authService = Authentication();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _isPasswordVisible = false;

  /// Pick image from gallery
  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: Stack(
        children: [
          // 🌈 Gradient Background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.accent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // Decorative circles
          Positioned(top: -120, left: -60, child: _circle(350, 0.15)),
          Positioned(bottom: -150, right: -80, child: _circle(380, 0.10)),

          // 🌟 Glass Card
          Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Container(
                  padding: const EdgeInsets.all(24),
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
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // Profile Image
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: 80,
                              backgroundColor: Colors.white.withOpacity(0.2),
                              backgroundImage: _selectedImage != null
                                  ? FileImage(_selectedImage!)
                                  : null,
                              child: _selectedImage == null
                                  ? const Icon(
                                      Icons.person,
                                      size: 60,
                                      color: Colors.white,
                                    )
                                  : null,
                            ),
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: IconButton(
                                onPressed: _pickImage,
                                icon: const Icon(
                                  Icons.photo_camera,
                                  color: Colors.black,
                                  size: 30,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // Title
                        Text(
                          l10n.createAccount,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Text(
                        //   l10n.signupSubtitle,
                        //   style: const TextStyle(
                        //     color: Colors.white70,
                        //     fontSize: 16,
                        //   ),
                        // ),
                        const SizedBox(height: 30),

                        _glassInput(
                          controller: _usernameController,
                          label: l10n.username,
                          icon: Icons.person,
                        ),
                        const SizedBox(height: 20),

                        _glassInput(
                          controller: _emailController,
                          label: l10n.email,
                          icon: Icons.email,
                        ),
                        const SizedBox(height: 20),

                        _glassInput(
                          controller: _passwordController,
                          label: l10n.password,
                          icon: Icons.lock,
                          isPassword: true,
                          visible: _isPasswordVisible,
                          togglePassword: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),

                        const SizedBox(height: 25),

                        // Sign Up Button
                        GestureDetector(
                          onTap: _isLoading ? null : _handleSignUp,
                          child: Container(
                            height: 55,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [AppColors.accent, AppColors.primary],
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Center(
                              child: _isLoading
                                  ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : Text(
                                      l10n.signUp,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Login Link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              l10n.alreadyHaveAccount,
                              style: const TextStyle(color: Colors.white70),
                            ),
                            TextButton(
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const LoginScreen(),
                                ),
                              ),
                              child: Text(
                                l10n.login,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Glass Input Field
  Widget _glassInput({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
    bool visible = false,
    VoidCallback? togglePassword,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: TextField(
        controller: controller,
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
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 16,
          ),
        ),
      ),
    );
  }

  Widget _circle(double size, double opacity) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(opacity),
      ),
    );
  }

  Future<void> _handleSignUp() async {
    setState(() => _isLoading = true);

    final imageUrl = _selectedImage == null
        ? ""
        : await CloudinaryService().uploadImage(_selectedImage!);

    final user = await _authService.signUp(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
      username: _usernameController.text.trim(),
      ImageUrl: imageUrl,
      context: context,
    );

    setState(() => _isLoading = false);

    if (user != null && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    }
  }
}
