import 'package:flutter/material.dart';
import 'package:mental_healthcare/admin/upload_content/video_uplaod/video_upload_UI.dart';
import 'package:mental_healthcare/admin/upload_content/upload_quiz/Mcqs_upload.dart';

class AdminUploadPanel extends StatefulWidget {
  const AdminUploadPanel({super.key});

  @override
  State<AdminUploadPanel> createState() => _AdminUploadPanelState();
}

class _AdminUploadPanelState extends State<AdminUploadPanel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   leading: IconButton(
      //     icon: const Icon(Icons.arrow_back),
      //     onPressed: () {
      //       Navigator.pop(context);
      //     },
      // ),
      // title: const Text("Admin Upload Panel"),
      // ),
      backgroundColor: const Color(0xfff4f7fb),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: LayoutBuilder(
          builder: (context, constraints) {
            double width = constraints.maxWidth;

            return SingleChildScrollView(
              child: Wrap(
                spacing: 20,
                runSpacing: 20,
                children: [
                  SizedBox(
                    width: getCardWidth(width),
                    height: 160,
                    child: _buildAdminCard(
                      title: "Upload Quiz",
                      icon: Icons.quiz_outlined,
                      color1: const Color(0xff6a11cb),
                      color2: const Color(0xff2575fc),
                      onpress: () {
                        // Navigate to Upload Quiz Screen
                        // Example:
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => QuizUploadScreen()),
                        );
                      },
                    ),
                  ),

                  SizedBox(
                    width: getCardWidth(width),
                    height: 160,
                    child: _buildAdminCard(
                      title: "Upload Video",
                      icon: Icons.video_call_outlined,
                      color1: const Color(0xffee0979),
                      color2: const Color(0xffff6a00),
                      onpress: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AdminVideoUploadScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // ******** RESPONSIVE CARD WIDTH ********
  double getCardWidth(double width) {
    if (width > 1300) return 260; // Large screen
    if (width > 900) return 380; // Medium screen
    return width - 40; // Mobile full width
  }

  // ******** BEAUTIFUL ADMIN CARD ********
  Widget _buildAdminCard({
    required String title,
    required IconData icon,
    required Color color1,
    required Color color2,
    required VoidCallback onpress,
  }) {
    return InkWell(
      onTap: onpress,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color1.withOpacity(0.85), color2.withOpacity(0.85)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: color1.withOpacity(0.25),
              blurRadius: 12,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
        child: Row(
          children: [
            CircleAvatar(
              radius: 32,
              backgroundColor: Colors.white.withOpacity(0.22),
              child: Icon(icon, size: 34, color: Colors.white),
            ),
            const SizedBox(width: 22),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 18),
          ],
        ),
      ),
    );
  }
}
