import 'package:flutter/material.dart';
import 'package:mental_healthcare/frontend/widgets/appcolors.dart';
// import '../theme/app_colors.dart'; // adjust path if needed

class HelpNowScreen extends StatelessWidget {
  const HelpNowScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black54),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top "Call for help!" button
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 18),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.8),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text(
                  "Call for help!",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 25),

            // Cards List
            _buildHelpCard(
              context,
              icon: Icons.call_outlined,
              title: "Call 988",
            ),
            const SizedBox(height: 15),

            _buildHelpCard(
              context,
              icon: Icons.phone_forwarded_outlined,
              title: "Call Local Crisis Line",
            ),
            const SizedBox(height: 15),

            _buildHelpCard(
              context,
              icon: Icons.message_outlined,
              title: "Send SMS to Friend",
            ),
            const SizedBox(height: 15),

            _buildHelpCard(
              context,
              icon: Icons.mic_none_outlined,
              title: "Guided Voice Coach",
            ),
          ],
        ),
      ),

      // Bottom Navigation Bar (similar to screenshot)
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.9),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const [
            Icon(Icons.home, color: Colors.white),
            Icon(Icons.bookmark_border, color: Colors.white),
            Icon(Icons.school, color: Colors.white),
            Icon(Icons.layers_outlined, color: Colors.white),
            Icon(Icons.person_outline, color: Colors.white),
          ],
        ),
      ),
    );
  }

  Widget _buildHelpCard(
    BuildContext context, {
    required IconData icon,
    required String title,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.deepPurpleAccent),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios_rounded,
          color: Colors.black38,
          size: 18,
        ),
        onTap: () {
          // TODO: Add actual action (e.g. call, SMS, etc.)
        },
      ),
    );
  }
}
