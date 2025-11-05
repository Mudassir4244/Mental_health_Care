import 'package:flutter/material.dart';
import 'package:mental_healthcare/backend/practionar.dart'; // <-- contains fetch_practionar + update function
import 'package:mental_healthcare/frontend/practioner_interface/prac_homescreen.dart';
import 'package:mental_healthcare/frontend/practioner_interface/widgets/pract_custom_wdgets.dart';
import 'package:mental_healthcare/frontend/widgets/appcolors.dart';

class PracProfile extends StatefulWidget {
  const PracProfile({super.key});

  @override
  State<PracProfile> createState() => _PracProfileState();
}

class _PracProfileState extends State<PracProfile>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Future<Map<String, dynamic>?> _profileFuture;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..forward();

    final auth = PracAuth();
    _profileFuture = auth.fetch_practionor(context); // fetch only once
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // --- Stat card widget ---
  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return FadeTransition(
      opacity: _controller,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 30),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              label,
              style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
            ),
          ],
        ),
      ),
    );
  }

  // --- Skill chip (if you want later) ---
  Widget _buildSkillChip(String skill) {
    return Chip(
      label: Text(skill, style: const TextStyle(fontWeight: FontWeight.w500)),
      backgroundColor: AppColors.primary.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = PracAuth();

    return Scaffold(
      backgroundColor: const Color(0xfff8f9fb),
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PracHomescreen()),
            );
          },
          child: const Icon(Icons.arrow_back_ios),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Practitioner Profile',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        elevation: 4,
      ),

      body: FutureBuilder(
        future: _profileFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text("No data found"));
          }

          final data = snapshot.data as Map<String, dynamic>;

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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              children: [
                FadeTransition(
                  opacity: _controller,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // --- Profile Image ---
                      const CircleAvatar(
                        radius: 60,
                        backgroundImage: AssetImage(
                          'assets/images/profile.jpg',
                        ),
                        backgroundColor: Colors.white,
                      ),
                      const SizedBox(height: 12),

                      // --- Name & Specialty ---
                      Text(
                        data['Fullname'] ?? 'No Name',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff222B45),
                        ),
                      ),
                      Text(
                        data['Speciality'] ?? 'Unknown Specialty',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // --- Stats ---
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: _buildStatCard(
                              'Experience',
                              '${data['Experience'] ?? 'N/A'} yrs',
                              Icons.workspace_premium_rounded,
                              Colors.teal,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildStatCard(
                              'Role',
                              data['role'] ?? 'Practioner',
                              Icons.badge_rounded,
                              Colors.purpleAccent,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildStatCard(
                              'Payment',
                              data['Payment Status'] ?? 'Unpaid',
                              Icons.payment_rounded,
                              Colors.blueAccent,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),

                      // --- About Section ---
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'About Me',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade200,
                              blurRadius: 6,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Text(
                          data['About'] ??
                              'Professional practitioner helping clients improve their mental health through therapy and mindfulness.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade800,
                            height: 1.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),

                      // --- Contact Section ---
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Contact Information',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 14,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade200,
                              blurRadius: 6,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            ListTile(
                              leading: const Icon(
                                Icons.email,
                                color: Colors.blue,
                              ),
                              title: Text(data['Email'] ?? 'N/A'),
                            ),
                            ListTile(
                              leading: const Icon(
                                Icons.phone,
                                color: Colors.green,
                              ),
                              title: Text(data['Phone Number'] ?? 'N/A'),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 35),

                      // --- Edit Profile Button ---
                      ElevatedButton.icon(
                        onPressed: () async {
                          final nameController = TextEditingController(
                            text: data['Fullname'],
                          );
                          final emailController = TextEditingController(
                            text: data['Email'],
                          );
                          final specialityController = TextEditingController(
                            text: data['Speciality'],
                          );
                          final phoneController = TextEditingController(
                            text: data['Phone Number'],
                          );
                          // Show dialog for editing
                          await showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text(
                                  "Edit Profile",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextField(
                                      controller: nameController,
                                      decoration: const InputDecoration(
                                        labelText: "Full Name",
                                        prefixIcon: Icon(Icons.person),
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    TextField(
                                      controller: emailController,
                                      decoration: const InputDecoration(
                                        labelText: "Email",
                                        prefixIcon: Icon(Icons.email),
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    TextField(
                                      controller: specialityController,
                                      decoration: const InputDecoration(
                                        labelText: "Speciality",
                                        prefixIcon: Icon(Icons.work),
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    TextField(
                                      controller: phoneController,
                                      decoration: const InputDecoration(
                                        labelText: "Phone Number",
                                        prefixIcon: Icon(Icons.phone),
                                      ),
                                    ),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text("Cancel"),
                                  ),
                                  ElevatedButton(
                                    onPressed: () async {
                                      // ✅ Call your already defined backend function
                                      await auth.update_practionar(context, {
                                        'Full Name': nameController.text.trim(),
                                        'Email': emailController.text.trim(),
                                        'role': data['role'],
                                        'Phone Number': phoneController.text
                                            .trim(),
                                        'Speciality': specialityController.text
                                            .trim(),
                                      });

                                      Navigator.pop(context);

                                      // Refresh profile after update
                                      setState(() {
                                        _profileFuture = auth.fetch_practionor(
                                          context,
                                        );
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primary,
                                    ),
                                    child: const Text("Save"),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 28,
                            vertical: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 3,
                        ),
                        icon: const Icon(Icons.edit, color: Colors.white),
                        label: const Text(
                          "Edit Profile",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),

      bottomNavigationBar: prac_bottomNavbbar(currentScreen: 'Profile'),
    );
  }
}
