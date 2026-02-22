// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:flutter/material.dart';
// // import 'package:mental_healthcare/frontend/practioner_interface/prac_homescreen.dart';
// // import 'package:mental_healthcare/frontend/practioner_interface/widgets/pract_custom_wdgets.dart';
// // import 'package:mental_healthcare/frontend/training_components/module_viewer.dart';
// // import 'package:mental_healthcare/frontend/widgets/appcolors.dart';

// // class PractitionarTraining extends StatefulWidget {
// //   const PractitionarTraining({super.key});

// //   @override
// //   State<PractitionarTraining> createState() => _PractitionarTrainingState();
// // }

// // class _PractitionarTrainingState extends State<PractitionarTraining>
// //     with SingleTickerProviderStateMixin {
// //   late AnimationController _controller;

// //   @override
// //   void initState() {
// //     super.initState();
// //     _controller = AnimationController(
// //       vsync: this,
// //       duration: const Duration(seconds: 1),
// //     )..forward();
// //   }

// //   @override
// //   void dispose() {
// //     _controller.dispose();
// //     super.dispose();
// //   }

// //   Widget _buildTrainingCard(Map<String, dynamic> module, int index) {
// //     // Generate a color based on index for variety
// //     final List<Color> colors = [
// //       Colors.blueAccent,
// //       Colors.purpleAccent,
// //       Colors.teal,
// //       Colors.orangeAccent,
// //       Colors.pinkAccent,
// //       Colors.indigoAccent,
// //     ];
// //     final color = colors[index % colors.length];

// //     final animation =
// //         Tween<Offset>(
// //           begin: Offset(0, 0.3 * (index + 1)),
// //           end: Offset.zero,
// //         ).animate(
// //           CurvedAnimation(
// //             parent: _controller,
// //             curve: Interval(0, 1, curve: Curves.easeOut),
// //           ),
// //         );

// //     return SlideTransition(
// //       position: animation,
// //       child: Container(
// //         margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
// //         padding: const EdgeInsets.all(18),
// //         decoration: BoxDecoration(
// //           color: Colors.white,
// //           borderRadius: BorderRadius.circular(20),
// //           boxShadow: [
// //             BoxShadow(
// //               color: color.withOpacity(0.25),
// //               blurRadius: 10,
// //               spreadRadius: 2,
// //               offset: const Offset(0, 4),
// //             ),
// //           ],
// //         ),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             Text(
// //               module['title'] ?? "Untitled Module",
// //               style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
// //             ),
// //             const SizedBox(height: 8),
// //             Text(
// //               module['description'] ?? "No description available.",
// //               style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
// //             ),
// //             const SizedBox(height: 16),
// //             // Progress placeholder (random for now as we don't track it yet)
// //             ClipRRect(
// //               borderRadius: BorderRadius.circular(10),
// //               child: LinearProgressIndicator(
// //                 value: 0.0, // Initial state
// //                 color: color,
// //                 backgroundColor: color.withOpacity(0.1),
// //                 minHeight: 8,
// //               ),
// //             ),
// //             const SizedBox(height: 10),
// //             Align(
// //               alignment: Alignment.bottomRight,
// //               child: ElevatedButton.icon(
// //                 onPressed: () {
// //                   Navigator.push(
// //                     context,
// //                     MaterialPageRoute(
// //                       builder: (_) => ModuleViewerScreen(moduleData: module),
// //                     ),
// //                   );
// //                 },
// //                 style: ElevatedButton.styleFrom(
// //                   backgroundColor: color,
// //                   shape: RoundedRectangleBorder(
// //                     borderRadius: BorderRadius.circular(12),
// //                   ),
// //                 ),
// //                 icon: const Icon(Icons.play_circle_fill, color: Colors.white),
// //                 label: const Text(
// //                   'Start Training',
// //                   style: TextStyle(color: Colors.white),
// //                 ),
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return WillPopScope(
// //       onWillPop: () async {
// //         Navigator.push(
// //           context,
// //           MaterialPageRoute(builder: (_) => PracHomescreen()),
// //         );
// //         return false;
// //       },
// //       child: Scaffold(
// //         backgroundColor: const Color(0xfff8f9fb),
// //         appBar: AppBar(
// //           iconTheme: const IconThemeData(color: Colors.white),
// //           leading: IconButton(
// //             onPressed: () {
// //               Navigator.push(
// //                 context,
// //                 MaterialPageRoute(builder: (_) => PracHomescreen()),
// //               );
// //             },
// //             icon: const Icon(Icons.arrow_back_ios),
// //           ),
// //           elevation: 4,
// //           title: const Text(
// //             'Practitioner Training',
// //             style: TextStyle(
// //               color: Colors.white,
// //               fontWeight: FontWeight.bold,
// //               fontSize: 20,
// //             ),
// //           ),
// //           centerTitle: true,
// //           flexibleSpace: Container(
// //             decoration: BoxDecoration(
// //               gradient: LinearGradient(
// //                 colors: [AppColors.primary, AppColors.accent],
// //                 begin: Alignment.topLeft,
// //                 end: Alignment.bottomRight,
// //               ),
// //             ),
// //           ),
// //         ),
// //         body: Container(
// //           decoration: const BoxDecoration(
// //             gradient: LinearGradient(
// //               colors: [Color(0xffe9f5ff), Color(0xfff8f9fb)],
// //               begin: Alignment.topLeft,
// //               end: Alignment.bottomRight,
// //             ),
// //           ),
// //           child: Padding(
// //             padding: const EdgeInsets.all(16.0),
// //             child: StreamBuilder<QuerySnapshot>(
// //               stream: FirebaseFirestore.instance
// //                   .collection('TrainingModules')
// //                   .orderBy('timestamp', descending: true)
// //                   .snapshots(),
// //               builder: (context, snapshot) {
// //                 if (snapshot.connectionState == ConnectionState.waiting) {
// //                   return const Center(child: CircularProgressIndicator());
// //                 }

// //                 if (snapshot.hasError) {
// //                   return const Center(child: Text("Something went wrong"));
// //                 }

// //                 final docs = snapshot.data?.docs ?? [];

// //                 return ListView(
// //                   physics: const BouncingScrollPhysics(),
// //                   children: [
// //                     const Text(
// //                       'Welcome Back 👋',
// //                       style: TextStyle(
// //                         fontSize: 26,
// //                         fontWeight: FontWeight.bold,
// //                         color: Color(0xff222B45),
// //                       ),
// //                     ),
// //                     const SizedBox(height: 6),
// //                     Text(
// //                       'Continue your professional growth with engaging modules.',
// //                       style: TextStyle(
// //                         fontSize: 14,
// //                         color: Colors.grey.shade600,
// //                       ),
// //                     ),
// //                     const SizedBox(height: 20),

// //                     // Client Provided Training Modules
// //                     ...docs.asMap().entries.map(
// //                       (entry) => _buildTrainingCard(
// //                         entry.value.data() as Map<String, dynamic>,
// //                         entry.key,
// //                       ),
// //                     ),
// //                     // if (docs.isEmpty)
// //                     //   const Center(
// //                     //     child: Text("No training modules available."),
// //                     //   )
// //                     // else
// //                     //   ...docs.asMap().entries.map(
// //                     //     (entry) => _buildTrainingCard(
// //                     //       entry.value.data() as Map<String, dynamic>,
// //                     //       entry.key,
// //                     //     ),
// //                     //   ),
// //                   ],
// //                 );
// //               },
// //             ),
// //           ),
// //         ),
// //         bottomNavigationBar: prac_bottomNavbbar(
// //           currentScreen: 'Training',
// //           clientData: {},
// //         ),
// //       ),
// //     );
// //   }
// // }
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:flutter/material.dart';
// // import 'package:mental_healthcare/frontend/practioner_interface/prac_homescreen.dart';
// // import 'package:mental_healthcare/frontend/practioner_interface/widgets/pract_custom_wdgets.dart';
// // import 'package:mental_healthcare/frontend/training_components/module_viewer.dart';
// // import 'package:mental_healthcare/frontend/widgets/appcolors.dart';

// // class PractitionarTraining extends StatefulWidget {
// //   const PractitionarTraining({super.key});

// //   @override
// //   State<PractitionarTraining> createState() => _PractitionarTrainingState();
// // }

// // class _PractitionarTrainingState extends State<PractitionarTraining>
// //     with SingleTickerProviderStateMixin {
// //   late AnimationController _controller;

// //   bool paymentCompleted = false;
// //   bool loadingPaymentStatus = true;

// //   /// ✅ 10 HARD-CODED TRAINING MODULES
// //   final List<Map<String, dynamic>> hardcodedModules = [
// //     {
// //       "title": "1. Introduction to Mental Health First Aid",
// //       "description": "Overview and public health importance of mental health",
// //     },
// //     {
// //       "title": "2. Mental Health & Wellbeing",
// //       "description": "Understanding mental wellness and prevention",
// //     },
// //     {
// //       "title": "3. Depression & Mood Disorders",
// //       "description": "Signs, symptoms and early intervention",
// //     },
// //     {
// //       "title": "4. Anxiety Disorders",
// //       "description": "Types of anxiety and coping strategies",
// //     },
// //     {
// //       "title": "5. Psychosis & Schizophrenia",
// //       "description": "Identifying psychotic episodes",
// //     },
// //     {
// //       "title": "6. Substance Use Disorders",
// //       "description": "Addiction, dependency and recovery",
// //     },
// //     {
// //       "title": "7. Suicide Prevention",
// //       "description": "Warning signs and immediate actions",
// //     },
// //     {
// //       "title": "8. Crisis Intervention",
// //       "description": "Handling emergency mental health situations",
// //     },
// //     {
// //       "title": "9. Cultural Sensitivity in Care",
// //       "description": "Providing inclusive and respectful care",
// //     },
// //     {
// //       "title": "10. Ethics & Professional Boundaries",
// //       "description": "Legal and ethical responsibilities",
// //     },
// //   ];

// //   @override
// //   void initState() {
// //     super.initState();

// //     _controller = AnimationController(
// //       vsync: this,
// //       duration: const Duration(milliseconds: 900),
// //     )..forward();

// //     checkPaymentStatus(); // 🔥 Independent call
// //   }

// //   /// ✅ INDEPENDENT PAYMENT CHECK (NO PROVIDER)
// //   Future<void> checkPaymentStatus() async {
// //     final uid = FirebaseAuth.instance.currentUser!.uid;

// //     final querySnapshot = await FirebaseFirestore.instance
// //         .collection('Users')
// //         .where('uid', isEqualTo: uid)
// //         .where('Payment Status', isEqualTo: 'Completed')
// //         .get();

// //     setState(() {
// //       paymentCompleted = querySnapshot.docs.isNotEmpty;
// //       loadingPaymentStatus = false;
// //     });
// //   }

// //   @override
// //   void dispose() {
// //     _controller.dispose();
// //     super.dispose();
// //   }

// //   Widget _trainingCard(Map<String, dynamic> module, int index) {
// //     final List<Color> colors = [
// //       Colors.blueAccent,
// //       Colors.purpleAccent,
// //       Colors.teal,
// //       Colors.orangeAccent,
// //       Colors.pinkAccent,
// //       Colors.indigoAccent,
// //       Colors.green,
// //       Colors.redAccent,
// //       Colors.cyan,
// //       Colors.deepPurple,
// //     ];

// //     final color = colors[index % colors.length];

// //     final animation = Tween<Offset>(
// //       begin: Offset(0, 0.15 * (index + 1)),
// //       end: Offset.zero,
// //     ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

// //     return SlideTransition(
// //       position: animation,
// //       child: Container(
// //         margin: const EdgeInsets.symmetric(vertical: 10),
// //         padding: const EdgeInsets.all(18),
// //         decoration: BoxDecoration(
// //           color: Colors.white,
// //           borderRadius: BorderRadius.circular(18),
// //           boxShadow: [
// //             BoxShadow(
// //               color: color.withOpacity(0.25),
// //               blurRadius: 10,
// //               offset: const Offset(0, 4),
// //             ),
// //           ],
// //         ),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             Text(
// //               module['title'],
// //               style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
// //             ),
// //             const SizedBox(height: 8),
// //             Text(
// //               module['description'],
// //               style: TextStyle(color: Colors.grey.shade700),
// //             ),
// //             const SizedBox(height: 16),
// //             ClipRRect(
// //               borderRadius: BorderRadius.circular(10),
// //               child: LinearProgressIndicator(
// //                 value: 0.0,
// //                 minHeight: 8,
// //                 color: color,
// //                 backgroundColor: color.withOpacity(0.1),
// //               ),
// //             ),
// //             const SizedBox(height: 14),

// //             /// 🔐 PAYMENT-BASED BUTTON
// //             Align(
// //               alignment: Alignment.bottomRight,
// //               child: loadingPaymentStatus
// //                   ? const CircularProgressIndicator()
// //                   : ElevatedButton.icon(
// //                       onPressed: paymentCompleted
// //                           ? () {
// //                               Navigator.push(
// //                                 context,
// //                                 MaterialPageRoute(
// //                                   builder: (_) =>
// //                                       ModuleViewerScreen(moduleData: module),
// //                                 ),
// //                               );
// //                             }
// //                           : () {
// //                               ScaffoldMessenger.of(context).showSnackBar(
// //                                 const SnackBar(
// //                                   content: Text(
// //                                     'Please complete payment to unlock training',
// //                                   ),
// //                                 ),
// //                               );
// //                             },
// //                       style: ElevatedButton.styleFrom(
// //                         backgroundColor: paymentCompleted
// //                             ? color
// //                             : Colors.orange,
// //                         shape: RoundedRectangleBorder(
// //                           borderRadius: BorderRadius.circular(12),
// //                         ),
// //                       ),
// //                       icon: Icon(
// //                         paymentCompleted
// //                             ? Icons.play_circle_fill
// //                             : Icons.lock_open,
// //                         color: Colors.white,
// //                       ),
// //                       label: Text(
// //                         paymentCompleted ? 'Start Training' : 'Unlock Training',
// //                         style: const TextStyle(color: Colors.white),
// //                       ),
// //                     ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return WillPopScope(
// //       onWillPop: () async {
// //         Navigator.pushReplacement(
// //           context,
// //           MaterialPageRoute(builder: (_) => PracHomescreen()),
// //         );
// //         return false;
// //       },
// //       child: Scaffold(
// //         backgroundColor: const Color(0xfff8f9fb),
// //         appBar: AppBar(
// //           title: const Text(
// //             'Practitioner Training',
// //             style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
// //           ),
// //           centerTitle: true,
// //           iconTheme: const IconThemeData(color: Colors.white),
// //           flexibleSpace: Container(
// //             decoration: BoxDecoration(
// //               gradient: LinearGradient(
// //                 colors: [AppColors.primary, AppColors.accent],
// //               ),
// //             ),
// //           ),
// //         ),
// //         body: Padding(
// //           padding: const EdgeInsets.all(16),
// //           child: ListView(
// //             physics: const BouncingScrollPhysics(),
// //             children: [
// //               const Text(
// //                 'Welcome Back 👋',
// //                 style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
// //               ),
// //               const SizedBox(height: 20),
// //               ...hardcodedModules.asMap().entries.map(
// //                 (e) => _trainingCard(e.value, e.key),
// //               ),
// //             ],
// //           ),
// //         ),
// //         bottomNavigationBar: prac_bottomNavbbar(
// //           currentScreen: 'Training',
// //           clientData: {},
// //         ),
// //       ),
// //     );
// //   }
// // }
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:mental_healthcare/frontend/customer_interface/homescreen.dart';
// import 'package:mental_healthcare/frontend/practioner_interface/prac_homescreen.dart';
// import 'package:mental_healthcare/frontend/practioner_interface/widgets/pract_custom_wdgets.dart';
// import 'package:mental_healthcare/frontend/widgets/appcolors.dart';
// import 'package:mental_healthcare/payment_process/stripe_services.dart';
// import 'package:mental_healthcare/training_content_Providedby%20admin/1st.dart';
// import 'package:mental_healthcare/training_content_Providedby%20admin/2nd.dart';
// import 'package:mental_healthcare/training_content_Providedby%20admin/3rd.dart';
// import 'package:mental_healthcare/training_content_Providedby%20admin/4rth.dart';
// import 'package:mental_healthcare/training_content_Providedby%20admin/5th.dart';
// import 'package:mental_healthcare/training_content_Providedby%20admin/6th.dart';
// import 'package:mental_healthcare/training_content_Providedby%20admin/7th.dart';
// import 'package:mental_healthcare/training_content_Providedby%20admin/8th.dart';
// import 'package:mental_healthcare/training_content_Providedby%20admin/9th.dart';

// class PractitionarTraining extends StatefulWidget {
//   const PractitionarTraining({super.key});

//   @override
//   State<PractitionarTraining> createState() => _PractitionarTrainingState();
// }

// class _PractitionarTrainingState extends State<PractitionarTraining>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;

//   bool paymentCompleted = false;
//   bool loadingPaymentStatus = true;
//   final stripe = StripeServices();

//   // Make this function async
//   Future<void> processPayment() async {
//     try {
//       // Show CircularProgressIndicator dialog
//       showDialog(
//         context: context,
//         barrierDismissible: false,
//         builder: (context) => Dialog(
//           backgroundColor: Colors.transparent,
//           child: SizedBox(
//             height: 120,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: const [
//                 CircularProgressIndicator(),
//                 SizedBox(height: 20),
//                 Text("Processing your payment..."),
//               ],
//             ),
//           ),
//         ),
//       );

//       // Wait for Stripe payment
//       final result = await stripe.makePayment(10, "USD").then((_) async {
//         await FirebaseFirestore.instance
//             .collection('Users')
//             .doc(FirebaseAuth.instance.currentUser!.uid)
//             .update({
//               'Payment Status': 'Completed',
//               'Subscription Start Date': FieldValue.serverTimestamp(),
//               'Subscription End Date': Timestamp.fromDate(
//                 DateTime.now().add(Duration(days: 30)),
//               ),
//             });
//       });

//       // Close progress dialog
//       Navigator.of(context).pop();

//       // Show success animation dialog
//       showDialog(
//         context: context,
//         barrierDismissible: false,
//         builder: (context) => Dialog(
//           backgroundColor: Colors.transparent,
//           child: Container(
//             height: 250,
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(20),
//             ),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: const [
//                 Icon(Icons.check_circle, color: Colors.green, size: 80),
//                 SizedBox(height: 20),
//                 Text(
//                   "Payment Completed!",
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.green,
//                   ),
//                 ),
//                 SizedBox(height: 10),
//                 Text(
//                   "Updating your training access...",
//                   style: TextStyle(fontSize: 14, color: Colors.black54),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       );

//       // Wait 2 seconds for animation
//       await Future.delayed(const Duration(seconds: 2));

//       // Update Firestore
//       await FirebaseFirestore.instance
//           .collection('Users')
//           .doc(FirebaseAuth.instance.currentUser!.uid)
//           .update({'Payment Status': 'Completed'});

//       // Close success dialog
//       Navigator.of(context).pop();

//       // Show snackbar
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Training unlocked successfully!")),
//       );
//     } catch (e) {
//       // Close dialog if something fails
//       Navigator.of(context).pop();
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text("Payment failed: $e")));
//     }
//   }

//   final List<Map<String, dynamic>> hardcodedModules = [
//     {
//       "title": "1. Introduction to Mental Health First Aid",
//       "description": "Overview and public health importance of mental health",
//     },
//     {
//       "title": "2. UNDERSTANDING COMMON MENTAL HEALTH DISORDERS ",
//       "description":
//           "Understanding mental Disorder and mental Pychological problems",
//     },
//     {
//       "title": "3. THE ALGEE ACTION PLAN ",
//       "description": "Assess for Risk of Suicide or Harm ",
//     },
//     {
//       "title": "4. WORKPLACE-SPECIFIC MHFA",
//       "description":
//           "Recognizing Workplace Challenges and Legal Considerations",
//     },
//     {
//       "title": "5. CULTURAL HUMILITY & EQUITY ",
//       "description":
//           "Ask: “Is there anything culturally important I should be aware of to better support you?",
//     },
//     {
//       "title": "6. RECOGNIZING CRISIS SITUATIONS ",
//       "description": "De-escalation Techniques:",
//     },
//     {
//       "title": "7. ONGOING SUPPORT ",
//       "description":
//           "I’m here to support you, but I’m not a clinician. Let’s involve someone who can provide more specialized care.",
//     },
//     {
//       "title": "8. PRACTICAL SKILLS TRAINING ",
//       "description": "Practical skill for Leads to Better Mental health",
//     },
//     {
//       "title": "9. SELF-CARE FOR MENTAL HEALTH FIRDT AID HELPERS ",
//       "description": ": The Role of Self-Care in Mental Health First Aid",
//     },
//   ];

//   @override
//   void initState() {
//     super.initState();

//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 900),
//     )..forward();

//     _checkPaymentStatus();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   /// ✅ FETCH PAYMENT STATUS FROM FIRESTORE
//   Future<void> _checkPaymentStatus() async {
//     try {
//       final uid = FirebaseAuth.instance.currentUser!.uid;
//       final userDoc = await FirebaseFirestore.instance
//           .collection('Users')
//           .doc(uid)
//           .get();

//       if (userDoc.exists) {
//         final status = userDoc.data()?['Payment Status'];
//         setState(() {
//           paymentCompleted = status == 'Completed';
//           loadingPaymentStatus = false;
//         });
//         print('Payment Status: $status'); // Debugging
//       } else {
//         setState(() {
//           paymentCompleted = false;
//           loadingPaymentStatus = false;
//         });
//       }
//     } catch (e) {
//       print('Error checking payment status: $e');
//       setState(() {
//         paymentCompleted = false;
//         loadingPaymentStatus = false;
//       });
//     }
//   }

//   Widget _trainingCard(
//     Map<String, dynamic> module,
//     int index, {
//     VoidCallback? onTap,
//   }) {
//     final List<Color> colors = [
//       Colors.blueAccent,
//       Colors.purpleAccent,
//       Colors.teal,
//       Colors.orangeAccent,
//       Colors.pinkAccent,
//       Colors.indigoAccent,
//       Colors.green,
//       Colors.redAccent,
//       Colors.cyan,
//       Colors.deepPurple,
//     ];

//     final color = colors[index % colors.length];

//     final animation = Tween<Offset>(
//       begin: Offset(0, 0.15 * (index + 1)),
//       end: Offset.zero,
//     ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

//     return SlideTransition(
//       position: animation,
//       child: Container(
//         margin: const EdgeInsets.symmetric(vertical: 10),
//         padding: const EdgeInsets.all(18),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(18),
//           boxShadow: [
//             BoxShadow(
//               color: color.withOpacity(0.25),
//               blurRadius: 10,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               module['title'] ?? 'Untitled',
//               style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               module['description'] ?? '',
//               style: TextStyle(color: Colors.grey.shade700),
//             ),
//             const SizedBox(height: 16),

//             // ClipRRect(
//             //   borderRadius: BorderRadius.circular(10),
//             //   child: StreamBuilder<DocumentSnapshot>(
//             //     stream: FirebaseFirestore.instance
//             //         .collection('reading')
//             //         .doc(FirebaseAuth.instance.currentUser!.uid)
//             //         .snapshots(),
//             //     builder: (context, snapshot) {
//             //       bool isCompleted = false;

//             //       if (snapshot.hasData && snapshot.data!.exists) {
//             //         final data = snapshot.data!.data() as Map<String, dynamic>;

//             //         // 🔴 CHANGE module_2 according to current module
//             //         isCompleted = data['module_no'] == "Completed_${index + 1}";
//             //       }

//             //       return LinearProgressIndicator(
//             //         value: isCompleted ? 1.0 : 0.0,
//             //         minHeight: 8,
//             //         color: isCompleted ? color : Colors.grey,
//             //         backgroundColor: isCompleted ? color : Colors.grey.shade300,
//             //       );
//             //     },
//             //   ),
//             // ),
//             const SizedBox(height: 14),
//             Align(
//               alignment: Alignment.bottomRight,
//               child: loadingPaymentStatus
//                   ? CircularProgressIndicator()
//                   : ElevatedButton.icon(
//                       onPressed: () {
//                         if (paymentCompleted) {
//                           if (onTap != null) onTap();
//                         } else {
//                           processPayment();

//                           // ScaffoldMessenger.of(context).showSnackBar(
//                           //   const SnackBar(
//                           //     content: Text(
//                           //       'Please complete payment to unlock training',
//                           //     ),
//                           //   ),
//                           // );
//                         }
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: paymentCompleted
//                             ? color
//                             : Colors.orange,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                       ),
//                       icon: Icon(
//                         paymentCompleted
//                             ? Icons.play_circle_fill
//                             : Icons.lock_open,
//                         color: Colors.white,
//                       ),
//                       label: Text(
//                         paymentCompleted ? 'Start Training' : 'Unlock Training',
//                         style: const TextStyle(color: Colors.white),
//                       ),
//                     ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (_) => PracHomescreen()),
//         );
//         return false;
//       },
//       child: Scaffold(
//         backgroundColor: const Color(0xfff8f9fb),
//         appBar: AppBar(
//           leading: IconButton(
//             onPressed: () {
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(builder: (_) => PracHomescreen()),
//               );
//             },
//             icon: Icon(
//               Icons.arrow_back_ios_new,
//               size: 20,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           title: const Text(
//             'Training Screen',
//             style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//           ),
//           centerTitle: true,
//           iconTheme: const IconThemeData(color: Colors.white),
//           flexibleSpace: Container(
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [AppColors.primary, AppColors.accent],
//               ),
//             ),
//           ),
//         ),
//         body: Padding(
//           padding: const EdgeInsets.all(16),
//           child: StreamBuilder<QuerySnapshot>(
//             stream: FirebaseFirestore.instance
//                 .collection('TrainingModules')
//                 .orderBy('timestamp', descending: false)
//                 .snapshots(),
//             builder: (context, snapshot) {
//               final firestoreModules = snapshot.data?.docs ?? [];

//               return ListView(
//                 physics: const BouncingScrollPhysics(),
//                 children: [
//                   const Text(
//                     'Welcome Back 👋',
//                     style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 20),

//                   // 1st module (free)
//                   Container(
//                     margin: const EdgeInsets.symmetric(vertical: 10),
//                     padding: const EdgeInsets.all(18),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(18),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.blue.withOpacity(0.25),
//                           blurRadius: 10,
//                           offset: const Offset(0, 4),
//                         ),
//                       ],
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const Text(
//                           "1. Introduction to Mental Health First Aid",
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         Text(
//                           "Overview and public health importance of mental health",
//                           style: TextStyle(color: Colors.grey.shade700),
//                         ),
//                         const SizedBox(height: 16),
//                         // ClipRRect(
//                         //   borderRadius: BorderRadius.circular(10),
//                         //   child: LinearProgressIndicator(
//                         //     value: 0.0,
//                         //     minHeight: 8,
//                         //     color: Colors.blue,
//                         //     backgroundColor: Colors.blue,
//                         //   ),
//                         // ),
//                         const SizedBox(height: 14),
//                         Align(
//                           alignment: Alignment.bottomRight,
//                           child: ElevatedButton.icon(
//                             onPressed: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (_) => MentalHealthIntroScreen(),
//                                 ),
//                               );
//                             },
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.blue,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                             ),
//                             icon: const Icon(
//                               Icons.play_circle_fill,
//                               color: Colors.white,
//                             ),
//                             label: const Text(
//                               'Start Training',
//                               style: TextStyle(color: Colors.white),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),

//                   // Hardcoded modules requiring payment
//                   ...hardcodedModules
//                       .sublist(1)
//                       .asMap()
//                       .entries
//                       .map(
//                         (e) => _trainingCard(
//                           e.value,
//                           e.key + 1,
//                           onTap: () {
//                             switch (e.key + 1) {
//                               case 1:
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (_) =>
//                                         MentalHealthDisordersScreen(),
//                                   ),
//                                 );
//                                 break;
//                               case 2:
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (_) => AlgeeActionPlanScreen(),
//                                   ),
//                                 );
//                                 break;
//                               case 3:
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (_) => WorkplaceMhfaScreen(),
//                                   ),
//                                 );
//                                 break;
//                               case 4:
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (_) =>
//                                         CulturalHumilityEquityScreen(),
//                                   ),
//                                 );
//                                 break;
//                               case 5:
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (_) => RecognizingCrisisScreen(),
//                                   ),
//                                 );
//                                 break;
//                               case 6:
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (_) => OngoingSupportScreen(),
//                                   ),
//                                 );
//                                 break;
//                               case 7:
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (_) =>
//                                         PracticalSkillsTrainingScreen(),
//                                   ),
//                                 );
//                                 break;
//                               case 8:
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (_) =>
//                                         MentalHealthSelfCareScreen(),
//                                   ),
//                                 );
//                                 break;
//                             }
//                           },
//                         ),
//                       ),

//                   // Firestore modules
//                   ...firestoreModules.asMap().entries.map(
//                     (e) => _trainingCard(
//                       e.value.data() as Map<String, dynamic>,
//                       e.key + hardcodedModules.length,
//                     ),
//                   ),
//                 ],
//               );
//             },
//           ),
//         ),
//         bottomNavigationBar: prac_bottomNavbbar(
//           currentScreen: 'Training',
//           clientData: {},
//         ),
//       ),
//     );
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mental_healthcare/frontend/practioner_interface/prac_homescreen.dart';
import 'package:mental_healthcare/frontend/practioner_interface/widgets/pract_custom_wdgets.dart';
import 'package:mental_healthcare/frontend/widgets/appcolors.dart';
import 'package:mental_healthcare/payment_process/stripe_services.dart';
import 'package:mental_healthcare/training_content_Providedby%20admin/1st.dart';
import 'package:mental_healthcare/training_content_Providedby%20admin/2nd.dart';
import 'package:mental_healthcare/training_content_Providedby%20admin/3rd.dart';
import 'package:mental_healthcare/training_content_Providedby%20admin/4rth.dart';
import 'package:mental_healthcare/training_content_Providedby%20admin/5th.dart';
import 'package:mental_healthcare/training_content_Providedby%20admin/6th.dart';
import 'package:mental_healthcare/training_content_Providedby%20admin/7th.dart';
import 'package:mental_healthcare/training_content_Providedby%20admin/8th.dart';
import 'package:mental_healthcare/training_content_Providedby%20admin/9th.dart';
import 'package:mental_healthcare/l10n/app_localizations.dart';

/// ✅ LOCALIZATION KEY → ARB GETTER MAPPER
extension AppLocalizationsExt on AppLocalizations {
  String t(String key) {
    switch (key) {
      case 'module1Title':
        return module1Title;
      case 'module1Description':
        return module1Description;
      case 'module2Title':
        return module2Title;
      case 'module2Description':
        return module2Description;
      case 'module3Title':
        return module3Title;
      case 'module3Description':
        return module3Description;
      case 'module4Title':
        return module4Title;
      case 'module4Description':
        return module4Description;
      case 'module5Title':
        return module5Title;
      case 'module5Description':
        return module5Description;
      case 'module6Title':
        return module6Title;
      case 'module6Description':
        return module6Description;
      case 'module7Title':
        return module7Title;
      case 'module7Description':
        return module7Description;
      case 'module8Title':
        return module8Title;
      case 'module8Description':
        return module8Description;
      case 'module9Title':
        return module9Title;
      case 'module9Description':
        return module9Description;
      default:
        return key;
    }
  }
}

class PractitionarTraining extends StatefulWidget {
  const PractitionarTraining({super.key});

  @override
  State<PractitionarTraining> createState() => _PractitionarTrainingState();
}

class _PractitionarTrainingState extends State<PractitionarTraining>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  bool paymentCompleted = false;
  bool loadingPaymentStatus = true;
  final stripe = StripeServices();

  final List<Map<String, String>> hardcodedModules = [
    {'titleKey': 'module1Title', 'descriptionKey': 'module1Description'},
    {'titleKey': 'module2Title', 'descriptionKey': 'module2Description'},
    {'titleKey': 'module3Title', 'descriptionKey': 'module3Description'},
    {'titleKey': 'module4Title', 'descriptionKey': 'module4Description'},
    {'titleKey': 'module5Title', 'descriptionKey': 'module5Description'},
    {'titleKey': 'module6Title', 'descriptionKey': 'module6Description'},
    {'titleKey': 'module7Title', 'descriptionKey': 'module7Description'},
    {'titleKey': 'module8Title', 'descriptionKey': 'module8Description'},
    {'titleKey': 'module9Title', 'descriptionKey': 'module9Description'},
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();
    _checkPaymentStatus();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _checkPaymentStatus() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final userDoc = await FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .get();

    setState(() {
      paymentCompleted = userDoc.data()?['Payment Status'] == 'Completed';
      loadingPaymentStatus = false;
    });
  }

  Future<void> processPayment() async {
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      await stripe.makePayment(10, "USD");

      await FirebaseFirestore.instance
          .collection('Users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({'Payment Status': 'Completed'});

      Navigator.pop(context);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.trainingUnlocked)));

      setState(() => paymentCompleted = true);
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.paymentFailed)));
    }
  }

  Widget _trainingCard(
    Map<String, String> module,
    int index, {
    VoidCallback? onTap,
  }) {
    final l10n = AppLocalizations.of(context)!;

    final List<Color> colors = [
      Colors.blueAccent,
      Colors.purpleAccent,
      Colors.teal,
      Colors.orangeAccent,
      Colors.pinkAccent,
      Colors.indigoAccent,
      Colors.green,
      Colors.redAccent,
      Colors.cyan,
      Colors.deepPurple,
    ];

    final color = colors[index % colors.length];

    final animation = Tween<Offset>(
      begin: Offset(0, 0.15 * (index + 1)),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    return SlideTransition(
      position: animation,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.25),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.t(module['titleKey']!),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.t(module['descriptionKey']!),
              style: TextStyle(color: Colors.grey.shade700),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.bottomRight,
              child: loadingPaymentStatus
                  ? const CircularProgressIndicator()
                  : ElevatedButton.icon(
                      onPressed: () {
                        if (paymentCompleted) {
                          onTap?.call();
                        } else {
                          processPayment();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: paymentCompleted
                            ? color
                            : Colors.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: Icon(
                        paymentCompleted
                            ? Icons.play_circle_fill
                            : Icons.lock_open,
                        color: Colors.white,
                      ),
                      label: Text(
                        paymentCompleted
                            ? l10n.startTraining
                            : l10n.unlockTraining,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => PracHomescreen()),
        );
        return false;
      },
      child: Scaffold(
        backgroundColor: const Color(0xfff8f9fb),
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => PracHomescreen()),
              );
            },
            icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          ),
          title: Text(
            l10n.trainingScreen,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.white),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.accent],
              ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              Text(
                l10n.welcomeBackEmoji,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              ...hardcodedModules.asMap().entries.map(
                (e) => _trainingCard(
                  e.value,
                  e.key,
                  onTap: () {
                    final screens = [
                      MentalHealthIntroScreen(),
                      MentalHealthDisordersScreen(),
                      AlgeeActionPlanScreen(),
                      WorkplaceMhfaScreen(),
                      CulturalHumilityEquityScreen(),
                      RecognizingCrisisScreen(),
                      OngoingSupportScreen(),
                      PracticalSkillsTrainingScreen(),
                      MentalHealthSelfCareScreen(),
                    ];
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => screens[e.key]),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: prac_bottomNavbbar(
          currentScreen: 'Training',
          clientData: {},
        ),
        // bottomNavigationBar: BottomNavBar(currentScreen: l10n.training),
      ),
    );
  }
}
