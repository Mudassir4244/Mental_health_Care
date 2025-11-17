// import 'package:flutter/material.dart';
// import 'package:mental_healthcare/backend/authentication.dart';
// import 'package:mental_healthcare/frontend/customer_interface/homescreen.dart';
// import 'package:mental_healthcare/frontend/widgets/appcolors.dart';

// class SignupScreen extends StatelessWidget {
//   const SignupScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final colors = Theme.of(context).colorScheme;
//     final auth_service = Authentication();
//     TextEditingController username_contorller = TextEditingController();
//     TextEditingController email_contorller = TextEditingController();
//     TextEditingController password_contoller = TextEditingController();

//     return Scaffold(
//       backgroundColor: colors.surface,
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(24.0),
//           child: SingleChildScrollView(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 // Circle Avatar
//                 CircleAvatar(
//                   radius: 60,
//                   backgroundColor: colors.primary.withOpacity(0.1),
//                   child: Icon(Icons.person, size: 60, color: colors.primary),
//                 ),
//                 const SizedBox(height: 20),

//                 // Title
//                 Text(
//                   "Create Account",
//                   style: const TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   "Sign up to get started",
//                   style: TextStyle(
//                     fontSize: 16,
//                     color: colors.onSurface.withOpacity(0.7),
//                   ),
//                 ),
//                 const SizedBox(height: 32),

//                 // Username Field
//                 TextField(
//                   controller: username_contorller,
//                   decoration: InputDecoration(
//                     labelText: "Username",
//                     prefixIcon: Icon(Icons.person, color: colors.secondary),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderSide: BorderSide(color: colors.primary, width: 2),
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 16),

//                 // Email Field
//                 TextField(
//                   controller: email_contorller,
//                   decoration: InputDecoration(
//                     labelText: "Email",
//                     prefixIcon: Icon(Icons.email, color: colors.secondary),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderSide: BorderSide(color: colors.primary, width: 2),
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 16),

//                 // Password Field
//                 TextField(
//                   controller: password_contoller,
//                   obscureText: true,
//                   decoration: InputDecoration(
//                     labelText: "Password",
//                     prefixIcon: Icon(Icons.lock, color: colors.secondary),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderSide: BorderSide(color: colors.primary, width: 2),
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 24),

//                 // Signup Button
//                 SizedBox(
//                   width: double.infinity,
//                   height: 50,
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: AppColors.accent,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                     onPressed: () {
//                       auth_service
//                           .signUp(
//                             email: email_contorller.text.trim(),
//                             password: password_contoller.text.trim(),
//                             context: context,
//                           )
//                           .then((vlaue) {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(builder: (_) => HomeScreen()),
//                             );
//                           });
//                     },
//                     child: const Text(
//                       "Sign Up",
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 16),

//                 // Login Link
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       "Already have an account?",
//                       style: TextStyle(
//                         color: colors.onSurface.withOpacity(0.7),
//                       ),
//                     ),
//                     TextButton(
//                       onPressed: () {
//                         Navigator.pop(context);
//                       },
//                       child: Text(
//                         "Login",
//                         style: TextStyle(
//                           color: colors.secondary,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:mental_healthcare/backend/customer.dart';
import 'package:mental_healthcare/frontend/customer_interface/homescreen.dart';
import 'package:mental_healthcare/frontend/widgets/appcolors.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  final Authentication _authService = Authentication();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colors.surface,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 👤 Circle Avatar
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: colors.primary.withOpacity(0.1),
                    child: Icon(Icons.person, size: 60, color: colors.primary),
                  ),
                  const SizedBox(height: 20),

                  // 🏷️ Title
                  const Text(
                    "Create Account",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Sign up to get started",
                    style: TextStyle(
                      fontSize: 16,
                      color: colors.onSurface.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // 🧑 Username Field
                  TextFormField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: "Username",
                      prefixIcon: Icon(Icons.person, color: colors.secondary),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: colors.primary, width: 2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Please enter your username";
                      }
                      if (value.length < 3) {
                        return "Username must be at least 3 characters";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // 📧 Email Field
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: "Email",
                      prefixIcon: Icon(Icons.email, color: colors.secondary),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: colors.primary, width: 2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Please enter your email";
                      }
                      final emailRegex = RegExp(
                        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                      );
                      if (!emailRegex.hasMatch(value)) {
                        return "Please enter a valid email";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // 🔒 Password Field
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: "Password",
                      prefixIcon: Icon(Icons.lock, color: colors.secondary),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: colors.primary, width: 2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your password";
                      }
                      if (value.length < 6) {
                        return "Password must be at least 8 characters";
                      }

                      // if (!RegExp(r'[0-9]').hasMatch(value)) {
                      //   return "Include at least one number";
                      // }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  // 🚀 Signup Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _isLoading ? null : _handleSignUp,
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              "Sign Up",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 🔙 Login Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account?",
                        style: TextStyle(
                          color: colors.onSurface.withOpacity(0.7),
                        ),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          "Login",
                          style: TextStyle(
                            color: colors.secondary,
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
    );
  }

  Future<void> _handleSignUp() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final user = await _authService.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        context: context,
        username: _usernameController.text.trim(),
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
}
