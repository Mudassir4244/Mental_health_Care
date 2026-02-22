// edit_profile_role_based.dart
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:mental_healthcare/frontend/widgets/appcolors.dart';

/// ======================
/// EditProfileProvider
/// ======================
class EditProfileProvider extends ChangeNotifier {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final ImagePicker _picker = ImagePicker();

  // Form controllers
  final usernameController = TextEditingController();
  final phoneController = TextEditingController();
  final cityController = TextEditingController();
  final experienceController = TextEditingController();
  final specializationController = TextEditingController();
  final bioController = TextEditingController();
  final organizationController = TextEditingController();
  final emailController = TextEditingController();

  File? pickedImageFile;
  String? uploadedImageUrl;
  bool isLoading = false;
  bool isSaving = false;
  String? role;

  /// Loads current user data based on role
  Future<void> loadUserData() async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      isLoading = true;
      notifyListeners();

      final doc = await _firestore.collection('Users').doc(user.uid).get();
      if (!doc.exists) return;

      final data = doc.data()!;
      role = (data['role'] ?? 'customer').toString().toLowerCase();

      switch (role) {
        case 'practitioner':
          usernameController.text = (data['Fullname'] ?? '') as String;
          phoneController.text = (data['Phone Number'] ?? '') as String;
          // cityController.text = (data['city'] ?? '') as String;
          experienceController.text = (data['Experience'] ?? '') as String;
          specializationController.text = (data['Speciality'] ?? '') as String;

          uploadedImageUrl = (data['photoUrl'] ?? '') as String?;
          break;

        case 'customer':
          usernameController.text = (data['username'] ?? '') as String;
          phoneController.text = (data['phone'] ?? '') as String;
          cityController.text = (data['city'] ?? '') as String;
          uploadedImageUrl = (data['photoUrl'] ?? '') as String?;
          break;

        case 'organization owner':
        case 'organizationowner':
          organizationController.text =
              (data['organizationName'] ?? '') as String;
          emailController.text = (data['email'] ?? '') as String;
          uploadedImageUrl = (data['photoUrl'] ?? '') as String?;
          break;

        case 'organization employee':
        case 'organizationemployee':
          usernameController.text = (data['username'] ?? '') as String;
          emailController.text = (data['email'] ?? '') as String;
          uploadedImageUrl = (data['photoUrl'] ?? '') as String?;
          break;

        default:
          // Default fallback
          usernameController.text = (data['username'] ?? '') as String;
          uploadedImageUrl = (data['photoUrl'] ?? '') as String?;
      }
    } catch (e) {
      debugPrint('Error loading user data: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Pick image
  Future<void> pickImage({bool fromCamera = false}) async {
    try {
      final picked = await _picker.pickImage(
        source: fromCamera ? ImageSource.camera : ImageSource.gallery,
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 80,
      );
      if (picked == null) return;
      pickedImageFile = File(picked.path);
      notifyListeners();
    } catch (e) {
      debugPrint('Image pick error: $e');
    }
  }

  /// Upload image (mock, replace with Firebase Storage if needed)
  Future<String?> uploadProfileImage() async {
    if (pickedImageFile == null) return uploadedImageUrl;
    // Implement Firebase Storage upload if needed
    return uploadedImageUrl; // For now, keep old URL
  }

  /// Validate fields (basic)
  String? validateFields() {
    if (role == 'practitioner' ||
        role == 'customer' ||
        role == 'organization employee' ||
        role == 'organizationemployee') {
      if (usernameController.text.trim().isEmpty) return 'Enter username';
    }
    if (role == 'practitioner' || role == 'customer') {
      if (phoneController.text.trim().isEmpty) return 'Enter phone';
    }
    return null;
  }

  /// Save profile
  Future<bool> saveProfile() async {
    final user = _auth.currentUser;
    if (user == null) return false;

    final validationError = validateFields();
    if (validationError != null) throw Exception(validationError);

    try {
      isSaving = true;
      notifyListeners();

      final imageUrl = await uploadProfileImage();
      final updateData = <String, dynamic>{};

      switch (role) {
        case 'practitioner':
          updateData.addAll({
            'username': usernameController.text.trim(),
            'phone': phoneController.text.trim(),
            'city': cityController.text.trim(),
            'experience': experienceController.text.trim(),
            'specialization': specializationController.text.trim(),
            'bio': bioController.text.trim(),
          });
          break;

        case 'customer':
          updateData.addAll({
            'username': usernameController.text.trim(),
            'phone': phoneController.text.trim(),
            'city': cityController.text.trim(),
          });
          break;

        case 'organization owner':
        case 'organizationowner':
          updateData.addAll({
            'organizationName': organizationController.text.trim(),
            'email': emailController.text.trim(),
          });
          break;

        case 'organization employee':
        case 'organizationemployee':
          updateData.addAll({
            'username': usernameController.text.trim(),
            'email': emailController.text.trim(),
          });
          break;
      }

      if (imageUrl != null && imageUrl.isNotEmpty) {
        updateData['photoUrl'] = imageUrl;
      }

      await _firestore
          .collection('Users')
          .doc(user.uid)
          .set(updateData, SetOptions(merge: true));

      isSaving = false;
      notifyListeners();
      return true;
    } catch (e) {
      isSaving = false;
      notifyListeners();
      rethrow;
    }
  }

  @override
  void dispose() {
    usernameController.dispose();
    phoneController.dispose();
    cityController.dispose();
    experienceController.dispose();
    specializationController.dispose();
    bioController.dispose();
    organizationController.dispose();
    emailController.dispose();
    super.dispose();
  }

  void clearData() {
    usernameController.clear();
    phoneController.clear();
    cityController.clear();
    experienceController.clear();
    specializationController.clear();
    bioController.clear();
    organizationController.clear();
    emailController.clear();

    pickedImageFile = null;
    uploadedImageUrl = null;
    isLoading = false;
    isSaving = false;
    role = null;
    notifyListeners();
  }
}

/// ======================
/// EditProfileScreen
/// ======================
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late EditProfileProvider provider;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider = Provider.of<EditProfileProvider>(context, listen: false);
      provider.loadUserData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<EditProfileProvider>(
      create: (_) => EditProfileProvider(),
      child: Consumer<EditProfileProvider>(
        builder: (context, prov, _) {
          if (prov.isLoading) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
            );
          }

          return Scaffold(
            appBar: AppBar(
              title: const Text('Edit Profile'),
              backgroundColor: AppColors.primary,
              centerTitle: true,
            ),
            body: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Profile Avatar
                      _buildAvatarSection(prov),

                      const SizedBox(height: 20),

                      // Role-based fields
                      if (prov.role == 'practitioner' ||
                          prov.role == 'customer' ||
                          prov.role == 'organization employee' ||
                          prov.role == 'organizationemployee') ...[
                        _buildTextField(
                          controller: prov.usernameController,
                          label: 'Username',
                        ),
                      ],

                      if (prov.role == 'practitioner' ||
                          prov.role == 'customer') ...[
                        const SizedBox(height: 12),
                        _buildTextField(
                          controller: prov.phoneController,
                          label: 'Phone',
                          keyboardType: TextInputType.phone,
                        ),
                        const SizedBox(height: 12),
                        _buildTextField(
                          controller: prov.cityController,
                          label: 'City',
                        ),
                      ],

                      if (prov.role == 'practitioner') ...[
                        const SizedBox(height: 12),
                        _buildTextField(
                          controller: prov.experienceController,
                          label: 'Experience',
                        ),
                        const SizedBox(height: 12),
                        _buildTextField(
                          controller: prov.specializationController,
                          label: 'Specialization',
                        ),
                        const SizedBox(height: 12),
                        _buildTextField(
                          controller: prov.bioController,
                          label: 'About / Bio',
                          maxLines: 4,
                        ),
                      ],

                      if (prov.role == 'organization owner' ||
                          prov.role == 'organizationowner') ...[
                        _buildTextField(
                          controller: prov.organizationController,
                          label: 'Organization Name',
                        ),
                        const SizedBox(height: 12),
                        _buildTextField(
                          controller: prov.emailController,
                          label: 'Email',
                        ),
                      ],

                      if (prov.role == 'organization employee' ||
                          prov.role == 'organizationemployee') ...[
                        const SizedBox(height: 12),
                        _buildTextField(
                          controller: prov.emailController,
                          label: 'Email',
                        ),
                      ],

                      const SizedBox(height: 24),

                      prov.isSaving
                          ? const CircularProgressIndicator(
                              color: AppColors.primary,
                            )
                          : SizedBox(
                              width: double.infinity,
                              height: 52,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onPressed: () async {
                                  if (!_formKey.currentState!.validate()) {
                                    return;
                                  }
                                  try {
                                    final success = await prov.saveProfile();
                                    if (success && mounted) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Profile updated successfully',
                                          ),
                                        ),
                                      );
                                      Navigator.pop(context);
                                    }
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Error: ${e.toString()}'),
                                      ),
                                    );
                                  }
                                },
                                child: const Text(
                                  'Save Changes',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAvatarSection(EditProfileProvider prov) {
    final photoUrl = prov.uploadedImageUrl;
    final hasLocalImage = prov.pickedImageFile != null;
    final displayImage = hasLocalImage
        ? Image.file(prov.pickedImageFile!, fit: BoxFit.cover)
        : (photoUrl != null && photoUrl.isNotEmpty
              ? Image.network(photoUrl, fit: BoxFit.cover)
              : null);

    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            CircleAvatar(
              radius: 56,
              backgroundColor: AppColors.primary.withOpacity(0.1),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(56),
                child: SizedBox(
                  width: 112,
                  height: 112,
                  child:
                      displayImage ??
                      const Icon(
                        Icons.person,
                        size: 56,
                        color: AppColors.primary,
                      ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.camera_alt,
                      color: AppColors.primary,
                    ),
                    onPressed: () => prov.pickImage(fromCamera: true),
                  ),
                  IconButton(
                    icon: const Icon(Icons.photo, color: AppColors.primary),
                    onPressed: () => prov.pickImage(fromCamera: false),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextButton(
          onPressed: () {
            prov.pickedImageFile = null;
            prov.uploadedImageUrl = null;
            prov.notifyListeners();
          },
          child: const Text(
            'Remove Photo',
            style: TextStyle(color: Colors.red),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: (v) => v == null || v.trim().isEmpty ? 'Enter $label' : null,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
