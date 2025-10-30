import 'package:flutter/material.dart';
import 'package:mental_healthcare/frontend/widgets/appcolors.dart';
// import '../theme/app_colors.dart'; // adjust import path if needed

class CheckInScreen extends StatelessWidget {
  const CheckInScreen({super.key});

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
        title: const Text(
          "Daily Check-In",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Container
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 18),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.85),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text(
                  "How are you feeling today?",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 25),

            // Mood Selection Cards
            Wrap(
              spacing: 15,
              runSpacing: 15,
              children: [
                _buildMoodCard(
                  Icons.sentiment_very_satisfied,
                  "Happy",
                  AppColors.success.withOpacity(0.8),
                ),
                _buildMoodCard(
                  Icons.sentiment_satisfied,
                  "Good",
                  Colors.lightBlueAccent.withOpacity(0.8),
                ),
                _buildMoodCard(
                  Icons.sentiment_neutral,
                  "Okay",
                  Colors.amberAccent.withOpacity(0.8),
                ),
                _buildMoodCard(
                  Icons.sentiment_dissatisfied,
                  "Sad",
                  Colors.orangeAccent.withOpacity(0.8),
                ),
                _buildMoodCard(
                  Icons.sentiment_very_dissatisfied,
                  "Stressed",
                  AppColors.error.withOpacity(0.8),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // Notes or Journal Section
            Text(
              "Add a short note (optional)",
              style: TextStyle(
                color: AppColors.textColorPrimary.withOpacity(0.8),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              maxLines: 4,
              decoration: InputDecoration(
                hintText: "Write how you're feeling...",
                filled: true,
                fillColor: AppColors.cardColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 25),

            // Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: handle submission logic
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Check-In submitted!")),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Submit",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),

      // Bottom Navigation Bar (consistent with your app)
      // bottomNavigationBar: Container(
      //   padding: const EdgeInsets.symmetric(vertical: 8),
      //   decoration: BoxDecoration(
      //     color: AppColors.primary.withOpacity(0.9),
      //     borderRadius: const BorderRadius.only(
      //       topLeft: Radius.circular(16),
      //       topRight: Radius.circular(16),
      //     ),
      //   ),
      //   child: Row(
      //     mainAxisAlignment: MainAxisAlignment.spaceAround,
      //     children: const [
      //       Icon(Icons.home, color: Colors.white),
      //       Icon(Icons.bookmark_border, color: Colors.white),
      //       Icon(Icons.school, color: Colors.white),
      //       Icon(Icons.layers_outlined, color: Colors.white),
      //       Icon(Icons.person_outline, color: Colors.white),
      //     ],
      //   ),
      // ),
    );
  }

  Widget _buildMoodCard(IconData icon, String title, Color color) {
    return Container(
      width: 100,
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 1),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              color: AppColors.textColorPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
