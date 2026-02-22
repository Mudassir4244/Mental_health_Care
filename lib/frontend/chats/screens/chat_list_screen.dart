// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:mental_healthcare/frontend/chats/screens/chat_screen.dart';
// import 'package:mental_healthcare/frontend/widgets/appcolors.dart';
// import 'package:mental_healthcare/frontend/widgets/widgets.dart';
// import 'package:mental_healthcare/frontend/practioner_interface/widgets/pract_custom_wdgets.dart';

// class InboxScreen extends StatefulWidget {
//   final bool isPractitioner;
//   const InboxScreen({super.key, this.isPractitioner = false});

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
//       backgroundColor: AppColors.background,
//       drawer: widget.isPractitioner ? const prac_drawer() : const Mydrawer(),
//       bottomNavigationBar: widget.isPractitioner
//           ? prac_bottomNavbbar(
//               currentScreen: 'Inbox',
//               clientData: const {},
//             )
//           : BottomNavBar(currentScreen: 'Inbox'),
//       body: Stack(
//         children: [
//           Column(
//             children: [
//               // ======================
//               // TOP BAR + SEARCH BAR
//               // ======================
//               Container(
//                 padding: const EdgeInsets.only(
//                   top: 50,
//                   left: 20,
//                   right: 20,
//                   bottom: 20,
//                 ),
//                 decoration: const BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [AppColors.primary, AppColors.accent],
//                     begin: Alignment.topLeft,
//                   ),
//                   borderRadius: BorderRadius.only(
//                     bottomLeft: Radius.circular(25),
//                     bottomRight: Radius.circular(25),
//                   ),
//                 ),
//                 child: Column(
//                   children: [
//                     Row(
//                       children: [
//                         Builder(
//                           builder: (context) => IconButton(
//                             onPressed: () => Scaffold.of(context).openDrawer(),
//                             icon: const Icon(Icons.menu, color: Colors.white),
//                           ),
//                         ),
//                         const SizedBox(width: 5),
//                         const Text(
//                           "Inbox",
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 24,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 20),

//                     // SEARCH BAR
//                     TextField(
//                       onChanged: (value) {
//                         setState(() => searchQuery = value.toLowerCase());
//                       },
//                       decoration: InputDecoration(
//                         hintText: "Search chats...",
//                         filled: true,
//                         fillColor: Colors.white,
//                         prefixIcon: const Icon(Icons.search),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(30),
//                           borderSide: BorderSide.none,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               const SizedBox(height: 10),

//               // ======================
//               // CHAT LIST
//               // ======================
//               Expanded(
//                 child: StreamBuilder<QuerySnapshot>(
//                   stream: firestore.collection("Chats").snapshots(),
//                   builder: (context, chatSnapshot) {
//                     if (!chatSnapshot.hasData) {
//                       return const Center(child: CircularProgressIndicator());
//                     }

//                     var chatDocs = chatSnapshot.data!.docs;

//                     // Filter chats (Client-side to support legacy data)
//                     chatDocs = chatDocs.where((doc) {
//                       final data = doc.data() as Map<String, dynamic>;
//                       // 1. Check participants array if exists
//                       if (data.containsKey('participants') &&
//                           data['participants'] is List) {
//                         final participants = List.from(data['participants']);
//                         if (participants.contains(currentUid)) return true;
//                       }
//                       // 2. Fallback to senderId/receiverId check
//                       return data['senderId'] == currentUid ||
//                           data['receiverId'] == currentUid;
//                     }).toList();

//                     // Sort by timestamp (newest first)
//                     chatDocs.sort((a, b) {
//                       final dataA = a.data() as Map<String, dynamic>;
//                       final dataB = b.data() as Map<String, dynamic>;

//                       Timestamp? tA = dataA['timestamp'];
//                       Timestamp? tB = dataB['timestamp'];

//                       if (tA == null && tB == null) return 0;
//                       if (tA == null) return 1; // Put nulls at the bottom
//                       if (tB == null) return -1;

//                       return tB.compareTo(tA); // Descending
//                     });

//                     if (chatDocs.isEmpty) {
//                       return const Center(
//                         child: Text(
//                           "No chats found",
//                           style: TextStyle(color: Colors.grey),
//                         ),
//                       );
//                     }

//                     // Apply search filter (Basic name check)
//                     // Note: If names are unknown, they might not match search until resolved
//                     if (searchQuery.isNotEmpty) {
//                       chatDocs = chatDocs.where((doc) {
//                         final data = doc.data() as Map<String, dynamic>;
//                         String sId = data['senderId'] ?? '';
//                         String rName = data['receiverName'] ?? '';
//                         String sName = data['senderName'] ?? '';

//                         String otherName = (currentUid == sId) ? rName : sName;
//                         return otherName.toLowerCase().contains(searchQuery);
//                       }).toList();
//                     }

//                     return ListView.builder(
//                       padding: const EdgeInsets.fromLTRB(
//                         20,
//                         0,
//                         20,
//                         100,
//                       ), // Added bottom padding for navbar
//                       itemCount: chatDocs.length,
//                       itemBuilder: (context, index) {
//                         return ChatListItem(
//                           chatDoc: chatDocs[index],
//                           currentUid: currentUid,
//                         );
//                       },
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// class ChatListItem extends StatefulWidget {
//   final DocumentSnapshot chatDoc;
//   final String currentUid;

//   const ChatListItem({
//     super.key,
//     required this.chatDoc,
//     required this.currentUid,
//   });

//   @override
//   State<ChatListItem> createState() => _ChatListItemState();
// }

// class _ChatListItemState extends State<ChatListItem> {
//   late String myName;
//   late String otherName;
//   late String otherId;
//   bool isLoadingName = false;

//   @override
//   void initState() {
//     super.initState();
//     _initializeNames();
//   }

//   @override
//   void didUpdateWidget(ChatListItem oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (oldWidget.chatDoc != widget.chatDoc) {
//       _initializeNames();
//     }
//   }

//   void _initializeNames() {
//     final chatData = widget.chatDoc.data() as Map<String, dynamic>;
//     String senderId = chatData['senderId'] ?? '';
//     String senderName = chatData['senderName'] ?? 'Unknown';
//     String receiverId = chatData['receiverId'] ?? '';
//     String receiverName = chatData['receiverName'] ?? 'Unknown';

//     if (widget.currentUid == senderId) {
//       myName = senderName;
//       otherName = receiverName;
//       otherId = receiverId;
//     } else {
//       myName = receiverName;
//       otherName = senderName;
//       otherId = senderId;
//     }

//     // Fallback: If otherId is empty, try to find it in participants
//     if (otherId.isEmpty && chatData.containsKey('participants')) {
//       final participants = List.from(chatData['participants'] ?? []);
//       for (var p in participants) {
//         if (p != widget.currentUid) {
//           otherId = p.toString();
//           break;
//         }
//       }
//     }

//     // If name is unknown/missing, fetch it
//     if ((otherName == 'Unknown' || otherName.isEmpty) && otherId.isNotEmpty) {
//       _fetchOtherUserName();
//     }
//   }

//   Future<void> _fetchOtherUserName() async {
//     if (isLoadingName) return;
//     setState(() => isLoadingName = true);

//     try {
//       DocumentSnapshot userDoc = await FirebaseFirestore.instance
//           .collection('Users')
//           .doc(otherId)
//           .get();

//       if (userDoc.exists) {
//         final userData = userDoc.data() as Map<String, dynamic>;
//         // Check various name fields
//         String fetchedName =
//             userData['username'] ??
//             userData['Fullname'] ??
//             userData['Organization name'] ??
//             'Unknown User';

//         if (mounted) {
//           setState(() {
//             otherName = fetchedName;
//             isLoadingName = false;
//           });

//           // Update the chat document safely
//           final chatData = widget.chatDoc.data() as Map<String, dynamic>;
//           final sId = chatData['senderId'];

//           if (sId != null && widget.currentUid == sId) {
//             // I am sender, so update receiverName
//             widget.chatDoc.reference.update({'receiverName': fetchedName});
//           } else {
//             // I am receiver (or senderId is missing), so update senderName
//             widget.chatDoc.reference.update({'senderName': fetchedName});
//           }
//         }
//       } else {
//         if (mounted) setState(() => isLoadingName = false);
//       }
//     } catch (e) {
//       print("Error fetching user name: $e");
//       if (mounted) setState(() => isLoadingName = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final chatData = widget.chatDoc.data() as Map<String, dynamic>;

//     return StreamBuilder<QuerySnapshot>(
//       stream: FirebaseFirestore.instance
//           .collection("Chats")
//           .doc(widget.chatDoc.id)
//           .collection("messages")
//           .orderBy("timestamp", descending: true)
//           .limit(1)
//           .snapshots(),
//       builder: (context, msgSnap) {
//         String lastMessage = "Say Hi 👋";
//         String time = "";

//         if (msgSnap.hasData && msgSnap.data!.docs.isNotEmpty) {
//           var msg = msgSnap.data!.docs.first;
//           lastMessage = msg["message"] ?? "";

//           Timestamp? ts = msg["timestamp"];
//           if (ts != null) {
//             DateTime dt = ts.toDate();
//             time =
//                 "${dt.hour > 12 ? dt.hour - 12 : dt.hour}:${dt.minute.toString().padLeft(2, '0')} ${dt.hour >= 12 ? 'PM' : 'AM'}";
//           }
//         }

//         return GestureDetector(
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (_) => ChatScreen(
//                   chatId: widget.chatDoc.id,
//                   senderId: widget.currentUid,
//                   senderName: myName,
//                   receiverId: otherId,
//                   receiverName: otherName,
//                   receiverRole: chatData['receiverRole'] ?? 'Client',
//                 ),
//               ),
//             );
//           },
//           child: Container(
//             margin: const EdgeInsets.symmetric(vertical: 8),
//             padding: const EdgeInsets.all(15),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(18),
//               boxShadow: const [
//                 BoxShadow(
//                   color: Colors.black12,
//                   blurRadius: 6,
//                   spreadRadius: 1,
//                   offset: Offset(0, 4),
//                 ),
//               ],
//             ),
//             child: Row(
//               children: [
//                 CircleAvatar(
//                   radius: 25,
//                   backgroundColor: Colors.blue,
//                   child: Text(
//                     otherName.isNotEmpty ? otherName[0].toUpperCase() : '?',
//                     style: const TextStyle(color: Colors.white, fontSize: 20),
//                   ),
//                 ),
//                 const SizedBox(width: 15),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         otherName,
//                         style: const TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16,
//                         ),
//                       ),
//                       const SizedBox(height: 5),
//                       Text(
//                         lastMessage,
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                         style: const TextStyle(color: Colors.grey),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Text(
//                   time,
//                   style: const TextStyle(color: Colors.grey, fontSize: 12),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mental_healthcare/frontend/chats/screens/chat_screen.dart';
import 'package:mental_healthcare/frontend/widgets/appcolors.dart';
import 'package:mental_healthcare/frontend/widgets/widgets.dart';
import 'package:mental_healthcare/frontend/practioner_interface/widgets/pract_custom_wdgets.dart';

class InboxScreen extends StatefulWidget {
  final bool isPractitioner;
  const InboxScreen({super.key, this.isPractitioner = false});

  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  String searchQuery = "";
  bool isSelectionMode = false;
  Set<String> selectedChats = {};

  void _toggleSelectionMode() {
    setState(() {
      isSelectionMode = !isSelectionMode;
      if (!isSelectionMode) {
        selectedChats.clear();
      }
    });
  }

  void _toggleChatSelection(String chatId) {
    setState(() {
      if (selectedChats.contains(chatId)) {
        selectedChats.remove(chatId);
      } else {
        selectedChats.add(chatId);
      }
    });
  }

  Future<void> _deleteSelectedChats() async {
    if (selectedChats.isEmpty) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Chats'),
        content: Text(
          'Are you sure you want to delete ${selectedChats.length} chat(s)?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        for (String chatId in selectedChats) {
          await firestore.collection('Chats').doc(chatId).delete();
        }
        setState(() {
          selectedChats.clear();
          isSelectionMode = false;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Chats deleted successfully')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error deleting chats: $e')));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUid = auth.currentUser!.uid;

    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: widget.isPractitioner ? const prac_drawer() : const Mydrawer(),
      bottomNavigationBar: widget.isPractitioner
          ? prac_bottomNavbbar(currentScreen: 'Inbox', clientData: const {})
          : BottomNavBar(currentScreen: 'Inbox'),
      body: Stack(
        children: [
          Column(
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
                        if (!isSelectionMode)
                          Builder(
                            builder: (context) => IconButton(
                              onPressed: () =>
                                  Scaffold.of(context).openDrawer(),
                              icon: const Icon(Icons.menu, color: Colors.white),
                            ),
                          )
                        else
                          IconButton(
                            onPressed: _toggleSelectionMode,
                            icon: const Icon(Icons.close, color: Colors.white),
                          ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            isSelectionMode
                                ? "${selectedChats.length} Selected"
                                : "Inbox",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (isSelectionMode)
                          IconButton(
                            onPressed: _deleteSelectedChats,
                            icon: const Icon(Icons.delete, color: Colors.white),
                          ),
                      ],
                    ),
                    if (!isSelectionMode) ...[
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

                    // Filter chats (Client-side to support legacy data)
                    chatDocs = chatDocs.where((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      // 1. Check participants array if exists
                      if (data.containsKey('participants') &&
                          data['participants'] is List) {
                        final participants = List.from(data['participants']);
                        if (participants.contains(currentUid)) return true;
                      }
                      // 2. Fallback to senderId/receiverId check
                      return data['senderId'] == currentUid ||
                          data['receiverId'] == currentUid;
                    }).toList();

                    // Sort by timestamp (newest first)
                    chatDocs.sort((a, b) {
                      final dataA = a.data() as Map<String, dynamic>;
                      final dataB = b.data() as Map<String, dynamic>;

                      Timestamp? tA = dataA['timestamp'];
                      Timestamp? tB = dataB['timestamp'];

                      if (tA == null && tB == null) return 0;
                      if (tA == null) return 1;
                      if (tB == null) return -1;

                      return tB.compareTo(tA);
                    });

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
                        final data = doc.data() as Map<String, dynamic>;
                        String sId = data['senderId'] ?? '';
                        String rName = data['receiverName'] ?? '';
                        String sName = data['senderName'] ?? '';

                        String otherName = (currentUid == sId) ? rName : sName;
                        return otherName.toLowerCase().contains(searchQuery);
                      }).toList();
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                      itemCount: chatDocs.length,
                      itemBuilder: (context, index) {
                        return ChatListItem(
                          chatDoc: chatDocs[index],
                          currentUid: currentUid,
                          isSelectionMode: isSelectionMode,
                          isSelected: selectedChats.contains(
                            chatDocs[index].id,
                          ),
                          onLongPress: () {
                            if (!isSelectionMode) {
                              _toggleSelectionMode();
                              _toggleChatSelection(chatDocs[index].id);
                            }
                          },
                          onTapInSelectionMode: () {
                            if (isSelectionMode) {
                              _toggleChatSelection(chatDocs[index].id);
                            }
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ChatListItem extends StatefulWidget {
  final DocumentSnapshot chatDoc;
  final String currentUid;
  final bool isSelectionMode;
  final bool isSelected;
  final VoidCallback onLongPress;
  final VoidCallback onTapInSelectionMode;

  const ChatListItem({
    super.key,
    required this.chatDoc,
    required this.currentUid,
    this.isSelectionMode = false,
    this.isSelected = false,
    VoidCallback? onLongPress,
    VoidCallback? onTapInSelectionMode,
  }) : onLongPress = onLongPress ?? _defaultCallback,
       onTapInSelectionMode = onTapInSelectionMode ?? _defaultCallback;

  static void _defaultCallback() {}

  @override
  State<ChatListItem> createState() => _ChatListItemState();
}

class _ChatListItemState extends State<ChatListItem> {
  late String myName;
  late String otherName;
  late String otherId;
  bool isLoadingName = false;

  @override
  void initState() {
    super.initState();
    _initializeNames();
  }

  @override
  void didUpdateWidget(ChatListItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.chatDoc != widget.chatDoc) {
      _initializeNames();
    }
  }

  void _initializeNames() {
    final chatData = widget.chatDoc.data() as Map<String, dynamic>;
    String senderId = chatData['senderId'] ?? '';
    String senderName = chatData['senderName'] ?? 'Unknown';
    String receiverId = chatData['receiverId'] ?? '';
    String receiverName = chatData['receiverName'] ?? 'Unknown';

    if (widget.currentUid == senderId) {
      myName = senderName;
      otherName = receiverName;
      otherId = receiverId;
    } else {
      myName = receiverName;
      otherName = senderName;
      otherId = senderId;
    }

    if (otherId.isEmpty && chatData.containsKey('participants')) {
      final participants = List.from(chatData['participants'] ?? []);
      for (var p in participants) {
        if (p != widget.currentUid) {
          otherId = p.toString();
          break;
        }
      }
    }

    if ((otherName == 'Unknown' || otherName.isEmpty) && otherId.isNotEmpty) {
      _fetchOtherUserName();
    }
  }

  Future<void> _fetchOtherUserName() async {
    if (isLoadingName) return;
    setState(() => isLoadingName = true);

    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(otherId)
          .get();

      if (userDoc.exists) {
        final userData = userDoc.data() as Map<String, dynamic>;
        String fetchedName =
            userData['username'] ??
            userData['Fullname'] ??
            userData['Organization name'] ??
            'Unknown User';

        if (mounted) {
          setState(() {
            otherName = fetchedName;
            isLoadingName = false;
          });

          final chatData = widget.chatDoc.data() as Map<String, dynamic>;
          final sId = chatData['senderId'];

          if (sId != null && widget.currentUid == sId) {
            widget.chatDoc.reference.update({'receiverName': fetchedName});
          } else {
            widget.chatDoc.reference.update({'senderName': fetchedName});
          }
        }
      } else {
        if (mounted) setState(() => isLoadingName = false);
      }
    } catch (e) {
      print("Error fetching user name: $e");
      if (mounted) setState(() => isLoadingName = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatData = widget.chatDoc.data() as Map<String, dynamic>;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("Chats")
          .doc(widget.chatDoc.id)
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
          onLongPress: widget.onLongPress,
          onTap: () {
            if (widget.isSelectionMode) {
              widget.onTapInSelectionMode();
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChatScreen(
                    chatId: widget.chatDoc.id,
                    senderId: widget.currentUid,
                    senderName: myName,
                    receiverId: otherId,
                    receiverName: otherName,
                    receiverRole: chatData['receiverRole'] ?? 'Client',
                    recieverimageurl: chatData['receiverImageUrl'] ?? "",
                  ),
                ),
              );
            }
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: widget.isSelected ? Colors.blue.shade50 : Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: widget.isSelected
                  ? Border.all(color: Colors.blue, width: 2)
                  : null,
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
                if (widget.isSelectionMode)
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Icon(
                      widget.isSelected
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      color: widget.isSelected ? Colors.blue : Colors.grey,
                    ),
                  ),
                CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.blue,
                  child: Text(
                    otherName.isNotEmpty ? otherName[0].toUpperCase() : '?',
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                Text(
                  time,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
