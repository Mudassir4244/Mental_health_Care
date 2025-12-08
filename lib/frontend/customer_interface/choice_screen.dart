import 'package:flutter/material.dart';
import 'package:mental_healthcare/admin/admin_login.dart';
import 'package:mental_healthcare/backend/customer.dart';
import 'package:mental_healthcare/backend/guest.dart';
import 'package:mental_healthcare/frontend/customer_interface/homescreen.dart';
import 'package:mental_healthcare/frontend/practioner_interface/practionar_registration.dart';
import 'package:mental_healthcare/frontend/customer_interface/signup_screen.dart';
import 'package:mental_healthcare/frontend/organization_interface/oraginzation%20owner/create_organization.dart';
import 'package:mental_healthcare/frontend/widgets/appcolors.dart';

class ChoiceScreen extends StatelessWidget {
  const ChoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final auth = Authentication();
    final auth = geustauth();
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,

        // 🔹 Full-screen gradient background
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE0F7FA), Color(0xFF80DEEA)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 32,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 🎨 Gradient Welcome Title with shadow
                    ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [Color(0xFF6A5AE0), Color(0xFF00C2FF)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(bounds),
                      child: const Text(
                        "Welcome",
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              blurRadius: 8,
                              color: Colors.black26,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 50),

                    // 🟦 Glassmorphic Buttons
                    _buildGlassButton(
                      title: "Continue as Guest",
                      gradientColors: const [
                        Color(0xFF29ADB2),
                        Color(0xFF33D1C4),
                      ],
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => HomeScreen()),
                        );
                      },
                    ),
                    const SizedBox(height: 20),

                    _buildGlassButton(
                      title: "Continue as Customer",
                      gradientColors: [AppColors.primary, AppColors.accent],
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => SignupScreen()),
                      ),
                    ),
                    const SizedBox(height: 20),

                    _buildGlassButton(
                      title: "Continue as Practitionar",
                      gradientColors: const [Colors.black87, Colors.black54],
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PractitionerRegistrationScreen(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    _buildGlassButton(
                      title: "Continue as Organization",
                      gradientColors: [
                        AppColors.textColorSecondary,
                        AppColors.primary,
                      ],
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => OrganizationOptionScreen(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),

                    // ⚡ Login text and button
                    const Text(
                      'Already have an account?',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildGlassButton(
                      title: "Login",
                      gradientColors: [
                        AppColors.textColorPrimary,
                        Colors.blueAccent,
                      ],
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => AdminLoginScreen()),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // =========================
  // 🔹 Glassmorphic Button
  // =========================
  Widget _buildGlassButton({
    required String title,
    required List<Color> gradientColors,
    required VoidCallback onTap,
  }) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 800),
      builder: (context, double value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, (1 - value) * 20),
            child: child,
          ),
        );
      },
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: double.infinity,
          height: 60,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: gradientColors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: gradientColors.first.withOpacity(0.4),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Center(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [
                  Shadow(
                    color: Colors.black26,
                    blurRadius: 4,
                    offset: Offset(1, 1),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
