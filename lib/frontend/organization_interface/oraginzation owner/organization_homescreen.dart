import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mental_healthcare/frontend/organization_interface/oraginzation%20owner/organ_inbox.dart';
import 'package:mental_healthcare/frontend/organization_interface/oraginzation%20owner/employee_detailscreen.dart';
import 'package:mental_healthcare/frontend/organization_interface/widgets/organ_widigets.dart';
import 'package:mental_healthcare/frontend/widgets/appcolors.dart';

class organ_owner_homescreen extends StatefulWidget {
  const organ_owner_homescreen({super.key});

  @override
  State<organ_owner_homescreen> createState() => _organ_owner_homescreenState();
}

class _organ_owner_homescreenState extends State<organ_owner_homescreen>
    with SingleTickerProviderStateMixin {
  final String title = 'Home';
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late AnimationController _animationController;
  String? currentUserId;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();

    currentUserId = _auth.currentUser?.uid;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // 🔹 Fetch employees added by this organization owner
  Stream<QuerySnapshot> fetchEmployees() {
    if (currentUserId == null) return const Stream.empty();
    return _firestore
        .collection('Users')
        .where('Created by', isEqualTo: currentUserId)
        .where('role', isEqualTo: 'Organization Employee')
        .snapshots();
  }

  // 🔹 Fetch the organization name of the current user
  Stream<DocumentSnapshot> fetchOrganizationName() {
    if (currentUserId == null) {
      return const Stream.empty();
    }
    return _firestore.collection('Users').doc(currentUserId).snapshots();
  }

  // 🔹 Get status color
  Color _statusColor(String? status) {
    if (status == null) return Colors.grey;
    switch (status) {
      case 'Active':
        return Colors.green;
      case 'Pending':
        return Colors.orange;
      case 'Inactive':
        return Colors.red;
      default:
        return Colors.blueGrey;
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime? lastPressed;

    return WillPopScope(
      onWillPop: () async {
        final now = DateTime.now();
        if (lastPressed == null ||
            now.difference(lastPressed!) > const Duration(seconds: 2)) {
          lastPressed = now;
          Fluttertoast.showToast(msg: "Press again to exit");
          return false;
        }
        SystemNavigator.pop();
        return false;
      },
      child: Scaffold(
        backgroundColor: const Color(0xfff8f9fb),

        // 🔹 StreamBuilder to get Organization Name dynamically
        appBar: AppBar(
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => OrganationInbox()),
                  );
                },
                icon: Icon(Icons.near_me),
              ),
            ),
          ],
          iconTheme: const IconThemeData(color: Colors.white),
          leading: Builder(
            builder: (context) => IconButton(
              onPressed: () => Scaffold.of(context).openDrawer(),
              icon: const Icon(Icons.menu),
            ),
          ),
          centerTitle: true,
          title: StreamBuilder<DocumentSnapshot>(
            stream: fetchOrganizationName(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text(
                  "Loading...",
                  style: TextStyle(color: Colors.white, fontSize: 22),
                );
              }

              if (!snapshot.hasData || !snapshot.data!.exists) {
                return const Text(
                  "Mind Assist",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                );
              }

              final orgData =
                  snapshot.data!.data() as Map<String, dynamic>? ?? {};
              final orgName =
                  orgData['Organization name'] ??
                  orgData['username'] ??
                  'Mind Assist';

              return Text(
                orgName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  letterSpacing: 0.8,
                  color: Colors.white,
                ),
              );
            },
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
        ),

        drawer: Mydrawer(),

        // 🔹 Body
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xffe9f5ff), Color(0xfff8f9fb)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Your Employees 👥',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff222B45),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Track your organization employees in real-time.',
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 20),

                // 🔹 Employees Grid
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: fetchEmployees(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(color: Colors.blue),
                        );
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Center(
                          child: Text(
                            "No employees added yet.",
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 16,
                            ),
                          ),
                        );
                      }

                      final employees = snapshot.data!.docs;

                      return GridView.builder(
                        itemCount: employees.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 14,
                              mainAxisSpacing: 14,
                              childAspectRatio: 0.95,
                            ),
                        itemBuilder: (context, index) {
                          final data =
                              employees[index].data() as Map<String, dynamic>;

                          final name = data['username'] ?? 'Unnamed';
                          final email = data['email'] ?? 'N/A';
                          final status = data['status'] ?? 'Active';

                          return AnimatedBuilder(
                            animation: _animationController,
                            builder: (context, child) {
                              final offsetAnimation =
                                  Tween<Offset>(
                                    begin: Offset(0, 0.4 * (index + 1)),
                                    end: Offset.zero,
                                  ).animate(
                                    CurvedAnimation(
                                      parent: _animationController,
                                      curve: const Interval(
                                        0,
                                        1,
                                        curve: Curves.easeOut,
                                      ),
                                    ),
                                  );

                              return SlideTransition(
                                position: offsetAnimation,
                                child: Opacity(
                                  opacity: _animationController.value,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(20),
                                    splashColor: AppColors.primary.withOpacity(
                                      0.1,
                                    ),

                                    // ✅ Click Action on Container
                                    onTap: () {
                                      // TODO: Navigate to Employee Detail Screen here if needed
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => EmployeeDetailscreen(
                                            employeeId: employees[index].id,
                                          ),
                                        ),
                                      );
                                    },

                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(
                                              0.15,
                                            ),
                                            blurRadius: 8,
                                            spreadRadius: 2,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            CircleAvatar(
                                              radius: 32,
                                              backgroundColor: AppColors.primary
                                                  .withOpacity(0.15),
                                              child: Text(
                                                name[0].toUpperCase(),
                                                style: TextStyle(
                                                  fontSize: 24,
                                                  color: AppColors.primary,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            Text(
                                              name,
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16,
                                                color: Color(0xff222B45),
                                              ),
                                            ),
                                            SizedBox(height: 6),

                                            const SizedBox(height: 10),
                                            Expanded(
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 6,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: _statusColor(
                                                    status,
                                                  ).withOpacity(0.15),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: Text(
                                                  status,
                                                  style: TextStyle(
                                                    color: _statusColor(status),
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 13,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
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
        ),

        bottomNavigationBar: organ_bottomNavbbar(currentScreen: title),
      ),
    );
  }
}
