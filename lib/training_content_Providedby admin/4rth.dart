import 'package:flutter/material.dart';

class WorkplaceMhfaScreen extends StatelessWidget {
  const WorkplaceMhfaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF2F80ED), Color(0xFF56CCF2)],
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
            colors: [Color(0xFFF3F6FA), Color(0xFFE9EEF5)],
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
                        "A. Recognizing Workplace Challenges",
                        Icons.work_outline,
                      ),

                      infoCard(Colors.blue, [
                        "Changes in communication style",
                        "Decline in grooming or appearance",
                        "Avoiding social gatherings or meetings",
                      ]),

                      sectionTitle(
                        "B. Legal Considerations",
                        Icons.gavel_outlined,
                      ),

                      splitLegalCard(),

                      sectionTitle(
                        "C. Approaching a Coworker",
                        Icons.people_outline,
                      ),

                      conversationCard([
                        "I care about your wellbeing and wanted to check in.",
                        "You’re not in trouble — I’m simply concerned.",
                      ]),

                      sectionTitle(
                        "D. Crisis Procedures",
                        Icons.warning_amber_outlined,
                      ),

                      crisisCard([
                        "Call security if safety is threatened",
                        "Clear the area if necessary",
                        "Provide calm, clear instructions",
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
                  // final read = Authentication();
                  // read.reading_completed(module_no: 4);
                  // ScaffoldMessenger.of(context).showSnackBar(
                  //   const SnackBar(
                  //     content: Text("Reading marked as completed."),
                  //   ),
                  // );
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
      padding: const EdgeInsets.symmetric(vertical: 26),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF2F80ED), Color(0xFF56CCF2)],
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      child: const Center(
        child: Text(
          "Workplace-Specific MHFA",
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
          Icon(icon, color: Colors.blueGrey),
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

  // ================= INFO CARD =================
  Widget infoCard(Color color, List<String> items) {
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
        children: items
            .map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Icon(Icons.circle, size: 10, color: color),
                    const SizedBox(width: 10),
                    Expanded(child: Text(item)),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  // ================= LEGAL SPLIT CARD =================
  Widget splitLegalCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      child: Row(
        children: [
          Expanded(
            child: legalCard("What You CAN Do", Colors.green, [
              "Discuss performance issues",
              "Offer support and referrals",
              "Provide accommodations information",
            ]),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: legalCard("What You CANNOT Do", Colors.red, [
              "Ask about specific diagnoses",
              "Demand personal medical details",
            ]),
          ),
        ],
      ),
    );
  }

  Widget legalCard(String title, Color color, List<String> items) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, color: color),
          ),
          const SizedBox(height: 10),
          ...items.map(
            (e) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Icon(
                    color == Colors.green ? Icons.check_circle : Icons.cancel,
                    color: color,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Expanded(child: Text(e)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= CONVERSATION CARD =================
  Widget conversationCard(List<String> phrases) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE0EAFC), Color(0xFFCFDEF3)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: phrases
            .map(
              (p) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  "💬 \"$p\"",
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  // ================= CRISIS CARD =================
  Widget crisisCard(List<String> steps) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.red.shade100, Colors.red.shade50],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: steps
            .map(
              (s) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    const Icon(Icons.warning, color: Colors.red),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        s,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
