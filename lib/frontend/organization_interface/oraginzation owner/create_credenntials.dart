import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:get/get.dart';
import 'package:mental_healthcare/backend/oraganization.dart';

/// 🌀 Riverpod State Provider for Loading
final isLoadingProvider = StateProvider<bool>((ref) => false);

class CreateCredentialsScreen extends ConsumerStatefulWidget {
  const CreateCredentialsScreen({super.key});

  @override
  ConsumerState<CreateCredentialsScreen> createState() =>
      _CreateCredentialsScreenState();
}

class _CreateCredentialsScreenState
    extends ConsumerState<CreateCredentialsScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _obscurePassword = true;

  final OrganAuth auth = OrganAuth();

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(isLoadingProvider);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF0D47A1), // Dark Blue
              Color(0xFF1976D2), // Medium Blue
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Create Credentials",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 40),

                // 🔹 Organization name (from Firestore)
                FutureBuilder(
                  future: auth.fetch_organowner(context),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      );
                    } else if (snapshot.hasError) {
                      return const Text(
                        'Error fetching organization data',
                        style: TextStyle(color: Colors.redAccent),
                      );
                    } else if (!snapshot.hasData || snapshot.data == null) {
                      return const Text(
                        'No organization data found',
                        style: TextStyle(color: Colors.white),
                      );
                    }

                    final organName = snapshot.data!['Organization name'] ?? '';

                    return TextField(
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: organName,
                        labelStyle: const TextStyle(color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(
                            width: 1.2,
                            color: Colors.white54,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            width: 1.5,
                            color: Colors.white,
                          ),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        prefixIcon: const Icon(
                          Icons.account_balance_rounded,
                          color: Colors.white,
                        ),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.15),
                      ),
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    );
                  },
                ),

                const SizedBox(height: 20),

                // 🔹 Username
                _buildTextField(
                  controller: usernameController,
                  label: "Username",
                  icon: Icons.person,
                ),
                const SizedBox(height: 20),

                // 🔹 Email
                _buildTextField(
                  controller: emailController,
                  label: "Email",
                  icon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),

                // 🔹 Password
                _buildTextField(
                  controller: passwordController,
                  label: "Password",
                  icon: Icons.lock,
                  obscureText: _obscurePassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 40),

                // 🔹 Button or Loader
                isLoading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 3,
                      )
                    : ElevatedButton(
                        onPressed: () async {
                          if (usernameController.text.isEmpty ||
                              emailController.text.isEmpty ||
                              passwordController.text.isEmpty) {
                            Get.snackbar(
                              "Error",
                              "All fields are required to create credentials",
                              backgroundColor: Colors.white,
                              colorText: Colors.redAccent,
                            );
                            return;
                          }

                          ref.read(isLoadingProvider.notifier).state = true;

                          try {
                            await auth.add_user(
                              Username: usernameController.text,
                              Useremail: emailController.text,
                              Userpassword: passwordController.text,
                              context: context,
                              payment_status: "Completed",
                            );

                            Get.snackbar(
                              'Success ✅',
                              "Credentials have been successfully created!",
                              backgroundColor: Colors.white,
                              colorText: Colors.blueAccent,
                            );
                            usernameController.clear();
                            passwordController.clear();
                            emailController.clear();
                          } catch (error) {
                            Get.snackbar(
                              'Error ❌',
                              error.toString(),
                              backgroundColor: Colors.redAccent,
                              colorText: Colors.white,
                            );
                          }

                          ref.read(isLoadingProvider.notifier).state = false;
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.blueAccent,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 60,
                            vertical: 18,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 6,
                        ),
                        child: const Text(
                          "Create Credentials",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
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

  /// 🔹 Reusable TextField Widget
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white, fontSize: 18),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.white),
        suffixIcon: suffixIcon,
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.white54, width: 1.2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.white, width: 1.5),
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.15),
      ),
    );
  }
}
