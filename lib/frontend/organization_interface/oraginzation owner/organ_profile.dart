import 'package:flutter/material.dart';
import 'package:mental_healthcare/frontend/organization_interface/oraginzation%20owner/organization_homescreen.dart';
import 'package:mental_healthcare/frontend/organization_interface/widgets/organ_widigets.dart';
import 'package:mental_healthcare/frontend/widgets/appcolors.dart';
import 'package:mental_healthcare/backend/oraganization.dart';

class OrganProfile extends StatefulWidget {
  const OrganProfile({super.key});

  @override
  State<OrganProfile> createState() => _OrganProfileState();
}

class _OrganProfileState extends State<OrganProfile>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final organAuth = OrganAuth();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return FadeTransition(
      opacity: _controller,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 30),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              label,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => organ_owner_homescreen()),
        );
        return true;
      },
      child: Scaffold(
        backgroundColor: const Color(0xfff8f9fb),
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => const organ_owner_homescreen(),
                ),
              );
            },
            child: const Icon(Icons.arrow_back_ios),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text(
            'Organization Profile',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.accent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          elevation: 4,
        ),

        // ✅ Using FutureBuilder
        body: FutureBuilder<Map<String, dynamic>?>(
          future: organAuth.fetch_organowner(context),
          builder: (context, snapshot) {
            // 🌀 Loading
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            // ❌ Error
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error fetching data: ${snapshot.error}',
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                ),
              );
            }

            // ⚠️ No data
            if (!snapshot.hasData || snapshot.data == null) {
              return const Center(
                child: Text(
                  'No organization data found',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }

            final organData = snapshot.data!;

            // ✅ Success UI
            return Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xffe9f5ff), Color(0xfff8f9fb)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(16),
                children: [
                  FadeTransition(
                    opacity: _controller,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const CircleAvatar(
                          radius: 55,
                          backgroundImage: AssetImage(
                            'assets/images/profile.jpg',
                          ),
                          backgroundColor: Colors.white,
                        ),
                        const SizedBox(height: 12),

                        // Organization Name
                        Text(
                          organData['Organization name'] ??
                              'Unknown Organization',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff222B45),
                          ),
                        ),

                        // Owner Email
                        Text(
                          organData['Organization owner email'] ??
                              'Unknown Email',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Stats Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: _buildStatCard(
                                'Payment Status',
                                organData['Payment Status'] ?? 'Unknown',
                                Icons.payment_rounded,
                                Colors.green,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildStatCard(
                                'Role',
                                organData['role'] ?? 'N/A',
                                Icons.account_balance_rounded,
                                Colors.blueAccent,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 30),
                        Text(organData['Created by']),
                        // const SizedBox(height: 24),
                        // Expanded(
                        //   child: _buildStatCard(
                        //     'User ID',
                        //     organData['Organization Id'] ?? 'N/A',
                        //     Icons.account_balance_rounded,
                        //     Colors.blueAccent,
                        //   ),
                        // ),
                        // Optional Details
                        if (organData['Organization address'] != null)
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Address',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  organData['Organization address'] ??
                                      'Not available',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade800,
                                    height: 1.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),

        bottomNavigationBar: organ_bottomNavbbar(currentScreen: 'Profile'),
      ),
    );
  }
}
