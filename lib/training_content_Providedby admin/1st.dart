import 'package:flutter/material.dart';
import 'package:mental_healthcare/frontend/widgets/appcolors.dart';

class MentalHealthIntroScreen extends StatelessWidget {
  const MentalHealthIntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF5F7FA), Color(0xFFE4ECF5)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _premiumAppBar(context),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: section(
                          "Introduction to Mental Health First Aid",
                          Icons.info_outline,
                        ),
                      ),

                      glassCard("Training Overview", [
                        chip("Early recognition of mental health challenges"),
                        chip("Support & guide others to care"),
                        chip("Reduce stigma and promote openness"),
                        chip("Strengthen workplace well-being"),
                      ]),

                      glassCard("MHFA IS", [
                        chip("Bridge between distress & professional help"),
                        chip("Structured listening & referral method"),
                        chip("For non-clinical responders"),
                        chip("Empathy & safety focused"),
                      ]),

                      glassCard("MHFA IS NOT", [
                        chip("Therapy or counseling"),
                        chip("Mental illness diagnosis"),
                        chip("Replacement for professionals"),
                        chip("Control over behavior"),
                      ]),

                      section("Real-Life Examples", Icons.psychology),

                      highlightCard(
                        "If an employee withdraws from meetings, MHFA teaches how to start a supportive conversation without pressure.",
                      ),
                      highlightCard(
                        "If someone appears tearful or detached, MHFA helps you approach safely and respectfully.",
                      ),

                      section("Common Misconceptions", Icons.error_outline),

                      glassCard("", [
                        chip("MHFA ≠ CPR (it supports, not fixes)"),
                        chip("Talking about suicide saves lives"),
                        chip("Anyone can provide MHFA"),
                      ]),

                      section("Discussion Exercise", Icons.forum_outlined),

                      discussionCard([
                        "What fears do you have about discussing mental health?",
                        "Where did your earliest ideas about mental illness come from?",
                      ]),

                      section("Foundational Definitions", Icons.menu_book),

                      definitionTile(
                        title: "Mental Health",
                        description:
                            "Ability to manage emotions, relationships, work, and stress.",
                      ),
                      definitionTile(
                        title: "Mental Illness",
                        description:
                            "Clinically significant changes in thoughts or behavior.",
                      ),
                      definitionTile(
                        title: "Crisis",
                        description:
                            "Risk of harm or inability to manage daily needs.",
                      ),

                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),

              /// PREMIUM FINISH BUTTON
              Padding(
                padding: const EdgeInsets.all(16),
                child: GestureDetector(
                  onTap: () => _showFinishDialog(context),
                  child: Container(
                    height: 55,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.primary, AppColors.accent],
                      ),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        "Finish",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =================== PREMIUM APP BAR ===================
  Widget _premiumAppBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [AppColors.primary, AppColors.accent]),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_ios, color: Colors.white, size: 28),
          ),
          SizedBox(width: 50),
          Center(
            child: Text(
              "Mental Health First Aid",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =================== SECTION ===================
  Widget section(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Icon(icon, color: Colors.deepPurple),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  // =================== GLASS CARD ===================
  Widget glassCard(String title, List<Widget> children) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.85),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title.isNotEmpty)
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          const SizedBox(height: 10),
          ...children,
        ],
      ),
    );
  }

  // =================== GRADIENT CHIP ===================
  Widget chip(String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF43CEA2), Color(0xFF185A9D)],
        ),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Text(text, style: const TextStyle(color: Colors.white)),
    );
  }

  // =================== HIGHLIGHT CARD ===================
  Widget highlightCard(String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFF1EB), Color(0xFFACE0F9)],
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(text),
    );
  }

  // =================== DISCUSSION ===================
  Widget discussionCard(List<String> items) {
    return glassCard("", items.map((e) => chip(e)).toList());
  }

  // =================== DEFINITION TILE ===================
  Widget definitionTile({required String title, required String description}) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 6),
      leading: const Icon(Icons.circle, size: 12, color: Colors.deepPurple),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(description),
    );
  }

  // =================== FINISH DIALOG ===================
  void _showFinishDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.emoji_events, color: Colors.white, size: 70),
              const SizedBox(height: 12),
              const Text(
                "Congratulations!",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "You’ve completed the Mental Health First Aid introduction.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  // final read = Authentication();
                  // read.reading_completed(module_no: 1);
                  // ScaffoldMessenger.of(context).showSnackBar(
                  //   const SnackBar(
                  //     content: Text("Reading marked as completed."),
                  //   ),
                  // );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  "Continue",
                  style: TextStyle(color: Colors.deepPurple),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
