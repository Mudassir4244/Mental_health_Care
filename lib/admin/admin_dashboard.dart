import 'package:flutter/material.dart';
import 'package:mental_healthcare/admin/reported_problems.dart';
import 'package:mental_healthcare/admin/total_quizes.dart';
import 'package:mental_healthcare/admin/total_users/total_users.dart';
import 'package:mental_healthcare/admin/training/admin_training_list.dart';

class DesktopDashboard extends StatelessWidget {
  const DesktopDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    // Large screen → row  | Small screen → column
    final crossAxisCount = width > 900 ? 4 : 2;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: GridView(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.4,
        ),
        children: [
          DashboardCard(
            title: "Total Users",
            icon: Icons.people,
            color1: const Color(0xff6a11cb),
            color2: const Color(0xff2575fc),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TotalSummary()),
              );
            },
          ),

          DashboardCard(
            title: "Total Quizzes",
            icon: Icons.quiz,
            color1: const Color(0xff11998e),
            color2: const Color(0xff38ef7d),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TotalQuizes()),
              );
            },
          ),

          // DashboardCard(
          //   title: "Total Videos",
          //   icon: Icons.video_library,
          //   color1: const Color(0xffee0979),
          //   color2: const Color(0xffff6a00),
          //   onTap: () {
          //     // Navigator.push(context,
          //     //     MaterialPageRoute(builder: (_) =>  ()));
          //   },
          // ),
          DashboardCard(
            title: "Total Reports",
            icon: Icons.report,
            color1: const Color(0xfffc4a1a),
            color2: const Color(0xfff7b733),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AdminSupportPanel()),
              );
            },
          ),

          DashboardCard(
            title: "Training Modules",
            icon: Icons.school,
            color1: const Color(0xff00b09b),
            color2: const Color(0xff96c93d),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => AdminTrainingListScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}

class DashboardCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color1;
  final Color color2;
  final VoidCallback onTap;

  const DashboardCard({
    super.key,
    required this.title,
    required this.icon,
    required this.color1,
    required this.color2,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [color1, color2],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: color1.withOpacity(0.4),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, size: 40, color: Colors.white),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
