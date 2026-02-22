// import 'package:flutter/material.dart';

// class MentalHealthSelfCareScreen extends StatelessWidget {
//   const MentalHealthSelfCareScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         iconTheme: IconThemeData(color: Colors.white),
//         elevation: 0,
//         centerTitle: true,
//         title: const Text(
//           'Self-Care for MHFA Helpers',
//           style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
//         ),
//         flexibleSpace: Container(
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//           ),
//         ),
//       ),

//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             sectionTitle(Icons.info, "Overview: Role of Self-Care"),
//             infoCard(
//               title: "",
//               content: [
//                 bullet(
//                   "Self-care is essential for instructors and participants supporting others.",
//                 ),
//                 bullet(
//                   "Without self-care, helpers risk fatigue, burnout, vicarious trauma, and reduced capacity.",
//                 ),
//                 bullet(
//                   "This section provides strategies, discussion prompts, and tools to understand and implement self-care.",
//                 ),
//               ],
//             ),

//             sectionTitle(Icons.favorite, "Why Self-Care Matters"),
//             infoCard(
//               title: "",
//               content: [
//                 bullet("Enhances resilience & coping capacity"),
//                 bullet("Prevents burnout & compassion fatigue"),
//                 bullet("Improves decision-making under pressure"),
//                 bullet("Supports long-term mental and physical health"),
//                 bullet("Models healthy behavior for others"),
//               ],
//             ),

//             sectionTitle(Icons.category, "Key Types of Self-Care"),
//             infoCard(
//               title: "1. Physical Self-Care",
//               content: [
//                 bullet("Regular physical activity (walking, yoga, stretching)"),
//                 bullet("Adequate sleep hygiene routines"),
//                 bullet("Nourishing meals and hydration"),
//                 bullet("Rest breaks during stressful workdays"),
//                 bullet("Medical or preventive appointments"),
//                 bullet(
//                   "Instructor Tip: Physical symptoms often appear first when stressed (headaches, fatigue, tension).",
//                 ),
//               ],
//             ),
//             infoCard(
//               title: "2. Emotional Self-Care",
//               content: [
//                 bullet("Talk with a trusted friend or counselor"),
//                 bullet("Journaling or expressive writing"),
//                 bullet("Mindfulness or grounding techniques"),
//                 bullet("Allow emotions without judgment"),
//                 bullet("Set healthy emotional boundaries"),
//                 bullet(
//                   "Activity: Identify an emotion you frequently suppress and discuss healthy expression.",
//                 ),
//               ],
//             ),
//             infoCard(
//               title: "3. Psychological/Mental Self-Care",
//               content: [
//                 bullet("Engage in hobbies or creative activities"),
//                 bullet("Reading, podcasts, or learning something new"),
//                 bullet("Limit exposure to negative media content"),
//                 bullet("Practice positive self-talk or reframing"),
//                 bullet("Use time-management and organizational tools"),
//                 bullet(
//                   "Instructor Note: Small routines like checklists can reduce mental clutter and stress.",
//                 ),
//               ],
//             ),
//             infoCard(
//               title: "4. Social Self-Care",
//               content: [
//                 bullet("Spend time with supportive people"),
//                 bullet("Participate in community or cultural groups"),
//                 bullet("Schedule regular check-ins with loved ones"),
//                 bullet("Ask for help when needed"),
//                 bullet("Reduce time with draining individuals"),
//                 bullet(
//                   "Discussion Prompt: What social interactions energize or drain you? How can you adjust balance?",
//                 ),
//               ],
//             ),
//             infoCard(
//               title: "5. Professional/Occupational Self-Care",
//               content: [
//                 bullet("Set boundaries around workload and availability"),
//                 bullet("Take breaks without guilt"),
//                 bullet("Seek supervision or peer support"),
//                 bullet("Prioritize tasks realistically"),
//                 bullet("Maintain work-life integration"),
//                 bullet(
//                   "Instructor Tip: Early workplace stress management prevents burnout.",
//                 ),
//               ],
//             ),
//             infoCard(
//               title: "6. Spiritual Self-Care",
//               content: [
//                 bullet("Practice gratitude"),
//                 bullet("Spend time in nature"),
//                 bullet("Meditation or prayer"),
//                 bullet("Volunteering"),
//                 bullet("Values-based activities promoting inner peace"),
//               ],
//             ),

//             SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: sectionTitle(
//                 Icons.warning_amber,
//                 "Recognizing Early Warning Signs of Stress",
//               ),
//             ),
//             infoCard(
//               title: "",
//               content: [
//                 bullet(
//                   "Physical: Fatigue, headaches, muscle tension, frequent illness",
//                 ),
//                 bullet(
//                   "Emotional: Irritability, anxiety, feeling overwhelmed, numbness",
//                 ),
//                 bullet(
//                   "Cognitive: Difficulty concentrating, forgetfulness, racing thoughts",
//                 ),
//                 bullet(
//                   "Behavioral: Withdrawal, appetite changes, increased substance use, procrastination",
//                 ),
//                 bullet(
//                   "Professional: Low motivation, reduced productivity, frustration, absenteeism",
//                 ),
//                 bullet(
//                   "Quick Exercise: Identify your top three personal warning signs.",
//                 ),
//               ],
//             ),

//             SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: sectionTitle(
//                 Icons.edit,
//                 "Building a Personalized Self-Care Plan",
//               ),
//             ),
//             infoCard(
//               title: "Step 1: Identify Current Stressors",
//               content: [
//                 bullet("Workplace demands"),
//                 bullet("Personal responsibilities"),
//                 bullet("Caregiving roles"),
//                 bullet("Environmental or financial stressors"),
//               ],
//             ),
//             infoCard(
//               title: "Step 2: Identify Existing Strengths & Supports",
//               content: [
//                 bullet("What is already working well?"),
//                 bullet("What helps during difficult times?"),
//               ],
//             ),
//             infoCard(
//               title: "Step 3: Choose 3–5 Realistic Self-Care Activities",
//               content: [
//                 bullet("Daily: hydration, movement"),
//                 bullet("Weekly: social time, hobbies"),
//                 bullet("Monthly: therapy session, nature day"),
//               ],
//             ),
//             infoCard(
//               title: "Step 4: Set Boundaries",
//               content: [
//                 bullet(
//                   "“I will not respond to non-urgent messages after 7 p.m.”",
//                 ),
//                 bullet("“I will take my lunch break away from my desk.”"),
//               ],
//             ),
//             infoCard(
//               title: "Step 5: Identify Barriers & Solutions",
//               content: [
//                 bullet(
//                   "Barrier: “I don’t have time.” → Solution: Start with 5-minute practices",
//                 ),
//                 bullet(
//                   "Barrier: “I feel guilty resting.” → Solution: Reframe rest as essential for productivity",
//                 ),
//               ],
//             ),
//             infoCard(
//               title: "Step 6: Create a Maintenance & Review Schedule",
//               content: [
//                 bullet("Weekly check-ins"),
//                 bullet("Monthly reflection"),
//                 bullet("After stressful life events"),
//               ],
//             ),

//             const SizedBox(height: 80),
//           ],
//         ),
//       ),

//       /// FINISH BUTTON
//       // floatingActionButton: ElevatedButton.icon(
//       //   onPressed: () => _showFinishDialog(context),
//       //   icon: const Icon(Icons.check_circle),
//       //   label: const Text("Finish"),
//       //   style: ElevatedButton.styleFrom(
//       //     padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
//       //     shape: RoundedRectangleBorder(
//       //       borderRadius: BorderRadius.circular(30),
//       //     ),
//       //   ),
//       // ),
//       bottomNavigationBar: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Container(
//           decoration: BoxDecoration(
//             gradient: const LinearGradient(
//               colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
//             ),
//             borderRadius: BorderRadius.circular(30),
//           ),
//           child: ElevatedButton.icon(
//             onPressed: () => _showFinishDialog(context),
//             icon: const Icon(Icons.check_circle, color: Colors.white),
//             label: const Text("Finish", style: TextStyle(color: Colors.white)),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.transparent,
//               shadowColor: Colors.transparent,
//               padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(30),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   /// ================== DIALOG ==================
//   void _showFinishDialog(BuildContext context) {
//     showGeneralDialog(
//       context: context,
//       barrierDismissible: true,
//       barrierLabel: "Finish",
//       transitionDuration: const Duration(milliseconds: 400),
//       pageBuilder: (_, __, ___) {
//         return Center(
//           child: Material(
//             color: Colors.transparent,
//             child: Container(
//               margin: const EdgeInsets.symmetric(horizontal: 24),
//               padding: const EdgeInsets.all(24),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   const Icon(Icons.celebration, color: Colors.green, size: 60),
//                   const SizedBox(height: 12),
//                   const Text(
//                     "Well Done!",
//                     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 8),
//                   const Text(
//                     "You have successfully completed the Self-Care for Mental Health First Aid Helpers section.",
//                     textAlign: TextAlign.center,
//                   ),
//                   const SizedBox(height: 20),
//                   Container(
//                     decoration: BoxDecoration(
//                       gradient: const LinearGradient(
//                         colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
//                       ),
//                       borderRadius: BorderRadius.circular(30),
//                     ),
//                     child: ElevatedButton(
//                       onPressed: () => Navigator.pop(context),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.transparent,
//                         shadowColor: Colors.transparent,
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 32,
//                           vertical: 14,
//                         ),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(30),
//                         ),
//                       ),
//                       child: const Text(
//                         "Continue",
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 16,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//       transitionBuilder: (_, animation, __, child) {
//         return Transform.scale(
//           scale: animation.value,
//           child: Opacity(opacity: animation.value, child: child),
//         );
//       },
//     );
//   }

//   /// ================== UI HELPERS ==================

//   Widget sectionTitle(IconData icon, String text) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 14),
//       child: Row(
//         children: [
//           Icon(icon, color: Colors.blue),
//           const SizedBox(width: 8),
//           Text(
//             text,
//             style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget infoCard({required String title, required List<Widget> content}) {
//     return Card(
//       elevation: 4,
//       margin: const EdgeInsets.only(bottom: 12),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             if (title.isNotEmpty)
//               Text(
//                 title,
//                 style: const TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             const SizedBox(height: 8),
//             ...content,
//           ],
//         ),
//       ),
//     );
//   }

//   Widget bullet(String text) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 6),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Icon(Icons.check_circle_outline, size: 18, color: Colors.green),
//           const SizedBox(width: 6),
//           Expanded(child: Text(text)),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';

class MentalHealthSelfCareScreen extends StatelessWidget {
  const MentalHealthSelfCareScreen({super.key});

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFF1F3F8),

        // appBar: AppBar(
        //   elevation: 0,
        //   centerTitle: true,
        //   iconTheme: const IconThemeData(color: Colors.white),
        //   title: const Text(
        //     'Self-Care for MHFA Helpers',
        //     style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        //   ),
        //   flexibleSpace: Container(
        //     decoration: const BoxDecoration(gradient: primaryGradient),
        //   ),
        // ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// ================= HERO HEADER =================
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 28, 20, 36),
                decoration: const BoxDecoration(
                  gradient: primaryGradient,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(28),
                    bottomRight: Radius.circular(28),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.arrow_back_ios_outlined,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Self-Care for MHFA Helpers',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                      ),
                    ),
                    Text(
                      "Care for Yourself\nWhile Caring for Others",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        height: 1.3,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      "Mental Health First Aid starts with your own wellbeing. "
                      "This guide helps you stay balanced, resilient, and effective.",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    sectionBlock(
                      Icons.info_outline,
                      "Overview: Role of Self-Care",
                    ),
                    enhancedCard([
                      bullet(
                        "Self-care is essential for instructors and participants supporting others.",
                      ),
                      bullet(
                        "Without self-care, helpers risk fatigue, burnout, and vicarious trauma.",
                      ),
                      bullet(
                        "This section provides strategies and tools to build sustainable support.",
                      ),
                    ]),

                    sectionBlock(
                      Icons.favorite_outline,
                      "Why Self-Care Matters",
                    ),
                    enhancedCard([
                      bullet("Enhances resilience and emotional regulation"),
                      bullet("Prevents burnout and compassion fatigue"),
                      bullet("Improves clarity under pressure"),
                      bullet("Supports long-term mental and physical health"),
                    ]),

                    sectionBlock(
                      Icons.category_outlined,
                      "Key Types of Self-Care",
                    ),

                    enhancedCard([
                      titleText("Physical Self-Care"),
                      bullet("Regular physical activity"),
                      bullet("Sleep hygiene routines"),
                      bullet("Healthy meals and hydration"),
                      bullet("Preventive medical care"),
                    ]),

                    enhancedCard([
                      titleText("Emotional Self-Care"),
                      bullet("Talking with trusted people"),
                      bullet("Mindfulness and grounding"),
                      bullet("Healthy emotional boundaries"),
                    ]),

                    enhancedCard([
                      titleText("Psychological / Mental Self-Care"),
                      bullet("Creative hobbies"),
                      bullet("Positive self-talk"),
                      bullet("Limiting negative media"),
                    ]),

                    enhancedCard([
                      titleText("Social Self-Care"),
                      bullet("Supportive relationships"),
                      bullet("Community engagement"),
                      bullet("Asking for help"),
                    ]),

                    enhancedCard([
                      titleText("Professional Self-Care"),
                      bullet("Workload boundaries"),
                      bullet("Breaks without guilt"),
                      bullet("Work-life balance"),
                    ]),

                    enhancedCard([
                      titleText("Spiritual Self-Care"),
                      bullet("Gratitude"),
                      bullet("Nature connection"),
                      bullet("Meditation or prayer"),
                    ]),

                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ],
          ),
        ),

        /// ================= FINISH BUTTON =================
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(20),
          child: Container(
            decoration: BoxDecoration(
              gradient: primaryGradient,
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// ================= DIALOG =================
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
                      gradient: primaryGradient,
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
                      gradient: primaryGradient,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        // final read = Authentication();
                        // read.reading_completed(module_no: 9);
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

  /// ================= UI HELPERS =================

  Widget sectionBlock(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 18),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: primaryGradient,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget enhancedCard(List<Widget> children) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget titleText(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );
  }

  Widget bullet(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle, size: 18, color: Colors.green),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
