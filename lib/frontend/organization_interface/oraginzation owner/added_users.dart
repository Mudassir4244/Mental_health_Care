import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mental_healthcare/frontend/organization_interface/oraginzation%20owner/create_credenntials.dart';
import 'package:mental_healthcare/frontend/widgets/appcolors.dart';

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
      if (mounted) {
        setState(() {
          organizationName = data['Organization name'] ?? "Organization";
        });
      }
    } else {
      if (mounted) {
        setState(() {
          organizationName = "Organization";
        });
      }
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

  @override
  Widget build(BuildContext context) {
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
        title: const Text(
          "Manage Users",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        elevation: 4,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const CreateCredentialsScreen(),
            ),
          );
        },
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text("Add User", style: TextStyle(color: Colors.white)),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xffe9f5ff), Color(0xfff8f9fb)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            // 🔹 Employees List
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: fetchEmployees(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                          color: AppColors.primary),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.people_outline,
                              size: 80, color: Colors.grey[400]),
                          const SizedBox(height: 10),
                          Text(
                            "No employees added yet.",
                            style: TextStyle(
                                color: Colors.grey[600], fontSize: 18),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "Tap the + button to add a new user.",
                            style: TextStyle(
                                color: Colors.grey[500], fontSize: 14),
                          ),
                        ],
                      ),
                    );
                  }

                  final employees = snapshot.data!.docs;

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: employees.length,
                    itemBuilder: (context, index) {
                      final doc = employees[index];
                      final data = doc.data() as Map<String, dynamic>;
                      
                      return UserListItem(
                        data: data,
                        docId: doc.id,
                        onDelete: () => deleteUser(doc.id),
                        onEdit: () {
                           Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CreateCredentialsScreen(
                                userData: data, // Pass data for editing
                                docId: doc.id,
                              ),
                            ),
                          );
                        },
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

class UserListItem extends StatefulWidget {
  final Map<String, dynamic> data;
  final String docId;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const UserListItem({
    super.key,
    required this.data,
    required this.docId,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  State<UserListItem> createState() => _UserListItemState();
}

class _UserListItemState extends State<UserListItem> {
  bool _isPasswordVisible = false;

  void copyCredentials(String email, String password) {
    Clipboard.setData(
      ClipboardData(text: 'Email: $email\nPassword: $password'),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Credentials copied to clipboard!'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _showOptionsBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: Wrap(
            children: [
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.edit, color: Colors.blue),
                ),
                title: const Text('Update User Details'),
                onTap: () {
                  Navigator.pop(context);
                  widget.onEdit();
                },
              ),
              const Divider(),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.delete, color: Colors.red),
                ),
                title: const Text('Delete User'),
                subtitle: const Text('This action cannot be undone'),
                onTap: () {
                  Navigator.pop(context);
                  _showDeleteConfirmation();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete User?"),
        content: const Text("Are you sure you want to remove this user?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              widget.onDelete();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Delete", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final email = widget.data['email'] ?? 'No Email';
    final password = widget.data['Password'] ?? 'No Password';
    final username = widget.data['username'] ?? 'User';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onLongPress: _showOptionsBottomSheet,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Avatar
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: AppColors.primary.withOpacity(0.1),
                      child: Text(
                        username.isNotEmpty ? username[0].toUpperCase() : 'U',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    
                    // Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            username,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff222B45),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            email,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Copy Button
                    IconButton(
                      icon: Icon(Icons.copy_rounded, color: Colors.grey[400], size: 20),
                      onPressed: () => copyCredentials(email, password),
                      tooltip: "Copy Credentials",
                    ),
                  ],
                ),
                
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.lock_outline, size: 16, color: Colors.grey[500]),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _isPasswordVisible ? password : "•" * 8,
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: _isPasswordVisible ? null : 'Courier',
                            letterSpacing: _isPasswordVisible ? 0 : 2,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            _isPasswordVisible ? "HIDE" : "SHOW",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
