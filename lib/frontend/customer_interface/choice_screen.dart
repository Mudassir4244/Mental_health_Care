import 'package:flutter/material.dart';
import 'package:mental_healthcare/frontend/customer_interface/homescreen.dart';
import 'package:mental_healthcare/frontend/customer_interface/loginscreen.dart';
import 'package:mental_healthcare/frontend/practioner_interface/practionar_registration.dart';
import 'package:mental_healthcare/frontend/customer_interface/signup_screen.dart';
import 'package:mental_healthcare/frontend/organization_interface/oraginzation%20owner/user_choice.dart';
import 'package:mental_healthcare/frontend/widgets/appcolors.dart';

class ChoiceScreen extends StatelessWidget {
  const ChoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final design = AppColors();
    return Scaffold(
      backgroundColor: AppColors.background, // Background color
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Title
                Text(
                  "Welcome",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary, // Primary color
                  ),
                ),
                const SizedBox(height: 40),

                // Guest Button
                _buildLoginButton(
                  title: "Continue as Guest",
                  color: const Color(0xFF29ADB2), // Accent color
                  onTap: () {
                    // Handle Guest Login
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => HomeScreen()),
                    );
                  },
                ),
                const SizedBox(height: 20),

                // User Button
                _buildLoginButton(
                  title: "Continue as Customer",
                  color: AppColors.primary, // Primary color
                  onTap: () {
                    // Handle User Login
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => SignupScreen()),
                    );
                  },
                ),
                const SizedBox(height: 20),

                // Doctor Button
                _buildLoginButton(
                  title: "Continue as Practitionar",
                  color: Colors.black87, // Contrast with palette
                  onTap: () {
                    // Handle Doctor Login
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PractitionerRegistrationScreen(),
                      ),
                    );
                  },
                ),
                SizedBox(height: 30),
                _buildLoginButton(
                  title: "Continue as Organization",
                  color: AppColors.textColorSecondary,

                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => OrganizationOptionScreen(),
                      ),
                    );
                  },
                ),
                SizedBox(height: 30),
                Text(
                  'Already have an account ?',
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                _buildLoginButton(
                  title: 'Login',
                  color: AppColors.textColorPrimary,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => LoginScreen()),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Reusable Button Widget
  Widget _buildLoginButton({
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 3,
        ),
        child: Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
