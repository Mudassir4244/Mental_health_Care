// import 'package:flutter/material.dart';

// class DesktopDashboard extends StatelessWidget {
//   const DesktopDashboard({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final width = MediaQuery.of(context).size.width;

//     // Large screen → row  | Small screen → column
//     final crossAxisCount = width > 900 ? 4 : 1;

//     return Padding(
//       padding: const EdgeInsets.all(20),
//       child: GridView(
//         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: crossAxisCount,
//           crossAxisSpacing: 16,
//           mainAxisSpacing: 16,
//           childAspectRatio: 1.4,
//         ),
//         children: [
//           DashboardCard(
//             title: "Total Users",
//             icon: Icons.people,
//             color1: const Color(0xff6a11cb),
//             color2: const Color(0xff2575fc),
//             onTap: () {
//               // Navigator.push(context,
//               // MaterialPageRoute(builder: (_) => const UsersScreen()));
//             },
//           ),

//           DashboardCard(
//             title: "Total Quizzes",
//             icon: Icons.quiz,
//             color1: const Color(0xff11998e),
//             color2: const Color(0xff38ef7d),
//             onTap: () {
//               // Navigator.push(context,
//               // MaterialPageRoute(builder: (_) => const QuizScreen()));
//             },
//           ),

//           DashboardCard(
//             title: "Total Videos",
//             icon: Icons.video_library,
//             color1: const Color(0xffee0979),
//             color2: const Color(0xffff6a00),
//             onTap: () {
//               // Navigator.push(context,
//               //     MaterialPageRoute(builder: (_) => const VideoScreen()));
//             },
//           ),

//           DashboardCard(
//             title: "Total Reports",
//             icon: Icons.report,
//             color1: const Color(0xfffc4a1a),
//             color2: const Color(0xfff7b733),
//             onTap: () {
//               // Navigator.push(context,
//               //     MaterialPageRoute(builder: (_) => const ReportsScreen()));
//             },
//           ),
//           // DashboardCard(
//           //   title: "Total Reports",
//           //   icon: Icons.report,
//           //   color1: const Color(0xfffc4a1a),
//           //   color2: const Color(0xfff7b733),
//           //   onTap: () {
//           //     // Navigator.push(context,
//           //     //     MaterialPageRoute(builder: (_) => const ReportsScreen()));
//           //   },
//           // ),
//         ],
//       ),
//     );
//   }
// }

// class DashboardCard extends StatelessWidget {
//   final String title;
//   final IconData icon;
//   final Color color1;
//   final Color color2;
//   final VoidCallback onTap;

//   const DashboardCard({
//     super.key,
//     required this.title,
//     required this.icon,
//     required this.color1,
//     required this.color2,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       borderRadius: BorderRadius.circular(18),
//       onTap: onTap,
//       child: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [color1.withOpacity(0.9), color2.withOpacity(0.9)],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//           borderRadius: BorderRadius.circular(18),
//           boxShadow: [
//             BoxShadow(
//               color: color1.withOpacity(0.3),
//               blurRadius: 12,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         padding: const EdgeInsets.all(25),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(icon, size: 45, color: Colors.white),
//             const SizedBox(height: 18),
//             Text(
//               title,
//               textAlign: TextAlign.center,
//               style: const TextStyle(
//                 fontSize: 20,
//                 color: Colors.white,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:mental_healthcare/admin/total_quizes.dart';
import 'package:mental_healthcare/admin/total_report_screen.dart';
import 'package:mental_healthcare/admin/total_users/total_users.dart';
import 'package:mental_healthcare/admin/upload_content/total_videos.dart';

class DesktopDashboard extends StatelessWidget {
  const DesktopDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    // Determine number of columns based on screen width
    int crossAxisCount;
    if (width >= 1200) {
      crossAxisCount = 4;
    } else if (width >= 900) {
      crossAxisCount = 3;
    } else if (width >= 600) {
      crossAxisCount = 2;
    } else {
      crossAxisCount = 1;
    }

    // Card aspect ratio
    double childAspectRatio = width >= 1200
        ? 1.6
        : width >= 900
        ? 1.5
        : width >= 600
        ? 1.5
        : 1.8;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: GridView(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: childAspectRatio,
        ),
        children: [
          DashboardCard(
            title: "Total Users",
            icon: Icons.people,
            color1: const Color(0xff6a11cb),
            color2: const Color(0xff2575fc),
            onTap: () {
              // Navigate to Users Screen
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
              // Navigate to Quiz Screen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TotalQuizes()),
              );
            },
          ),
          DashboardCard(
            title: "Total Videos",
            icon: Icons.video_library,
            color1: const Color(0xffee0979),
            color2: const Color(0xffff6a00),
            onTap: () {
              // Navigate to Video Screen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => TotalVideos()),
              );
            },
          ),
          DashboardCard(
            title: "Total Reports",
            icon: Icons.report,
            color1: const Color(0xfffc4a1a),
            color2: const Color(0xfff7b733),
            onTap: () {
              // Navigate to Reports Screen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TotalReportScreen()),
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
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color1.withOpacity(0.9), color2.withOpacity(0.9)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: color1.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 45, color: Colors.white),
            const SizedBox(height: 18),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
