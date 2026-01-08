import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mental_healthcare/admin/total_quizes.dart';
import 'package:mental_healthcare/admin/total_users/Admin_users.dart';

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

  @override
  void initState() {
    super.initState();
    fetchCounts();
  }

  Future<void> fetchCounts() async {
    try {
      // Fetch Users
      QuerySnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .get();

      int customerCount = 0;
      int practitionerCount = 0;
      int organizationCount = 0;

      for (var doc in userSnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        String role = (data['role'] ?? '').toString().toLowerCase();

        if (role == "customer") customerCount++;
        if (role == "practitioner") practitionerCount++;
        if (role == "organization owner") organizationCount++;
      }

      // Fetch Quiz Papers
      QuerySnapshot quizSnapshot = await FirebaseFirestore.instance
          .collection('QuizPapers')
          .get();
      int qCount = quizSnapshot.docs.length;

      if (mounted) {
        setState(() {
          customers = customerCount;
          practitioners = practitionerCount;
          organizationOwners = organizationCount;
          quizCount = qCount;
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error fetching counts: $e");
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Dashboard Summary",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
            color: Colors.black87,
          ),
        ),
      ),
      backgroundColor: const Color(0xfff4f7fb),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        double width = constraints.maxWidth;
                        double cardWidth = getCardWidth(width);

                        return SingleChildScrollView(
                          child: Wrap(
                            spacing: 20,
                            runSpacing: 20,
                            children: [
                              SizedBox(
                                width: cardWidth,
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
                                        builder: (_) => const TotalCustomers(),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              SizedBox(
                                width: cardWidth,
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
                                        builder: (_) =>
                                            const TotalPractitioners(),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              SizedBox(
                                width: cardWidth,
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
                                        builder: (_) =>
                                            const TotalOrganizations(),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              SizedBox(
                                width: cardWidth,
                                height: 150,
                                child: _buildUserCard(
                                  title: "Total Quizzes",
                                  count: quizCount,
                                  icon: Icons.quiz_outlined,
                                  color1: const Color(0xfffc4a1a),
                                  color2: const Color(0xfff7b733),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => const TotalQuizes(),
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

  double getCardWidth(double width) {
    if (width > 1300) return 300; // Large screens
    if (width > 900) return (width - 60) / 2; // Medium screens (2 per row)
    return width; // Mobile (full width)
  }

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
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color1, color2],
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
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
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
