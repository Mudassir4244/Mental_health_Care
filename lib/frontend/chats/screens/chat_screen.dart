// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:mental_healthcare/frontend/customer_interface/therapist_details.dart';
// import 'package:mental_healthcare/frontend/widgets/appcolors.dart';

// class ChatScreen extends StatefulWidget {
//   final String chatId;
//   final String senderId;
//   final String senderName;
//   final String receiverId;
//   final String receiverName;
//   final String receiverRole;

//   const ChatScreen({
//     super.key,
//     required this.chatId,
//     required this.senderId,
//     required this.senderName,
//     required this.receiverId,
//     required this.receiverName,
//     required this.receiverRole,
//   });

//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   final TextEditingController msgController = TextEditingController();
//   final FirebaseFirestore firestore = FirebaseFirestore.instance;
//   final ScrollController _scrollController = ScrollController();

//   void sendMessage() {
//     String message = msgController.text.trim();
//     if (message.isEmpty) return;
//     msgController.clear();
//     firestore
//         .collection("Chats")
//         .doc(widget.chatId)
//         .collection("messages")
//         .add({
//           "message": message,
//           "senderId": widget.senderId,
//           "senderName": widget.senderName,
//           "timestamp": FieldValue.serverTimestamp(),
//         });

//     Future.delayed(const Duration(milliseconds: 200), () {
//       _scrollController.animateTo(
//         _scrollController.position.maxScrollExtent,
//         duration: const Duration(milliseconds: 300),
//         curve: Curves.easeOut,
//       );
//     });
//   }

//   // Format timestamp
//   String formatTime(Timestamp? timestamp) {
//     if (timestamp == null) return "";
//     DateTime dt = timestamp.toDate();
//     return DateFormat('hh:mm a').format(dt);
//   }

//   @override
//   Widget build(BuildContext context) {
//     List<Map<String, dynamic>> practitioners = [];
//     return Scaffold(
//       // =============================
//       // BEAUTIFUL GRADIENT APPBAR
//       // =============================
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         // leading: GestureDetector(
//         //   onTap: () => Navigator.pop(context),
//         //   child: Icon(
//         //     Icons.arrow_back_ios_new,
//         //     color: AppColors.cardColor,
//         //     fontWeight: FontWeight.bold,
//         //   ),
//         // ),
//         // elevation: 3,
//         title: Row(
//           children: [
//             GestureDetector(
//               onTap: () => Navigator.pop(context),
//               child: Icon(
//                 Icons.arrow_back_ios_new,
//                 color: AppColors.cardColor,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(width: 15),
//             CircleAvatar(
//               backgroundColor: Colors.white,
//               radius: 20,
//               child: Icon(Icons.person),
//             ),
//             const SizedBox(width: 5),
//             GestureDetector(
//               onTap: () async {
//                 // Fetch therapist data from Firestore
//                 final doc = await FirebaseFirestore.instance
//                     .collection('Users')
//                     .doc(widget.receiverId)
//                     .get();

//                 if (doc.exists) {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (_) => TherapistDetails(data: doc.data()!),
//                     ),
//                   );
//                 } else {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(content: Text("Therapist data not found")),
//                   );
//                 }
//               },
//               child: Text(
//                 widget.receiverName,
//                 style: const TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 18,
//                   color: AppColors.cardColor,
//                 ),
//               ),
//             ),
//           ],
//         ),

//         flexibleSpace: Container(
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               colors: [AppColors.primary, AppColors.accent],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//           ),
//         ),
//       ),

//       // =============================
//       // CHAT UI
//       // =============================
//       body: Column(
//         children: [
//           Expanded(
//             child: StreamBuilder(
//               stream: firestore
//                   .collection("Chats")
//                   .doc(widget.chatId)
//                   .collection("messages")
//                   .orderBy("timestamp", descending: false)
//                   .snapshots(),
//               builder: (context, snapshot) {
//                 if (!snapshot.hasData) {
//                   return const Center(child: CircularProgressIndicator());
//                 }

//                 var messages = snapshot.data!.docs;

//                 return ListView.builder(
//                   controller: _scrollController,
//                   padding: const EdgeInsets.all(15),
//                   itemCount: messages.length,
//                   itemBuilder: (context, index) {
//                     var msg = messages[index];
//                     bool isMe = msg['senderId'] == widget.senderId;

//                     return Column(
//                       crossAxisAlignment: isMe
//                           ? CrossAxisAlignment.end
//                           : CrossAxisAlignment.start,
//                       children: [
//                         Container(
//                           constraints: BoxConstraints(
//                             maxWidth: MediaQuery.of(context).size.width * 0.75,
//                           ),
//                           margin: const EdgeInsets.symmetric(vertical: 6),
//                           padding: const EdgeInsets.all(14),
//                           decoration: BoxDecoration(
//                             gradient: isMe
//                                 ? const LinearGradient(
//                                     colors: [
//                                       AppColors.primary,
//                                       AppColors.accent,
//                                     ],
//                                   )
//                                 : null,
//                             color: isMe ? null : Colors.grey.shade200,
//                             borderRadius: BorderRadius.only(
//                               topLeft: const Radius.circular(18),
//                               topRight: const Radius.circular(18),
//                               bottomLeft: isMe
//                                   ? const Radius.circular(18)
//                                   : const Radius.circular(0),
//                               bottomRight: isMe
//                                   ? const Radius.circular(0)
//                                   : const Radius.circular(18),
//                             ),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.black.withOpacity(0.05),
//                                 blurRadius: 8,
//                                 offset: const Offset(0, 3),
//                               ),
//                             ],
//                           ),
//                           child: Column(
//                             crossAxisAlignment: isMe
//                                 ? CrossAxisAlignment.end
//                                 : CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 msg['message'],
//                                 style: TextStyle(
//                                   color: isMe ? Colors.white : Colors.black87,
//                                   fontSize: 16,
//                                 ),
//                               ),
//                               const SizedBox(height: 5),
//                               Text(
//                                 formatTime(msg['timestamp']),
//                                 style: TextStyle(
//                                   fontSize: 11,
//                                   color: isMe
//                                       ? Colors.white70
//                                       : Colors.grey.shade600,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     );
//                   },
//                 );
//               },
//             ),
//           ),

//           // =============================
//           // MESSAGE INPUT BAR
//           // =============================
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//             decoration: const BoxDecoration(
//               color: Colors.white,
//               boxShadow: [
//                 BoxShadow(
//                   blurRadius: 6,
//                   color: Colors.black12,
//                   offset: Offset(0, -2),
//                 ),
//               ],
//             ),
//             child: Row(
//               children: [
//                 // Rounded Input Field
//                 Expanded(
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 15),
//                     decoration: BoxDecoration(
//                       color: Colors.grey.shade100,
//                       borderRadius: BorderRadius.circular(25),
//                       boxShadow: [
//                         BoxShadow(blurRadius: 5, color: Colors.black12),
//                       ],
//                     ),
//                     child: TextField(
//                       controller: msgController,
//                       decoration: const InputDecoration(
//                         hintText: "Type a message...",
//                         border: InputBorder.none,
//                       ),
//                     ),
//                   ),
//                 ),

//                 const SizedBox(width: 10),

//                 // Send Button
//                 Container(
//                   padding: const EdgeInsets.all(12),
//                   decoration: const BoxDecoration(
//                     // color: AppColors.primary,
//                     shape: BoxShape.circle,
//                     gradient: LinearGradient(
//                       colors: [AppColors.accent, AppColors.primary],
//                     ),
//                   ),
//                   child: InkWell(
//                     onTap: sendMessage,
//                     child: const Icon(
//                       Icons.send,
//                       color: Colors.white,
//                       size: 22,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mental_healthcare/frontend/customer_interface/therapist_details.dart';
import 'package:mental_healthcare/frontend/organization_interface/oraginzation%20owner/employee_detailscreen.dart';
import 'package:mental_healthcare/frontend/widgets/appcolors.dart';

class ChatScreen extends StatefulWidget {
  final String chatId;
  final String senderId;
  final String senderName;
  final String receiverId;
  final String receiverName;
  final String receiverRole;
  final String recieverimageurl;

  const ChatScreen({
    super.key,
    required this.chatId,
    required this.senderId,
    required this.senderName,
    required this.receiverId,
    required this.receiverName,
    required this.receiverRole,
    required this.recieverimageurl,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController msgController = TextEditingController();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final ScrollController _scrollController = ScrollController();

  void sendMessage() {
    String message = msgController.text.trim();
    if (message.isEmpty) return;
    msgController.clear();

    firestore.collection("Chats").doc(widget.chatId).collection("messages").add(
      {
        "message": message,
        "senderId": widget.senderId,
        "senderName": widget.senderName,
        "timestamp": FieldValue.serverTimestamp(),
        "participants": [
          widget.senderId,
          widget.receiverId,
        ], // <-- added participants array
        "deletedFor": [], // <-- initialize deletedFor as empty list
        "pinned": false, // optional: for future pinned message feature
      },
    );

    // Update parent Chat document to ensure participants field exists for querying
    firestore.collection("Chats").doc(widget.chatId).set({
      "participants": [widget.senderId, widget.receiverId],
      "lastMessage": message,
      "timestamp": FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    Future.delayed(const Duration(milliseconds: 200), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  // Format timestamp
  String formatTime(Timestamp? timestamp) {
    if (timestamp == null) return "";
    DateTime dt = timestamp.toDate();
    return DateFormat('hh:mm a').format(dt);
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> practitioners = [];
    final Map<String, dynamic> clientData;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Icon(
                Icons.arrow_back_ios_new,
                color: AppColors.cardColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 15),
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.grey.shade300,

              backgroundImage:
                  widget.recieverimageurl.isNotEmpty
                  ? NetworkImage(widget.recieverimageurl)
                  : null,

              child:
                  widget.recieverimageurl.isEmpty
                  ? (widget.receiverName.isNotEmpty
                        ? Text(
                            widget.receiverName[0].toUpperCase(),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          )
                        : const Icon(Icons.person))
                  : null,
            ),

            const SizedBox(width: 5),
            GestureDetector(
              onTap: () async {
                // Fetch user data from Firestore
                final doc = await FirebaseFirestore.instance
                    .collection('Users')
                    .doc(widget.receiverId)
                    .get();

                if (doc.exists) {
                  final userData = doc.data()!;
                  final role = userData['role']?.toString().toLowerCase() ?? '';

                  // If the user is an employee/organization employee, show employee details
                  if (role.contains('employee')) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            EmployeeDetailscreen(employeeId: widget.receiverId),
                      ),
                    );
                  } else {
                    // Otherwise show therapist details (default behavior)
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TherapistDetails(data: userData),
                      ),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("User data not found")),
                  );
                }
              },
              child: Text(
                widget.receiverName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: AppColors.cardColor,
                ),
              ),
            ),
          ],
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primary, AppColors.accent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: firestore
                  .collection("Chats")
                  .doc(widget.chatId)
                  .collection("messages")
                  .orderBy("timestamp", descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                var messages = snapshot.data!.docs;

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(15),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    var msg = messages[index];
                    var msgData = msg.data();
                    bool isMe = msgData['senderId'] == widget.senderId;

                    // Safely check deletedFor array
                    bool deletedForMe = (msgData['deletedFor'] ?? []).contains(
                      widget.senderId,
                    );
                    if (deletedForMe) {
                      return const SizedBox(); // skip messages deleted for me
                    }

                    return Column(
                      crossAxisAlignment: isMe
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onLongPress: () {
                            if (isMe) {
                              _showMessageOptions(msgData, msg.id);
                            }
                          },
                          child: Container(
                            constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(context).size.width * 0.75,
                            ),
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              gradient: isMe
                                  ? const LinearGradient(
                                      colors: [
                                        AppColors.primary,
                                        AppColors.accent,
                                      ],
                                    )
                                  : null,
                              color: isMe ? null : Colors.grey.shade200,
                              borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(18),
                                topRight: const Radius.circular(18),
                                bottomLeft: isMe
                                    ? const Radius.circular(18)
                                    : const Radius.circular(0),
                                bottomRight: isMe
                                    ? const Radius.circular(0)
                                    : const Radius.circular(18),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: isMe
                                  ? CrossAxisAlignment.end
                                  : CrossAxisAlignment.start,
                              children: [
                                Text(
                                  msgData['message'],
                                  style: TextStyle(
                                    color: isMe ? Colors.white : Colors.black87,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  formatTime(msgData['timestamp']),
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: isMe
                                        ? Colors.white70
                                        : Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
          // =============================
          // MESSAGE INPUT BAR
          // =============================
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  blurRadius: 6,
                  color: Colors.black12,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(blurRadius: 5, color: Colors.black12),
                      ],
                    ),
                    child: TextField(
                      controller: msgController,
                      decoration: const InputDecoration(
                        hintText: "Type a message...",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [AppColors.accent, AppColors.primary],
                    ),
                  ),
                  child: InkWell(
                    onTap: sendMessage,
                    child: const Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================================
  // Message Options (Long Press)
  // ================================
  void _showMessageOptions(Map<String, dynamic> msgData, String msgId) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.delete_forever),
                title: const Text("Delete for Everyone"),
                onTap: () {
                  _deleteMessageForEveryone(msgId);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _deleteMessageForEveryone(String msgId) {
    firestore
        .collection("Chats")
        .doc(widget.chatId)
        .collection("messages")
        .doc(msgId)
        .update({
          "deletedFor": FieldValue.arrayUnion([widget.senderId]),
        });
  }
}
