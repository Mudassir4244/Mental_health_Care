// // ignore_for_file: unused_local_variable

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart'; // Added for currentUser
// import 'package:mental_healthcare/frontend/practioner_interface/premium_client.dart';
// import 'package:provider/provider.dart';

// // REMOVE THESE IF NOT NEEDED
// import 'package:mental_healthcare/frontend/practioner_interface/widgets/pract_custom_wdgets.dart';
// import 'package:mental_healthcare/frontend/widgets/appcolors.dart';

// ///////////////////////////////////////////////////////////////////////////////
// /// PROVIDER + SCREEN ALL IN ONE FILE (NO SEPARATE FILE REQUIRED)
// ///////////////////////////////////////////////////////////////////////////////

// class PremiumClientProvider extends ChangeNotifier {
//   bool loading = false;
//   bool loadedOnce = false;
//   List<Map<String, dynamic>> premiumClients = [];
//   Set<String> messagedClientIds =
//       {}; // Stores IDs of clients we've chatted with

//   Future<void> fetchPremiumClients({bool forceRefresh = false}) async {
//     if (loadedOnce && !forceRefresh) return;

//     loading = true;
//     notifyListeners();

//     try {
//       // 1. Fetch Premium Clients
//       final QuerySnapshot snapshot = await FirebaseFirestore.instance
//           .collection("Users")
//           .where("role", isEqualTo: "customer")
//           .where("Payment Status", isEqualTo: "Completed")
//           .get();

//       premiumClients = snapshot.docs.map((e) {
//         final data = e.data() as Map<String, dynamic>;
//         // Ensure we have the document ID if 'uid' is missing in data
//         if (!data.containsKey('uid')) {
//           data['uid'] = e.id;
//         }
//         return data;
//       }).toList();

//       premiumClients.shuffle(); // Randomize client order

//       // 2. Fetch Chats to identify messaged clients
//       final currentUid = FirebaseAuth.instance.currentUser?.uid;
//       if (currentUid != null) {
//         messagedClientIds.clear();

//         // Fetch chats where current user is a participant
//         // Note: This matches the logic in chat_list_screen
//         final chatSnapshot = await FirebaseFirestore.instance
//             .collection("Chats")
//             .get(); // Fetching all and filtering might be safer if indices are missing,
//         // but ideally use .where('participants', arrayContains: currentUid)

//         // We'll use client-side filtering to be safe and consistent with previous logic
//         for (var doc in chatSnapshot.docs) {
//           final data = doc.data();
//           bool isParticipant = false;
//           String otherId = '';

//           // Check participants array
//           if (data.containsKey('participants') &&
//               data['participants'] is List) {
//             final p = List.from(data['participants']);
//             if (p.contains(currentUid)) {
//               isParticipant = true;
//               otherId = p.firstWhere(
//                 (id) => id != currentUid,
//                 orElse: () => '',
//               );
//             }
//           }

//           // Fallback checks
//           if (!isParticipant) {
//             if (data['senderId'] == currentUid) {
//               isParticipant = true;
//               otherId = data['receiverId'] ?? '';
//             } else if (data['receiverId'] == currentUid) {
//               isParticipant = true;
//               otherId = data['senderId'] ?? '';
//             }
//           }

//           if (isParticipant && otherId.isNotEmpty) {
//             messagedClientIds.add(otherId);
//           }
//         }
//       }

//       loadedOnce = true;
//     } catch (e) {
//       print("❌ ERROR FETCHING PREMIUM CLIENTS: $e");
//     }

//     loading = false;
//     notifyListeners();
//   }

//   void clear() {
//     loading = false;
//     loadedOnce = false;
//     premiumClients = [];
//     messagedClientIds = {};
//     notifyListeners();
//   }
// }

// ///////////////////////////////////////////////////////////////////////////////
// /// MAIN SCREEN
// ///////////////////////////////////////////////////////////////////////////////

// class PracHomescreen extends StatefulWidget {
//   const PracHomescreen({super.key});

//   @override
//   State<PracHomescreen> createState() => _PracHomescreenState();
// }

// class _PracHomescreenState extends State<PracHomescreen>
//     with SingleTickerProviderStateMixin {
//   final String title = "Home";
//   late AnimationController _animationController;
//   String _filterStatus = 'All'; // 'All', 'Messaged', 'Not Messaged'

//   @override
//   void initState() {
//     super.initState();

//     // Animation Controller
//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 900),
//     )..forward();

//     // Fetch only first time
//     Future.microtask(() {
//       context.read<PremiumClientProvider>().fetchPremiumClients();
//     });
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     DateTime? lastPressed;

//     return WillPopScope(
//       onWillPop: () async {
//         final now = DateTime.now();

//         if (lastPressed == null ||
//             now.difference(lastPressed!) > const Duration(seconds: 2)) {
//           lastPressed = now;
//           Fluttertoast.showToast(msg: "Press again to exit");
//           return false;
//         }

//         SystemNavigator.pop();
//         return false;
//       },
//       child: Scaffold(
//         backgroundColor: const Color(0xfff8f9fb),

//         /////////////////////////////////////////////////////////////////////////////
//         /// APP BAR
//         /////////////////////////////////////////////////////////////////////////////
//         appBar: AppBar(
//           iconTheme: const IconThemeData(color: Colors.white),
//           leading: Builder(
//             builder: (context) => IconButton(
//               onPressed: () => Scaffold.of(context).openDrawer(),
//               icon: const Icon(Icons.menu),
//             ),
//           ),
//           actions: [
//             // IconButton(
//             //   onPressed: () {
//             //     Navigator.push(
//             //       context,
//             //       MaterialPageRoute(builder: (_) => AdminHomescreen()),
//             //     );
//             //   },
//             //   icon: const Icon(Icons.admin_panel_settings),
//             // ),
//           ],
//           centerTitle: true,
//           title: const Text(
//             'Mind Assist',
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//               fontSize: 22,
//               letterSpacing: 0.8,
//               color: Colors.white,
//             ),
//           ),
//           flexibleSpace: Container(
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [AppColors.primary, AppColors.accent],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//             ),
//           ),
//         ),

//         drawer: prac_drawer(),

//         /////////////////////////////////////////////////////////////////////////////
//         /// BODY
//         /////////////////////////////////////////////////////////////////////////////
//         body: Consumer<PremiumClientProvider>(
//           builder: (context, provider, _) {
//             if (provider.loading && !provider.loadedOnce) {
//               return const Center(
//                 child: CircularProgressIndicator(color: AppColors.primary),
//               );
//             }

//             final clients = provider.premiumClients;

//             return Container(
//               decoration: const BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [Color(0xffe9f5ff), Color(0xfff8f9fb)],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 ),
//               ),
//               child: RefreshIndicator(
//                 onRefresh: () async {
//                   await provider.fetchPremiumClients(forceRefresh: true);
//                 },
//                 child: CustomScrollView(
//                   slivers: [
//                     SliverToBoxAdapter(
//                       child: Padding(
//                         padding: const EdgeInsets.all(16),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const FeatureGrid(),
//                             const SizedBox(height: 20),
//                             const Text(
//                               'Premium Clients 👑',
//                               style: TextStyle(
//                                 fontSize: 26,
//                                 fontWeight: FontWeight.bold,
//                                 color: Color(0xff222B45),
//                               ),
//                             ),
//                             const SizedBox(height: 8),
//                             Text(
//                               'Registered users with completed payments.',
//                               style: TextStyle(
//                                 fontSize: 14,
//                                 color: Colors.grey.shade600,
//                               ),
//                             ),
//                             const SizedBox(height: 20),

//                             // Filter Chips
//                             SingleChildScrollView(
//                               scrollDirection: Axis.horizontal,
//                               clipBehavior: Clip.none,
//                               child: Row(
//                                 children: [
//                                   _buildFilterChip('All'),
//                                   const SizedBox(width: 12),
//                                   _buildFilterChip('Messaged'),
//                                   const SizedBox(width: 12),
//                                   _buildFilterChip('Not Messaged'),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     SliverPadding(
//                       padding: const EdgeInsets.symmetric(horizontal: 16),
//                       sliver: SliverGrid(
//                         gridDelegate:
//                             const SliverGridDelegateWithFixedCrossAxisCount(
//                               crossAxisCount: 2,
//                               crossAxisSpacing: 14,
//                               mainAxisSpacing: 14,
//                               childAspectRatio: 0.95,
//                             ),
//                         delegate: SliverChildBuilderDelegate((context, index) {
//                           // Filter Logic
//                           final allClients = provider.premiumClients;
//                           final filteredClients = allClients.where((user) {
//                             final uid = user['uid'] ?? user['docId'];
//                             final isMessaged = provider.messagedClientIds
//                                 .contains(uid);
//                             if (_filterStatus == 'All') return true;
//                             if (_filterStatus == 'Messaged') return isMessaged;
//                             if (_filterStatus == 'Not Messaged') {
//                               return !isMessaged;
//                             }
//                             return true;
//                           }).toList();

//                           if (index >= filteredClients.length) return null;

//                           final user = filteredClients[index];
//                           final String name = user['username'] ?? "Unknown";

//                           final String uid =
//                               user['uid'] ??
//                               user['docId']; // Ensure we have the ID
//                           final bool isMessaged = provider.messagedClientIds
//                               .contains(uid);

//                           return AnimatedBuilder(
//                             animation: _animationController,
//                             builder: (context, child) {
//                               final offsetAnimation =
//                                   Tween<Offset>(
//                                     begin: Offset(0, 0.4 * (index + 1)),
//                                     end: Offset.zero,
//                                   ).animate(
//                                     CurvedAnimation(
//                                       parent: _animationController,
//                                       curve: const Interval(
//                                         0,
//                                         1,
//                                         curve: Curves.easeOut,
//                                       ),
//                                     ),
//                                   );

//                               return SlideTransition(
//                                 position: offsetAnimation,
//                                 child: Opacity(
//                                   opacity: _animationController.value,
//                                   child: GestureDetector(
//                                     onTap: () {
//                                       Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                           builder: (_) =>
//                                               PremiumClientDetailsScreen(
//                                                 clientData: user,
//                                                 currentUsername: '',
//                                                 currentUserRole: '',
//                                                 recievername: '',
//                                                 recieverId: '',
//                                                 receiverRole: '',
//                                                 data: {},
//                                               ),
//                                         ),
//                                       );
//                                     },
//                                     child: Container(
//                                       decoration: BoxDecoration(
//                                         borderRadius: BorderRadius.circular(20),
//                                         color: Colors.white,
//                                         boxShadow: [
//                                           BoxShadow(
//                                             color: Colors.grey.withOpacity(0.1),
//                                             blurRadius: 10,
//                                             spreadRadius: 1,
//                                             offset: const Offset(0, 5),
//                                           ),
//                                         ],
//                                       ),
//                                       child: Stack(
//                                         children: [
//                                           // Background decoration
//                                           Positioned(
//                                             top: -20,
//                                             right: -20,
//                                             child: Container(
//                                               width: 80,
//                                               height: 80,
//                                               decoration: BoxDecoration(
//                                                 color: AppColors.primary
//                                                     .withOpacity(0.05),
//                                                 shape: BoxShape.circle,
//                                               ),
//                                             ),
//                                           ),

//                                           Padding(
//                                             padding: const EdgeInsets.all(14.0),
//                                             child: Column(
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.start,
//                                               children: [
//                                                 // Header Row: Avatar + Status Icon
//                                                 Row(
//                                                   children: [
//                                                     Hero(
//                                                       tag: 'avatar_$uid',
//                                                       child: CircleAvatar(
//                                                         radius: 22,
//                                                         backgroundColor:
//                                                             AppColors.primary
//                                                                 .withOpacity(
//                                                                   0.1,
//                                                                 ),
//                                                         child:
//                                                             user['ImageUrl'] !=
//                                                                     null &&
//                                                                 (user['ImageUrl']
//                                                                         as String)
//                                                                     .isNotEmpty
//                                                             ? ClipRRect(
//                                                                 borderRadius:
//                                                                     BorderRadius.circular(
//                                                                       50,
//                                                                     ),
//                                                                 child: Image.network(
//                                                                   user['ImageUrl'],
//                                                                   width: 50,
//                                                                   height: 50,
//                                                                   fit: BoxFit
//                                                                       .cover,
//                                                                 ),
//                                                               )
//                                                             : Text(
//                                                                 name.isNotEmpty
//                                                                     ? name[0]
//                                                                           .toUpperCase()
//                                                                     : '?',
//                                                                 style: const TextStyle(
//                                                                   fontSize: 18,
//                                                                   color: AppColors
//                                                                       .primary,
//                                                                   fontWeight:
//                                                                       FontWeight
//                                                                           .bold,
//                                                                 ),
//                                                               ),
//                                                       ),
//                                                     ),
//                                                     const Spacer(),
//                                                     Padding(
//                                                       padding:
//                                                           const EdgeInsets.only(
//                                                             bottom: 40,
//                                                           ),
//                                                       child: Container(
//                                                         padding:
//                                                             const EdgeInsets.all(
//                                                               6,
//                                                             ),
//                                                         decoration: BoxDecoration(
//                                                           color: isMessaged
//                                                               ? Colors.green
//                                                                     .withOpacity(
//                                                                       0.1,
//                                                                     )
//                                                               : Colors.orange
//                                                                     .withOpacity(
//                                                                       0.1,
//                                                                     ),
//                                                           shape:
//                                                               BoxShape.circle,
//                                                         ),
//                                                         child: Center(
//                                                           child: Icon(
//                                                             isMessaged
//                                                                 ? Icons
//                                                                       .chat_bubble_outline
//                                                                 : Icons
//                                                                       .mark_email_unread_outlined,
//                                                             size: 16,
//                                                             color: isMessaged
//                                                                 ? Colors.green
//                                                                 : Colors.orange,
//                                                           ),
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                                 // const Spacer(),
//                                                 // Name
//                                                 Text(
//                                                   name,
//                                                   maxLines: 1,
//                                                   overflow:
//                                                       TextOverflow.ellipsis,
//                                                   style: const TextStyle(
//                                                     fontWeight: FontWeight.bold,
//                                                     fontSize: 16,
//                                                     color: Color(0xff222B45),
//                                                   ),
//                                                 ),
//                                                 // const SizedBox(height: 4),
//                                                 // Status Text
//                                                 Text(
//                                                   isMessaged
//                                                       ? "Connected"
//                                                       : "Pending",
//                                                   style: TextStyle(
//                                                     fontSize: 12,
//                                                     fontWeight: FontWeight.w500,
//                                                     color: isMessaged
//                                                         ? Colors.green
//                                                         : Colors.orange,
//                                                   ),
//                                                 ),
//                                                 const SizedBox(height: 5),
//                                                 // Action Button
//                                                 Container(
//                                                   width: double.infinity,
//                                                   padding:
//                                                       const EdgeInsets.symmetric(
//                                                         vertical: 5,
//                                                       ),
//                                                   decoration: BoxDecoration(
//                                                     color: AppColors.primary
//                                                         .withOpacity(0.1),
//                                                     borderRadius:
//                                                         BorderRadius.circular(
//                                                           10,
//                                                         ),
//                                                   ),
//                                                   child: const Center(
//                                                     child: Text(
//                                                       "View Profile",
//                                                       style: TextStyle(
//                                                         fontSize: 12,
//                                                         fontWeight:
//                                                             FontWeight.bold,
//                                                         color:
//                                                             AppColors.primary,
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               );
//                             },
//                           );
//                         }), // Removed childCount to let it dynamic based on null return
//                       ),
//                     ),
//                     const SliverToBoxAdapter(child: SizedBox(height: 20)),
//                   ],
//                 ),
//               ),
//             );
//           },
//         ),

//         bottomNavigationBar: prac_bottomNavbbar(
//           currentScreen: title,
//           clientData: {},
//         ),
//       ),
//     );
//   }

//   Widget _buildFilterChip(String label) {
//     final bool isSelected = _filterStatus == label;
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           _filterStatus = label;
//         });
//       },
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 200),
//         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//         decoration: BoxDecoration(
//           color: isSelected ? AppColors.primary : Colors.white,
//           borderRadius: BorderRadius.circular(30),
//           border: Border.all(
//             color: isSelected ? AppColors.primary : Colors.grey.shade300,
//             width: 1,
//           ),
//           boxShadow: isSelected
//               ? [
//                   BoxShadow(
//                     color: AppColors.primary.withOpacity(0.3),
//                     blurRadius: 8,
//                     offset: const Offset(0, 4),
//                   ),
//                 ]
//               : [
//                   BoxShadow(
//                     color: Colors.grey.withOpacity(0.05),
//                     blurRadius: 4,
//                     offset: const Offset(0, 2),
//                   ),
//                 ],
//         ),
//         child: Text(
//           label,
//           style: TextStyle(
//             color: isSelected ? Colors.white : Colors.grey.shade600,
//             fontWeight: FontWeight.w600,
//             fontSize: 14,
//           ),
//         ),
//       ),
//     );
//   }
// }
// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mental_healthcare/frontend/customer_interface/checkin.dart';
import 'package:mental_healthcare/frontend/customer_interface/helpnow.dart';
import 'package:mental_healthcare/frontend/practioner_interface/practitionar_training.dart';
import 'package:mental_healthcare/frontend/practioner_interface/premium_client.dart';
import 'package:mental_healthcare/l10n/app_localizations.dart';
import 'package:mental_healthcare/resources/resources_screen.dart';
import 'package:provider/provider.dart';

import 'package:mental_healthcare/frontend/practioner_interface/widgets/pract_custom_wdgets.dart';
import 'package:mental_healthcare/frontend/widgets/appcolors.dart';

///////////////////////////////////////////////////////////////////////////////
/// PROVIDER
///////////////////////////////////////////////////////////////////////////////

class PremiumClientProvider extends ChangeNotifier {
  bool loading = false;
  bool loadedOnce = false;
  String? errorMessage;
  List<Map<String, dynamic>> premiumClients = [];
  Set<String> messagedClientIds = {};

  Future<void> fetchPremiumClients({bool forceRefresh = false}) async {
    if (loadedOnce && !forceRefresh) return;

    loading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        errorMessage = 'User not authenticated.';
        loading = false;
        notifyListeners();
        return;
      }

      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection("Users")
          .where("role", isEqualTo: "customer")
          .where("Payment Status", isEqualTo: "Completed")
          .get();

      premiumClients = snapshot.docs.map((e) {
        final data = e.data() as Map<String, dynamic>;
        data['uid'] = e.id;
        return data;
      }).toList();

      premiumClients.shuffle();

      messagedClientIds.clear();
      try {
        final chatSnapshot = await FirebaseFirestore.instance
            .collection("Chats")
            .where('participants', arrayContains: currentUser.uid)
            .get();

        for (var doc in chatSnapshot.docs) {
          final data = doc.data();
          if (data['participants'] is List) {
            final p = List<String>.from(data['participants']);
            final otherId = p.firstWhere(
              (id) => id != currentUser.uid,
              orElse: () => '',
            );
            if (otherId.isNotEmpty) messagedClientIds.add(otherId);
          }
        }
      } catch (_) {
        // chats failing is non-fatal
      }

      loadedOnce = true;
    } catch (e) {
      errorMessage = e.toString();
      debugPrint("❌ ERROR: $e");
    }

    loading = false;
    notifyListeners();
  }

  void clear() {
    loading = false;
    loadedOnce = false;
    errorMessage = null;
    premiumClients = [];
    messagedClientIds = {};
    notifyListeners();
  }
}

///////////////////////////////////////////////////////////////////////////////
/// MAIN SCREEN
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
  String _filterStatus = 'All';
  DateTime? _lastPressed;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();

    Future.microtask(() {
      if (mounted) {
        context.read<PremiumClientProvider>().fetchPremiumClients();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> _filtered(PremiumClientProvider p) {
    return p.premiumClients.where((user) {
      final uid = user['uid'] ?? '';
      final messaged = p.messagedClientIds.contains(uid);
      if (_filterStatus == 'Messaged') return messaged;
      if (_filterStatus == 'Not Messaged') return !messaged;
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final now = DateTime.now();
        if (_lastPressed == null ||
            now.difference(_lastPressed!) > const Duration(seconds: 2)) {
          _lastPressed = now;
          Fluttertoast.showToast(msg: "Press again to exit");
          return false;
        }
        SystemNavigator.pop();
        return false;
      },
      child: Scaffold(
        backgroundColor: const Color(0xfff8f9fb),
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          leading: Builder(
            builder: (ctx) => IconButton(
              onPressed: () => Scaffold.of(ctx).openDrawer(),
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
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.accent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
        ),
        drawer: prac_drawer(),
        body: Consumer<PremiumClientProvider>(
          builder: (context, provider, _) {
            // ── Loading ──────────────────────────────────────────────────
            if (provider.loading && !provider.loadedOnce) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            }

            // ── Error ────────────────────────────────────────────────────
            if (provider.errorMessage != null && !provider.loadedOnce) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 52,
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Something went wrong',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        provider.errorMessage!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 12),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: () =>
                            provider.fetchPremiumClients(forceRefresh: true),
                        icon: const Icon(Icons.refresh),
                        label: const Text('Retry'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            final filteredClients = _filtered(provider);

            return Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xffe9f5ff), Color(0xfff8f9fb)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: RefreshIndicator(
                onRefresh: () =>
                    provider.fetchPremiumClients(forceRefresh: true),
                child: CustomScrollView(
                  slivers: [
                    // ── Header ─────────────────────────────────────────
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ✅ Your original FeatureGrid — shrinkWrap fixed
                            Container(
                              width: double.infinity,
                              height: 100,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(color: AppColors.primary),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Hello, ${FirebaseAuth.instance.currentUser?.displayName ?? 'Guest'} 👋',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const Text(
                                      'Welcome Back!',
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            const FeatureGrid(),
                            const SizedBox(height: 20),
                            Text(
                              AppLocalizations.of(context)!.premiumClientsTitle,
                              style: const TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff222B45),
                              ),
                            ),
                            const SizedBox(height: 6),

                            Text(
                              AppLocalizations.of(
                                context,
                              )!.premiumClientsSubtitle,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            const SizedBox(height: 16),

                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  _chip(
                                    AppLocalizations.of(context)!.filterAll,
                                  ),
                                  const SizedBox(width: 10),
                                  _chip(
                                    AppLocalizations.of(
                                      context,
                                    )!.filterMessaged,
                                  ),
                                  const SizedBox(width: 10),
                                  _chip(
                                    AppLocalizations.of(
                                      context,
                                    )!.filterNotMessaged,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ),

                    // ── Empty State ────────────────────────────────────
                    if (filteredClients.isEmpty)
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.people_outline,
                                size: 72,
                                color: Colors.grey.shade300,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                provider.premiumClients.isEmpty
                                    ? 'No premium clients found.\nCheck Firestore field names.'
                                    : 'No "$_filterStatus" clients.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.grey.shade500,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      // ── Grid ─────────────────────────────────────────
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        sliver: SliverGrid(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 14,
                                mainAxisSpacing: 14,
                                childAspectRatio: 0.95,
                              ),
                          delegate: SliverChildBuilderDelegate(
                            childCount: filteredClients.length, // ✅ REQUIRED
                            (context, index) {
                              final user = filteredClients[index];
                              final name = user['username'] ?? 'Unknown';
                              final uid = user['uid'] ?? '';
                              final isMessaged = provider.messagedClientIds
                                  .contains(uid);

                              final delay = (index * 0.08).clamp(0.0, 0.8);
                              final slideAnim =
                                  Tween<Offset>(
                                    begin: const Offset(0, 0.25),
                                    end: Offset.zero,
                                  ).animate(
                                    CurvedAnimation(
                                      parent: _animationController,
                                      curve: Interval(
                                        delay,
                                        (delay + 0.4).clamp(0.0, 1.0),
                                        curve: Curves.easeOut,
                                      ),
                                    ),
                                  );

                              return SlideTransition(
                                position: slideAnim,
                                child: FadeTransition(
                                  opacity: _animationController,
                                  child: _ClientCard(
                                    user: user,
                                    name: name,
                                    uid: uid,
                                    isMessaged: isMessaged,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),

                    const SliverToBoxAdapter(child: SizedBox(height: 24)),
                  ],
                ),
              ),
            );
          },
        ),
        bottomNavigationBar: prac_bottomNavbbar(
          currentScreen: title,
          clientData: {},
        ),
      ),
    );
  }

  Widget _chip(String label) {
    final selected = _filterStatus == label;
    return GestureDetector(
      onTap: () => setState(() => _filterStatus = label),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: selected ? AppColors.primary : Colors.grey.shade300,
          ),
          boxShadow: [
            BoxShadow(
              color: selected
                  ? AppColors.primary.withOpacity(0.3)
                  : Colors.grey.withOpacity(0.08),
              blurRadius: selected ? 8 : 4,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : Colors.grey.shade600,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

///////////////////////////////////////////////////////////////////////////////
/// FEATURE GRID
/// ✅ THE ONLY FIX: shrinkWrap: true  — required when GridView is inside
///    a Column which is inside a SliverToBoxAdapter (unbounded height context)
///////////////////////////////////////////////////////////////////////////////
class FeatureGrid extends StatelessWidget {
  const FeatureGrid({super.key});

  Widget _buildPlaceholderIllustration(IconData icon) {
    return Icon(icon, size: 60, color: AppColors.primary.withOpacity(0.7));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 16.0,
      mainAxisSpacing: 16.0,
      shrinkWrap: true, // ✅ THIS WAS MISSING — caused blank screen
      physics: const NeverScrollableScrollPhysics(),
      children: [
        FeatureTile(
          label: l10n.helpNow,
          illustration: _buildPlaceholderIllustration(Icons.handshake_outlined),
          ontap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => HelpNowScreen()),
          ),
          imagepath: 'assets/helpnow.png',
        ),
        FeatureTile(
          label: l10n.checkIn,
          illustration: _buildPlaceholderIllustration(Icons.map_outlined),
          ontap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => CheckInScreen()),
          ),
          imagepath: 'assets/checkin.png',
        ),
        FeatureTile(
          label: l10n.training,
          illustration: _buildPlaceholderIllustration(
            Icons.psychology_outlined,
          ),
          ontap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => PractitionarTraining()),
          ),
          imagepath: 'assets/training.png',
        ),
        FeatureTile(
          label: l10n.toolsAndResources,
          illustration: _buildPlaceholderIllustration(Icons.source_outlined),
          ontap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => ResourcesScreen()),
          ),
          imagepath: 'assets/resources.png',
        ),
      ],
    );
  }
}

///////////////////////////////////////////////////////////////////////////////
/// FEATURE TILE
///////////////////////////////////////////////////////////////////////////////
class FeatureTile extends StatelessWidget {
  final String label;
  final Widget illustration;
  final VoidCallback ontap;
  final String imagepath;

  const FeatureTile({
    super.key,
    required this.label,
    required this.illustration,
    required this.ontap,
    required this.imagepath,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.cardColor,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: ontap,
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(child: Image.asset(imagepath)),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

///////////////////////////////////////////////////////////////////////////////
/// CLIENT CARD
///////////////////////////////////////////////////////////////////////////////
class _ClientCard extends StatelessWidget {
  final Map<String, dynamic> user;
  final String name;
  final String uid;
  final bool isMessaged;

  const _ClientCard({
    required this.user,
    required this.name,
    required this.uid,
    required this.isMessaged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PremiumClientDetailsScreen(
            clientData: user,
            currentUsername: '',
            currentUserRole: '',
            recievername: '',
            recieverId: '',
            receiverRole: '',
            data: {},
          ),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 1,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Stack(
          clipBehavior: Clip.hardEdge,
          children: [
            Positioned(
              top: -20,
              right: -20,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.05),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Hero(
                        tag: 'avatar_$uid',
                        child: CircleAvatar(
                          radius: 22,
                          backgroundColor: AppColors.primary.withOpacity(0.1),
                          child: _avatar(),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        margin: const EdgeInsets.only(bottom: 40),
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: isMessaged
                              ? Colors.green.withOpacity(0.1)
                              : Colors.orange.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isMessaged
                              ? Icons.chat_bubble_outline
                              : Icons.mark_email_unread_outlined,
                          size: 16,
                          color: isMessaged ? Colors.green : Colors.orange,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Color(0xff222B45),
                    ),
                  ),
                  Text(
                    isMessaged ? 'Connected' : 'Pending',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: isMessaged ? Colors.green : Colors.orange,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Text(
                        'View Profile',
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
    );
  }

  Widget _avatar() {
    final url = user['ImageUrl'];
    if (url != null && (url as String).isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: Image.network(
          url,
          width: 44,
          height: 44,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _initials(),
        ),
      );
    }
    return _initials();
  }

  Widget _initials() => Text(
    name.isNotEmpty ? name[0].toUpperCase() : '?',
    style: const TextStyle(
      fontSize: 18,
      color: AppColors.primary,
      fontWeight: FontWeight.bold,
    ),
  );
}
