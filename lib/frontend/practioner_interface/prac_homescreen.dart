import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mental_healthcare/frontend/practioner_interface/premium_client.dart';
import 'package:provider/provider.dart';

// REMOVE THESE IF NOT NEEDED
import 'package:mental_healthcare/frontend/practioner_interface/widgets/pract_custom_wdgets.dart';
import 'package:mental_healthcare/frontend/widgets/appcolors.dart';

///////////////////////////////////////////////////////////////////////////////
/// PROVIDER + SCREEN ALL IN ONE FILE (NO SEPARATE FILE REQUIRED)
///////////////////////////////////////////////////////////////////////////////

class PremiumClientProvider extends ChangeNotifier {
  bool loading = false;
  List<Map<String, dynamic>> premiumClients = [];

  Future<void> fetchPremiumClients() async {
    loading = true;
    notifyListeners();

    try {
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection("Users")
          .where("role", isEqualTo: "customer")
          .where("payment Status", isEqualTo: "Completed")
          .get();

      premiumClients = snapshot.docs
          .map((e) => e.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print("❌ ERROR FETCHING PREMIUM CLIENTS: $e");
    }

    loading = false;
    notifyListeners();
  }
}

///////////////////////////////////////////////////////////////////////////////
/// MAIN SCREEN STARTS
///////////////////////////////////////////////////////////////////////////////

class PracHomescreen extends StatefulWidget {
  const PracHomescreen({super.key});

  @override
  State<PracHomescreen> createState() => _PracHomescreenState();
}

class _PracHomescreenState extends State<PracHomescreen>
    with SingleTickerProviderStateMixin {
  final String title = "Home";

  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    // Animation
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();

    // Fetch premium clients immediately
    Future.microtask(() {
      context.read<PremiumClientProvider>().fetchPremiumClients();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'Active':
        return Colors.green;
      case 'Pending':
        return Colors.orange;
      default:
        return Colors.red;
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

        /////////////////////////////////////////////////////////////////////////////
        /// APP BAR
        /////////////////////////////////////////////////////////////////////////////
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          leading: Builder(
            builder: (context) => IconButton(
              onPressed: () => Scaffold.of(context).openDrawer(),
              icon: const Icon(Icons.menu),
            ),
          ),
          centerTitle: true,
          title: const Text(
            'Mind Assist',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
              letterSpacing: 0.8,
              color: Colors.white,
            ),
          ),
          backgroundColor: AppColors.primary,
        ),

        drawer: prac_drawer(),

        /////////////////////////////////////////////////////////////////////////////
        /// MAIN BODY
        /////////////////////////////////////////////////////////////////////////////
        body: Consumer<PremiumClientProvider>(
          builder: (context, provider, _) {
            if (provider.loading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            }

            final clients = provider.premiumClients;

            return Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xffe9f5ff), Color(0xfff8f9fb)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Premium Clients 👑',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff222B45),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Customers with completed payments.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 20),

                    //////////////////////////////////////////////////////////////////////
                    /// GRID VIEW
                    //////////////////////////////////////////////////////////////////////
                    Expanded(
                      child: GridView.builder(
                        itemCount: clients.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 14,
                              mainAxisSpacing: 14,
                              childAspectRatio: 0.95,
                            ),
                        itemBuilder: (context, index) {
                          final user = clients[index];
                          final String name = user['username'] ?? "Unknown";
                          // final String lastSession = user["email"] ?? "N/A";

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
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              PremiumClientDetailsScreen(
                                                clientData: user,
                                                currentUserId: FirebaseAuth
                                                    .instance
                                                    .currentUser!
                                                    .uid,
                                                currentUsername: '',
                                                currentUserRole: '',
                                                recievername: '',
                                                recieverId: '',
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
                                                name[0],
                                                style: const TextStyle(
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
                                            // const SizedBox(height: 6),
                                            // Text(
                                            //   lastSession,
                                            //   style: TextStyle(
                                            //     color: Colors.grey.shade600,
                                            //     fontSize: 13,
                                            //   ),
                                            // ),
                                            // const SizedBox(height: 10),
                                            // Container(
                                            //   padding:
                                            //       const EdgeInsets.symmetric(
                                            //         horizontal: 12,
                                            //         vertical: 4,
                                            //       ),
                                            //   decoration: BoxDecoration(
                                            //     color: Colors.green.withOpacity(
                                            //       0.15,
                                            //     ),
                                            //     borderRadius:
                                            //         BorderRadius.circular(12),
                                            //   ),
                                            //   child: const Text(
                                            //     "Premium",
                                            //     style: TextStyle(
                                            //       color: Colors.green,
                                            //       fontWeight: FontWeight.bold,
                                            //       fontSize: 13,
                                            //     ),
                                            //   ),
                                            // ),
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
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),

        bottomNavigationBar: prac_bottomNavbbar(currentScreen: title, clientData: {},),
      ),
    );
  }
}
