import 'package:flutter/material.dart';
import 'package:mental_healthcare/frontend/widgets/appcolors.dart';

class ResourcesScreen extends StatelessWidget {
  const ResourcesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Resources",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                "Helpful Resources for Your Well-being",
                style: TextStyle(
                  color: AppColors.textColorPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Resource cards
            Expanded(
              child: ListView(
                children: const [
                  ResourceTile(
                    icon: Icons.library_books_outlined,
                    title: "Mental Health Articles",
                    subtitle: "Read verified guides and expert tips",
                  ),
                  ResourceTile(
                    icon: Icons.videocam_outlined,
                    title: "Video Therapy Sessions",
                    subtitle: "Watch guided videos from experts",
                  ),
                  ResourceTile(
                    icon: Icons.local_hospital_outlined,
                    title: "Nearby Clinics & Help Centers",
                    subtitle: "Find professional help around you",
                  ),
                  ResourceTile(
                    icon: Icons.podcasts_outlined,
                    title: "Podcasts & Audio Therapy",
                    subtitle: "Relax your mind with expert audio sessions",
                  ),
                  ResourceTile(
                    icon: Icons.self_improvement_outlined,
                    title: "Self-care & Journaling Tools",
                    subtitle: "Track mood, gratitude, and emotions",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ResourceTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const ResourceTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon, color: AppColors.accent, size: 30),
        title: Text(
          title,
          style: const TextStyle(
            color: AppColors.textColorPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            color: AppColors.textColorSecondary,
            fontSize: 13,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Opening $title..."),
              duration: const Duration(seconds: 1),
            ),
          );
        },
      ),
    );
  }
}
