import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:mental_healthcare/backend/oraganization.dart';
import 'package:mental_healthcare/frontend/widgets/appcolors.dart';

// import '../providers/loading_provider.dart';
class LoadingProvider extends ChangeNotifier {
  bool isLoading = false;

  void setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }
}

class CreateCredentialsScreen extends StatefulWidget {
  final Map<String, dynamic>? userData;
  final String? docId;

  const CreateCredentialsScreen({super.key, this.userData, this.docId});

  @override
  State<CreateCredentialsScreen> createState() =>
      _CreateCredentialsScreenState();
}

class _CreateCredentialsScreenState extends State<CreateCredentialsScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _obscurePassword = true;

  final OrganAuth auth = OrganAuth();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    if (widget.userData != null) {
      usernameController.text = widget.userData!['username'] ?? '';
      emailController.text = widget.userData!['email'] ?? '';
      passwordController.text = widget.userData!['Password'] ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final loadingProvider = Provider.of<LoadingProvider>(context);
    final isEditMode = widget.docId != null;

    return Scaffold(
      backgroundColor: const Color(0xfff8f9fb),
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primary, AppColors.accent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
        title: Text(
          isEditMode ? "Update User" : "Create Credentials",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        elevation: 4,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xffe9f5ff), Color(0xfff8f9fb)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              children: [
                // Organization name (Only show in create mode or if needed)
                if (!isEditMode)
                  FutureBuilder(
                    future: auth.fetch_organowner(context),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                          ),
                        );
                      }

                      final organName =
                          snapshot.data?["Organization name"] ?? "Organization";

                      return TextField(
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: "Organization: $organName",
                          labelStyle: TextStyle(color: AppColors.primary),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(
                              color: AppColors.primary.withOpacity(0.3),
                              width: 1.2,
                            ),
                          ),
                          prefixIcon: Icon(
                            Icons.account_balance_rounded,
                            color: AppColors.primary,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                        ),
                      );
                    },
                  ),

                if (!isEditMode) const SizedBox(height: 20),

                // Username
                _buildTextField(
                  controller: usernameController,
                  label: "Username",
                  icon: Icons.person,
                ),

                const SizedBox(height: 20),

                // Email
                _buildTextField(
                  controller: emailController,
                  label: "Email",
                  icon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                  // Disable email editing in edit mode to avoid auth issues for now
                  // or keep it enabled if just updating metadata
                  readOnly: isEditMode,
                  helperText: isEditMode ? "Email cannot be changed" : null,
                ),

                const SizedBox(height: 20),

                // Password
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
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),

                const SizedBox(height: 40),

                loadingProvider.isLoading
                    ? CircularProgressIndicator(
                        color: AppColors.primary,
                        strokeWidth: 3,
                      )
                    : ElevatedButton(
                        onPressed: () async {
                          if (usernameController.text.isEmpty ||
                              emailController.text.isEmpty ||
                              passwordController.text.isEmpty) {
                            Get.snackbar(
                              "Error",
                              "All fields are required",
                              backgroundColor: Colors.white,
                              colorText: Colors.redAccent,
                            );
                            return;
                          }

                          loadingProvider.setLoading(true);

                          try {
                            if (isEditMode) {
                              // Update existing user metadata
                              await _firestore
                                  .collection('Users')
                                  .doc(widget.docId)
                                  .update({
                                    'username': usernameController.text.trim(),
                                    'Password': passwordController.text.trim(),
                                    // We don't update email here to avoid auth mismatch
                                  });
                              Get.snackbar(
                                "Success",
                                "User updated successfully!",
                                backgroundColor: Colors.white,
                                colorText: Colors.green,
                              );
                              Navigator.pop(context);
                            } else {
                              // Create new user
                              await auth.add_user(
                                Username: usernameController.text,
                                Useremail: emailController.text,
                                Userpassword: passwordController.text,
                                context: context,
                                payment_status: "Completed",
                              );

                              // Clear fields
                              usernameController.clear();
                              emailController.clear();
                              passwordController.clear();

                              // Note: add_user handles navigation/snackbar internally usually,
                              // but here we might want to pop or stay.
                              // Based on previous code, it just showed snackbar.
                            }
                          } catch (e) {
                            Get.snackbar(
                              "Error",
                              e.toString(),
                              backgroundColor: Colors.redAccent,
                              colorText: Colors.white,
                            );
                          }

                          loadingProvider.setLoading(false);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 60,
                            vertical: 18,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 5,
                          shadowColor: AppColors.primary.withOpacity(0.4),
                        ),
                        child: Text(
                          isEditMode ? "Update User" : "Create Credentials",
                          style: const TextStyle(
                            fontSize: 18,
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputType keyboardType = TextInputType.text,
    bool readOnly = false,
    String? helperText,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      readOnly: readOnly,
      style: const TextStyle(color: Colors.black87, fontSize: 16),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.grey[600]),
        suffixIcon: suffixIcon,
        labelText: label,
        helperText: helperText,
        labelStyle: TextStyle(color: Colors.grey[600]),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey[300]!, width: 1.2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: AppColors.primary, width: 1.5),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }
}
