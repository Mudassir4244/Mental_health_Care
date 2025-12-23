import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mental_healthcare/backend/practionar.dart';
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
    if (_profile != null) return;
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

  void clearProfile() {
    _profile = null;
    _loading = false;
    notifyListeners();
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
class PracProfile extends StatefulWidget {
  const PracProfile({super.key});

  @override
  State<PracProfile> createState() => _PracProfileState();
}

class _PracProfileState extends State<PracProfile>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PracProfileProvider>().fetchProfile(context);
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff8f9fb),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          color: Colors.white,
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const PracHomescreen()),
            );
          },
        ),
        title: const Text(
          'Practitioner Profile',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        elevation: 0,
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
            color: AppColors.primary,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 24,
                ),
                children: [
                  // Profile Header
                  Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.primary,
                            width: 3,
                          ),
                        ),
                        child: const CircleAvatar(
                          radius: 55,
                          backgroundImage: AssetImage(
                            'assets/images/profile.jpg',
                          ),
                          backgroundColor: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        data['username'] ?? 'No Name',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff222B45),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        data['Speciality'] ?? 'Specialist',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Stats Row
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          'Experience',
                          '${data['Experience'] ?? 'N/A'} yrs',
                          Icons.workspace_premium,
                          Colors.orange,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCard(
                          'Role',
                          data['role'] ?? 'Practitioner',
                          Icons.badge,
                          Colors.blue,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Payment status separately or could be in row above if 3 items fit well
                  _buildStatCard(
                    'Payment Status',
                    data['Payment Status'] ?? 'Unpaid',
                    Icons.payment,
                    Colors.green,
                    fullWidth: true,
                  ),

                  const SizedBox(height: 32),

                  // About Section
                  _buildSectionHeader('About Me'),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
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
                    child: Text(
                      data['About'] ??
                          'Professional practitioner helping clients improve their mental health.',
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey.shade700,
                        height: 1.5,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Contact Section
                  _buildSectionHeader('Contact Info'),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
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
                      children: [
                        _buildContactTile(
                          Icons.email_outlined,
                          "Email",
                          data['email'] ?? 'N/A',
                        ),
                        Divider(height: 1, color: Colors.grey.shade100),
                        _buildContactTile(
                          Icons.phone_outlined,
                          "Phone",
                          data['Phone Number'] ?? 'N/A',
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Edit Button
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () => _showEditSheet(context, data, provider),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 2,
                      ),
                      child: const Text(
                        "Edit Profile",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: prac_bottomNavbbar(
        currentScreen: 'Profile',
        clientData: const {},
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Color(0xff222B45),
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color, {
    bool fullWidth = false,
  }) {
    return Container(
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
      child: Row(
        mainAxisAlignment: fullWidth
            ? MainAxisAlignment.start
            : MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff222B45),
                ),
              ),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade500,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContactTile(IconData icon, String title, String value) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: AppColors.primary, size: 20),
      ),
      title: Text(
        value,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: Color(0xff222B45),
        ),
      ),
      subtitle: Text(
        title,
        style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
      ),
    );
  }

  void _showEditSheet(
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
    final experienceController = TextEditingController(
      text: data['Experience'],
    );
    final aboutController = TextEditingController(text: data['About']);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Edit Profile",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                children: [
                  _buildTextField(
                    nameController,
                    "Full Name",
                    Icons.person_outline,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    emailController,
                    "Email",
                    Icons.email_outlined,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    specialityController,
                    "Speciality",
                    Icons.work_outline,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    experienceController,
                    "Years of Experience",
                    Icons.workspace_premium,
                    inputType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    phoneController,
                    "Phone",
                    Icons.phone_outlined,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    aboutController,
                    "About Me",
                    Icons.info_outline,
                    maxLines: 4,
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () async {
                        await provider.updateProfile(context, {
                          'username': nameController.text.trim(),
                          'email': emailController.text.trim(),
                          'role': data['role'],
                          'Phone Number': phoneController.text.trim(),
                          'Speciality': specialityController.text.trim(),
                          'Experience': experienceController.text.trim(),
                          'About': aboutController.text.trim(),
                        });
                        if (context.mounted) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Profile updated successfully"),
                              backgroundColor: Colors.green,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Save Changes",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon, {
    int maxLines = 1,
    TextInputType? inputType,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: inputType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.grey.shade600, size: 22),
        filled: true,
        fillColor: const Color(0xfff5f6fa),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
    );
  }
}
