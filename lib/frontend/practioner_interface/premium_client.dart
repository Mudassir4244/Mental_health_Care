// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// import 'package:mental_healthcare/frontend/chats/screens/chat_screen.dart';
// import 'package:mental_healthcare/frontend/widgets/appcolors.dart';

// class PremiumClientDetailsScreen extends StatelessWidget {
//   final Map<String, dynamic> clientData;
//   final Map<String, dynamic> data;

//   // final String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? "";
//   final String currentuserId = FirebaseAuth.instance.currentUser!.uid;

//   /// Make these nullable to avoid crash
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
//     final client = clientData;

//     // SAFE UID VALUES
//     final String clientid = clientData['uid'] ?? "";
//     final String chatId = generateChatId(currentuserId, clientid);

//     return Scaffold(
//       backgroundColor: AppColors.background,
//       appBar: AppBar(
//         centerTitle: true,
//         leading: IconButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           icon: const Icon(
//             Icons.arrow_back_ios_new,
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
//             // ===================== PROFILE HEADER ====================
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
//                   // SAFE USERNAME INITIAL
//                   CircleAvatar(
//                     radius: 55,
//                     backgroundColor: Colors.white,
//                     child:
//                         clientData['ImageUrl'] != null &&
//                             clientData['ImageUrl'] != ""
//                         ? ClipOval(
//                             child: Image.network(
//                               clientData['ImageUrl'],
//                               width: 100,
//                               height: 100,
//                               fit: BoxFit.cover,
//                             ),
//                           )
//                         : Text(
//                             (clientData["username"] ?? "U")
//                                 .toString()[0]
//                                 .toUpperCase(),
//                             style: const TextStyle(
//                               fontSize: 40,
//                               color: AppColors.primary,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                   ),

//                   const SizedBox(height: 15),

//                   // SAFE USERNAME
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

//             // ===================== DETAILS ====================
//             detailTile(
//               title: "Email",
//               value: clientData["email"] ?? "N/A",
//               icon: Icons.email,
//               clickable: true,
//             ),

//             detailTile(
//               title: "Payment Status",
//               value: clientData["Payment Status"] ?? "N/A",
//               icon: Icons.payment,
//             ),

//             detailTile(
//               title: "Role",
//               value: clientData["role"] ?? "N/A",
//               icon: Icons.person,
//             ),

//             detailTile(
//               title: "Plan",
//               value: clientData["plan"] ?? "Premium",
//               icon: Icons.stars,
//             ),

//             detailTile(
//               title: "Preferred Payment Method",
//               value: clientData["Preferred Payment Method"] ?? "N/A",
//               icon: Icons.perm_identity,
//               clickable: true,
//             ),
//             const SizedBox(height: 25),

//             detailTile(
//               title: "User ID",
//               value: clientData["uid"] ?? "N/A",
//               icon: Icons.perm_identity,
//               clickable: true,
//             ),

//             const SizedBox(height: 25),

//             // ===================== SEND MESSAGE BUTTON ====================
//             Container(
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [AppColors.primary, AppColors.accent],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 ),
//                 borderRadius: BorderRadius.circular(14),
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
//                 ),

//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (_) => ChatScreen(
//                         chatId: chatId,
//                         senderId: currentuserId,
//                         senderName: currentUsername, // Will update after fetch
//                         receiverId: client['uid'],
//                         receiverName: client['username'],
//                         receiverRole: "Therapist",
//                       ),
//                     ),
//                   );
//                 },

//                 icon: const Icon(Icons.message),
//                 label: const Text(
//                   "Text to Connect",
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // ===================== CHAT ID GENERATOR =====================
//   String generateChatId(String a, String b) {
//     List<String> ids = [a, b];
//     ids.sort();
//     return ids.join("_");
//   }

//   // ===================== DETAIL TILE =====================
//   Widget detailTile({
//     required String title,
//     required dynamic value,
//     required IconData icon,
//     bool clickable = false,
//   }) {
//     final safeValue = value?.toString() ?? "N/A";

//     return GestureDetector(
//       onTap: clickable
//           ? () {
//               Clipboard.setData(ClipboardData(text: safeValue));
//               HapticFeedback.lightImpact();
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
//                 "$title: $safeValue",
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

  final String currentuserId = FirebaseAuth.instance.currentUser!.uid;

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
    final String clientid = clientData['uid'] ?? "";
    final String chatId = generateChatId(currentuserId, clientid);
    final String imageUrl = clientData['ImageUrl'] ?? "";

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
                  // PROFILE IMAGE WITH TAP GESTURE
                  GestureDetector(
                    onTap: () {
                      if (imageUrl.isNotEmpty) {
                        _showFullScreenImage(context, imageUrl);
                      }
                    },
                    child: Hero(
                      tag: 'profile_image_$clientid',
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 55,
                          backgroundColor: Colors.white,
                          child: imageUrl.isNotEmpty
                              ? ClipOval(
                                  child: Image.network(
                                    imageUrl,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                          if (loadingProgress == null) {
                                            return child;
                                          }
                                          return Center(
                                            child: CircularProgressIndicator(
                                              value:
                                                  loadingProgress
                                                          .expectedTotalBytes !=
                                                      null
                                                  ? loadingProgress
                                                            .cumulativeBytesLoaded /
                                                        loadingProgress
                                                            .expectedTotalBytes!
                                                  : null,
                                              color: AppColors.primary,
                                            ),
                                          );
                                        },
                                  ),
                                )
                              : Text(
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
                      ),
                    ),
                  ),

                  // Camera icon indicator when image exists
                  if (imageUrl.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.touch_app,
                            size: 16,
                            color: Colors.white.withOpacity(0.7),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "Tap to view",
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 15),

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

            detailTile(
              title: "Preferred Payment Method",
              value: clientData["Preferred Payment Method"] ?? "N/A",
              icon: Icons.perm_identity,
              clickable: true,
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
                        senderName: currentUsername,
                        receiverId: client['uid'],
                        receiverName: client['username'],
                        receiverRole: "Therapist",
                        recieverimageurl: client['ImageUrl'] ?? "",
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.message),
                label: const Text(
                  "Text to Connect",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===================== FULL SCREEN IMAGE VIEWER =====================
  void _showFullScreenImage(BuildContext context, String imageUrl) {
    Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => FullScreenImageViewer(
          imageUrl: imageUrl,
          heroTag: 'profile_image_${clientData['uid'] ?? ''}',
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

// ===================== FULL SCREEN IMAGE VIEWER WIDGET =====================
class FullScreenImageViewer extends StatefulWidget {
  final String imageUrl;
  final String heroTag;

  const FullScreenImageViewer({
    super.key,
    required this.imageUrl,
    required this.heroTag,
  });

  @override
  State<FullScreenImageViewer> createState() => _FullScreenImageViewerState();
}

class _FullScreenImageViewerState extends State<FullScreenImageViewer> {
  double _scale = 1.0;
  double _previousScale = 1.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Image with pinch to zoom
          Center(
            child: GestureDetector(
              onScaleStart: (details) {
                _previousScale = _scale;
              },
              onScaleUpdate: (details) {
                setState(() {
                  _scale = (_previousScale * details.scale).clamp(1.0, 4.0);
                });
              },
              onScaleEnd: (details) {
                if (_scale < 1.0) {
                  setState(() {
                    _scale = 1.0;
                  });
                }
              },
              onDoubleTap: () {
                setState(() {
                  _scale = _scale > 1.0 ? 1.0 : 2.0;
                });
              },
              child: Hero(
                tag: widget.heroTag,
                child: Transform.scale(
                  scale: _scale,
                  child: Image.network(
                    widget.imageUrl,
                    fit: BoxFit.contain,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                              : null,
                          color: Colors.white,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),

          // Close button
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  if (_scale != 1.0)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${(_scale * 100).toInt()}%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Instructions at bottom
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Pinch to zoom • Double tap to zoom',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
