import 'package:flutter/material.dart';
import 'package:mental_healthcare/frontend/widgets/appcolors.dart';

class JoinOrganizationScreen extends StatelessWidget {
  const JoinOrganizationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 🔹 Dummy organization data
    final List<Map<String, String>> dummyOrganizations = [
      {"name": "MindAssist Foundation", "tagline": "Connecting hearts & minds"},
      {"name": "Peaceful Path", "tagline": "Walk together toward calm"},
      {"name": "NeuroCare Center", "tagline": "For a healthier mind"},
      {"name": "Calm Minds Clinic", "tagline": "Therapy that listens"},
      {"name": "Serenity Mental Health", "tagline": "Restoring balance"},
    ];

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back_ios),
        ),
        title: const Text(
          "Join Organization",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primary,
      ),
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: dummyOrganizations.length,
          itemBuilder: (context, index) {
            final org = dummyOrganizations[index];
            return Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.primary.withOpacity(0.1),
                  child: const Icon(Icons.business, color: AppColors.primary),
                ),
                title: Text(
                  org["name"]!,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textColorPrimary,
                  ),
                ),
                subtitle: Text(
                  org["tagline"]!,
                  style: const TextStyle(color: AppColors.textColorSecondary),
                ),
                trailing: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Request sent to join ${org["name"]!} ✅"),
                      ),
                    );
                  },
                  child: const Text(
                    "Join",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
