import 'package:flutter/material.dart';
import 'package:mental_healthcare/backend/customer.dart';

class AlgeeActionPlanScreen extends StatelessWidget {
  const AlgeeActionPlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF11998E), Color(0xFF38EF7D)],
            ),
            borderRadius: BorderRadius.circular(30),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 14,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: ElevatedButton.icon(
            onPressed: () => _showFinishDialog(context),
            icon: const Icon(Icons.check_circle, color: Colors.white),
            label: const Text(
              "Finish",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF4F7FA), Color(0xFFE6ECF2)],
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
                      sectionTitle(
                        "A. Assess for Risk of Suicide or Harm",
                        Icons.report_problem,
                      ),

                      questionCard([
                        "Have you thought about how you might harm yourself?",
                        "Do you have access to anything that could be used to hurt yourself?",
                      ]),

                      actionCard(Colors.red, [
                        "Check for immediate danger",
                        "Remove access to harmful objects (if safe)",
                        "Stay calm and speak clearly",
                      ]),

                      sectionTitle("B. Listen Nonjudgmentally", Icons.hearing),

                      skillCard(Colors.blue, [
                        "Maintain eye contact, nod gently",
                        "Lean slightly forward",
                        "Validate emotions, not behaviors",
                        "Use a warm and calm tone",
                      ]),

                      exampleCard([
                        "It makes sense you feel overwhelmed given what you’re going through.",
                        "I’m here, and I’m listening.",
                      ]),

                      sectionTitle(
                        "C. Give Reassurance & Information",
                        Icons.favorite_outline,
                      ),

                      reassuranceCard([
                        "What you’re experiencing is treatable.",
                        "There are professionals who can help with this.",
                      ]),

                      sectionTitle(
                        "D. Encourage Professional Help",
                        Icons.medical_services_outlined,
                      ),

                      actionCard(Colors.purple, [
                        "Community behavioral health centers",
                        "Peer support specialists",
                        "Faith-based counselors (if preferred)",
                        "Crisis stabilization units",
                      ]),

                      sectionTitle(
                        "E. Encourage Self-Help & Support Strategies",
                        Icons.self_improvement,
                      ),

                      actionCard(Colors.green, [
                        "Healthy sleep habits",
                        "Daily routine building",
                        "Creative outlets (art, music, journaling)",
                        "Mindfulness or breathing apps",
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
                  final read = Authentication();
                  read.reading_completed(module_no: 3);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Reading marked as completed."),
                    ),
                  );
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

  // ================= HEADER =================
  Widget _header() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF11998E), Color(0xFF38EF7D)],
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      child: const Center(
        child: Text(
          "The ALGEE Action Plan",
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
      padding: const EdgeInsets.symmetric(vertical: 18),
      child: Row(
        children: [
          Icon(icon, color: Colors.teal),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  // ================= QUESTION CARD =================
  Widget questionCard(List<String> questions) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFE259), Color(0xFFFFF7D6)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: questions
            .map(
              (q) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  "❓ $q",
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  // ================= ACTION CARD =================
  Widget actionCard(Color color, List<String> actions) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.15), color.withOpacity(0.05)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: actions
            .map(
              (a) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Icon(Icons.check_circle, color: color),
                    const SizedBox(width: 10),
                    Expanded(child: Text(a)),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  // ================= SKILL CARD =================
  Widget skillCard(Color color, List<String> skills) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
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
        children: skills
            .map(
              (s) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Icon(Icons.circle, size: 10, color: color),
                    const SizedBox(width: 10),
                    Expanded(child: Text(s)),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  // ================= EXAMPLE CARD =================
  Widget exampleCard(List<String> examples) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE0EAFC), Color(0xFFCFDEF3)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: examples
            .map(
              (e) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text("💬 \"$e\""),
              ),
            )
            .toList(),
      ),
    );
  }

  // ================= REASSURANCE CARD =================
  Widget reassuranceCard(List<String> messages) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFDCE35B), Color(0xFF45B649)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: messages
            .map(
              (m) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  m,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
