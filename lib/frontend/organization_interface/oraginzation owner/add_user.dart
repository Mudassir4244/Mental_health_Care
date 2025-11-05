// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:get/get.dart';
// import 'package:mental_healthcare/backend/oraganization.dart';
// import 'package:mental_healthcare/frontend/widgets/appcolors.dart';

// class CreateCredentialsScreen extends StatefulWidget {
//   const CreateCredentialsScreen({super.key});

//   @override
//   State<CreateCredentialsScreen> createState() =>
//       _CreateCredentialsScreenState();
// }

// class _CreateCredentialsScreenState extends State<CreateCredentialsScreen> {
//   bool _showForm = false;
//   bool _isloading = false;
//   bool _obscurePassword = true;
//   final _formKey = GlobalKey<FormState>();
//   final auth = OrganAuth();

//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final TextEditingController usernameController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Color(0xFF3A7BD5), Color(0xFF00D2FF)],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//         ),
//         child: Center(
//           child: AnimatedSwitcher(
//             duration: const Duration(milliseconds: 500),
//             child: _showForm
//                 ? _buildCredentialsForm(context)
//                 : _buildSavedCredentialsList(context),
//           ),
//         ),
//       ),
//     );
//   }

//   // -----------------------------------------------------------------
//   // 🔹 Firestore Stream (Only Organization Employees)
//   // -----------------------------------------------------------------
//   Widget _buildSavedCredentialsList(BuildContext context) {
//     return SingleChildScrollView(
//       key: const ValueKey('savedList'),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const Text(
//             "Saved Organization Employees",
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 22,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const SizedBox(height: 20),

//           StreamBuilder<QuerySnapshot>(
//             stream: FirebaseFirestore.instance
//                 .collection("Users")
//                 .where('role', isEqualTo: 'Organization Employee')
//                 .where(
//                   'Created by',
//                   isEqualTo: FirebaseAuth.instance.currentUser!.uid,
//                 )
//                 .snapshots(),
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return const Center(child: CircularProgressIndicator());
//               }
//               if (snapshot.hasError) {
//                 return const Center(
//                   child: Text(
//                     "Error loading data",
//                     style: TextStyle(color: Colors.white),
//                   ),
//                 );
//               }
//               if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                 return const Center(
//                   child: Text(
//                     "No Organization Employees found",
//                     style: TextStyle(color: Colors.white),
//                   ),
//                 );
//               }

//               final docs = snapshot.data!.docs;

//               return Column(
//                 children: docs.map((doc) {
//                   final data = doc.data() as Map<String, dynamic>;

//                   return Container(
//                     margin: const EdgeInsets.symmetric(vertical: 8),
//                     padding: const EdgeInsets.all(16),
//                     width: 320,
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(16),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black26,
//                           blurRadius: 8,
//                           offset: const Offset(0, 4),
//                         ),
//                       ],
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           "👤 Username: ${data["Username"] ?? "N/A"}",
//                           style: const TextStyle(color: Colors.black87),
//                         ),
//                         Text(
//                           "📧 Email: ${data["Email"] ?? "N/A"}",
//                           style: const TextStyle(color: Colors.black87),
//                         ),
//                         Text(
//                           "🔑 Password: ${data["Password"] ?? "N/A"}",
//                           style: const TextStyle(color: Colors.black87),
//                         ),
//                         Text(
//                           "🧩 Role: ${data["role"] ?? "N/A"}",
//                           style: const TextStyle(color: Colors.black87),
//                         ),
//                       ],
//                     ),
//                   );
//                 }).toList(),
//               );
//             },
//           ),

//           const SizedBox(height: 30),
//           ElevatedButton(
//             onPressed: () {
//               setState(() {
//                 _showForm = true;
//               });
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.white,
//               foregroundColor: AppColors.primary,
//               padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(30),
//               ),
//               elevation: 6,
//             ),
//             child: const Text(
//               "Create New Credential",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // -----------------------------------------------------------------
//   // 🔹 Edit / Delete Options Dialog
//   // -----------------------------------------------------------------
//   void _showOptionsDialog(String docId, Map<String, dynamic> data) {
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: const Text("Manage User"),
//         content: const Text("Choose an action for this user:"),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context);
//               _editUser(docId, data);
//             },
//             child: const Text("✏️ Edit"),
//           ),
//           TextButton(
//             onPressed: () async {
//               Navigator.pop(context);
//               await FirebaseFirestore.instance
//                   .collection("Users")
//                   .doc(docId)
//                   .delete();

//               Fluttertoast.showToast(
//                 msg: "🗑️ User deleted successfully!",
//                 backgroundColor: Colors.redAccent,
//               );
//             },
//             child: const Text(
//               "🗑️ Delete",
//               style: TextStyle(color: Colors.red),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // -----------------------------------------------------------------
//   // 🔹 Edit User Data
//   // -----------------------------------------------------------------
//   void _editUser(String docId, Map<String, dynamic> data) {
//     usernameController.text = data["Username"] ?? "";
//     emailController.text = data["Email"] ?? "";
//     passwordController.text = data["Password"] ?? "";

//     setState(() {
//       _showForm = true;
//     });

//     // When saving again, it will update the existing user
//     Future.delayed(const Duration(milliseconds: 500), () {
//       showDialog(
//         context: context,
//         builder: (_) => AlertDialog(
//           title: const Text("Edit User"),
//           content: const Text("Do you want to update this user’s credentials?"),
//           actions: [
//             TextButton(
//               onPressed: () async {
//                 Navigator.pop(context);
//                 await FirebaseFirestore.instance
//                     .collection("Users")
//                     .doc(docId)
//                     .update({
//                       "Username": usernameController.text.trim(),
//                       "Email": emailController.text.trim(),
//                       "Password": passwordController.text.trim(),
//                     });

//                 Fluttertoast.showToast(
//                   msg: "✅ User updated successfully!",
//                   backgroundColor: Colors.green,
//                 );

//                 setState(() {
//                   _showForm = false;
//                 });
//               },
//               child: const Text("Save"),
//             ),
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text("Cancel"),
//             ),
//           ],
//         ),
//       );
//     });
//   }

//   // -----------------------------------------------------------------
//   // 🔹 Form to Create New Credential
//   // -----------------------------------------------------------------
//   Widget _buildCredentialsForm(BuildContext context) {
//     return SingleChildScrollView(
//       key: const ValueKey('formContainer'),
//       padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
//       child: Form(
//         key: _formKey,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Text(
//               "Set Your Credentials",
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 30),

//             // Username
//             TextFormField(
//               controller: usernameController,
//               decoration: InputDecoration(
//                 labelText: "Username",
//                 filled: true,
//                 fillColor: Colors.white,
//                 prefixIcon: const Icon(Icons.person_rounded),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//               validator: (value) =>
//                   value == null || value.isEmpty ? "Enter username" : null,
//             ),
//             const SizedBox(height: 20),

//             // Email
//             TextFormField(
//               controller: emailController,
//               keyboardType: TextInputType.emailAddress,
//               decoration: InputDecoration(
//                 labelText: "Email",
//                 filled: true,
//                 fillColor: Colors.white,
//                 prefixIcon: const Icon(Icons.email_rounded),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return "Enter your email";
//                 }
//                 final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
//                 if (!emailRegex.hasMatch(value)) {
//                   return "Enter valid email";
//                 }
//                 return null;
//               },
//             ),
//             const SizedBox(height: 20),

//             // Password
//             TextFormField(
//               controller: passwordController,
//               obscureText: _obscurePassword,
//               decoration: InputDecoration(
//                 labelText: "Password",
//                 filled: true,
//                 fillColor: Colors.white,
//                 prefixIcon: const Icon(Icons.lock_rounded),
//                 suffixIcon: IconButton(
//                   icon: Icon(
//                     _obscurePassword
//                         ? Icons.visibility_off_rounded
//                         : Icons.visibility_rounded,
//                   ),
//                   onPressed: () {
//                     setState(() {
//                       _obscurePassword = !_obscurePassword;
//                     });
//                   },
//                 ),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//               validator: (value) =>
//                   value == null || value.isEmpty ? "Enter password" : null,
//             ),
//             const SizedBox(height: 30),

//             // Save Button
//             // SizedBox(
//             //   width: double.infinity,
//             //   height: 55,
//             //   child: ElevatedButton(
//             //     onPressed: () async {
//             //       if (_formKey.currentState!.validate()) {
//             //         try {
//             //           await auth.add_user(
//             //             Username: usernameController.text,
//             //             Useremail: emailController.text,
//             //             Userpassword: passwordController.text,
//             //             context: context,
//             //             payment_status: "Completed",
//             //           );

//             //           Fluttertoast.showToast(
//             //             msg: "✅ User created successfully!",
//             //             backgroundColor: Colors.green,
//             //           );

//             //           setState(() {
//             //             _showForm = false;
//             //             _isloading = true;
//             //           });

//             //           usernameController.clear();
//             //           emailController.clear();
//             //           passwordController.clear();
//             //         } catch (e) {
//             //           ScaffoldMessenger.of(context).showSnackBar(
//             //             SnackBar(
//             //               duration: const Duration(seconds: 5),
//             //               content: Text(e.toString()),
//             //             ),
//             //           );
//             //         }
//             //       }
//             //     },
//             //     style: ElevatedButton.styleFrom(
//             //       backgroundColor: Colors.white,
//             //       foregroundColor: AppColors.primary,
//             //       shape: RoundedRectangleBorder(
//             //         borderRadius: BorderRadius.circular(12),
//             //       ),
//             //       elevation: 6,
//             //     ),
//             //     child: const Text(
//             //       "Save Credentials",
//             //       style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             //     ),
//             //   ),
//             // ),
//             SizedBox(
//               width: double.infinity,
//               height: 55,
//               child: ElevatedButton(
//                 onPressed: _isloading
//                     ? null // Disable button when loading
//                     : () async {
//                         if (_formKey.currentState!.validate()) {
//                           setState(() {
//                             _isloading = true;
//                           });

//                           try {
//                             await auth.add_user(
//                               Username: usernameController.text,
//                               Useremail: emailController.text,
//                               Userpassword: passwordController.text,
//                               context: context,
//                             );

//                             Fluttertoast.showToast(
//                               msg: "✅ User created successfully!",
//                               backgroundColor: Colors.green,
//                             );

//                             setState(() {
//                               _showForm = false;
//                             });

//                             usernameController.clear();
//                             emailController.clear();
//                             passwordController.clear();
//                           } catch (e) {
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               SnackBar(
//                                 duration: const Duration(seconds: 5),
//                                 content: Text(e.toString()),
//                               ),
//                             );
//                           } finally {
//                             // Stop loading after completion (whether success or error)
//                             setState(() {
//                               _isloading = false;
//                             });
//                           }
//                         }
//                       },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.white,
//                   foregroundColor: AppColors.primary,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   elevation: 6,
//                 ),
//                 child: _isloading
//                     ? const SizedBox(
//                         width: 24,
//                         height: 24,
//                         child: CircularProgressIndicator(
//                           color: Colors.white,
//                           strokeWidth: 3,
//                         ),
//                       )
//                     : const Text(
//                         "Save Credentials",
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//               ),
//             ),

//             const SizedBox(height: 20),

//             TextButton(
//               onPressed: () {
//                 setState(() {
//                   _showForm = false;
//                 });
//               },
//               child: const Text(
//                 "Back",
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 16,
//                   decoration: TextDecoration.underline,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:mental_healthcare/backend/oraganization.dart';
import 'package:mental_healthcare/frontend/widgets/appcolors.dart';

class CreateCredentialsScreen extends StatefulWidget {
  const CreateCredentialsScreen({super.key});

  @override
  State<CreateCredentialsScreen> createState() =>
      _CreateCredentialsScreenState();
}

class _CreateCredentialsScreenState extends State<CreateCredentialsScreen> {
  bool _showForm = false;
  bool _isloading = false;
  bool _obscurePassword = true;
  final _formKey = GlobalKey<FormState>();
  final auth = OrganAuth();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF3A7BD5), Color(0xFF00D2FF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: _showForm
                ? _buildCredentialsForm(context)
                : _buildSavedCredentialsList(context),
          ),
        ),
      ),
    );
  }

  // -----------------------------------------------------------------
  // 🔹 Firestore Stream (Only Organization Employees)
  // -----------------------------------------------------------------
  Widget _buildSavedCredentialsList(BuildContext context) {
    return SingleChildScrollView(
      key: const ValueKey('savedList'),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Saved Organization Employees",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),

          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("Users")
                .where('role', isEqualTo: 'Organization Employee')
                .where(
                  'Created by',
                  isEqualTo: FirebaseAuth.instance.currentUser!.uid,
                )
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return const Center(
                  child: Text(
                    "Error loading data",
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text(
                    "No Organization Employees found",
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }

              final docs = snapshot.data!.docs;

              return Column(
                children: docs.map((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  bool _obscurePass = true;

                  return StatefulBuilder(
                    builder: (context, setStateCard) {
                      return GestureDetector(
                        onLongPress: () {
                          _showOptionsDialog(doc.id, data);
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          padding: const EdgeInsets.all(16),
                          width: 320,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "👤 ${data["Username"] ?? "N/A"}",
                                    style: const TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.copy_rounded,
                                      color: Colors.blueAccent,
                                    ),
                                    tooltip: "Copy Email & Password",
                                    onPressed: () async {
                                      final email = data["Email"] ?? "";
                                      final pass = data["Password"] ?? "";
                                      if (email.isNotEmpty && pass.isNotEmpty) {
                                        await Clipboard.setData(
                                          ClipboardData(
                                            text:
                                                "Email: $email\nPassword: $pass",
                                          ),
                                        );
                                        Fluttertoast.showToast(
                                          msg: "📋 Copied to clipboard!",
                                          backgroundColor: Colors.green,
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                "📧 ${data["Email"] ?? "N/A"}",
                                style: const TextStyle(color: Colors.black87),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  const Text(
                                    "🔑 ",
                                    style: TextStyle(color: Colors.black87),
                                  ),
                                  Expanded(
                                    child: Text(
                                      _obscurePass
                                          ? "••••••••"
                                          : "${data["Password"] ?? "N/A"}",
                                      style: const TextStyle(
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      _obscurePass
                                          ? Icons.visibility_off_rounded
                                          : Icons.visibility_rounded,
                                      color: Colors.grey[700],
                                    ),
                                    onPressed: () {
                                      setStateCard(() {
                                        _obscurePass = !_obscurePass;
                                      });
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                "🧩 Role: ${data["role"] ?? "N/A"}",
                                style: const TextStyle(color: Colors.black87),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              );
            },
          ),

          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _showForm = true;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 6,
            ),
            child: const Text(
              "Create New Credential",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  // -----------------------------------------------------------------
  // 🔹 Edit / Delete Options Dialog
  // -----------------------------------------------------------------
  void _showOptionsDialog(String docId, Map<String, dynamic> data) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Manage User"),
        content: const Text("Choose an action for this user:"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _editUser(docId, data);
            },
            child: const Text("✏️ Edit"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await FirebaseFirestore.instance
                  .collection("Users")
                  .doc(docId)
                  .delete();

              Fluttertoast.showToast(
                msg: "🗑️ User deleted successfully!",
                backgroundColor: Colors.redAccent,
              );
            },
            child: const Text(
              "🗑️ Delete",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  // -----------------------------------------------------------------
  // 🔹 Edit User Data
  // -----------------------------------------------------------------
  void _editUser(String docId, Map<String, dynamic> data) {
    // Local controllers so dialog edits don't interfere with the main form controllers
    final TextEditingController dlgUsername = TextEditingController(
      text: data["Username"] ?? "",
    );
    final TextEditingController dlgEmail = TextEditingController(
      text: data["Email"] ?? "",
    );
    final TextEditingController dlgPassword = TextEditingController(
      text: data["Password"] ?? "",
    );

    final _dlgFormKey = GlobalKey<FormState>();
    bool _isSaving = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text("Edit User"),
              content: Form(
                key: _dlgFormKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Username
                      TextFormField(
                        controller: dlgUsername,
                        decoration: const InputDecoration(
                          labelText: "Username",
                        ),
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? "Enter username"
                            : null,
                      ),
                      const SizedBox(height: 8),
                      // Email
                      TextFormField(
                        controller: dlgEmail,
                        decoration: const InputDecoration(labelText: "Email"),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty)
                            return "Enter email";
                          final emailRegex = RegExp(
                            r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                          );
                          if (!emailRegex.hasMatch(v.trim()))
                            return "Enter a valid email";
                          return null;
                        },
                      ),
                      const SizedBox(height: 8),
                      // Password
                      TextFormField(
                        controller: dlgPassword,
                        decoration: const InputDecoration(
                          labelText: "Password",
                        ),
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? "Enter password"
                            : null,
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: _isSaving
                      ? null
                      : () {
                          Navigator.of(context).pop(); // cancel edits
                        },
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: _isSaving
                      ? null
                      : () async {
                          // Validate form first
                          if (!(_dlgFormKey.currentState?.validate() ?? false))
                            return;

                          setStateDialog(() => _isSaving = true);

                          try {
                            // Update Firestore doc
                            await FirebaseFirestore.instance
                                .collection("Users")
                                .doc(docId)
                                .update({
                                  "Username": dlgUsername.text.trim(),
                                  "Email": dlgEmail.text.trim(),
                                  "Password": dlgPassword.text.trim(),
                                });

                            // Optionally: update main controllers so if you open the form they show new data
                            usernameController.text = dlgUsername.text.trim();
                            emailController.text = dlgEmail.text.trim();
                            passwordController.text = dlgPassword.text.trim();

                            Fluttertoast.showToast(
                              msg: "✅ User updated successfully!",
                              backgroundColor: Colors.green,
                            );

                            Navigator.of(context).pop(); // close dialog
                            setState(() {
                              _showForm =
                                  false; // optional: keep consistent with your UI
                            });
                          } catch (e) {
                            // show error
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Update failed: ${e.toString()}"),
                              ),
                            );
                            setStateDialog(() => _isSaving = false);
                          }
                        },
                  style: ElevatedButton.styleFrom(elevation: 4),
                  child: _isSaving
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text("Save"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // -----------------------------------------------------------------
  // 🔹 Form to Create New Credential
  // -----------------------------------------------------------------
  Widget _buildCredentialsForm(BuildContext context) {
    return SingleChildScrollView(
      key: const ValueKey('formContainer'),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Set Your Credentials",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),

            // Username
            TextFormField(
              controller: usernameController,
              decoration: InputDecoration(
                labelText: "Username",
                filled: true,
                fillColor: Colors.white,
                prefixIcon: const Icon(Icons.person_rounded),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              validator: (value) =>
                  value == null || value.isEmpty ? "Enter username" : null,
            ),
            const SizedBox(height: 20),

            // Email
            TextFormField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: "Email",
                filled: true,
                fillColor: Colors.white,
                prefixIcon: const Icon(Icons.email_rounded),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Enter your email";
                }
                final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                if (!emailRegex.hasMatch(value)) {
                  return "Enter valid email";
                }
                return null;
              },
            ),
            const SizedBox(height: 20),

            // Password
            TextFormField(
              controller: passwordController,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                labelText: "Password",
                filled: true,
                fillColor: Colors.white,
                prefixIcon: const Icon(Icons.lock_rounded),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_off_rounded
                        : Icons.visibility_rounded,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              validator: (value) =>
                  value == null || value.isEmpty ? "Enter password" : null,
            ),
            const SizedBox(height: 30),

            // Save Button
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _isloading
                    ? null
                    : () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            _isloading = true;
                          });

                          try {
                            await auth.add_user(
                              Username: usernameController.text,
                              Useremail: emailController.text,
                              Userpassword: passwordController.text,
                              context: context,
                            );

                            Fluttertoast.showToast(
                              msg: "✅ User created successfully!",
                              backgroundColor: Colors.green,
                            );

                            setState(() {
                              _showForm = false;
                            });

                            usernameController.clear();
                            emailController.clear();
                            passwordController.clear();
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                duration: const Duration(seconds: 5),
                                content: Text(e.toString()),
                              ),
                            );
                          } finally {
                            setState(() {
                              _isloading = false;
                            });
                          }
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 6,
                ),
                child: _isloading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 3,
                        ),
                      )
                    : const Text(
                        "Save Credentials",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 20),

            TextButton(
              onPressed: () {
                setState(() {
                  _showForm = false;
                });
              },
              child: const Text(
                "Back",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
