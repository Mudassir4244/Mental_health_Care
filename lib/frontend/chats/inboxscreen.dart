// import 'package:flutter/material.dart';
// import 'package:mental_healthcare/frontend/customer_interface/homescreen.dart';
// import 'package:mental_healthcare/frontend/widgets/appcolors.dart';
// import 'package:mental_healthcare/frontend/widgets/widgets.dart';
// // make sure this file is correctly imported

// class InboxScreen extends StatelessWidget {
//   const InboxScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final String title = 'Inbox';
//     final List<Map<String, String>> chats = [
//       {
//         'name': 'Sarah Ahmed',
//         'message': 'Hey, how are you doing today?',
//         'time': '10:45 AM',
//         'avatar': 'assets/images/avatar1.png',
//       },
//       {
//         'name': 'Ali Khan',
//         'message': 'Can you check the new design?',
//         'time': '09:30 AM',
//         'avatar': 'assets/images/avatar2.png',
//       },
//       {
//         'name': 'John Doe',
//         'message': 'See you at the event tomorrow!',
//         'time': 'Yesterday',
//         'avatar': 'assets/images/avatar3.png',
//       },
//     ];

//     return Scaffold(
//       backgroundColor: AppColors.background,
//       appBar: AppBar(
//         leading: GestureDetector(
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (_) => HomeScreen()),
//             );
//           },
//           child: Icon(Icons.arrow_back_ios_new),
//         ),
//         backgroundColor: AppColors.primary,
//         iconTheme: IconThemeData(color: AppColors.cardColor),
//         elevation: 0,
//         title: const Text(
//           'Inbox',
//           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//         ),
//         centerTitle: true,
//       ),
//       drawer: Mydrawer(),
//       body: Stack(
//         children: [
//           SafeArea(
//             child: Padding(
//               padding: const EdgeInsets.all(15),
//               child: Column(
//                 children: [
//                   // 🔍 Search Bar
//                   TextField(
//                     decoration: InputDecoration(
//                       hintText: 'Search messages...',
//                       prefixIcon: const Icon(
//                         Icons.search,
//                         color: AppColors.accent,
//                       ),
//                       filled: true,
//                       fillColor: Colors.white,
//                       contentPadding: const EdgeInsets.symmetric(vertical: 12),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         borderSide: const BorderSide(
//                           color: AppColors.stripedColor,
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 16),

//                   // 🗨️ Chat List
//                   Expanded(
//                     child: ListView.separated(
//                       itemCount: chats.length,
//                       separatorBuilder: (context, index) =>
//                           const SizedBox(height: 10),
//                       itemBuilder: (context, index) {
//                         final chat = chats[index];
//                         return InkWell(
//                           onTap: () {
//                             // 🧭 Navigate to chat detail screen
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (_) =>
//                                     ChatDetailScreen(name: chat['name']!),
//                               ),
//                             );
//                           },
//                           borderRadius: BorderRadius.circular(16),
//                           child: Container(
//                             padding: const EdgeInsets.all(12),
//                             decoration: BoxDecoration(
//                               color: AppColors.cardColor,
//                               borderRadius: BorderRadius.circular(16),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Colors.grey.withOpacity(0.1),
//                                   blurRadius: 8,
//                                   offset: const Offset(0, 3),
//                                 ),
//                               ],
//                             ),
//                             child: Row(
//                               children: [
//                                 // 🖼️ Avatar
//                                 CircleAvatar(
//                                   radius: 28,
//                                   backgroundImage: AssetImage(chat['avatar']!),
//                                 ),
//                                 const SizedBox(width: 12),

//                                 // 📝 Chat Info
//                                 Expanded(
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         chat['name']!,
//                                         style: const TextStyle(
//                                           fontSize: 16,
//                                           fontWeight: FontWeight.bold,
//                                           color: AppColors.textColorPrimary,
//                                         ),
//                                       ),
//                                       const SizedBox(height: 4),
//                                       Text(
//                                         chat['message']!,
//                                         overflow: TextOverflow.ellipsis,
//                                         style: const TextStyle(
//                                           color: AppColors.textColorSecondary,
//                                           fontSize: 14,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),

//                                 // 🕒 Time
//                                 Text(
//                                   chat['time']!,
//                                   style: const TextStyle(
//                                     color: AppColors.textColorSecondary,
//                                     fontSize: 12,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           Align(
//             alignment: Alignment.bottomCenter,
//             child: BottomNavBar(currentScreen: title),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // 📱 Dummy Chat Detail Screen
// class ChatDetailScreen extends StatelessWidget {
//   final String name;
//   const ChatDetailScreen({super.key, required this.name});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text(name), backgroundColor: AppColors.primary),
//       body: const Center(
//         child: Text(
//           'Chat Details Coming Soon...',
//           style: TextStyle(fontSize: 18, color: AppColors.textColorPrimary),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:mental_healthcare/frontend/chats/chatscreen.dart';

class InboxScreen extends StatefulWidget {
  final String currentUserId;
  final String currentUsername;
  final String currentUserRole;
  final Map<String, dynamic> clientData;
  const InboxScreen({
    super.key,
    required this.currentUserId,
    required this.currentUsername,
    required this.currentUserRole,
    required this.clientData,
  });

  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  final DatabaseReference _chatsRef = FirebaseDatabase.instance.ref('Chats');
  List<ChatPreview> _chatPreviews = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadChats();
  }

  Future<void> _loadChats() async {
    setState(() => _isLoading = true);

    _chatsRef.onValue.listen((event) async {
      if (event.snapshot.value == null) {
        setState(() {
          _chatPreviews = [];
          _isLoading = false;
        });
        return;
      }

      final chatsData = event.snapshot.value as Map<dynamic, dynamic>;
      List<ChatPreview> previews = [];

      for (var chatEntry in chatsData.entries) {
        final chatId = chatEntry.key as String;

        // Check if current user is part of chat
        if (!chatId.contains(widget.currentUserId)) continue;

        final messagesMap = chatEntry.value as Map<dynamic, dynamic>;

        if (messagesMap.isEmpty) continue;

        final messagesList = messagesMap.entries.toList();

        // Sort by timestamp DESC (latest first)
        messagesList.sort((a, b) {
          final aTime = a.value['timestamp'] ?? 0;
          final bTime = b.value['timestamp'] ?? 0;
          return bTime.compareTo(aTime);
        });

        final lastMessage = messagesList.first.value;

        String otherUserId = lastMessage['senderId'] == widget.currentUserId
            ? lastMessage['receiverId']
            : lastMessage['senderId'];

        String otherUserName = lastMessage['senderId'] == widget.currentUserId
            ? lastMessage['receiverName']
            : lastMessage['senderName'];

        String otherUserRole = lastMessage['senderId'] == widget.currentUserId
            ? lastMessage['receiverRole']
            : lastMessage['senderRole'];

        previews.add(
          ChatPreview(
            chatId: chatId,
            otherUserId: otherUserId,
            otherUserName: otherUserName,
            otherUserRole: otherUserRole,
            lastMessage: lastMessage['text'] ?? '',
            timestamp: lastMessage['timestamp'] ?? 0,
            isRead: lastMessage['senderId'] == widget.currentUserId,
          ),
        );
      }

      // Sort all conversations by timestamp
      previews.sort((a, b) => b.timestamp.compareTo(a.timestamp));

      setState(() {
        _chatPreviews = previews;
        _isLoading = false;
      });
    });
  }

  String _formatTimestamp(int timestamp) {
    if (timestamp == 0) return "";

    final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays == 0) return DateFormat('HH:mm').format(date);
    if (diff.inDays == 1) return "Yesterday";
    if (diff.inDays < 7) return DateFormat('EEEE').format(date);

    return DateFormat('dd/MM/yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: Colors.white),
        title: const Text('Messages'),
        backgroundColor: Colors.deepPurple,
      ),

      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _chatPreviews.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.chat_bubble_outline,
                    size: 80,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "No messages yet",
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: () async => _loadChats(),
              child: ListView.separated(
                itemCount: _chatPreviews.length,
                separatorBuilder: (_, __) => Divider(indent: 72, height: 1),
                itemBuilder: (context, index) {
                  final chat = _chatPreviews[index];

                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChatScreen(
                            recievername: widget.currentUsername,
                            currentUserRole: widget.currentUserRole,
                            peerUserId: chat.otherUserId,
                            peerUsername: chat.otherUserName,
                            clientData: {},
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      color: chat.isRead
                          ? Colors.white
                          : Colors.deepPurple.shade50,
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 26,
                            backgroundColor: Colors.deepPurple,
                            child: Text(
                              chat.otherUserName[0].toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        chat.otherUserName,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: chat.isRead
                                              ? FontWeight.w500
                                              : FontWeight.bold,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Text(
                                      _formatTimestamp(chat.timestamp),
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),

                                Text(
                                  chat.otherUserRole,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade500,
                                  ),
                                ),

                                const SizedBox(height: 4),

                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        chat.lastMessage,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: Colors.black87,
                                          fontWeight: chat.isRead
                                              ? FontWeight.normal
                                              : FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    if (!chat.isRead)
                                      Container(
                                        width: 10,
                                        height: 10,
                                        decoration: const BoxDecoration(
                                          color: Colors.deepPurple,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}

class ChatPreview {
  final String chatId;
  final String otherUserId;
  final String otherUserName;
  final String otherUserRole;
  final String lastMessage;
  final int timestamp;
  final bool isRead;

  ChatPreview({
    required this.chatId,
    required this.otherUserId,
    required this.otherUserName,
    required this.otherUserRole,
    required this.lastMessage,
    required this.timestamp,
    required this.isRead,
  });
}
