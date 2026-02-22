import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mental_healthcare/cloudinary/cloudinary_service.dart';
import 'package:mental_healthcare/l10n/app_localizations.dart';
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
  final bool _paymentLoading = false;
  String _paymentStatus = 'Pending';
  bool _isPremium = false;
  File? _selectedImage;

  final _auth = PracAuth();

  Map<String, dynamic>? get profile => _profile;
  bool get loading => _loading;
  bool get paymentLoading => _paymentLoading;
  String get paymentStatus => _paymentStatus;
  bool get isPremium => _isPremium;
  File? get selectedImage => _selectedImage;

  String _selectedPaymentMethod = 'Both';
  String get selectedPaymentMethod => _selectedPaymentMethod;

  // Load payment method from Firestore
  Future<void> loadPaymentMethod() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return;

      final doc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(uid)
          .get();

      if (doc.exists && doc.data()?['Preferred Payment Method'] != null) {
        _selectedPaymentMethod = doc.data()!['Preferred Payment Method'];
        notifyListeners();
      }
    } catch (e) {
      print('Error loading payment method: $e');
    }
  }

  // Update payment method and save to Firestore
  Future<void> updatePaymentMethod(String method) async {
    try {
      _selectedPaymentMethod = method;
      notifyListeners();

      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return;

      await FirebaseFirestore.instance.collection('Users').doc(uid).update({
        'Preferred Payment Method': method,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      print('✅ Payment method updated to: $method');
    } catch (e) {
      print('❌ Error updating payment method: $e');
    }
  }

  Future<void> loadProfile() async {
    _loading = true;
    notifyListeners();

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _isPremium = false;
      _loading = false;
      notifyListeners();
      return;
    }

    try {
      final userDoc = await FirebaseFirestore.instance
          .collection("Users")
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        final data = userDoc.data();
        _paymentStatus = data?['Payment Status'] ?? 'Pending';
        _isPremium = _paymentStatus == 'Completed';
      } else {
        _isPremium = false;
      }
    } catch (e) {
      print("Error loading profile: $e");
      _isPremium = false;
    }

    _loading = false;
    notifyListeners();
  }

  Future<void> fetchProfile(BuildContext context) async {
    if (_profile != null) return;

    _loading = true;
    notifyListeners();

    try {
      final data = await _auth.fetch_practionor(context);
      if (data != null) {
        _profile = data;
      }
    } catch (e) {
      print("Error fetching profile: $e");
    }

    _loading = false;
    notifyListeners();
  }

  Future<void> refreshProfile(BuildContext context) async {
    _profile = null;
    _selectedImage = null;
    await fetchProfile(context);
  }

  void clearProfile() {
    _profile = null;
    _loading = false;
    _selectedImage = null;
    notifyListeners();
  }

  Future<void> updateProfile(
    BuildContext context,
    Map<String, dynamic> newData,
  ) async {
    try {
      await _auth.update_practionar(context, newData);
      await refreshProfile(context);
    } catch (e) {
      print("Error updating profile: $e");
      rethrow;
    }
  }

  void setSelectedImage(File? image) {
    _selectedImage = image;
    notifyListeners();
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
  bool _isInitialized = false;

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
      _initializeProfile();
    });
  }

  Future<void> _initializeProfile() async {
    if (_isInitialized) return;

    try {
      final provider = Provider.of<PracProfileProvider>(context, listen: false);
      await provider.fetchProfile(context);
      await provider.loadPaymentMethod();
      await _controller.forward();

      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    } catch (e) {
      print('Error initializing profile: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load profile: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
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
        title: Text(
          AppLocalizations.of(context)!.profile,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        elevation: 0,
      ),
      body: Consumer<PracProfileProvider>(
        builder: (context, provider, _) {
          if (!_isInitialized ||
              (provider.loading && provider.profile == null)) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          final data = provider.profile;
          if (data == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 60, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text(
                    "No profile data found",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => provider.refreshProfile(context),
                    child: const Text("Retry"),
                  ),
                ],
              ),
            );
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
                        child: CircleAvatar(
                          radius: 55,
                          backgroundColor: Colors.grey.shade200,
                          backgroundImage: provider.selectedImage != null
                              ? FileImage(provider.selectedImage!)
                                    as ImageProvider
                              : (data['ImageUrl'] != null &&
                                    data['ImageUrl'].toString().isNotEmpty)
                              ? NetworkImage(data['ImageUrl'])
                              : null,
                          child:
                              (provider.selectedImage == null &&
                                  (data['ImageUrl'] == null ||
                                      data['ImageUrl'].toString().isEmpty))
                              ? const Icon(
                                  Icons.person,
                                  size: 50,
                                  color: AppColors.primary,
                                )
                              : null,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            data['username'] ?? 'No Name',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff222B45),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Icon(
                            Icons.verified,
                            color: AppColors.success,
                            size: 22,
                          ),
                        ],
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
                      _buildStatCard(
                        AppLocalizations.of(context)!.experience,
                        '${data['Experience'] ?? 'N/A'} yrs',
                        Icons.workspace_premium,
                        Colors.orange,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildStatCard(
                          AppLocalizations.of(context)!.role,
                          data['role'] ?? 'Practitioner',
                          Icons.badge,
                          Colors.blue,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildStatCard(
                    AppLocalizations.of(context)!.paymentStatus,
                    data['Payment Status'] ?? 'Unpaid',
                    Icons.payment,
                    Colors.green,
                    fullWidth: true,
                  ),

                  const SizedBox(height: 32),

                  // About Section
                  _buildSectionHeader(AppLocalizations.of(context)!.aboutMe),
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
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey.shade700,
                        height: 1.5,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Contact Section
                  _buildSectionHeader(
                    AppLocalizations.of(context)!.contactInfo,
                  ),
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
                          AppLocalizations.of(context)!.email,
                          data['email'] ?? 'N/A',
                        ),
                        Divider(height: 1, color: Colors.grey.shade100),
                        _buildContactTile(
                          Icons.phone_outlined,
                          AppLocalizations.of(context)!.phone,
                          data['Phone Number'] ?? 'N/A',
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Payment Method Selection Card
                  Card(
                    color: AppColors.cardColor,
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.payment_outlined,
                                color: AppColors.primary,
                              ),
                              const SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  AppLocalizations.of(
                                    context,
                                  )!.preferredPaymentMethod,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: _buildPaymentOption(
                                  provider,
                                  'Cash',
                                  Icons.attach_money,
                                  AppColors.primary,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildPaymentOption(
                                  provider,
                                  'Insurance',
                                  Icons.shield_outlined,
                                  AppColors.accent,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: _buildPaymentOption(
                              provider,
                              'Both',
                              Icons.done_all,
                              AppColors.success,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

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
                      child: Text(
                        AppLocalizations.of(context)!.editProfile,
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

  Widget _buildPaymentOption(
    PracProfileProvider provider,
    String value,
    IconData icon,
    Color activeColor,
  ) {
    final bool isSelected = provider.selectedPaymentMethod == value;

    return GestureDetector(
      onTap: () => provider.updatePaymentMethod(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? activeColor.withOpacity(0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected
                ? activeColor
                : AppColors.textColorSecondary.withOpacity(0.3),
            width: 2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? activeColor : AppColors.textColorSecondary,
              size: 22,
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                value,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: isSelected
                      ? activeColor
                      : AppColors.textColorSecondary,
                ),
              ),
            ),
            const SizedBox(width: 8),
            AnimatedScale(
              scale: isSelected ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 300),
              child: Icon(Icons.check_circle, color: activeColor, size: 20),
            ),
          ],
        ),
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
                  color: Color.fromARGB(255, 0, 64, 255),
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
      title: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Text(
          value,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Color(0xff222B45),
          ),
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
      text: data['Experience']?.toString() ?? '',
    );
    final aboutController = TextEditingController(text: data['About']);

    // CRITICAL: Declare variables OUTSIDE StatefulBuilder
    File? profileImage;
    bool isUploadingImage = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: true,
      builder: (sheetContext) => StatefulBuilder(
        builder: (BuildContext builderContext, StateSetter setModalState) {
          return Container(
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
                const SizedBox(height: 16),
                // Profile Image Section
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey.shade200,
                        backgroundImage: profileImage != null
                            ? FileImage(profileImage!) as ImageProvider
                            : (data['ImageUrl'] != null &&
                                  data['ImageUrl'].toString().isNotEmpty)
                            ? NetworkImage(data['ImageUrl'])
                            : null,
                        child:
                            (profileImage == null &&
                                (data['ImageUrl'] == null ||
                                    data['ImageUrl'].toString().isEmpty))
                            ? const Icon(
                                Icons.person,
                                size: 40,
                                color: AppColors.primary,
                              )
                            : null,
                      ),
                      if (isUploadingImage)
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              shape: BoxShape.circle,
                            ),
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 3,
                              ),
                            ),
                          ),
                        ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: isUploadingImage
                              ? null
                              : () async {
                                  try {
                                    final ImagePicker picker = ImagePicker();
                                    final XFile? picked = await picker
                                        .pickImage(
                                          source: ImageSource.gallery,
                                          imageQuality: 80,
                                        );

                                    if (picked != null) {
                                      setModalState(() {
                                        profileImage = File(picked.path);
                                      });
                                    }
                                  } catch (e) {
                                    print('Error picking image: $e');
                                    if (builderContext.mounted) {
                                      ScaffoldMessenger.of(
                                        builderContext,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text("Failed to pick image"),
                                          backgroundColor: Colors.red,
                                          behavior: SnackBarBehavior.floating,
                                        ),
                                      );
                                    }
                                  }
                                },
                          child: Container(
                            decoration: BoxDecoration(
                              color: isUploadingImage
                                  ? Colors.grey
                                  : AppColors.primary,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            padding: const EdgeInsets.all(6.0),
                            child: Icon(
                              isUploadingImage
                                  ? Icons.hourglass_empty
                                  : Icons.photo_camera,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
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

                // Form Fields
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

                      // Save Button
                      SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          onPressed: isUploadingImage
                              ? null
                              : () async {
                                  try {
                                    setModalState(() {
                                      isUploadingImage = true;
                                    });

                                    String? imageUrl = data['ImageUrl'];

                                    // Upload image if selected
                                    if (profileImage != null) {
                                      try {
                                        print(
                                          '📤 Uploading image to Cloudinary...',
                                        );
                                        imageUrl = await CloudinaryService()
                                            .uploadImage(profileImage!);

                                        if (imageUrl.isNotEmpty) {
                                          print('✅ Image uploaded: $imageUrl');

                                          // Clear cache
                                          if (data['ImageUrl'] != null) {
                                            imageCache.evict(
                                              NetworkImage(data['ImageUrl']),
                                            );
                                          }
                                        } else {
                                          throw Exception('Empty URL returned');
                                        }
                                      } catch (uploadError) {
                                        print('❌ Upload error: $uploadError');

                                        setModalState(() {
                                          isUploadingImage = false;
                                        });

                                        if (builderContext.mounted) {
                                          ScaffoldMessenger.of(
                                            builderContext,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                "❌ Image upload failed: $uploadError",
                                              ),
                                              backgroundColor: Colors.red,
                                              behavior:
                                                  SnackBarBehavior.floating,
                                            ),
                                          );
                                        }
                                        return;
                                      }
                                    }

                                    final updatedData = {
                                      'username': nameController.text.trim(),
                                      'email': emailController.text.trim(),
                                      'role': data['role'],
                                      'Phone Number': phoneController.text
                                          .trim(),
                                      'Speciality': specialityController.text
                                          .trim(),
                                      'Experience': experienceController.text
                                          .trim(),
                                      'About': aboutController.text.trim(),
                                      'ImageUrl': imageUrl,
                                    };

                                    print('💾 Updating profile...');
                                    await provider.updateProfile(
                                      context,
                                      updatedData,
                                    );

                                    // Update provider's selected image
                                    if (profileImage != null) {
                                      provider.setSelectedImage(profileImage);
                                    }

                                    print('✅ Profile updated');

                                    if (builderContext.mounted) {
                                      Navigator.pop(builderContext);
                                      ScaffoldMessenger.of(
                                        builderContext,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            "✅ Profile updated successfully",
                                          ),
                                          backgroundColor: Colors.green,
                                          behavior: SnackBarBehavior.floating,
                                        ),
                                      );
                                    }
                                  } catch (e) {
                                    print('Error updating profile: $e');

                                    setModalState(() {
                                      isUploadingImage = false;
                                    });

                                    if (builderContext.mounted) {
                                      ScaffoldMessenger.of(
                                        builderContext,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            "❌ Failed to update: ${e.toString()}",
                                          ),
                                          backgroundColor: Colors.red,
                                          behavior: SnackBarBehavior.floating,
                                        ),
                                      );
                                    }
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            disabledBackgroundColor: Colors.grey,
                          ),
                          child: isUploadingImage
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5,
                                  ),
                                )
                              : const Text(
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
          );
        },
      ),
    );
  }

  // Helper method for text fields (keep this in your class)
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
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
    );
  }
}
