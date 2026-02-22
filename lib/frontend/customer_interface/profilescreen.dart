// ignore_for_file: deprecated_member_use, sort_child_properties_last

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mental_healthcare/cloudinary/cloudinary_service.dart';
import 'package:mental_healthcare/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:mental_healthcare/backend/customer.dart';
import 'package:mental_healthcare/frontend/customer_interface/finding_therapist.dart';
import 'package:mental_healthcare/frontend/customer_interface/homescreen.dart';
import 'package:mental_healthcare/frontend/customer_interface/loginscreen.dart';
import 'package:mental_healthcare/frontend/widgets/appcolors.dart';
import 'package:mental_healthcare/frontend/widgets/error_handler.dart';
import 'package:mental_healthcare/frontend/widgets/widgets.dart';
import 'package:mental_healthcare/payment_process/stripe_services.dart';

// ─────────────────────────────────────────────
// PROVIDER: Profile + Subscription State
// ─────────────────────────────────────────────
class ProfileProvider extends ChangeNotifier {
  Map<String, dynamic>? _profile;
  bool _loading = false;
  bool _paymentLoading = false;
  String _paymentStatus = 'Pending';
  bool _isPremium = false;

  Map<String, dynamic>? get profile => _profile;
  bool get loading => _loading;
  bool get paymentLoading => _paymentLoading;
  String get paymentStatus => _paymentStatus;
  bool get isPremium => _isPremium;
  // bool isPremium = false;
  String _selectedPaymentMethod = 'both'; // Default

  String get selectedPaymentMethod => _selectedPaymentMethod;

  // Load payment method from Firestore when user logs in
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

      // Update in Firestore
      await FirebaseFirestore.instance.collection('Users').doc(uid).update({
        'Preferred Payment Method': method,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      print('✅ Payment method updated to: $method');
    } catch (e) {
      print('❌ Error updating payment method: $e');
      // Optionally show a snackbar to the user
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
      // Fetch from Firestore
      final userDoc = await FirebaseFirestore.instance
          .collection("Users")
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        // Safely access data
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
    if (_profile != null) return; // prevent unnecessary reload
    _loading = true;
    notifyListeners();

    final data = await Authentication().fetchcustomer(context);
    if (data != null) {
      _profile = data;
      await _fetchPaymentStatus();
    }

    _loading = false;
    notifyListeners();
  }

  Future<void> _fetchPaymentStatus() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid)
          .get();
      final status = doc.data()?['Payment Status'] ?? 'Pending';
      _paymentStatus = status;
      _isPremium = status == 'Completed';
      notifyListeners();
    }
  }

  Future<void> refreshProfile(BuildContext context) async {
    _profile = null;
    await fetchProfile(context);
  }

  void clearProfile() {
    _profile = null;
    _loading = false;
    _paymentLoading = false;
    _paymentStatus = 'Pending';
    _isPremium = false;
    notifyListeners();
  }

  Future<void> updateProfile(
    BuildContext context,
    Map<String, dynamic> newData,
  ) async {
    await Authentication().updateCustomer(context, newData);
    await fetchProfile(context);
  }

  Future<void> makePayment(BuildContext context) async {
    _paymentLoading = true;
    notifyListeners();

    final user = FirebaseAuth.instance.currentUser;
    final stripe = StripeServices();
    final now = DateTime.now();
    final expiryDate = now.add(const Duration(days: 30));
    // 🔥 Get the fresh updated user
    try {
      await stripe.makePayment(9.99, "USD");
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(user!.uid)
          .update({
            "Payment Status": "Completed",
            "Subscription Start Date": FieldValue.serverTimestamp(),
            "Subscription End Date": Timestamp.fromDate(
              DateTime.now().add(const Duration(days: 30)),
            ),
          });
      _paymentStatus = 'Completed';
      _isPremium = true;
    } catch (e) {
      print("$e");
      ErrorHandler.showErrorSnackBar(
        context,
        "❌ Payment failed. Please try again.",
      );
    } finally {
      _paymentLoading = false;
      notifyListeners();
    }
  }
}

// Fixed version of Profilescreen - convert to StatefulWidget

class Profilescreen extends StatefulWidget {
  const Profilescreen({super.key});

  @override
  State<Profilescreen> createState() => _ProfilescreenState();
}

class _ProfilescreenState extends State<Profilescreen> {
  final String title = 'Profile';
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeProfile();
  }

  Future<void> _initializeProfile() async {
    if (_isInitialized) return;

    try {
      final provider = Provider.of<ProfileProvider>(context, listen: false);
      await provider.loadPaymentMethod();
      await provider.fetchProfile(context);
      setState(() {
        _isInitialized = true;
      });
    } catch (e) {
      print('Error initializing profile: $e');
      if (mounted) {
        ErrorHandler.showErrorSnackBar(
          context,
          "Failed to load profile. Please try again.",
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    if (FirebaseAuth.instance.currentUser == null) {
      return WillPopScope(
        onWillPop: () async {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
          return false;
        },
        child: Scaffold(
          backgroundColor: AppColors.background,
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.lock_outline, size: 80, color: AppColors.primary),
                  const SizedBox(height: 24),
                  Text(
                    loc.profileLocked,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textColorPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    loc.loginRequiredMessage,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textColorSecondary,
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      },
                      child: Text(
                        loc.login,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
        return false;
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        bottomNavigationBar: BottomNavBar(currentScreen: title),
        body: SafeArea(
          bottom: false,
          child: Consumer<ProfileProvider>(
            builder: (context, provider, _) {
              if (!_isInitialized ||
                  (provider.loading && provider.profile == null)) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.accent),
                );
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ProfileAppBar(),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () => provider.refreshProfile(context),
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const ProfileCard(),
                            const SizedBox(height: 24),
                            SectionTitle(title: loc.preferences),
                            PreferencesCard(),
                            // SectionTitle(title: loc.userId),
                            // Text(
                            //   FirebaseAuth.instance.currentUser!.uid,
                            //   style: const TextStyle(
                            //     color: AppColors.textColorSecondary,
                            //     fontSize: 14,
                            //   ),
                            // ),
                            const SizedBox(height: 24),
                            SectionTitle(title: loc.subscriptions),
                            const SubscriptionCard(),
                            const SizedBox(height: 40),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

// Fixed ProfileCard with correct image handling
class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key});

  Future<File?> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }

  void _editProfileDialog(BuildContext context, Map<String, dynamic> data) {
    final provider = Provider.of<ProfileProvider>(context, listen: false);
    final nameController = TextEditingController(text: data['username']);
    final emailController = TextEditingController(text: data['email']);

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: AppColors.cardColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              title: Text(
                AppLocalizations.of(context)!.editProfile,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.grey.shade200,
                          backgroundImage:
                              (data['ImageUrl'] != null &&
                                  data['ImageUrl'].toString().isNotEmpty)
                              ? NetworkImage(data['ImageUrl']) as ImageProvider
                              : null,
                          key: ValueKey(data['ImageUrl']),
                          child:
                              (data['ImageUrl'] == null ||
                                  data['ImageUrl'].toString().isEmpty)
                              ? const Icon(
                                  Icons.person,
                                  size: 40,
                                  color: AppColors.primary,
                                )
                              : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () async {
                              try {
                                final imageFile = await _pickImage();
                                if (imageFile == null) return;

                                final imageUrl = await CloudinaryService()
                                    .uploadImage(imageFile);

                                if (imageUrl.isNotEmpty) {
                                  if (data['ImageUrl'] != null) {
                                    imageCache.evict(
                                      NetworkImage(data['ImageUrl']),
                                    );
                                  }

                                  await provider.updateProfile(context, {
                                    'ImageUrl': imageUrl,
                                  });

                                  setState(() {
                                    data['ImageUrl'] = imageUrl;
                                  });

                                  if (context.mounted) {
                                    ErrorHandler.showSuccessSnackBar(
                                      context,
                                      "✅ Image updated successfully",
                                    );
                                  }
                                }
                              } catch (e) {
                                print('Error updating image: $e');
                                if (context.mounted) {
                                  ErrorHandler.showErrorSnackBar(
                                    context,
                                    "Failed to update image",
                                  );
                                }
                              }
                            },
                            child: Container(
                              width: 35,
                              height: 35,
                              decoration: const BoxDecoration(
                                color: Colors.black,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.edit_outlined,
                                color: AppColors.background,
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: "Username",
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        labelText: "Email",
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () async {
                    try {
                      await FirebaseFirestore.instance
                          .collection('Users')
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .update({
                            'ImageUrl': data['ImageUrl'],
                            'username': nameController.text.trim(),
                            'email': emailController.text.trim(),
                            'updatedAt': FieldValue.serverTimestamp(),
                          });

                      if (context.mounted) {
                        Navigator.pop(context);
                        ErrorHandler.showSuccessSnackBar(
                          context,
                          AppLocalizations.of(context)!.profileUpdated,
                        );
                      }
                    } catch (e) {
                      print('Error updating profile: $e');
                      if (context.mounted) {
                        ErrorHandler.showErrorSnackBar(
                          context,
                          AppLocalizations.of(context)!.profileUpdateFailed,
                        );
                      }
                    }
                  },
                  child: const Text("Save"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProfileProvider>(context);
    final data = provider.profile;
    final loc = AppLocalizations.of(context)!;
    if (data == null) {
      return Center(child: Text(loc.noRecordFound));
    }

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.accent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.white,
            backgroundImage:
                (data['ImageUrl'] != null &&
                    data['ImageUrl'].toString().isNotEmpty)
                ? NetworkImage(data['ImageUrl']) as ImageProvider
                : null,
            child:
                (data['ImageUrl'] == null ||
                    data['ImageUrl'].toString().isEmpty)
                ? const Icon(Icons.person, size: 40, color: AppColors.primary)
                : null,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '${data['username']}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    provider.isPremium
                        ? Padding(
                            padding: const EdgeInsets.only(left: 6.0),
                            child: Icon(
                              Icons.verified,
                              color: Colors.white,
                              size: 20,
                            ),
                          )
                        : SizedBox(),
                  ],
                ),
                Text(
                  '${data['email']}',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
                Text(
                  'Role: ${data['role'] ?? 'Not assigned'}',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 13,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: Colors.white),
            onPressed: () => _editProfileDialog(context, data),
          ),
        ],
      ),
    );
  }
}

// // ─────────────────────────────────────────────
// // TOP APP BAR
// // ─────────────────────────────────────────────
class ProfileAppBar extends StatelessWidget {
  const ProfileAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, top: 10.0, bottom: 8.0),
      child: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios,
          color: AppColors.textColorPrimary,
          size: 24,
        ),
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────
// SECTION TITLE
// ─────────────────────────────────────────────
class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Text(
        title,
        style: const TextStyle(
          color: AppColors.sectionTitleColor,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// PREFERENCES CARD
// ─────────────────────────────────────────────
class PreferencesCard extends StatelessWidget {
  const PreferencesCard({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Card(
      color: AppColors.cardColor,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        children: [
          _buildItem(Icons.language_outlined, loc.language),
          _buildItem(Icons.help_outline, loc.helpSupport),
          _buildItem(Icons.favorite_border, loc.aboutApp, isLast: true),
        ],
      ),
    );
  }

  Widget _buildItem(
    IconData icon,
    String title, {
    String? trailing,
    bool isLast = false,
  }) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: AppColors.primary),
          title: Text(title),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (trailing != null)
                Text(
                  trailing,
                  style: const TextStyle(color: AppColors.textColorSecondary),
                ),
              const Icon(
                Icons.chevron_right,
                color: AppColors.textColorSecondary,
              ),
            ],
          ),
        ),
        if (!isLast)
          const Divider(height: 1, indent: 60, color: AppColors.stripedColor),
      ],
    );
  }
}

// // ─────────────────────────────────────────────
// // SUBSCRIPTION CARD (with provider)
// // ─────────────────────────────────────────────
class SubscriptionCard extends StatelessWidget {
  const SubscriptionCard({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProfileProvider>(context);

    return Column(
      children: [
        Card(
          color: AppColors.cardColor,
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.star_outline, color: AppColors.primary),
                        const SizedBox(width: 8),
                        Text(
                          AppLocalizations.of(context)!.currentTier,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 32.0),
                      child: Text(
                        provider.isPremium ? 'Premium' : 'Free',
                        style: const TextStyle(
                          color: AppColors.textColorSecondary,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: provider.isPremium
                        ? AppColors.primary
                        : AppColors.accent,
                    // foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 10,
                    ),
                  ),
                  onPressed: provider.paymentLoading || provider.isPremium
                      ? null
                      : () => provider.makePayment(context),
                  child: provider.paymentLoading
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            // color: Colors.white,
                          ),
                        )
                      : Icon(
                          provider.isPremium
                              ? Icons.lock_open_outlined
                              : Icons.lock_outline,
                          color: provider.isPremium
                              ? AppColors.accent
                              : AppColors.cardColor,

                          size: 24,
                        ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 20),
        provider.isPremium
            ? Card(
                color: AppColors.cardColor,
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final bool isSmallScreen = constraints.maxWidth < 400;

                      Widget paymentOption({
                        required String value,
                        required String label,
                        required IconData icon,
                        required Color activeColor,
                      }) {
                        final bool isSelected =
                            provider.selectedPaymentMethod == value;

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
                                    : AppColors.textColorSecondary.withOpacity(
                                        0.3,
                                      ),
                                width: 2,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  icon,
                                  color: isSelected
                                      ? activeColor
                                      : AppColors.textColorSecondary,
                                  size: 22,
                                ),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: Text(
                                    label,
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
                                  child: Icon(
                                    Icons.check_circle,
                                    color: activeColor,
                                    size: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      return Column(
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

                          /// Cash & Insurance
                          isSmallScreen
                              ? Column(
                                  children: [
                                    paymentOption(
                                      value: 'Cash',
                                      label: 'Cash',
                                      icon: Icons.attach_money,
                                      activeColor: AppColors.primary,
                                    ),
                                    const SizedBox(height: 10),
                                    paymentOption(
                                      value: 'Insurance',
                                      label: 'Insurance',
                                      icon: Icons.shield_outlined,
                                      activeColor: AppColors.accent,
                                    ),
                                  ],
                                )
                              : Row(
                                  children: [
                                    Expanded(
                                      child: paymentOption(
                                        value: 'Cash',
                                        label: 'Cash',
                                        icon: Icons.attach_money,
                                        activeColor: AppColors.primary,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: paymentOption(
                                        value: 'Insurance',
                                        label: 'Insurance',
                                        icon: Icons.shield_outlined,
                                        activeColor: AppColors.accent,
                                      ),
                                    ),
                                  ],
                                ),

                          const SizedBox(height: 12),

                          /// Both option
                          SizedBox(
                            width: double.infinity,
                            child: paymentOption(
                              value: 'Both',
                              label: 'Both',
                              icon: Icons.shield_outlined,
                              activeColor: AppColors.success,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              )
            : SizedBox(),
        const SizedBox(height: 20),
        GestureDetector(
          onTap: provider.isPremium
              ? () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => FindingTherapist()),
                )
              : () => provider.makePayment(context),
          child: Container(
            width: double.infinity,
            height: 60,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.accent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: provider.paymentLoading
                ? Center(child: CircularProgressIndicator())
                : Center(
                    child: Text(
                      provider.isPremium
                          ? AppLocalizations.of(context)!.findPractitioner
                          : AppLocalizations.of(context)!.upgradePremium,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 19,
                      ),
                    ),
                  ),
          ),
        ),
        // SizedBox(height: 20),
      ],
    );
  }
}
