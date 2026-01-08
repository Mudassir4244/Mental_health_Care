import 'package:flutter/material.dart';
import 'package:mental_healthcare/frontend/widgets/appcolors.dart';

class MentalHealthDisordersScreen extends StatelessWidget {
  const MentalHealthDisordersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF5F7FA), Color(0xFFE8ECF4)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _header(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      sectionTitle("Anxiety Disorders", Icons.psychology),

                      gradientCard("Common Symptoms", Colors.blue, [
                        chip("Dry mouth, muscle tension, dizziness"),
                        chip("Fear of failure & intrusive thoughts"),
                        chip("Avoidance, procrastination, irritability"),
                      ]),

                      gradientCard("Workplace Examples", Colors.blueAccent, [
                        chip("Repeated reassurance seeking"),
                        chip("Avoids calls or emails"),
                        chip("Freezes during presentations"),
                      ]),

                      responseCard([
                        "I notice you’ve been double-checking things lately. Is everything okay?",
                        "You seem overwhelmed. Would you like to step outside for a moment?",
                      ]),

                      sectionTitle(
                        "Depressive Disorders",
                        Icons.cloud_outlined,
                      ),

                      gradientCard("Symptoms", Colors.indigo, [
                        chip("Guilt, worthlessness"),
                        chip("Difficulty concentrating"),
                        chip("Fatigue & appetite changes"),
                      ]),

                      gradientCard(
                        "Workplace Indicators",
                        Colors.indigoAccent,
                        [
                          chip("Reduced work quality"),
                          chip("Hopeless statements"),
                          chip("Unusual mistakes"),
                        ],
                      ),

                      responseCard([
                        "Thank you for sharing. You’re not alone.",
                        "It sounds like you’ve been carrying a lot. How long has this been going on?",
                      ]),

                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: sectionTitle(
                          "Trauma & Stressor-Related Disorders",
                          Icons.warning_amber,
                        ),
                      ),

                      gradientCard("Trauma Symptoms", Colors.orange, [
                        chip("Emotional numbness"),
                        chip("Difficulty trusting"),
                        chip("Nightmares & anger"),
                      ]),

                      responseCard([
                        "Would you prefer sitting near the door or window?",
                        "Take your time—there’s no rush.",
                        "Would grounding exercises help right now?",
                      ]),

                      sectionTitle(
                        "Substance Use Disorders",
                        Icons.local_bar_outlined,
                      ),

                      gradientCard("Warning Signs", Colors.redAccent, [
                        chip("Frequent lateness"),
                        chip("Mood swings & hygiene issues"),
                        chip("Money problems"),
                        chip("Declining productivity"),
                      ]),

                      responseCard([
                        "I care about you and noticed some changes.",
                        "How are things going lately? I’m here to listen.",
                      ]),

                      warningCard([
                        "Why can’t you just stop?",
                        "You’re ruining your career.",
                      ]),

                      sectionTitle("Psychosis", Icons.visibility_off),

                      gradientCard("Symptoms", Colors.purple, [
                        chip("Paranoia or suspicion"),
                        chip("Disorganized speech"),
                        chip("Difficulty with reality"),
                      ]),

                      responseCard([
                        "I’m sorry you’re experiencing this—it must be frightening.",
                        "Let’s sit together where you feel safe.",
                      ]),

                      sectionTitle(
                        "Self-Harm & Suicidality",
                        Icons.favorite_border,
                      ),

                      gradientCard("Warning Signs", Colors.deepOrange, [
                        chip("Cutting or burning"),
                        chip("Sudden withdrawal"),
                        chip("Sudden calm after despair"),
                      ]),

                      responseCard([
                        "Your feelings are valid. Thank you for trusting me.",
                        "Let’s contact someone who can help keep you safe. I can stay with you.",
                      ]),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================= HEADER =================
  Widget _header() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Text(
          "Understanding Mental Health Disorders",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // ================= SECTION TITLE =================
  Widget sectionTitle(String title, IconData icon) {
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

  // ================= GRADIENT CARD =================
  Widget gradientCard(String title, Color color, List<Widget> items) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.15), color.withOpacity(0.05)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ...items,
        ],
      ),
    );
  }

  // ================= CHIP =================
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

  // ================= RESPONSE CARD =================
  Widget responseCard(List<String> responses) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: responses
            .map(
              (e) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text("• $e"),
              ),
            )
            .toList(),
      ),
    );
  }

  // ================= WARNING CARD =================
  Widget warningCard(List<String> warnings) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.red.shade100, Colors.red.shade50],
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: warnings
            .map(
              (e) => Text(
                "✗ $e",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

void _showFinishDialog(BuildContext context) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: "Finish",
    transitionDuration: const Duration(milliseconds: 400),
    pageBuilder: (_, __, ___) {
      return Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Color(0xFF43CEA2), Color(0xFF185A9D)],
                    ),
                  ),
                  child: const Icon(
                    Icons.celebration,
                    color: Colors.white,
                    size: 48,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Well Done!",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Text(
                  "You’ve completed the Self-Care section.\nTake a moment to appreciate yourself.",
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF43CEA2), Color(0xFF185A9D)],
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    //   final read = Authentication();
                    //   read.reading_completed(module_no: 3);
                    //   ScaffoldMessenger.of(context).showSnackBar(
                    //     const SnackBar(
                    //       content: Text("Reading marked as completed."),
                    //     ),
                    //   );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      "Continue",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
    transitionBuilder: (_, animation, __, child) {
      return Transform.scale(
        scale: animation.value,
        child: Opacity(opacity: animation.value, child: child),
      );
    },
  );
}
