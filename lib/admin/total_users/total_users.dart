// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:mental_healthcare/admin/total_quizes.dart';
// import 'package:mental_healthcare/admin/total_users/Admin_users.dart';
// import 'package:mental_healthcare/admin/upload_content/total_videos.dart';

// class TotalSummary extends StatefulWidget {
//   const TotalSummary({super.key});

//   @override
//   State<TotalSummary> createState() => _TotalUsersSummaryState();
// }

// class _TotalUsersSummaryState extends State<TotalSummary> {
//   int customers = 0;
//   int practitioners = 0;
//   int organizationOwners = 0;
//   int quizCount = 0;
//   bool isLoading = true;
//   // bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     fetchUserCounts();
//     fetchQuizCounts();
//   }

//   Future<void> fetchQuizCounts() async {
//     try {
//       QuerySnapshot snapshot = await FirebaseFirestore.instance
//           .collection('Quizes')
//           .get();

//       setState(() {
//         quizCount = snapshot.docs.length; // ← SAVE count here
//         isLoading = false;
//       });
//     } catch (e) {
//       print("Error: $e");
//       setState(() => isLoading = false);
//     }
//   }

//   Future<void> fetchUserCounts() async {
//     try {
//       QuerySnapshot snapshot = await FirebaseFirestore.instance
//           .collection('Users')
//           .get();

//       int customerCount = 0;
//       int practitionerCount = 0;
//       int organizationCount = 0;

//       for (var doc in snapshot.docs) {
//         final data = doc.data() as Map<String, dynamic>;
//         String role = (data['role'] ?? '').toString().toLowerCase();

//         if (role == "customer") customerCount++;
//         if (role == "Practitioner") practitionerCount++;
//         if (role == "Organization Owner") organizationCount++;
//       }

//       setState(() {
//         customers = customerCount;
//         practitioners = practitionerCount;
//         organizationOwners = organizationCount;
//         isLoading = false;
//       });
//     } catch (e) {
//       print("Error: $e");
//       setState(() => isLoading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // appBar: AppBar(title: Text('Total Users')),
//       backgroundColor: const Color(0xfff4f7fb),
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: isLoading
//             ? const Center(child: CircularProgressIndicator())
//             : Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // const Text(
//                   //   "Users Summary",
//                   //   style: TextStyle(
//                   //     fontSize: 28,
//                   //     fontWeight: FontWeight.bold,
//                   //     letterSpacing: 0.5,
//                   //   ),
//                   // ),
//                   // const SizedBox(height: 25),
//                   Expanded(
//                     child: LayoutBuilder(
//                       builder: (context, constraints) {
//                         double width = constraints.maxWidth;

//                         return SingleChildScrollView(
//                           child: Wrap(
//                             spacing: 20,
//                             runSpacing: 20,
//                             children: [
//                               SizedBox(
//                                 width: getCardWidth(width),
//                                 height: 150,
//                                 child: _buildUserCard(
//                                   title: "Customers",
//                                   count: customers,
//                                   icon: Icons.people_alt_outlined,
//                                   color1: const Color(0xff6a11cb),
//                                   color2: const Color(0xff2575fc),
//                                   onTap: () {
//                                     Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder: (_) => TotalCustomers(),
//                                       ),
//                                     );
//                                   },
//                                 ),
//                               ),
//                               SizedBox(
//                                 width: getCardWidth(width),
//                                 height: 150,
//                                 child: _buildUserCard(
//                                   title: "Practitioners",
//                                   count: practitioners,
//                                   icon: Icons.medical_services_outlined,
//                                   color1: const Color(0xff11998e),
//                                   color2: const Color(0xff38ef7d),
//                                   onTap: () {
//                                     Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder: (_) => TotalPractitioners(),
//                                       ),
//                                     );
//                                   },
//                                 ),
//                               ),
//                               SizedBox(
//                                 width: getCardWidth(width),
//                                 height: 150,
//                                 child: _buildUserCard(
//                                   title: "Organizations",
//                                   count: organizationOwners,
//                                   icon: Icons.business_outlined,
//                                   color1: const Color(0xffee0979),
//                                   color2: const Color(0xffff6a00),
//                                   onTap: () {
//                                     Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder: (_) => TotalOrganizations(),
//                                       ),
//                                     );
//                                   },
//                                 ),
//                               ),
//                               SizedBox(
//                                 width: getCardWidth(width),
//                                 height: 150,
//                                 child: _buildUserCard(
//                                   title: "Total Quizzes $quizCount",
//                                   count: organizationOwners,
//                                   icon: Icons.business_outlined,
//                                   color1: const Color(0xffee0979),
//                                   color2: const Color(0xffff6a00),
//                                   onTap: () {
//                                     Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder: (_) => TotalQuizes(),
//                                       ),
//                                     );
//                                   },
//                                 ),
//                               ),
//                               SizedBox(
//                                 width: getCardWidth(width),
//                                 height: 150,
//                                 child: _buildUserCard(
//                                   title: "Organizations",
//                                   count: organizationOwners,
//                                   icon: Icons.business_outlined,
//                                   color1: const Color(0xffee0979),
//                                   color2: const Color(0xffff6a00),
//                                   onTap: () {
//                                     Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder: (_) => TotalVideos(),
//                                       ),
//                                     );
//                                   },
//                                 ),
//                               ),
//                             ],
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//       ),
//     );
//   }

//   // ******* GET CARD WIDTH BASED ON SCREEN SIZE ********
//   double getCardWidth(double width) {
//     if (width > 1300) return 200; // 3 in row
//     if (width > 900) return 380; // 2 in row
//     return width - 40; // 1 full width (mobile)
//   }

//   // ************ BEAUTIFUL CARD ************
//   Widget _buildUserCard({
//     required String title,
//     required int count,
//     required IconData icon,
//     required Color color1,
//     required Color color2,
//     required VoidCallback onTap,
//   }) {
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(18),
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 250),
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [color1.withOpacity(0.85), color2.withOpacity(0.85)],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//           borderRadius: BorderRadius.circular(18),
//           boxShadow: [
//             BoxShadow(
//               color: color1.withOpacity(0.3),
//               blurRadius: 12,
//               spreadRadius: 2,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
//         child: Row(
//           children: [
//             CircleAvatar(
//               radius: 30,
//               backgroundColor: Colors.white.withOpacity(0.22),
//               child: Icon(icon, size: 32, color: Colors.white),
//             ),
//             const SizedBox(width: 22),
//             Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   title,
//                   style: const TextStyle(
//                     fontSize: 17,
//                     color: Colors.white70,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//                 const SizedBox(height: 5),
//                 Text(
//                   "$count",
//                   style: const TextStyle(
//                     fontSize: 32,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mental_healthcare/admin/total_quizes.dart';
import 'package:mental_healthcare/admin/total_users/Admin_users.dart';
import 'package:mental_healthcare/admin/upload_content/total_videos.dart';

class TotalSummary extends StatefulWidget {
  const TotalSummary({super.key});

  @override
  State<TotalSummary> createState() => _TotalUsersSummaryState();
}

class _TotalUsersSummaryState extends State<TotalSummary> {
  int customers = 0;
  int practitioners = 0;
  int organizationOwners = 0;
  int quizCount = 0;
  bool isLoading = true;
  // bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserCounts();
    fetchQuizCounts();
  }

  Future<void> fetchQuizCounts() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('Quizes')
          .get();

      setState(() {
        quizCount = snapshot.docs.length; // ← SAVE count here
        isLoading = false;
      });
    } catch (e) {
      print("Error: $e");
      setState(() => isLoading = false);
    }
  }

  Future<void> fetchUserCounts() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('Users')
          .get();

      int customerCount = 0;
      int practitionerCount = 0;
      int organizationCount = 0;

      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        String role = (data['role'] ?? '').toString().toLowerCase();

        if (role == "customer") customerCount++;
        if (role == "Practitioner") practitionerCount++;
        if (role == "Organization Owner") organizationCount++;
      }

      setState(() {
        customers = customerCount;
        practitioners = practitionerCount;
        organizationOwners = organizationCount;
        isLoading = false;
      });
    } catch (e) {
      print("Error: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text('Total Users')),
      backgroundColor: const Color(0xfff4f7fb),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // const Text(
                  //   "Users Summary",
                  //   style: TextStyle(
                  //     fontSize: 28,
                  //     fontWeight: FontWeight.bold,
                  //     letterSpacing: 0.5,
                  //   ),
                  // ),
                  // const SizedBox(height: 25),
                  Expanded(
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
                                height: 150,
                                child: _buildUserCard(
                                  title: "Customers",
                                  count: customers,
                                  icon: Icons.people_alt_outlined,
                                  color1: const Color(0xff6a11cb),
                                  color2: const Color(0xff2575fc),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => TotalCustomers(),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              SizedBox(
                                width: getCardWidth(width),
                                height: 150,
                                child: _buildUserCard(
                                  title: "Practitioners",
                                  count: practitioners,
                                  icon: Icons.medical_services_outlined,
                                  color1: const Color(0xff11998e),
                                  color2: const Color(0xff38ef7d),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => TotalPractitioners(),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              SizedBox(
                                width: getCardWidth(width),
                                height: 150,
                                child: _buildUserCard(
                                  title: "Organizations",
                                  count: organizationOwners,
                                  icon: Icons.business_outlined,
                                  color1: const Color(0xffee0979),
                                  color2: const Color(0xffff6a00),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => TotalOrganizations(),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              SizedBox(
                                width: getCardWidth(width),
                                height: 150,
                                child: _buildUserCard(
                                  title: "Total Quizzes ",
                                  count: quizCount,
                                  icon: Icons.business_outlined,
                                  color1: const Color(0xffee0979),
                                  color2: const Color(0xffff6a00),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => TotalQuizes(),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              SizedBox(
                                width: getCardWidth(width),
                                height: 150,
                                child: _buildUserCard(
                                  title: "Total Videos",
                                  count: organizationOwners,
                                  icon: Icons.business_outlined,
                                  color1: const Color(0xffee0979),
                                  color2: const Color(0xffff6a00),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => TotalVideos(),
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
                ],
              ),
      ),
    );
  }

  // ******* GET CARD WIDTH BASED ON SCREEN SIZE ********
  double getCardWidth(double width) {
    if (width > 1300) return 200; // 3 in row
    if (width > 900) return 380; // 2 in row
    return width - 40; // 1 full width (mobile)
  }

  // ************ BEAUTIFUL CARD ************
  Widget _buildUserCard({
    required String title,
    required int count,
    required IconData icon,
    required Color color1,
    required Color color2,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
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
              color: color1.withOpacity(0.3),
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
              radius: 30,
              backgroundColor: Colors.white.withOpacity(0.22),
              child: Icon(icon, size: 32, color: Colors.white),
            ),
            const SizedBox(width: 22),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 17,
                    color: Colors.white70,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  "$count",
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
