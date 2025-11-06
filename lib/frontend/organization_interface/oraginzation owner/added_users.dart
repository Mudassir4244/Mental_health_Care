// import 'package:flutter/material.dart';
// import 'package:mental_healthcare/backend/oraganization.dart';
// import 'package:mental_healthcare/frontend/organization_interface/oraginzation%20owner/create_credenntials.dart';
// import 'package:mental_healthcare/frontend/widgets/appcolors.dart';

// class AddedUsers extends StatefulWidget {
//   const AddedUsers({super.key});

//   @override
//   State<AddedUsers> createState() => _AddedUsersState();
// }

// class _AddedUsersState extends State<AddedUsers> {
//   @override
//   Widget build(BuildContext context) {
//     final auth = OrganAuth().fetch_organowner(context);

//     return Scaffold(
//       body: Container(
//         width: double.infinity,
//         height: double.infinity,
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             colors: [
//               Color(0xFF1A73E8), // Deep blue
//               Color(0xFF64B5F6), // Light blue
//             ],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//         ),
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Text(
//                 "Added Users",
//                 style: TextStyle(
//                   fontSize: 30,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                   letterSpacing: 1.5,
//                 ),
//               ),
//               const SizedBox(height: 40),

//               // Add User Button
//               ElevatedButton(
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (_) => const CreateCredentialsScreen(),
//                     ),
//                   );
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.white, // ⚪ white background
//                   foregroundColor: const Color(
//                     0xFF1A73E8,
//                   ), // 🔵 text/icon color (blue)
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 60,
//                     vertical: 18,
//                   ),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(14),
//                   ),
//                   elevation: 8,
//                   shadowColor: Colors.black.withOpacity(0.3),
//                 ),
//                 child: const Text(
//                   'Add User',
//                   style: TextStyle(
//                     fontSize: 22,
//                     fontWeight: FontWeight.bold,
//                     letterSpacing: 1,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mental_healthcare/frontend/organization_interface/oraginzation%20owner/create_credenntials.dart';

class AddedUsers extends StatefulWidget {
  const AddedUsers({super.key});

  @override
  State<AddedUsers> createState() => _AddedUsersState();
}

class _AddedUsersState extends State<AddedUsers> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? currentUserId;

  @override
  void initState() {
    super.initState();
    currentUserId = _auth.currentUser?.uid;
  }

  Stream<QuerySnapshot> fetchEmployees() {
    if (currentUserId == null) {
      return const Stream.empty();
    }

    // ✅ Fetch employees created by this organization owner
    return _firestore
        .collection('Users')
        .where('role', isEqualTo: 'Organization Employee')
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1A73E8), Color(0xFF64B5F6)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 60),
            const Text(
              "Added Users",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 30),

            // 🔹 Add User Button
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const CreateCredentialsScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF1A73E8),
                padding: const EdgeInsets.symmetric(
                  horizontal: 60,
                  vertical: 18,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 8,
              ),
              child: const Text(
                'Add User',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ),

            const SizedBox(height: 40),

            // 🔹 Employees List
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: fetchEmployees(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text(
                        "No employees added yet.",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    );
                  }

                  final employees = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: employees.length,
                    itemBuilder: (context, index) {
                      final data =
                          employees[index].data() as Map<String, dynamic>;

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.4),
                            ),
                          ),
                          child: Column(
                            children: [
                              ListTile(title: Text(data['Created by'])),
                              ListTile(
                                leading: const Icon(
                                  Icons.person,
                                  color: Colors.white,
                                ),
                                title: Text(
                                  data['Username'] ?? 'No Name',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                  data['Email'] ?? '',
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                                trailing: Text(
                                  data['Organization name'] ?? '',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
