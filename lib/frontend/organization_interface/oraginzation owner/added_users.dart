import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  String? organizationName;
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    currentUserId = _auth.currentUser?.uid;
    fetchOrganizationName();
  }

  /// ✅ Fetch organization name of current user (safe version)
  Future<void> fetchOrganizationName() async {
    if (currentUserId == null) return;

    final query = await _firestore
        .collection('Users')
        .where('uid', isEqualTo: currentUserId)
        .limit(1)
        .get();

    if (query.docs.isNotEmpty) {
      final data = query.docs.first.data();
      setState(() {
        organizationName = data['Organization name'] ?? "Organization";
      });
    } else {
      setState(() {
        organizationName = "Organization";
      });
    }
  }

  /// ✅ Stream to fetch employees created by this organization owner
  Stream<QuerySnapshot> fetchEmployees() {
    if (currentUserId == null) {
      return const Stream.empty();
    }

    return _firestore
        .collection('Users')
        .where('Created by', isEqualTo: currentUserId)
        .where('role', isEqualTo: 'Organization Employee')
        .snapshots();
  }

  /// ✅ Copy email and password to clipboard
  void copyCredentials(String email, String password) {
    Clipboard.setData(
      ClipboardData(text: 'Email: $email\nPassword: $password'),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Email & Password copied to clipboard!'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 1),
      ),
    );
  }

  /// ✅ Delete user from Firestore
  Future<void> deleteUser(String docId) async {
    await _firestore.collection('Users').doc(docId).delete();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('User deleted successfully'),
        backgroundColor: Colors.redAccent,
      ),
    );
  }

  /// ✅ Show edit/delete options
  void showLongPressOptions(String docId, Map<String, dynamic> data) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.edit, color: Colors.blue),
                title: const Text('Update User'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CreateCredentialsScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Delete User'),
                onTap: () {
                  Navigator.pop(context);
                  deleteUser(docId);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
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
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 10),
              // Text(
              //   organizationName ?? "Loading...",
              //   style: const TextStyle(
              //     fontSize: 26,
              //     fontWeight: FontWeight.bold,
              //     color: Colors.white,
              //     letterSpacing: 1.5,
              //   ),
              // ),
              // const SizedBox(height: 10),
              const Text(
                "Added Users",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),

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

              const SizedBox(height: 20),

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
                        final doc = employees[index];
                        final data = doc.data() as Map<String, dynamic>;
                        final email = data['email'] ?? '';
                        final password = data['Password'] ?? '';

                        return GestureDetector(
                          onLongPress: () => showLongPressOptions(doc.id, data),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.4),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 4,
                                    offset: const Offset(2, 3),
                                  ),
                                ],
                              ),
                              child: Stack(
                                children: [
                                  Positioned(
                                    right: 0,
                                    top: 0,
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.copy,
                                        color: Colors.white,
                                        size: 22,
                                      ),
                                      onPressed: () =>
                                          copyCredentials(email, password),
                                    ),
                                  ),

                                  // User Info
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.person,
                                            color: Colors.white70,
                                          ),
                                          const SizedBox(width: 5),
                                          Text(
                                            data['username'] ?? 'No Name',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.email,
                                            color: Colors.white70,
                                            size: 20,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            email,
                                            style: const TextStyle(
                                              color: Colors.white70,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.lock,
                                            color: Colors.white70,
                                            size: 20,
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              _isPasswordVisible
                                                  ? password
                                                  : '•' * password.length,
                                              style: const TextStyle(
                                                color: Colors.white70,
                                                fontSize: 15,
                                                letterSpacing: 1.5,
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                            icon: Icon(
                                              _isPasswordVisible
                                                  ? Icons.visibility_off
                                                  : Icons.visibility,
                                              color: Colors.white70,
                                              size: 22,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                _isPasswordVisible =
                                                    !_isPasswordVisible;
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
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
      ),
    );
  }
}
