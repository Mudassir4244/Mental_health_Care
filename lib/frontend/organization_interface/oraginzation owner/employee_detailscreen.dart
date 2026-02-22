// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:mental_healthcare/frontend/chats/screens/chat_screen.dart';
// import 'package:mental_healthcare/frontend/widgets/appcolors.dart';

// class EmployeeDetailscreen extends StatefulWidget {
//   final String employeeId;

//   const EmployeeDetailscreen({super.key, required this.employeeId});

//   @override
//   State<EmployeeDetailscreen> createState() => _EmployeeDetailscreenState();
// }

// class _EmployeeDetailscreenState extends State<EmployeeDetailscreen> {
//   late Future<DocumentSnapshot> employeeFuture;

//   @override
//   void initState() {
//     super.initState();
//     // ✅ Fetch once when the screen is opened
//     employeeFuture = FirebaseFirestore.instance
//         .collection('Users')
//         .doc(widget.employeeId)
//         .get();
//   }

//   @override
//   Widget build(BuildContext context) {
//     //   final Map<String, dynamic> clientData;
//     // final Map<String, dynamic> data;

//     // final String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? "";
//     final String currentuserId = FirebaseAuth.instance.currentUser!.uid;

//     /// Make these nullable to avoid crash
//     final String currentUsername;
//     final String currentUserRole;
//     final String recieverId;
//     final String recievername;
//     final String receiverRole;
//     return Scaffold(
//       backgroundColor: const Color(0xfff3f6fb),
//       appBar: AppBar(
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios, fontWeight: FontWeight.bold),
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//         flexibleSpace: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [AppColors.primary, AppColors.accent],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//           ),
//         ),
//         elevation: 4,
//         centerTitle: true,
//         title: const Text(
//           "Employee Details",
//           style: TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//             letterSpacing: 0.8,
//           ),
//         ),
//         iconTheme: const IconThemeData(color: Colors.white),
//       ),
//       body: FutureBuilder<DocumentSnapshot>(
//         future: employeeFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(
//               child: CircularProgressIndicator(color: Colors.blue),
//             );
//           }

//           if (!snapshot.hasData || !snapshot.data!.exists) {
//             return const Center(
//               child: Text(
//                 "Employee data not found.",
//                 style: TextStyle(fontSize: 16, color: Colors.black54),
//               ),
//             );
//           }

//           final data = snapshot.data!.data() as Map<String, dynamic>;
//           final name = data['username'] ?? 'Unknown';
//           final email = data['email'] ?? 'N/A';
//           final organization = data['Organization name'] ?? 'Not Assigned';
//           final status = data['status'] ?? 'Active';
//           final role = data['role'] ?? 'N/A';
//           final createdBy = data['Created by'] ?? 'N/A';

//           return SingleChildScrollView(
//             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
//             child: Column(
//               children: [
//                 // 🔹 Profile Card
//                 Container(
//                   width: double.infinity,
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       colors: [AppColors.primary, AppColors.accent],
//                       begin: Alignment.topLeft,
//                       end: Alignment.bottomRight,
//                     ),
//                     borderRadius: BorderRadius.circular(20),
//                     boxShadow: [
//                       BoxShadow(
//                         color: AppColors.primary.withOpacity(0.3),
//                         blurRadius: 10,
//                         offset: const Offset(0, 6),
//                       ),
//                     ],
//                   ),
//                   padding: const EdgeInsets.all(24),
//                   child: Column(
//                     children: [
//                       CircleAvatar(
//                         radius: 50,
//                         backgroundColor: Colors.white.withOpacity(0.2),
//                         child: Text(
//                           name[0].toUpperCase(),
//                           style: const TextStyle(
//                             fontSize: 42,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 14),
//                       Text(
//                         name,
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 24,
//                           fontWeight: FontWeight.bold,
//                           letterSpacing: 0.5,
//                         ),
//                       ),
//                       const SizedBox(height: 6),
//                       Text(
//                         email,
//                         style: const TextStyle(
//                           color: Colors.white70,
//                           fontSize: 15,
//                         ),
//                       ),
//                       const SizedBox(height: 10),
//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 16,
//                           vertical: 6,
//                         ),
//                         decoration: BoxDecoration(
//                           color: Colors.white.withOpacity(0.2),
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: Text(
//                           status,
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontWeight: FontWeight.bold,
//                             fontSize: 14,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),

//                 const SizedBox(height: 25),

//                 // 🔹 Information Card
//                 Container(
//                   width: double.infinity,
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(18),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.grey.withOpacity(0.15),
//                         blurRadius: 10,
//                         offset: const Offset(0, 4),
//                       ),
//                     ],
//                   ),
//                   padding: const EdgeInsets.all(20),
//                   child: Column(
//                     children: [
//                       _buildDetailTile(Icons.badge, "Role", role),
//                       _buildDetailTile(
//                         Icons.business,
//                         "Organization",
//                         organization,
//                       ),
//                       _buildDetailTile(
//                         Icons.account_tree,
//                         "Created By",
//                         createdBy,
//                       ),
//                       _buildDetailTile(Icons.verified_user, "Status", status),
//                     ],
//                   ),
//                 ),

//                 const SizedBox(height: 30),

//                 // 🔹 Message Button
//                 ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.transparent,
//                     shadowColor: Colors.transparent,
//                     padding: EdgeInsets
//                         .zero, // Important to let gradient container handle padding
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                   onPressed: () {

//                   },
//                   child: Ink(
//                     decoration: BoxDecoration(
//                       gradient: const LinearGradient(
//                         colors: [
//                           AppColors.primary, AppColors.accent, // Blue
//                         ],
//                       ),
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 40,
//                         vertical: 14,
//                       ),
//                       child: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           const Icon(Icons.message, color: Colors.white),
//                           const SizedBox(width: 8),
//                           Text(
//                             "Message $name",
//                             style: const TextStyle(
//                               color: Colors.white,
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildDetailTile(IconData icon, String title, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Row(
//         children: [
//           Container(
//             decoration: BoxDecoration(
//               color: AppColors.primary.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(10),
//             ),
//             padding: const EdgeInsets.all(10),
//             child: Icon(icon, color: AppColors.primary, size: 24),
//           ),
//           const SizedBox(width: 14),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   title,
//                   style: TextStyle(
//                     color: Colors.grey.shade600,
//                     fontSize: 13,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//                 const SizedBox(height: 2),
//                 Text(
//                   value,
//                   style: const TextStyle(
//                     fontSize: 16,
//                     color: Color(0xff222B45),
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mental_healthcare/frontend/chats/screens/chat_screen.dart';
import 'package:mental_healthcare/frontend/widgets/appcolors.dart';

class EmployeeDetailscreen extends StatefulWidget {
  final String employeeId;

  const EmployeeDetailscreen({super.key, required this.employeeId});

  @override
  State<EmployeeDetailscreen> createState() => _EmployeeDetailscreenState();
}

class _EmployeeDetailscreenState extends State<EmployeeDetailscreen> {
  late Future<DocumentSnapshot> employeeFuture;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    // Fetch employee data once when the screen opens
    employeeFuture = firestore.collection('Users').doc(widget.employeeId).get();
  }

  // ✅ Create or open chat in background
  Future<void> createOrOpenChat(Map<String, dynamic> employeeData) async {
    try {
      final currentUser = auth.currentUser!;
      final String chatId = currentUser.uid.compareTo(employeeData['uid']) < 0
          ? "${currentUser.uid}_${employeeData['uid']}"
          : "${employeeData['uid']}_${currentUser.uid}";

      // 🔥 Navigate immediately
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ChatScreen(
            chatId: chatId,
            senderId: currentUser.uid,
            senderName: currentUser.displayName ?? "User",
            receiverId: employeeData['uid'],
            receiverName: employeeData['username'] ?? "Employee",
            receiverRole: employeeData['role'] ?? "Employee", recieverimageurl: employeeData['ImageUrl'],
          ),
        ),
      );

      // Fetch current user name in background
      final userDoc = await firestore
          .collection("Users")
          .doc(currentUser.uid)
          .get();
      final currentUserName = userDoc.data()?["username"] ?? "";
      final currentUserrole = userDoc.data()?["role"] ?? "";
      // Write chat data in background
      await firestore.collection("Chats").doc(chatId).set({
        "senderId": currentUser.uid,
        "senderName": currentUserName,
        "senderrole": currentUserrole,
        "receiverId": employeeData['uid'],
        "receiverName": employeeData['username'] ?? "Employee",
        "receiverRole": employeeData['role'] ?? "Employee",
        "timestamp": FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      print("❌ ERROR in createOrOpenChat: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff3f6fb),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, fontWeight: FontWeight.bold),
          onPressed: () => Navigator.of(context).pop(),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primary, AppColors.accent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 4,
        centerTitle: true,
        title: const Text(
          "Employee Details",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.8,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: employeeFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.blue),
            );
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(
              child: Text(
                "Employee data not found.",
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
            );
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;
          final name = data['username'] ?? 'Unknown';
          final email = data['email'] ?? 'N/A';
          final organization = data['Organization name'] ?? 'Not Assigned';
          final status = data['status'] ?? 'Active';
          final role = data['role'] ?? 'N/A';
          final createdBy = data['Created by'] ?? 'N/A';

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
            child: Column(
              children: [
                // 🔹 Profile Card
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.primary, AppColors.accent],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white.withOpacity(0.2),
                        child: Text(
                          name[0].toUpperCase(),
                          style: const TextStyle(
                            fontSize: 42,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        email,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          status,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                // 🔹 Information Card
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.15),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      _buildDetailTile(Icons.badge, "Role", role),
                      _buildDetailTile(
                        Icons.business,
                        "Organization",
                        organization,
                      ),
                      _buildDetailTile(
                        Icons.account_tree,
                        "Created By",
                        createdBy,
                      ),
                      _buildDetailTile(Icons.verified_user, "Status", status),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // 🔹 Message Button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    createOrOpenChat({
                      'uid': widget.employeeId,
                      'username': name,
                      'role': role,
                    });
                  },
                  child: Ink(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.primary, AppColors.accent],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 14,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.message, color: Colors.white),
                          const SizedBox(width: 8),
                          Text(
                            "Message $name",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailTile(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(10),
            child: Icon(icon, color: AppColors.primary, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xff222B45),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
