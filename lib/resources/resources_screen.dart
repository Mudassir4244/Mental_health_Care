import 'package:flutter/material.dart';
import 'package:mental_healthcare/frontend/customer_interface/checkin.dart';
import 'package:mental_healthcare/frontend/widgets/appcolors.dart';
import 'package:mental_healthcare/l10n/app_localizations.dart';
import 'package:mental_healthcare/resources/mental_health_articles.dart';
import 'package:mental_healthcare/resources/nearest_practitioner/nearest_hospital.dart';
import 'package:mental_healthcare/resources/podcast_audio_screen.dart';

class ResourcesScreen extends StatelessWidget {
  const ResourcesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
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
        title: Text(
          loc.resources,
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
              child: Text(
                loc.resources_header,
                // "Helpful Resources for Your Well-being",
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
                    title: loc.mental_health_articles,
                    subtitle: loc.mental_health_articles_sub,
                  ),

                  ResourceTile(
                    OnTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => NearbyHospitalsScreen(),
                        ),
                      );
                    },
                    icon: Icons.local_hospital_outlined,
                    title: loc.nearby_clinics,
                    subtitle: loc.nearby_clinics_sub,
                  ),
                  ResourceTile(
                    icon: Icons.podcasts_outlined,
                    title: loc.therapeutic_audios,
                    subtitle: loc.therapeutic_audios_sub,
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
                    title: loc.self_care_tools,
                    subtitle: loc.self_care_tools_sub,
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
