// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:mental_healthcare/frontend/chats/screens/chat_screen.dart';
// import 'package:mental_healthcare/frontend/widgets/appcolors.dart';

// class InboxScreen extends StatefulWidget {
//   const InboxScreen({super.key});

//   @override
//   State<InboxScreen> createState() => _InboxScreenState();
// }

// class _InboxScreenState extends State<InboxScreen> {
//   final FirebaseFirestore firestore = FirebaseFirestore.instance;
//   final FirebaseAuth auth = FirebaseAuth.instance;

//   String searchQuery = "";

//   @override
//   Widget build(BuildContext context) {
//     final currentUid = auth.currentUser!.uid;

//     return Scaffold(
//       backgroundColor: Colors.grey[100],

//       // ==============================
//       // APP BAR WITH SEARCH BAR
//       // ==============================
//       body: Column(
//         children: [
//           Container(
//             padding: const EdgeInsets.only(
//               top: 50,
//               left: 20,
//               right: 20,
//               bottom: 20,
//             ),
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
//               children: [
//                 Row(
//                   children: [
//                     GestureDetector(
//                       onTap: () => Navigator.pop(context),
//                       child: const Icon(
//                         Icons.arrow_back_ios_new,
//                         color: Colors.white,
//                       ),
//                     ),
//                     const SizedBox(width: 20),
//                     const Text(
//                       "Inbox",
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 20),
//                 // Search bar
//                 TextField(
//                   onChanged: (value) {
//                     setState(() {
//                       searchQuery = value.toLowerCase();
//                     });
//                   },
//                   decoration: InputDecoration(
//                     hintText: "Search chats...",
//                     filled: true,
//                     fillColor: Colors.white,
//                     prefixIcon: const Icon(Icons.search),
//                     contentPadding: const EdgeInsets.symmetric(vertical: 0),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(30),
//                       borderSide: BorderSide.none,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           const SizedBox(height: 10),

//           // ==============================
//           // CHAT LIST
//           // ==============================
//           Expanded(
//             child: StreamBuilder(
//               stream: firestore
//                   .collection("Chats")
//                   .where("participants", arrayContains: currentUid)
//                   .snapshots(),
//               builder: (context, snapshot) {
//                 if (!snapshot.hasData) {
//                   return const Center(child: CircularProgressIndicator());
//                 }

//                 var chats = snapshot.data!.docs;

//                 if (chats.isEmpty) {
//                   return const Center(
//                     child: Text(
//                       "No chats yet",
//                       style: TextStyle(fontSize: 16, color: Colors.grey),
//                     ),
//                   );
//                 }

//                 // Apply search filter
//                 if (searchQuery.isNotEmpty) {
//                   chats = chats
//                       .where(
//                         (chat) => chat["receiverName"]
//                             .toString()
//                             .toLowerCase()
//                             .contains(searchQuery),
//                       )
//                       .toList();
//                 }

//                 return ListView.builder(
//                   padding: const EdgeInsets.symmetric(horizontal: 20),
//                   itemCount: chats.length,
//                   itemBuilder: (context, index) {
//                     var chat = chats[index];
//                     String chatId = chat.id;
//                     String receiverName = chat["receiverName"];
//                     String receiverId = chat["receiverId"];

//                     return StreamBuilder(
//                       stream: firestore
//                           .collection("Chats")
//                           .doc(chatId)
//                           .collection("messages")
//                           .where("participants", arrayContains: currentUid)
//                           .orderBy("timestamp", descending: true)
//                           .snapshots(),
//                       builder: (context, messageSnap) {
//                         String lastMessage = "Say Hi 👋";
//                         String time = "";

//                         if (messageSnap.hasData &&
//                             messageSnap.data!.docs.isNotEmpty) {
//                           var msg = messageSnap.data!.docs.first;

//                           lastMessage = msg["message"] ?? "";

//                           Timestamp? ts = msg["timestamp"];
//                           if (ts != null) {
//                             DateTime dt = ts.toDate();
//                             time =
//                                 "${dt.hour > 12 ? dt.hour - 12 : dt.hour}:${dt.minute.toString().padLeft(2, '0')} ${dt.hour >= 12 ? 'PM' : 'AM'}";
//                           }
//                         }

//                         return GestureDetector(
//                           onTap: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (_) => ChatScreen(
//                                   chatId: chatId,
//                                   senderId: auth.currentUser!.uid,
//                                   senderName: chat["senderName"],
//                                   receiverId: receiverId,
//                                   receiverName: receiverName,
//                                   receiverRole: chat["receiverRole"],
//                                 ),
//                               ),
//                             );
//                           },
//                           child: Container(
//                             margin: const EdgeInsets.symmetric(vertical: 8),
//                             padding: const EdgeInsets.all(15),
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(18),
//                               boxShadow: const [
//                                 BoxShadow(
//                                   color: Colors.black12,
//                                   blurRadius: 6,
//                                   spreadRadius: 1,
//                                   offset: Offset(0, 4),
//                                 ),
//                               ],
//                             ),
//                             child: Row(
//                               children: [
//                                 CircleAvatar(
//                                   radius: 25,
//                                   backgroundColor: Colors.blue,
//                                   child: Text(
//                                     receiverName[0].toUpperCase(),
//                                     style: const TextStyle(
//                                       color: Colors.white,
//                                       fontSize: 20,
//                                     ),
//                                   ),
//                                 ),
//                                 const SizedBox(width: 15),
//                                 Expanded(
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         receiverName,
//                                         style: const TextStyle(
//                                           fontWeight: FontWeight.bold,
//                                           fontSize: 16,
//                                         ),
//                                       ),
//                                       const SizedBox(height: 5),
//                                       Text(
//                                         lastMessage,
//                                         maxLines: 1,
//                                         overflow: TextOverflow.ellipsis,
//                                         style: const TextStyle(
//                                           color: Colors.grey,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 Text(
//                                   time,
//                                   style: const TextStyle(
//                                     color: Colors.grey,
//                                     fontSize: 12,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                     );
//                   },
//                 );
//               },
//             ),
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

class InboxScreen extends StatefulWidget {
  const InboxScreen({super.key});

  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
    
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    final currentUid = auth.currentUser!.uid;

    return Scaffold(
      backgroundColor: Colors.grey[100],

      body: Column(
        children: [
          // ======================
          // TOP BAR + SEARCH BAR
          // ======================
          Container(
            padding: const EdgeInsets.only(
              top: 50,
              left: 20,
              right: 20,
              bottom: 20,
            ),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.accent],
                begin: Alignment.topLeft,
                //                 end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25),
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 20),
                    const Text(
                      "Inbox",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // SEARCH BAR
                TextField(
                  onChanged: (value) {
                    setState(() => searchQuery = value.toLowerCase());
                  },
                  decoration: InputDecoration(
                    hintText: "Search chats...",
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // ======================
          // CHAT LIST
          // ======================
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: firestore.collection("Chats").snapshots(),
              builder: (context, chatSnapshot) {
                if (!chatSnapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                var chatDocs = chatSnapshot.data!.docs;

                // Filter chats that belong to current user
                chatDocs = chatDocs.where((doc) {
                  return doc["senderId"] == currentUid ||
                      doc["receiverId"] == currentUid;
                }).toList();

                if (chatDocs.isEmpty) {
                  return const Center(
                    child: Text(
                      "No chats found",
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                }

                // Apply search filter
                if (searchQuery.isNotEmpty) {
                  chatDocs = chatDocs.where((doc) {
                    String otherName = (currentUid == doc["senderId"])
                        ? doc["receiverName"]
                        : doc["senderName"];
                    return otherName.toLowerCase().contains(searchQuery);
                  }).toList();
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: chatDocs.length,
                  itemBuilder: (context, index) {
                    var chatDoc = chatDocs[index];
                    String chatId = chatDoc.id;

                    // Determine the OTHER person's info
                    String otherName = (currentUid == chatDoc["senderId"])
                        ? chatDoc["receiverName"]
                        : chatDoc["senderName"];

                    String otherId = (currentUid == chatDoc["senderId"])
                        ? chatDoc["receiverId"]
                        : chatDoc["senderId"];

                    return StreamBuilder<QuerySnapshot>(
                      stream: firestore
                          .collection("Chats")
                          .doc(chatId)
                          .collection("messages")
                          .orderBy("timestamp", descending: true)
                          .limit(1)
                          .snapshots(),
                      builder: (context, msgSnap) {
                        String lastMessage = "Say Hi 👋";
                        String time = "";

                        if (msgSnap.hasData && msgSnap.data!.docs.isNotEmpty) {
                          var msg = msgSnap.data!.docs.first;

                          lastMessage = msg["message"] ?? "";

                          Timestamp? ts = msg["timestamp"];
                          if (ts != null) {
                            DateTime dt = ts.toDate();
                            time =
                                "${dt.hour > 12 ? dt.hour - 12 : dt.hour}:${dt.minute.toString().padLeft(2, '0')} ${dt.hour >= 12 ? 'PM' : 'AM'}";
                          }
                        }

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ChatScreen(
                                  chatId: chatId,
                                  senderId: currentUid,
                                  senderName: chatDoc["senderName"],
                                  receiverId: otherId,
                                  receiverName: otherName,
                                  receiverRole: chatDoc["receiverRole"],
                                ),
                              ),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(18),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 6,
                                  spreadRadius: 1,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 25,
                                  backgroundColor: Colors.blue,
                                  child: Text(
                                    otherName[0].toUpperCase(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        otherName,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        lastMessage,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  time,
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
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
    );
  }
}
