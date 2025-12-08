import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:mental_healthcare/backend/oraganization.dart';
// import '../providers/loading_provider.dart';
class LoadingProvider extends ChangeNotifier {
  bool isLoading = false;

  void setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }
}
class CreateCredentialsScreen extends StatefulWidget {
  const CreateCredentialsScreen({super.key});

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

  @override
  Widget build(BuildContext context) {
    final loadingProvider = Provider.of<LoadingProvider>(context);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF0D47A1),
              Color(0xFF1976D2),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            child: Column(
              children: [
                const Text(
                  "Create Credentials",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 40),

                // Organization name
                FutureBuilder(
                  future: auth.fetch_organowner(context),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator(color: Colors.white);
                    }
                    if (snapshot.hasError) {
                      return const Text(
                        "Error fetching organization",
                        style: TextStyle(color: Colors.white),
                      );
                    }

                    final organName =
                        snapshot.data?["Organization name"] ?? "Organization";

                    return TextField(
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: organName,
                        labelStyle: const TextStyle(color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide:
                              const BorderSide(color: Colors.white54, width: 1.2),
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

                loadingProvider.isLoading
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
                              "All fields are required",
                              backgroundColor: Colors.white,
                              colorText: Colors.redAccent,
                            );
                            return;
                          }

                          loadingProvider.setLoading(true);

                          try {
                            await auth.add_user(
                              Username: usernameController.text,
                              Useremail: emailController.text,
                              Userpassword: passwordController.text,
                              context: context,
                              payment_status: "Completed",
                            );

                            Get.snackbar(
                              "Success",
                              "Credentials created!",
                              backgroundColor: Colors.white,
                              colorText: Colors.blueAccent,
                            );

                            usernameController.clear();
                            emailController.clear();
                            passwordController.clear();
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
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.blueAccent,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 60, vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
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

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';

// class CreateCredentialsScreen extends StatefulWidget {
//   final Map<String, dynamic>? userData;
//   final String? docId;

//   const CreateCredentialsScreen({super.key, this.userData, this.docId});

//   @override
//   State<CreateCredentialsScreen> createState() =>
//       _CreateCredentialsScreenState();
// }

// class _CreateCredentialsScreenState extends State<CreateCredentialsScreen> {
//   final TextEditingController _usernameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();

//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   bool isLoading = false;

//   @override
//   void initState() {
//     super.initState();

//     // Prefill for edit mode
//     if (widget.userData != null) {
//       _usernameController.text = widget.userData!['Username'] ?? '';
//       _emailController.text = widget.userData!['Email'] ?? '';
//       _passwordController.text = widget.userData!['Password'] ?? '';
//     }
//   }

//   Future<void> saveUser() async {
//     setState(() => isLoading = true);

//     final currentUserId = _auth.currentUser?.uid;

//     if (_usernameController.text.isEmpty ||
//         _emailController.text.isEmpty ||
//         _passwordController.text.isEmpty) {
//       Fluttertoast.showToast(msg: 'All fields are required');
//       setState(() => isLoading = false);
//       return;
//     }

//     try {
//       if (widget.docId == null) {
//         // Create new user
//         await _firestore.collection('Users').add({
//           'Username': _usernameController.text,
//           'Email': _emailController.text,
//           'Password': _passwordController.text,
//           'Created by': currentUserId,
//           'role': 'Organization Employee',
//         });
//         Fluttertoast.showToast(msg: 'User added successfully');
//       } else {
//         // Update existing user
//         await _firestore.collection('Users').doc(widget.docId).update({
//           'Username': _usernameController.text,
//           'Email': _emailController.text,
//           'Password': _passwordController.text,
//         });
//         Fluttertoast.showToast(msg: 'User updated successfully');
//       }

//       Navigator.pop(context);
//     } catch (e) {
//       Fluttertoast.showToast(msg: 'Error: $e');
//     }

//     setState(() => isLoading = false);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         width: double.infinity,
//         height: double.infinity,
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Color(0xFF1A73E8), Color(0xFF64B5F6)],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//         ),
//         child: SafeArea(
//           child: Center(
//             child: SingleChildScrollView(
//               padding: const EdgeInsets.all(24),
//               child: Column(
//                 children: [
//                   Text(
//                     widget.docId == null ? "Create Credentials" : "Update User",
//                     style: const TextStyle(
//                       fontSize: 26,
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 40),

//                   TextField(
//                     controller: _usernameController,
//                     decoration: const InputDecoration(
//                       labelText: 'Username',
//                       filled: true,
//                       fillColor: Colors.white,
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   TextField(
//                     controller: _emailController,
//                     decoration: const InputDecoration(
//                       labelText: 'Email',
//                       filled: true,
//                       fillColor: Colors.white,
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   TextField(
//                     controller: _passwordController,
//                     decoration: const InputDecoration(
//                       labelText: 'Password',
//                       filled: true,
//                       fillColor: Colors.white,
//                       border: OutlineInputBorder(),
//                     ),
//                     obscureText: true,
//                   ),
//                   const SizedBox(height: 40),

//                   isLoading
//                       ? const CircularProgressIndicator(color: Colors.white)
//                       : ElevatedButton(
//                           onPressed: saveUser,
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.white,
//                             foregroundColor: const Color(0xFF1A73E8),
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 80,
//                               vertical: 16,
//                             ),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(14),
//                             ),
//                           ),
//                           child: Text(
//                             widget.docId == null
//                                 ? 'Create User'
//                                 : 'Update User',
//                             style: const TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
