// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:mental_healthcare/payment_process/stripe_services.dart';
// import 'package:provider/provider.dart';
// import 'package:mental_healthcare/backend/oraganization.dart';
// import 'package:mental_healthcare/frontend/widgets/appcolors.dart';

// class LoadingProvider extends ChangeNotifier {
//   bool isLoading = false;

//   void setLoading(bool value) {
//     isLoading = value;
//     notifyListeners();
//   }
// }

// class CreateCredentialsScreen extends StatefulWidget {
//   final Map<String, dynamic>? userData;
//   final String? docId;

//   const CreateCredentialsScreen({super.key, this.userData, this.docId});

//   @override
//   State<CreateCredentialsScreen> createState() =>
//       _CreateCredentialsScreenState();
// }

// class _CreateCredentialsScreenState extends State<CreateCredentialsScreen> {
//   final TextEditingController usernameController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();

//   bool _obscurePassword = true;

//   final OrganAuth auth = OrganAuth();
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   static const int freeEmployeeLimit = 15;
//   static const int pricePerUser = 5;

//   @override
//   void initState() {
//     super.initState();
//     if (widget.userData != null) {
//       usernameController.text = widget.userData!['username'] ?? '';
//       emailController.text = widget.userData!['email'] ?? '';
//       passwordController.text = widget.userData!['Password'] ?? '';
//     }
//   }

//   /// 🔢 COUNT EMPLOYEES
//   Future<int> _getEmployeeCount(String ownerId) async {
//     final snapshot = await _firestore
//         .collection('Users')
//         .where('organizationOwnerId', isEqualTo: ownerId)
//         .where('role', isEqualTo: 'Organization Employee')
//         .get();

//     return snapshot.docs.length;
//   }

//   /// 👥 EMPLOYEE COUNTER
//   Widget _employeeCounter() {
//     final owner = FirebaseAuth.instance.currentUser;
//     if (owner == null) return const SizedBox();

//     return FutureBuilder<int>(
//       future: _getEmployeeCount(owner.uid),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData) return const SizedBox();

//         final count = snapshot.data!;
//         final isLimitReached = count >= freeEmployeeLimit;

//         return Container(
//           margin: const EdgeInsets.only(bottom: 20),
//           padding: const EdgeInsets.all(14),
//           decoration: BoxDecoration(
//             color: isLimitReached
//                 ? Colors.red.withOpacity(0.08)
//                 : AppColors.primary.withOpacity(0.08),
//             borderRadius: BorderRadius.circular(14),
//             border: Border.all(
//               color: isLimitReached ? Colors.red : AppColors.primary,
//             ),
//           ),
//           child: Row(
//             children: [
//               Icon(
//                 Icons.people,
//                 color: isLimitReached ? Colors.red : AppColors.primary,
//               ),
//               const SizedBox(width: 10),
//               Text(
//                 "Employees Used: $count / $freeEmployeeLimit",
//                 style: TextStyle(
//                   fontWeight: FontWeight.w600,
//                   color: isLimitReached ? Colors.red : AppColors.primary,
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   /// 💳 PAYMENT DIALOG
//   void _showPaymentDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: const Text("Payment Required"),
//         content: Text(
//           "You have used all $freeEmployeeLimit free employees.\n\n"
//           "Each additional employee costs \$$pricePerUser.",
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text("Cancel"),
//           ),
//           ElevatedButton(
//             onPressed: () async {
//               Navigator.pop(context);

//               final stripe = StripeServices();
//               await stripe.makePayment(5, "USD");

//               await auth.add_user(
//                 Username: usernameController.text.trim(),
//                 Useremail: emailController.text.trim(),
//                 Userpassword: passwordController.text.trim(),
//                 context: context,
//                 payment_status: "Completed",
//               );

//               usernameController.clear();
//               emailController.clear();
//               passwordController.clear();

//               setState(() {});
//             },
//             child: const Text("Pay & Continue"),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final loadingProvider = Provider.of<LoadingProvider>(context);
//     final isEditMode = widget.docId != null;
//     "Organization";
//     return Scaffold(
//       backgroundColor: const Color(0xfff8f9fb),
//       appBar: AppBar(
//         title: Text(
//           isEditMode ? "Update User" : "Create Credentials",
//           style: const TextStyle(color: Colors.white),
//         ),
//         centerTitle: true,
//         backgroundColor: AppColors.primary,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           children: [
//             if (!isEditMode)
//               FutureBuilder(
//                 future: auth.fetch_organowner(context),
//                 builder: (context, snapshot) {
//                   if (!snapshot.hasData) {
//                     return CircularProgressIndicator(color: AppColors.primary);
//                   }

//                   final organName =
//                       snapshot.data?["Organization name"] ?? "Organization";

//                   return TextField(
//                     readOnly: true,
//                     decoration: InputDecoration(
//                       labelText: "Organization: $organName",
//                       prefixIcon: const Icon(Icons.account_balance_rounded),
//                       filled: true,
//                       fillColor: Colors.white,
//                     ),
//                   );
//                 },
//               ),

//             const SizedBox(height: 16),

//             _employeeCounter(),

//             _buildTextField(
//               controller: usernameController,
//               label: "Username",
//               icon: Icons.person,
//             ),
//             const SizedBox(height: 16),

//             _buildTextField(
//               controller: emailController,
//               label: "Email",
//               icon: Icons.email,
//               readOnly: isEditMode,
//             ),
//             const SizedBox(height: 16),

//             _buildTextField(
//               controller: passwordController,
//               label: "Password",
//               icon: Icons.lock,
//               obscureText: _obscurePassword,
//               suffixIcon: IconButton(
//                 icon: Icon(
//                   _obscurePassword ? Icons.visibility_off : Icons.visibility,
//                 ),
//                 onPressed: () {
//                   setState(() {
//                     _obscurePassword = !_obscurePassword;
//                   });
//                 },
//               ),
//             ),
//             const SizedBox(height: 30),

//             loadingProvider.isLoading
//                 ? CircularProgressIndicator(color: AppColors.primary)
//                 : ElevatedButton(
//                     onPressed: () async {
//                       final owner = FirebaseAuth.instance.currentUser;
//                       if (owner == null) return;

//                       final count = await _getEmployeeCount(owner.uid);

//                       if (count >= freeEmployeeLimit) {
//                         _showPaymentDialog(context);
//                         return;
//                       }

//                       loadingProvider.setLoading(true);

//                       await auth.add_user(
//                         Username: usernameController.text.trim(),
//                         Useremail: emailController.text.trim(),
//                         Userpassword: passwordController.text.trim(),
//                         context: context,
//                         payment_status: "Completed",
//                       );

//                       loadingProvider.setLoading(false);
//                       usernameController.clear();
//                       emailController.clear();
//                       passwordController.clear();

//                       setState(() {});
//                     },
//                     child: const Text("Create Credentials"),
//                   ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildTextField({
//     required TextEditingController controller,
//     required String label,
//     required IconData icon,
//     bool obscureText = false,
//     Widget? suffixIcon,
//     bool readOnly = false,
//   }) {
//     return TextField(
//       controller: controller,
//       obscureText: obscureText,
//       readOnly: readOnly,
//       decoration: InputDecoration(
//         labelText: label,
//         prefixIcon: Icon(icon),
//         suffixIcon: suffixIcon,
//         filled: true,
//         fillColor: Colors.white,
//       ),
//     );
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mental_healthcare/payment_process/stripe_services.dart';
import 'package:provider/provider.dart';
import 'package:mental_healthcare/backend/oraganization.dart';
import 'package:mental_healthcare/frontend/widgets/appcolors.dart';

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

  static const int freeEmployeeLimit = 15;
  static const int pricePerUser = 5;

  /// 🔢 COUNT EMPLOYEES
  Future<int> _getEmployeeCount(String ownerId) async {
    final snapshot = await _firestore
        .collection('Users')
        .where('organizationOwnerId', isEqualTo: ownerId)
        .where('role', isEqualTo: 'Organization Employee')
        .get();

    return snapshot.docs.length;
  }

  /// 👥 EMPLOYEE COUNTER CARD
  Widget _employeeCounter() {
    final owner = FirebaseAuth.instance.currentUser;
    if (owner == null) return const SizedBox();

    return FutureBuilder<int>(
      future: _getEmployeeCount(owner.uid),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox();

        final count = snapshot.data!;
        final isLimitReached = count >= freeEmployeeLimit;

        return Container(
          margin: const EdgeInsets.only(bottom: 24),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isLimitReached
                  ? [Colors.red.shade400, Colors.red.shade700]
                  : [AppColors.primary, AppColors.accent],
            ),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.12),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              const Icon(
                Icons.people_alt_rounded,
                color: Colors.white,
                size: 30,
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Employees",
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  Text(
                    "$count / $freeEmployeeLimit Used",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  /// 💳 PAYMENT DIALOG
  void _showPaymentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Upgrade Required"),
        content: Text(
          "You’ve reached the free employee limit.\n\n"
          "Each additional employee costs \$$pricePerUser.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);

              final stripe = StripeServices();
              await stripe.makePayment(5, "USD");

              await auth.add_user(
                Username: usernameController.text.trim(),
                Useremail: emailController.text.trim(),
                Userpassword: passwordController.text.trim(),
                context: context,
                payment_status: "Completed",
              );

              usernameController.clear();
              emailController.clear();
              passwordController.clear();

              setState(() {});
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              "Pay & Continue",
              style: TextStyle(color: AppColors.background),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loadingProvider = Provider.of<LoadingProvider>(context);
    final isEditMode = widget.docId != null;

    return Scaffold(
      backgroundColor: const Color(0xfff4f6fa),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
        backgroundColor: AppColors.primary,
        centerTitle: true,
        title: Text(
          isEditMode ? "Update User" : "Create Credentials",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.background,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            if (!isEditMode)
              FutureBuilder(
                future: auth.fetch_organowner(context),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return CircularProgressIndicator(color: AppColors.primary);
                  }

                  final organName =
                      snapshot.data?["Organization name"] ?? "Organization";

                  return _infoTile(
                    icon: Icons.apartment_rounded,
                    text: organName,
                  );
                },
              ),

            const SizedBox(height: 16),

            _employeeCounter(),

            /// 🧾 FORM CARD
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildTextField(
                    controller: usernameController,
                    label: "Username",
                    icon: Icons.person_outline,
                  ),
                  const SizedBox(height: 16),

                  _buildTextField(
                    controller: emailController,
                    label: "Email",
                    icon: Icons.email_outlined,
                    readOnly: isEditMode,
                  ),
                  const SizedBox(height: 16),

                  _buildTextField(
                    controller: passwordController,
                    label: "Password",
                    icon: Icons.lock_outline,
                    obscureText: _obscurePassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            loadingProvider.isLoading
                ? CircularProgressIndicator(color: AppColors.primary)
                : SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () async {
                        final owner = FirebaseAuth.instance.currentUser;
                        if (owner == null) return;

                        final count = await _getEmployeeCount(owner.uid);

                        if (count >= freeEmployeeLimit) {
                          _showPaymentDialog(context);
                          return;
                        }

                        loadingProvider.setLoading(true);

                        await auth.add_user(
                          Username: usernameController.text.trim(),
                          Useremail: emailController.text.trim(),
                          Userpassword: passwordController.text.trim(),
                          context: context,
                          payment_status: "Completed",
                        );

                        loadingProvider.setLoading(false);
                        usernameController.clear();
                        emailController.clear();
                        passwordController.clear();

                        setState(() {});
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 6,
                      ),
                      child: const Text(
                        "Create Credentials",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  /// 🔹 INFO TILE
  Widget _infoTile({required IconData icon, required String text}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  /// 🔹 TEXT FIELD
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    Widget? suffixIcon,
    bool readOnly = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      readOnly: readOnly,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: const Color(0xfff9fafc),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
