// import 'package:flutter/material.dart';
// import 'package:mental_healthcare/backend/practionar.dart'; // <-- contains fetch_practionar + update function
// import 'package:mental_healthcare/frontend/practioner_interface/prac_homescreen.dart';
// import 'package:mental_healthcare/frontend/practioner_interface/widgets/pract_custom_wdgets.dart';
// import 'package:mental_healthcare/frontend/widgets/appcolors.dart';

// class PracProfile extends StatefulWidget {
//   const PracProfile({super.key});

//   @override
//   State<PracProfile> createState() => _PracProfileState();
// }

// class _PracProfileState extends State<PracProfile>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Future<Map<String, dynamic>?> _profileFuture;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 1),
//     )..forward();

//     final auth = PracAuth();
//     _profileFuture = auth.fetch_practionor(context); // fetch only once
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   // --- Stat card widget ---
//   Widget _buildStatCard(
//     String label,
//     String value,
//     IconData icon,
//     Color color,
//   ) {
//     return FadeTransition(
//       opacity: _controller,
//       child: Container(
//         padding: const EdgeInsets.all(14),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(18),
//           boxShadow: [
//             BoxShadow(
//               color: color.withOpacity(0.2),
//               blurRadius: 8,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         child: Column(
//           children: [
//             Icon(icon, color: color, size: 30),
//             const SizedBox(height: 8),
//             Text(
//               value,
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: color,
//               ),
//             ),
//             Text(
//               label,
//               style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // --- Skill chip (if you want later) ---
//   Widget _buildSkillChip(String skill) {
//     return Chip(
//       label: Text(skill, style: const TextStyle(fontWeight: FontWeight.w500)),
//       backgroundColor: AppColors.primary.withOpacity(0.1),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final auth = PracAuth();

//     return Scaffold(
//       backgroundColor: const Color(0xfff8f9fb),
//       appBar: AppBar(
//         leading: GestureDetector(
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (_) => const PracHomescreen()),
//             );
//           },
//           child: const Icon(Icons.arrow_back_ios),
//         ),
//         iconTheme: const IconThemeData(color: Colors.white),
//         title: const Text(
//           'Practitioner Profile',
//           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//         ),
//         centerTitle: true,
//         backgroundColor: AppColors.primary,
//         elevation: 4,
//       ),

//       body: FutureBuilder(
//         future: _profileFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(
//               child: CircularProgressIndicator(color: AppColors.primary),
//             );
//           } else if (snapshot.hasError) {
//             return Center(child: Text("Error: ${snapshot.error}"));
//           } else if (!snapshot.hasData || snapshot.data == null) {
//             return const Center(child: Text("No data found"));
//           }

//           final data = snapshot.data as Map<String, dynamic>;

//           return Container(
//             decoration: const BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [Color(0xffe9f5ff), Color(0xfff8f9fb)],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//             ),
//             child: ListView(
//               physics: const BouncingScrollPhysics(),
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
//               children: [
//                 FadeTransition(
//                   opacity: _controller,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       // --- Profile Image ---
//                       const CircleAvatar(
//                         radius: 60,
//                         backgroundImage: AssetImage(
//                           'assets/images/profile.jpg',
//                         ),
//                         backgroundColor: Colors.white,
//                       ),
//                       const SizedBox(height: 12),

//                       // --- Name & Specialty ---
//                       Text(
//                         data['Fullname'] ?? 'No Name',
//                         style: const TextStyle(
//                           fontSize: 24,
//                           fontWeight: FontWeight.bold,
//                           color: Color(0xff222B45),
//                         ),
//                       ),
//                       Text(
//                         data['Speciality'] ?? 'Unknown Specialty',
//                         style: TextStyle(
//                           fontSize: 16,
//                           color: Colors.grey.shade700,
//                         ),
//                       ),
//                       const SizedBox(height: 20),

//                       // --- Stats ---
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Expanded(
//                             child: _buildStatCard(
//                               'Experience',
//                               '${data['Experience'] ?? 'N/A'} yrs',
//                               Icons.workspace_premium_rounded,
//                               Colors.teal,
//                             ),
//                           ),
//                           const SizedBox(width: 12),
//                           Expanded(
//                             child: _buildStatCard(
//                               'Role',
//                               data['role'] ?? 'Practioner',
//                               Icons.badge_rounded,
//                               Colors.purpleAccent,
//                             ),
//                           ),
//                           const SizedBox(width: 12),
//                           Expanded(
//                             child: _buildStatCard(
//                               'Payment',
//                               data['Payment Status'] ?? 'Unpaid',
//                               Icons.payment_rounded,
//                               Colors.blueAccent,
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 28),

//                       // --- About Section ---
//                       Align(
//                         alignment: Alignment.centerLeft,
//                         child: Text(
//                           'About Me',
//                           style: TextStyle(
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold,
//                             color: AppColors.primary,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 10),
//                       Container(
//                         padding: const EdgeInsets.all(14),
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(14),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.grey.shade200,
//                               blurRadius: 6,
//                               offset: const Offset(0, 4),
//                             ),
//                           ],
//                         ),
//                         child: Text(
//                           data['About'] ??
//                               'Professional practitioner helping clients improve their mental health through therapy and mindfulness.',
//                           style: TextStyle(
//                             fontSize: 14,
//                             color: Colors.grey.shade800,
//                             height: 1.5,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 28),

//                       // --- Contact Section ---
//                       Align(
//                         alignment: Alignment.centerLeft,
//                         child: Text(
//                           'Contact Information',
//                           style: TextStyle(
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold,
//                             color: AppColors.primary,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 12),

//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                           vertical: 10,
//                           horizontal: 14,
//                         ),
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(14),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.grey.shade200,
//                               blurRadius: 6,
//                               offset: const Offset(0, 4),
//                             ),
//                           ],
//                         ),
//                         child: Column(
//                           children: [
//                             ListTile(
//                               leading: const Icon(
//                                 Icons.email,
//                                 color: Colors.blue,
//                               ),
//                               title: Text(data['Email'] ?? 'N/A'),
//                             ),
//                             ListTile(
//                               leading: const Icon(
//                                 Icons.phone,
//                                 color: Colors.green,
//                               ),
//                               title: Text(data['Phone Number'] ?? 'N/A'),
//                             ),
//                           ],
//                         ),
//                       ),

//                       const SizedBox(height: 35),

//                       // --- Edit Profile Button ---
//                       ElevatedButton.icon(
//                         onPressed: () async {
//                           final nameController = TextEditingController(
//                             text: data['Fullname'],
//                           );
//                           final emailController = TextEditingController(
//                             text: data['Email'],
//                           );
//                           final specialityController = TextEditingController(
//                             text: data['Speciality'],
//                           );
//                           final phoneController = TextEditingController(
//                             text: data['Phone Number'],
//                           );
//                           // Show dialog for editing
//                           await showDialog(
//                             context: context,
//                             builder: (context) {
//                               return AlertDialog(
//                                 title: const Text(
//                                   "Edit Profile",
//                                   style: TextStyle(fontWeight: FontWeight.bold),
//                                 ),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(20),
//                                 ),
//                                 content: Column(
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: [
//                                     TextField(
//                                       controller: nameController,
//                                       decoration: const InputDecoration(
//                                         labelText: "Full Name",
//                                         prefixIcon: Icon(Icons.person),
//                                       ),
//                                     ),
//                                     const SizedBox(height: 12),
//                                     TextField(
//                                       controller: emailController,
//                                       decoration: const InputDecoration(
//                                         labelText: "Email",
//                                         prefixIcon: Icon(Icons.email),
//                                       ),
//                                     ),
//                                     const SizedBox(height: 12),
//                                     TextField(
//                                       controller: specialityController,
//                                       decoration: const InputDecoration(
//                                         labelText: "Speciality",
//                                         prefixIcon: Icon(Icons.work),
//                                       ),
//                                     ),
//                                     const SizedBox(height: 12),
//                                     TextField(
//                                       controller: phoneController,
//                                       decoration: const InputDecoration(
//                                         labelText: "Phone Number",
//                                         prefixIcon: Icon(Icons.phone),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 actions: [
//                                   TextButton(
//                                     onPressed: () => Navigator.pop(context),
//                                     child: const Text("Cancel"),
//                                   ),
//                                   ElevatedButton(
//                                     onPressed: () async {
//                                       // ✅ Call your already defined backend function
//                                       await auth.update_practionar(context, {
//                                         'Full Name': nameController.text.trim(),
//                                         'Email': emailController.text.trim(),
//                                         'role': data['role'],
//                                         'Phone Number': phoneController.text
//                                             .trim(),
//                                         'Speciality': specialityController.text
//                                             .trim(),
//                                       });

//                                       Navigator.pop(context);

//                                       // Refresh profile after update
//                                       setState(() {
//                                         _profileFuture = auth.fetch_practionor(
//                                           context,
//                                         );
//                                       });
//                                     },
//                                     style: ElevatedButton.styleFrom(
//                                       backgroundColor: AppColors.primary,
//                                     ),
//                                     child: const Text("Save"),
//                                   ),
//                                 ],
//                               );
//                             },
//                           );
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: AppColors.primary,
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 28,
//                             vertical: 14,
//                           ),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(30),
//                           ),
//                           elevation: 3,
//                         ),
//                         icon: const Icon(Icons.edit, color: Colors.white),
//                         label: const Text(
//                           "Edit Profile",
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontWeight: FontWeight.bold,
//                             fontSize: 16,
//                           ),
//                         ),
//                       ),

//                       const SizedBox(height: 40),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),

//       bottomNavigationBar: prac_bottomNavbbar(currentScreen: 'Profile'),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mental_healthcare/backend/practionar.dart'; // contains fetch_practionar + update
import 'package:mental_healthcare/frontend/practioner_interface/prac_homescreen.dart';
import 'package:mental_healthcare/frontend/practioner_interface/widgets/pract_custom_wdgets.dart';
import 'package:mental_healthcare/frontend/widgets/appcolors.dart';

// ─────────────────────────────────────────────
// PROVIDER CLASS
// ─────────────────────────────────────────────
class PracProfileProvider extends ChangeNotifier {
  Map<String, dynamic>? _profile;
  bool _loading = false;

  Map<String, dynamic>? get profile => _profile;
  bool get loading => _loading;

  final _auth = PracAuth();

  Future<void> fetchProfile(BuildContext context) async {
    if (_profile != null) return; // prevent re-fetch
    _loading = true;
    notifyListeners();

    final data = await _auth.fetch_practionor(context);
    if (data != null) {
      _profile = data;
    }

    _loading = false;
    notifyListeners();
  }

  Future<void> refreshProfile(BuildContext context) async {
    _profile = null;
    await fetchProfile(context);
  }

  Future<void> updateProfile(
    BuildContext context,
    Map<String, dynamic> newData,
  ) async {
    await _auth.update_practionar(context, newData);
    await refreshProfile(context);
  }
}

// ─────────────────────────────────────────────
// PRACTITIONER PROFILE SCREEN
// ─────────────────────────────────────────────
class PracProfile extends StatelessWidget {
  const PracProfile({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PracProfileProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider.fetchProfile(context);
    });

    return Scaffold(
      backgroundColor: const Color(0xfff8f9fb),
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pushReplacement(
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

      body: Consumer<PracProfileProvider>(
        builder: (context, provider, _) {
          if (provider.loading && provider.profile == null) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          final data = provider.profile;
          if (data == null) {
            return const Center(child: Text("No profile data found"));
          }

          return RefreshIndicator(
            onRefresh: () => provider.refreshProfile(context),
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Profile Image
                    const CircleAvatar(
                      radius: 60,
                      backgroundImage: AssetImage('assets/images/profile.jpg'),
                      backgroundColor: Colors.white,
                    ),
                    const SizedBox(height: 12),

                    // Name & Specialty
                    Text(
                      data['username'] ?? 'No Name',
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

                    // Stats Section
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
                            data['role'] ?? 'Practitioner',
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

                    // About Section
                    _buildSectionTitle('About Me'),
                    _buildInfoBox(
                      data['About'] ??
                          'Professional practitioner helping clients improve their mental health through therapy and mindfulness.',
                    ),
                    const SizedBox(height: 28),

                    // Contact Information
                    _buildSectionTitle('Contact Information'),
                    _buildContactBox(data),

                    const SizedBox(height: 35),

                    // Edit Button
                    ElevatedButton.icon(
                      onPressed: () => _showEditDialog(context, data, provider),
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
              ],
            ),
          );
        },
      ),

      bottomNavigationBar: prac_bottomNavbbar(
        currentScreen: 'Profile',
        clientData: {},
      ),
    );
  }

  // ─────────────────────────────────────────────
  // WIDGET HELPERS
  // ─────────────────────────────────────────────
  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
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
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildInfoBox(String content) {
    return Container(
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
        content,
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey.shade800,
          height: 1.5,
        ),
      ),
    );
  }

  Widget _buildContactBox(Map<String, dynamic> data) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
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
            leading: const Icon(Icons.email, color: Colors.blue),
            title: Text(data['email'] ?? 'N/A'),
          ),
          ListTile(
            leading: const Icon(Icons.phone, color: Colors.green),
            title: Text(data['Phone Number'] ?? 'N/A'),
          ),
          ListTile(title: Text(data['uid'] ?? 'N/A')),
        ],
      ),
    );
  }

  void _showEditDialog(
    BuildContext context,
    Map<String, dynamic> data,
    PracProfileProvider provider,
  ) {
    final nameController = TextEditingController(text: data['username']);
    final emailController = TextEditingController(text: data['email']);
    final specialityController = TextEditingController(
      text: data['Speciality'],
    );
    final phoneController = TextEditingController(text: data['Phone Number']);

    showDialog(
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
                await provider.updateProfile(context, {
                  'username': nameController.text.trim(),
                  'email': emailController.text.trim(),
                  'role': data['role'],
                  'Phone Number': phoneController.text.trim(),
                  'Speciality': specialityController.text.trim(),
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("✅ Profile updated successfully"),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                // backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }
}
