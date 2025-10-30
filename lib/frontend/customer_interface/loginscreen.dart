// import 'package:flutter/material.dart';
// import 'package:mental_healthcare/frontend/customer_interface/choice_screen.dart';
// import 'package:mental_healthcare/frontend/customer_interface/homescreen.dart';
// import 'package:mental_healthcare/frontend/widgets/appcolors.dart';

// class LoginScreen extends StatelessWidget {
//   const LoginScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final colors = Theme.of(context).colorScheme;

//     return Scaffold(

//       backgroundColor: colors.surface,
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(24.0),
//           child: SingleChildScrollView(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 // Logo / Icon
//                 CircleAvatar(
//                   radius: 100,
//                   backgroundColor: Colors.transparent,
//                   child: Image.asset("assets/logo.png"),
//                 ),
//                 const SizedBox(height: 20),

//                 // Title
//                 Text(
//                   "Welcome Back!",
//                   style: TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   "Login to continue",
//                   style: TextStyle(
//                     fontSize: 16,
//                     color: colors.onSurface.withOpacity(0.7),
//                   ),
//                 ),
//                 const SizedBox(height: 32),

//                 // Email Field
//                 TextField(
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
//                 const SizedBox(height: 12),

//                 // Forgot Password
//                 Align(
//                   alignment: Alignment.centerRight,
//                   child: TextButton(
//                     onPressed: () {},
//                     child: Text(
//                       "Forgot Password?",
//                       style: TextStyle(color: colors.secondary),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 24),

//                 // Login Button
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
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (_) => HomeScreen()),
//                       );
//                     },
//                     child: const Text(
//                       "Login",
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 16),

//                 // Signup Link
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       "Don't have an account?",
//                       style: TextStyle(
//                         color: colors.onSurface.withOpacity(0.7),
//                       ),
//                     ),
//                     TextButton(
//                       onPressed: () {
//                         Navigator.push(context, MaterialPageRoute(builder: (context)=>ChoiceScreen()));
//                       },
//                       child: Text(
//                         "Sign Up",
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
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mental_healthcare/frontend/customer_interface/choice_screen.dart';
import 'package:mental_healthcare/frontend/customer_interface/homescreen.dart';
import 'package:mental_healthcare/frontend/organization_interface/oraginzation%20owner/organization_homescreen.dart';
import 'package:mental_healthcare/frontend/practioner_interface/prac_homescreen.dart';
import 'package:mental_healthcare/frontend/widgets/appcolors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _isPasswordVisible = false; // 👁 for toggle

  // 🔐 Login Function
  Future<void> _loginUser() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter email and password")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // 1️⃣ Sign in with FirebaseAuth
      UserCredential userCred = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      final uid = userCred.user!.uid;

      // 2️⃣ Fetch role from Firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(uid)
          .get();

      if (!userDoc.exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("User record not found in Firestore")),
        );
        return;
      }

      final role = userDoc['role'];

      // 3️⃣ Navigate based on role
      if (role == 'customer') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      } else if (role == 'Practionar') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const PracHomescreen()),
        );
      } else if (role == 'Oragnization Owner') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const organ_owner_homescreen()),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Unknown role: $role")));
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message ?? "Login failed")));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colors.surface,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 🧠 Logo
                CircleAvatar(
                  radius: 100,
                  backgroundColor: Colors.transparent,
                  child: Image.asset("assets/logo.png"),
                ),
                const SizedBox(height: 20),

                // Title
                const Text(
                  "Welcome Back!",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Login to continue",
                  style: TextStyle(
                    fontSize: 16,
                    color: colors.onSurface.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 32),

                // 📧 Email Field
                TextField(
                  controller: _emailController,
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
                ),
                const SizedBox(height: 16),

                // 🔒 Password Field with Toggle
                TextField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    labelText: "Password",
                    prefixIcon: Icon(Icons.lock, color: colors.secondary),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.grey[700],
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
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: colors.primary, width: 2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // 🔁 Forgot Password
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      "Forgot Password?",
                      style: TextStyle(color: colors.secondary),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // 🚀 Login Button
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
                    onPressed: _isLoading ? null : _loginUser,
                    child: _isLoading
                        ? const SizedBox(
                            height: 26,
                            width: 26,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                        : const Text(
                            "Login",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 16),

                // 🆕 Signup Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account?",
                      style: TextStyle(
                        color: colors.onSurface.withOpacity(0.7),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ChoiceScreen(),
                          ),
                        );
                      },
                      child: Text(
                        "Sign Up",
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
    );
  }
}
