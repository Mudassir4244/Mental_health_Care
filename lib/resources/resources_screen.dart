import 'package:flutter/material.dart';
import 'package:mental_healthcare/frontend/customer_interface/checkin.dart';
import 'package:mental_healthcare/frontend/widgets/appcolors.dart';
import 'package:mental_healthcare/resources/mental_health_articles.dart';
import 'package:mental_healthcare/resources/nearest_practitioner/nearest_doctors.dart';
import 'package:mental_healthcare/resources/podcast_audio_screen.dart';

class ResourcesScreen extends StatelessWidget {
  const ResourcesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primary, AppColors.accent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Resources",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
                children: [
                  ResourceTile(
                    OnTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MentalHealthArticles(),
                        ),
                      );
                    },
                    icon: Icons.library_books_outlined,
                    title: "Mental Health Articles",
                    subtitle: "Read verified guides and expert tips",
                  ),

                  ResourceTile(
                    OnTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => NearestHospitalsScreen(),
                        ),
                      );
                    },
                    icon: Icons.local_hospital_outlined,
                    title: "Nearby Clinics & Help Centers",
                    subtitle: "Find professional help around you",
                  ),
                  ResourceTile(
                    icon: Icons.podcasts_outlined,
                    title: "Podcasts & Audio Therapy",
                    subtitle: "Relax your mind with expert audio sessions",
                    OnTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const PodcastAudioScreen(),
                        ),
                      );
                    },
                  ),
                  ResourceTile(
                    icon: Icons.self_improvement_outlined,
                    title: "Self-care & Journaling Tools",
                    subtitle: "Track mood, gratitude, and emotions",
                    OnTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => CheckInScreen()),
                      );
                    },
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
  final OnTap;
  const ResourceTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.OnTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: OnTap,
      child: Card(
        color: AppColors.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
        ),
      ),
    );
  }
}
