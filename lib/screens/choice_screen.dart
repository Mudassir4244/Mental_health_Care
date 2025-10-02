import 'package:flutter/material.dart';
import 'package:mental_healthcare/widgets/appcolors.dart';

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
                    color: const Color(0xFF7B99E5), // Primary color
                  ),
                ),
                const SizedBox(height: 40),

                // Guest Button
                _buildLoginButton(
                  title: "Continue as Guest",
                  color: const Color(0xFF29ADB2), // Accent color
                  onTap: () {
                    // Handle Guest Login
                  },
                ),
                const SizedBox(height: 20),

                // User Button
                _buildLoginButton(
                  title: "Continue as User",
                  color: const Color(0xFF7B99E5), // Primary color
                  onTap: () {
                    // Handle User Login
                  },
                ),
                const SizedBox(height: 20),

                // Doctor Button
                _buildLoginButton(
                  title: "Continue as Doctor",
                  color: Colors.black87, // Contrast with palette
                  onTap: () {
                    // Handle Doctor Login
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
