import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mental_healthcare/admin/admin_homescreen.dart';
import 'package:mental_healthcare/backend/practionar.dart';
import 'package:mental_healthcare/frontend/customer_interface/choice_screen.dart';
import 'package:mental_healthcare/frontend/customer_interface/homescreen.dart';
import 'package:mental_healthcare/frontend/organization_interface/oraginzation owner/organization_homescreen.dart';
import 'package:mental_healthcare/frontend/practioner_interface/prac_homescreen.dart';
import 'package:mental_healthcare/frontend/practioner_interface/practitioner_onboarding.dart';
import 'package:mental_healthcare/frontend/widgets/error_handler.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final auth = PracAuth();
  bool _isLoading = false;
  bool _isPasswordVisible = false;

  Future<void> _loginUser() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ErrorHandler.showErrorSnackBar(
        context,
        "Please enter email and password",
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      auth.checkAndExpireSubscription();
      UserCredential userCred = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      final uid = userCred.user!.uid;

      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(uid)
          .get();

      String? role;
      String? paymentstatus;
      if (userDoc.exists) {
        role = userDoc.get('role');
        paymentstatus = userDoc.get('Payment Status');
      } else {
        DocumentSnapshot adminDoc = await FirebaseFirestore.instance
            .collection('admin')
            .doc(uid)
            .get();

        if (adminDoc.exists) role = adminDoc.get('role');
        if (adminDoc.exists) paymentstatus = adminDoc.get('Payment Status');
      }

      final String normalizedRole = role?.toLowerCase() ?? '';

      if (normalizedRole == 'customer') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      } else if (normalizedRole == 'practitioner') {
        if (paymentstatus == 'Completed') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const PracHomescreen()),
          );
        } else if (paymentstatus == 'Pending') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => PractitionerOnboardingScreen()),
          );
        }
      } else if (normalizedRole == 'organization owner' &&
          paymentstatus == 'Completed') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const organ_owner_homescreen()),
        );
      } else if (normalizedRole == 'organization employee') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      } else if (normalizedRole == 'admin') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const AdminHomescreen()),
        );
      } else {
        ErrorHandler.showErrorDialog(
          context,
          "Access Denied",
          "Unknown role or incomplete profile for role: $role",
        );
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = "Login failed";
      if (e.code == 'user-not-found') {
        errorMessage = "No user found for that email.";
      } else if (e.code == 'wrong-password') {
        errorMessage = "Wrong password provided.";
      } else if (e.code == 'invalid-email') {
        errorMessage = "The email address is invalid.";
      } else {
        errorMessage = e.message ?? "An undefined error occurred.";
      }
      ErrorHandler.showErrorDialog(context, "Login Failed", errorMessage);
    } catch (e) {
      ErrorHandler.showErrorDialog(
        context,
        "Error",
        "An unexpected error occurred: $e",
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const ChoiceScreen()),
        );
        return false;
      },
      child: Scaffold(
        body: Stack(
          children: [
            // 🌈 Beautiful Gradient Background
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF6A5AE0), Color(0xFF00C2FF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),

            // 🟣 Curved Top Wave
            Positioned(
              top: -120,
              left: -60,
              child: Container(
                width: 350,
                height: 350,
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

            // 🌟 Center Glass Container
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
                          // 🧠 Logo
                          CircleAvatar(
                            radius: 55,
                            backgroundColor: Colors.white.withOpacity(0.2),
                            child: Image.asset(
                              "assets/logo.png",
                              height: 70,
                              width: 70,
                            ),
                          ),

                          const SizedBox(height: 20),

                          // ✨ Gradient Text
                          ShaderMask(
                            shaderCallback: (bounds) => const LinearGradient(
                              colors: [Colors.white, Colors.yellowAccent],
                            ).createShader(bounds),
                            child: const Text(
                              "Welcome Back!",
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),

                          const SizedBox(height: 10),
                          const Text(
                            "Login to continue",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),

                          const SizedBox(height: 30),

                          // 📧 Email Field
                          _glassInput(
                            controller: _emailController,
                            label: "Email",
                            icon: Icons.email,
                          ),

                          const SizedBox(height: 20),

                          // 🔐 Password Field
                          _glassInput(
                            controller: _passwordController,
                            label: "Password",
                            icon: Icons.lock,
                            isPassword: true,
                            togglePassword: () {
                              setState(
                                () => _isPasswordVisible = !_isPasswordVisible,
                              );
                            },
                            visible: _isPasswordVisible,
                          ),

                          const SizedBox(height: 10),

                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {},
                              child: const Text(
                                "Forgot Password?",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          // 🚀 Gradient Login Button
                          GestureDetector(
                            onTap: _isLoading ? null : _loginUser,
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
                                        "Login",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Don't have an account?",
                                style: TextStyle(color: Colors.white70),
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
                                child: const Text(
                                  "Sign Up",
                                  style: TextStyle(
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
      ),
    );
  }

  // 🌟 REUSABLE GLASS INPUT FIELD
  Widget _glassInput({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
    VoidCallback? togglePassword,
    bool visible = false,
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
}
