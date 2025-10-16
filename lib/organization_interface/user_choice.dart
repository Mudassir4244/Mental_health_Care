import 'package:flutter/material.dart';
import 'package:mental_healthcare/organization_interface/create_organization.dart';
import 'package:mental_healthcare/organization_interface/join_organization.dart';
import 'package:mental_healthcare/organization_interface/organization_fee.dart';
import 'package:mental_healthcare/widgets/appcolors.dart'; // ✅ Use your color file

class OrganizationOptionScreen extends StatelessWidget {
  const OrganizationOptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back_ios),
        ),
        title: const Text(
          "Organization Portal",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        elevation: 4,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),

              // 🏢 Header Icon
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withOpacity(0.1),
                ),
                padding: const EdgeInsets.all(30),
                child: const Icon(
                  Icons.apartment_rounded,
                  color: AppColors.primary,
                  size: 60,
                ),
              ),

              const SizedBox(height: 25),

              // ✨ Title and subtitle
              const Text(
                "Welcome to Organization Portal",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textColorPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                "You can either join an existing organization or create a new one for your team.",
                style: TextStyle(
                  fontSize: 15,
                  color: AppColors.textColorSecondary.withOpacity(0.9),
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 50),

              // 🧩 Two options
              // _OptionCard(
              //   title: "Join Organization",
              //   icon: Icons.group_add_rounded,
              //   color: AppColors.accent,
              //   onTap: () {
              //     // TODO: Navigate to join screen
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(builder: (_) => JoinOrganizationScreen()),
              //     );
              //   },
              // ),
              const SizedBox(height: 20),

              _OptionCard(
                title: "Create Organization",
                icon: Icons.add_business_rounded,
                color: AppColors.primary,
                onTap: () {
                  // TODO: Navigate to create screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CreateOrganizationScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 🌟 Reusable Option Card Widget
class _OptionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _OptionCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        decoration: BoxDecoration(
          color: AppColors.cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(14),
              child: Icon(icon, color: color, size: 30),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textColorPrimary,
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 18),
          ],
        ),
      ),
    );
  }
}
