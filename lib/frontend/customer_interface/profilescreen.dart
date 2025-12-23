// ignore_for_file: deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
  bool isLoading = true;

  Future<void> loadProfile() async {
    isLoading = true;
    notifyListeners();

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _isPremium = false;
      isLoading = false;
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

    isLoading = false;
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
    final stripe = StripServices();

    try {
      await stripe.makepayments(9.99, "USD");
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(user!.uid)
          .update({'Payment Status': 'Completed'});
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

// ─────────────────────────────────────────────
// MAIN PROFILE SCREEN
// ─────────────────────────────────────────────
class Profilescreen extends StatelessWidget {
  final String title = 'Profile';
  const Profilescreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                  const Text(
                    "Profile Locked",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textColorPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "You must login to view and edit your profile.",
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
                      child: const Text(
                        "Login Now",
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
          bottomNavigationBar: BottomNavBar(currentScreen: title),
        ),
      );
    }

    final provider = Provider.of<ProfileProvider>(context, listen: true);
    // fetch profile only once when screen builds first time
    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider.fetchProfile(context);
    });

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
        body: Stack(
          children: [
            SafeArea(
              bottom: false,
              child: Consumer<ProfileProvider>(
                builder: (context, provider, _) {
                  if (provider.loading && provider.profile == null) {
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
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const ProfileCard(),
                                const SizedBox(height: 24),
                                const SectionTitle(title: 'Preferences'),
                                const PreferencesCard(),
                                const SectionTitle(title: 'User ID'),
                                Text(
                                  FirebaseAuth.instance.currentUser!.uid
                                      .toString(),
                                  style: const TextStyle(
                                    color: AppColors.textColorSecondary,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                const SectionTitle(title: 'Subscriptions'),
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
            Align(
              alignment: Alignment.bottomCenter,
              child: BottomNavBar(currentScreen: title),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// TOP APP BAR
// ─────────────────────────────────────────────
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
// PROFILE CARD
// ─────────────────────────────────────────────
class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key});

  void _editProfileDialog(BuildContext context, Map<String, dynamic> data) {
    final provider = Provider.of<ProfileProvider>(context, listen: false);
    final nameController = TextEditingController(text: data['username']);
    final emailController = TextEditingController(text: data['email']);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text(
            "Edit Profile",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              children: [
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
                final updatedData = {
                  'username': nameController.text.trim(),
                  'email': emailController.text.trim(),
                };
                await provider.updateProfile(context, updatedData);
                Navigator.pop(context);
                ErrorHandler.showSuccessSnackBar(
                  context,
                  "✅ Profile updated successfully",
                );
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProfileProvider>(context);
    final data = provider.profile;

    if (data == null) {
      return const Center(child: Text("No record found."));
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
          const CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white,
            child: Icon(Icons.person, size: 40, color: AppColors.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${data['username']}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
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
    return Card(
      color: AppColors.cardColor,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        children: [
          _buildItem(Icons.language_outlined, 'Language', trailing: 'English'),
          _buildItem(Icons.help_outline, 'Help & Support'),
          _buildItem(Icons.favorite_border, 'About App', isLast: true),
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

// ─────────────────────────────────────────────
// SUBSCRIPTION CARD (with provider)
// ─────────────────────────────────────────────
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
                        const Text(
                          'Current Tier',
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
                          ? 'Find Practitioner'
                          : 'Upgrade to Premium 9.99 USD',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 19,
                      ),
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
