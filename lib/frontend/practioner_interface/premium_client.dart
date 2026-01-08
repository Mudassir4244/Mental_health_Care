// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// import 'package:mental_healthcare/frontend/chats/screens/chat_screen.dart';
// import 'package:mental_healthcare/frontend/practioner_interface/prac_homescreen.dart';
// import 'package:mental_healthcare/frontend/widgets/appcolors.dart';
// import 'package:provider/provider.dart';

// class PremiumClientDetailsScreen extends StatelessWidget {
//   final Map<String, dynamic> clientData;
//   final Map<String, dynamic> data;
//   final String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? "";
//   final String currentUsername;
//   final String currentUserRole;
//   final String recieverId;
//   final String recievername;
//   final String receiverRole;

//   PremiumClientDetailsScreen({
//     super.key,
//     required this.clientData,
//     required this.currentUsername,
//     required this.currentUserRole,
//     required this.recievername,
//     required this.recieverId,
//     required this.receiverRole,
//     required this.data,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final clients = Provider.of<PremiumClientProvider>(context).premiumClients;
//     final therapist = data;
//     String chatId = currentUserId.compareTo(therapist['uid']) < 0
//         ? "${currentUserId}_${therapist['uid']}"
//         : "${therapist['uid']}_${currentUserId}";
//     return Scaffold(
//       backgroundColor: AppColors.background,

//       appBar: AppBar(
//         centerTitle: true,
//         leading: IconButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           icon: Icon(
//             Icons.arrow_back_ios_new,
//             fontWeight: FontWeight.bold,
//             color: AppColors.cardColor,
//           ),
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
//         shadowColor: AppColors.primary.withOpacity(0.4),
//         title: const Text(
//           "Client Details",
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             fontSize: 20,
//             color: AppColors.cardColor,
//           ),
//         ),
//       ),

//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           children: [
//             // ---------------- PROFILE HEADER ----------------
//             Container(
//               padding: const EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [AppColors.primary, AppColors.accent],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 ),
//                 borderRadius: BorderRadius.circular(20),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.deepPurple.withOpacity(0.3),
//                     blurRadius: 10,
//                     offset: const Offset(0, 4),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 children: [
//                   CircleAvatar(
//                     radius: 45,
//                     backgroundColor: Colors.white,
//                     child: Text(
//                       clientData["username"][0],
//                       style: const TextStyle(
//                         fontSize: 40,
//                         color: AppColors.primary,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 15),
//                   Text(
//                     clientData["username"] ?? "Unknown",
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 22,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 6),
//                   Container(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 12,
//                       vertical: 6,
//                     ),
//                     decoration: BoxDecoration(
//                       color: Colors.white.withOpacity(.2),
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: const Text(
//                       "Premium Client",
//                       style: TextStyle(color: Colors.white, fontSize: 14),
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             const SizedBox(height: 20),

//             // ---------------- DETAILS BOX ----------------
//             detailTile(
//               title: "Email",
//               value: clientData["email"],
//               icon: Icons.email,
//               clickable: true,
//             ),

//             detailTile(
//               title: "Payment Status",
//               value: clientData["payment Status"],
//               icon: Icons.payment,
//             ),

//             detailTile(
//               title: "Role",
//               value: clientData["role"],
//               icon: Icons.person,
//             ),

//             detailTile(
//               title: "Plan",
//               value: clientData["plan"] ?? "Premium",
//               icon: Icons.stars,
//             ),

//             const SizedBox(height: 25),
//             detailTile(
//               title: 'User Id\n',
//               value: clientData['uid'],
//               icon: Icons.perm_identity,
//               clickable: true,
//             ),

//             const SizedBox(height: 25),
//             // ---------------- SEND MESSAGE BUTTON ----------------
//             Container(
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [AppColors.primary, AppColors.accent],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 ),
//                 borderRadius: BorderRadius.circular(14),
//                 boxShadow: [
//                   BoxShadow(
//                     color: AppColors.primary.withOpacity(0.3),
//                     blurRadius: 5,
//                     offset: const Offset(0, 3),
//                   ),
//                 ],
//               ),
//               child: ElevatedButton.icon(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.transparent,
//                   shadowColor: Colors.transparent,
//                   foregroundColor: Colors.white,
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 30,
//                     vertical: 14,
//                   ),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(14),
//                   ),
//                   elevation: 0,
//                 ),
//                 onPressed: () {
//                   // Generate chat ID
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (_) => ChatScreen(
//                         chatId: chatId,
//                         senderId: currentUserId,
//                         senderName: currentUsername,
//                         receiverId: recieverId,
//                         receiverName: recievername,
//                         receiverRole: receiverRole,
//                       ),
//                     ),
//                   );
//                 },

//                 icon: const Icon(Icons.message),
//                 label: const Text(
//                   "Send Message",
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   //---------------------------------------------------------------------------
//   // GENERATE CHAT ID
//   //---------------------------------------------------------------------------
//   String generateChatId(String userId1, String userId2) {
//     List<String> ids = [userId1, userId2];
//     ids.sort();
//     return ids.join('_');
//   }

//   //---------------------------------------------------------------------------
//   // CUSTOM DETAIL TILE WIDGET
//   //---------------------------------------------------------------------------
//   Widget detailTile({
//     required String title,
//     required dynamic value,
//     required IconData icon,
//     bool clickable = false,
//   }) {
//     return GestureDetector(
//       onTap: clickable
//           ? () {
//               Clipboard.setData(ClipboardData(text: value.toString()));
//             }
//           : null,
//       onLongPress: clickable
//           ? () {
//               Clipboard.setData(ClipboardData(text: value.toString()));
//               HapticFeedback.mediumImpact();
//             }
//           : null,
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 12),
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(14),
//           color: Colors.white,
//           boxShadow: [
//             BoxShadow(
//               color: Colors.deepPurple.withOpacity(0.08),
//               blurRadius: 6,
//               offset: const Offset(0, 3),
//             ),
//           ],
//         ),

//         child: Row(
//           children: [
//             Icon(icon, size: 26, color: AppColors.primary),
//             const SizedBox(width: 15),
//             Expanded(
//               child: Text(
//                 "$title:  ${value ?? 'N/A'}",
//                 style: const TextStyle(
//                   fontSize: 15,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ),

//             if (clickable) const Icon(Icons.copy, size: 18, color: Colors.grey),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:mental_healthcare/frontend/chats/screens/chat_screen.dart';
import 'package:mental_healthcare/frontend/widgets/appcolors.dart';

class PremiumClientDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> clientData;
  final Map<String, dynamic> data;

  // final String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? "";
  final String currentuserId = FirebaseAuth.instance.currentUser!.uid;

  /// Make these nullable to avoid crash
  final String currentUsername;
  final String currentUserRole;
  final String recieverId;
  final String recievername;
  final String receiverRole;

  PremiumClientDetailsScreen({
    super.key,
    required this.clientData,
    required this.currentUsername,
    required this.currentUserRole,
    required this.recievername,
    required this.recieverId,
    required this.receiverRole,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final client = clientData;

    // SAFE UID VALUES
    final String clientid = clientData['uid'] ?? "";
    final String chatId = generateChatId(currentuserId, clientid);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.cardColor,
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
        elevation: 4,
        shadowColor: AppColors.primary.withOpacity(0.4),
        title: const Text(
          "Client Details",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: AppColors.cardColor,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // ===================== PROFILE HEADER ====================
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primary, AppColors.accent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.deepPurple.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // SAFE USERNAME INITIAL
                  CircleAvatar(
                    radius: 45,
                    backgroundColor: Colors.white,
                    child: Text(
                      (clientData["username"] ?? "U")
                          .toString()[0]
                          .toUpperCase(),
                      style: const TextStyle(
                        fontSize: 40,
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  // SAFE USERNAME
                  Text(
                    clientData["username"] ?? "Unknown",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      "Premium Client",
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ===================== DETAILS ====================
            detailTile(
              title: "Email",
              value: clientData["email"] ?? "N/A",
              icon: Icons.email,
              clickable: true,
            ),

            detailTile(
              title: "Payment Status",
              value: clientData["Payment Status"] ?? "N/A",
              icon: Icons.payment,
            ),

            detailTile(
              title: "Role",
              value: clientData["role"] ?? "N/A",
              icon: Icons.person,
            ),

            detailTile(
              title: "Plan",
              value: clientData["plan"] ?? "Premium",
              icon: Icons.stars,
            ),

            const SizedBox(height: 25),

            detailTile(
              title: "User ID",
              value: clientData["uid"] ?? "N/A",
              icon: Icons.perm_identity,
              clickable: true,
            ),

            const SizedBox(height: 25),

            // ===================== SEND MESSAGE BUTTON ====================
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primary, AppColors.accent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),

                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChatScreen(
                        chatId: chatId,
                        senderId: currentuserId,
                        senderName: currentUsername, // Will update after fetch
                        receiverId: client['uid'],
                        receiverName: client['username'],
                        receiverRole: "Therapist",
                      ),
                    ),
                  );
                },

                icon: const Icon(Icons.message),
                label: const Text(
                  "Send Message",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===================== CHAT ID GENERATOR =====================
  String generateChatId(String a, String b) {
    List<String> ids = [a, b];
    ids.sort();
    return ids.join("_");
  }

  // ===================== DETAIL TILE =====================
  Widget detailTile({
    required String title,
    required dynamic value,
    required IconData icon,
    bool clickable = false,
  }) {
    final safeValue = value?.toString() ?? "N/A";

    return GestureDetector(
      onTap: clickable
          ? () {
              Clipboard.setData(ClipboardData(text: safeValue));
              HapticFeedback.lightImpact();
            }
          : null,

      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.deepPurple.withOpacity(0.08),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),

        child: Row(
          children: [
            Icon(icon, size: 26, color: AppColors.primary),
            const SizedBox(width: 15),

            Expanded(
              child: Text(
                "$title: $safeValue",
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            if (clickable) const Icon(Icons.copy, size: 18, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
