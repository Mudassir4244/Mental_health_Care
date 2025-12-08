// import 'package:flutter/material.dart';
// import 'package:mental_healthcare/frontend/widgets/appcolors.dart';

// class TherapistDetails extends StatefulWidget {
//   final Map<String, dynamic> data;

//   const TherapistDetails({super.key, required this.data});

//   @override
//   State<TherapistDetails> createState() => _TherapistDetailsState();
// }

// class _TherapistDetailsState extends State<TherapistDetails> {
//   @override
//   Widget build(BuildContext context) {
//     final therapist = widget.data;

//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       body: Column(
//         children: [
//           // =======================
//           // TOP GRADIENT HEADER
//           // =======================
//           Container(
//             width: double.infinity,
//             padding: const EdgeInsets.symmetric(vertical: 40),
//             decoration: const BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [AppColors.primary, AppColors.accent],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//               borderRadius: BorderRadius.only(
//                 bottomLeft: Radius.circular(25),
//                 bottomRight: Radius.circular(25),
//               ),
//             ),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 // Profile avatar
//                 Align(
//                   alignment: Alignment.topLeft,
//                   child: Padding(
//                     padding: const EdgeInsets.only(left: 10, bottom: 10),
//                     child: GestureDetector(
//                       onTap: () {
//                         Navigator.pop(context);
//                       },
//                       child: Icon(
//                         Icons.arrow_back_ios_new,
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ),
//                 CircleAvatar(
//                   radius: 45,
//                   backgroundColor: Colors.white,
//                   child: Icon(Icons.person, size: 50, color: Colors.blue[700]),
//                 ),

//                 const SizedBox(height: 15),

//                 // Therapist Name
//                 Text(
//                   therapist['username'] ?? 'Therapist',
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),

//                 const SizedBox(height: 5),

//                 // Speciality short tag
//                 Text(
//                   therapist['Speciality'] ?? 'Specialist',
//                   style: const TextStyle(color: Colors.white70, fontSize: 16),
//                 ),
//               ],
//             ),
//           ),

//           const SizedBox(height: 20),

//           // =======================
//           // INFORMATION CARDS BELOW
//           // =======================
//           Expanded(
//             child: SingleChildScrollView(
//               padding: const EdgeInsets.symmetric(horizontal: 20),
//               child: Column(
//                 children: [
//                   detailCard(
//                     icon: Icons.email,
//                     label: "Email",
//                     value: therapist['email'] ?? "Not Available",
//                   ),
//                   detailCard(
//                     icon: Icons.phone,
//                     label: "Phone",
//                     value: therapist['Phone Number'] ?? "Not Provided",
//                   ),
//                   detailCard(
//                     icon: Icons.star,
//                     label: "Speciality",
//                     value: therapist['Speciality'] ?? "Not Available",
//                   ),
//                   SizedBox(height: 30),
//                   Padding(
//                     padding: const EdgeInsets.all(30),
//                     child: GestureDetector(
//                       onTap: () {},
//                       child: Container(
//                         width: double.infinity,
//                         height: 55,
//                         decoration: BoxDecoration(
//                           gradient: LinearGradient(
//                             colors: [AppColors.primary, AppColors.accent],
//                             begin: Alignment.topLeft,
//                             end: Alignment.bottomRight,
//                           ),
//                           borderRadius: BorderRadius.circular(30),
//                         ),
//                         child: Center(
//                           child: Text(
//                             'Send Message',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                             ),
//                             textAlign: TextAlign.center,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // =======================
//   // REUSABLE CARD WIDGET
//   // =======================
//   Widget detailCard({
//     required IconData icon,
//     required String label,
//     required String value,
//   }) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 18),
//       padding: const EdgeInsets.all(18),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(18),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black12,
//             blurRadius: 8,
//             spreadRadius: 1,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               color: Colors.blue[50],
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Icon(icon, color: Colors.blue),
//           ),
//           const SizedBox(width: 15),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 label,
//                 style: const TextStyle(color: Colors.grey, fontSize: 14),
//               ),
//               const SizedBox(height: 5),
//               Text(
//                 value,
//                 style: const TextStyle(
//                   fontSize: 17,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ],
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

class TherapistDetails extends StatefulWidget {
  final Map<String, dynamic> data;

  const TherapistDetails({super.key, required this.data});

  @override
  State<TherapistDetails> createState() => _TherapistDetailsState();
}

class _TherapistDetailsState extends State<TherapistDetails> {
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;

  /// ===========================================
  /// CREATE OR OPEN CHAT FUNCTION
  /// ===========================================
  Future<void> createOrOpenChat() async {
    try {
      final therapist = widget.data;
      final currentUser = auth.currentUser!;

      // Generate chat ID instantly
      String chatId = currentUser.uid.compareTo(therapist['uid']) < 0
          ? "${currentUser.uid}_${therapist['uid']}"
          : "${therapist['uid']}_${currentUser.uid}";

      // 🚀 Navigate IMMEDIATELY (No delay)
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ChatScreen(
            chatId: chatId,
            senderId: currentUser.uid,
            senderName: currentUser.displayName ?? "User", // Will update after fetch
            receiverId: therapist['uid'],
            receiverName: therapist['username'],
            receiverRole: "Therapist",
          ),
        ),
      );

      // 🔥 Fetch user name in background (no need to block UI)
      final userDoc = await firestore
          .collection("Users")
          .doc(currentUser.uid)
          .get();

      final currentUserName = userDoc.data()?["username"] ?? "";

      // 🔥 Write chat data also in background
      await firestore.collection("Chats").doc(chatId).set({
        "senderId": currentUser.uid,
        "senderName": currentUserName,
        "receiverId": therapist['uid'],
        "receiverName": therapist['username'],
        "receiverRole": "Therapist",
        "timestamp": FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      print("❌ ERROR in createOrOpenChat: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final therapist = widget.data;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          // ======================
          // HEADER (UNCHANGED)
          // ======================
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 40),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.accent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, bottom: 10),
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                CircleAvatar(
                  radius: 45,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 50, color: Colors.blue[700]),
                ),
                const SizedBox(height: 15),
                Text(
                  therapist['username'] ?? 'Therapist',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  therapist['Speciality'] ?? 'Specialist',
                  style: const TextStyle(color: Colors.white70, fontSize: 16),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // =============================
          // DETAILS + SEND MESSAGE BUTTON
          // =============================
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  detailCard(
                    icon: Icons.email,
                    label: "Email",
                    value: therapist['email'] ?? "Not Available",
                  ),
                  detailCard(
                    icon: Icons.phone,
                    label: "Phone",
                    value: therapist['Phone Number'] ?? "Not Provided",
                  ),
                  detailCard(
                    icon: Icons.star,
                    label: "Speciality",
                    value: therapist['Speciality'] ?? "Not Available",
                  ),

                  const SizedBox(height: 30),

                  // =============================
                  // SEND MESSAGE BUTTON (UNCHANGED)
                  // =============================
                  ElevatedButton(
                    onPressed: createOrOpenChat,

                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets
                          .zero, // important for removing default padding
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 3,
                      backgroundColor:
                          Colors.transparent, // will be overridden by Ink
                      shadowColor: Colors.transparent,
                    ),
                    child: Ink(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.primary, AppColors.accent],
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Container(
                        height: 55,
                        alignment: Alignment.center,
                        child: const Text(
                          'Send Message',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =======================
  // REUSABLE CARD
  // =======================
  Widget detailCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(color: Colors.grey)),
              const SizedBox(height: 5),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
