// import 'dart:async';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/services.dart';
// import 'package:intl/intl.dart';
// import 'package:mental_healthcare/frontend/practioner_interface/prac_homescreen.dart';
// import 'package:mental_healthcare/frontend/widgets/appcolors.dart';
// import 'package:provider/provider.dart';

// class ChatScreen extends StatefulWidget {
//   final String currentUserId = FirebaseAuth.instance.currentUser!.uid;
//   final String recievername;
//   final String currentUserRole;
//   final String peerUserId;
//   final String peerUsername;
//   final Map<String, dynamic> clientData;

//   ChatScreen({
//     super.key,
//     required this.recievername,
//     required this.currentUserRole,
//     required this.peerUserId,
//     required this.peerUsername,
//     required this.clientData,
//   });

//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   late final DatabaseReference _messagesRef;

//   final TextEditingController _controller = TextEditingController();
//   final ScrollController _scrollController = ScrollController();

//   // compute deterministic chat id
//   String get chatId {
//     if (widget.currentUserId.compareTo(widget.peerUserId) <= 0) {
//       return '${widget.currentUserId}_${widget.peerUserId}';
//     } else {
//       return '${widget.peerUserId}_${widget.currentUserId}';
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     _messagesRef = FirebaseDatabase.instance.ref('chats/$chatId/messages');
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     _scrollController.dispose();
//     super.dispose();
//   }

//   Future<void> _sendMessage() async {
//     final text = _controller.text.trim();
//     if (text.isEmpty) return;

//     try {
//       final newRef = _messagesRef.push();
//       await newRef.set({
//         'id': newRef.key,
//         'senderId': widget.currentUserId,
//         'revievername': widget.recievername,
//         'text': text,
//         'timestamp': ServerValue.timestamp,
//         'deleted': false,
//       });

//       _controller.clear();

//       // scroll after delay
//       Future.delayed(const Duration(milliseconds: 80), () {
//         if (_scrollController.hasClients) {
//           _scrollController.animateTo(
//             _scrollController.position.maxScrollExtent + 80,
//             duration: const Duration(milliseconds: 250),
//             curve: Curves.easeOut,
//           );
//         }
//       });
//     } catch (_) {}
//   }

//   Future<void> _deleteMessage(String messageId, String senderId) async {
//     if (senderId != widget.currentUserId) return;

//     final msgRef = _messagesRef.child(messageId);
//     await msgRef.update({
//       'deleted': true,
//       'text': 'This message was deleted',
//       'deletedBy': widget.currentUserId,
//     });
//   }

//   String _formatTimestamp(dynamic ts) {
//     try {
//       int millis;
//       if (ts == null) return '';
//       if (ts is int) {
//         millis = ts;
//       } else if (ts is double) {
//         millis = ts.toInt();
//       } else if (ts is String) {
//         millis = int.tryParse(ts) ?? 0;
//       } else {
//         return '';
//       }

//       final dt = DateTime.fromMillisecondsSinceEpoch(millis);
//       final now = DateTime.now();

//       if (dt.year == now.year && dt.month == now.month && dt.day == now.day) {
//         return DateFormat.jm().format(dt);
//       } else {
//         return DateFormat('dd MMM, hh:mm a').format(dt);
//       }
//     } catch (_) {
//       return '';
//     }
//   }

//   Widget _buildMessageBubble(Map message) {
//     final isMe = message['senderId'] == widget.currentUserId;
//     final text = message['text'] ?? '';
//     final deleted = message['deleted'] == true;
//     final time = _formatTimestamp(message['timestamp']);

//     final borderRadiusMe = const BorderRadius.only(
//       topLeft: Radius.circular(14),
//       topRight: Radius.circular(6),
//       bottomLeft: Radius.circular(14),
//       bottomRight: Radius.circular(14),
//     );

//     final borderRadiusOther = const BorderRadius.only(
//       topLeft: Radius.circular(6),
//       topRight: Radius.circular(14),
//       bottomLeft: Radius.circular(14),
//       bottomRight: Radius.circular(14),
//     );

//     return Align(
//       alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
//       child: ConstrainedBox(
//         constraints: BoxConstraints(
//           maxWidth: MediaQuery.of(context).size.width * 0.78,
//         ),
//         child: GestureDetector(
//           onLongPress: () async {
//             if (isMe) {
//               final shouldDelete = await showDialog<bool>(
//                 context: context,
//                 builder: (ctx) => AlertDialog(
//                   title: const Text('Delete message'),
//                   content: const Text('Delete this message for everyone?'),
//                   actions: [
//                     TextButton(
//                       onPressed: () => Navigator.pop(ctx, false),
//                       child: const Text('Cancel'),
//                     ),
//                     TextButton(
//                       onPressed: () => Navigator.pop(ctx, true),
//                       child: const Text(
//                         'Delete',
//                         style: TextStyle(color: Colors.red),
//                       ),
//                     ),
//                   ],
//                 ),
//               );

//               if (shouldDelete == true) {
//                 await _deleteMessage(message['id'], message['senderId']);
//               }
//             } else {
//               await showModalBottomSheet<bool>(
//                 context: context,
//                 builder: (ctx) => SafeArea(
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       ListTile(
//                         leading: const Icon(Icons.copy),
//                         title: const Text('Copy'),
//                         onTap: () {
//                           Clipboard.setData(ClipboardData(text: text));
//                           Navigator.pop(ctx, true);
//                         },
//                       ),
//                       ListTile(
//                         leading: const Icon(Icons.cancel),
//                         title: const Text('Cancel'),
//                         onTap: () => Navigator.pop(ctx, false),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             }
//           },
//           child: AnimatedContainer(
//             duration: const Duration(milliseconds: 200),
//             margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
//             padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
//             decoration: BoxDecoration(
//               color: isMe ? AppColors.primary.withOpacity(0.95) : Colors.white,
//               borderRadius: isMe ? borderRadiusMe : borderRadiusOther,
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.04),
//                   blurRadius: 6,
//                   offset: const Offset(0, 3),
//                 ),
//               ],
//             ),
//             child: Column(
//               crossAxisAlignment: isMe
//                   ? CrossAxisAlignment.end
//                   : CrossAxisAlignment.start,
//               children: [
//                 if (!isMe)
//                   Padding(
//                     padding: const EdgeInsets.only(bottom: 6.0),
//                     child: Text(
//                       message['senderName'] ?? '',
//                       style: const TextStyle(
//                         fontSize: 12,
//                         fontWeight: FontWeight.w700,
//                         color: AppColors.textColorSecondary,
//                       ),
//                     ),
//                   ),
//                 SelectableText(
//                   text,
//                   style: TextStyle(
//                     color: isMe ? Colors.white : AppColors.textColorPrimary,
//                     fontWeight: deleted ? FontWeight.w400 : FontWeight.w600,
//                     fontStyle: deleted ? FontStyle.italic : FontStyle.normal,
//                   ),
//                 ),
//                 const SizedBox(height: 6),
//                 Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Text(
//                       time,
//                       style: TextStyle(
//                         fontSize: 11,
//                         color: isMe
//                             ? Colors.white70
//                             : AppColors.textColorSecondary,
//                       ),
//                     ),
//                     const SizedBox(width: 8),
//                     if (isMe)
//                       Icon(
//                         deleted ? Icons.delete_outline : Icons.check,
//                         size: 14,
//                         color: isMe
//                             ? Colors.white70
//                             : AppColors.textColorSecondary,
//                       ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   List<Map> _parseMessages(DatabaseEvent event) {
//     final snapshot = event.snapshot;
//     if (!snapshot.exists || snapshot.value == null) return [];

//     final raw = snapshot.value;
//     final List<Map> messages = [];

//     if (raw is Map) {
//       raw.forEach((key, value) {
//         if (value is Map) {
//           final Map<String, dynamic> m = Map<String, dynamic>.from(value);
//           messages.add(m);
//         }
//       });

//       messages.sort((a, b) {
//         final ta = a['timestamp'] ?? 0;
//         final tb = b['timestamp'] ?? 0;
//         final ai = (ta is int) ? ta : int.tryParse(ta.toString()) ?? 0;
//         final bi = (tb is int) ? tb : int.tryParse(tb.toString()) ?? 0;
//         return ai.compareTo(bi);
//       });
//     }

//     return messages;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final clients = Provider.of<PremiumClientProvider>(context).premiumClients;

//     return Scaffold(
//       backgroundColor: AppColors.background,
//       appBar: AppBar(
//         leading: IconButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           icon: Icon(
//             Icons.arrow_back_ios,
//             color: AppColors.background,
//             fontWeight: FontWeight.bold,
//             size: 25,
//           ),
//         ),
//         backgroundColor: AppColors.primary,
//         elevation: 2,
//         centerTitle: true,
//         title: Row(
//           children: [
//             CircleAvatar(
//               backgroundColor: Colors.white,
//               child: Icon(Icons.person),
//             ),
//             const SizedBox(width: 12),
//             Text(
//               widget.recievername,
//               style: const TextStyle(
//                 fontSize: 18,
//                 color: Colors.white,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const Spacer(),
//             IconButton(
//               onPressed: () {},
//               icon: const Icon(Icons.info_outline),
//               color: Colors.white,
//             ),
//           ],
//         ),
//       ),

//       body: Column(
//         children: [
//           Expanded(
//             child: StreamBuilder<DatabaseEvent>(
//               stream: _messagesRef.orderByChild('timestamp').onValue,
//               builder: (context, snapshot) {
//                 if (!snapshot.hasData) {
//                   return const Center(child: CircularProgressIndicator());
//                 }

//                 final messages = _parseMessages(snapshot.data!);

//                 if (messages.isEmpty) {
//                   return const Center(child: Text('No messages yet'));
//                 }

//                 return ListView.builder(
//                   controller: _scrollController,
//                   padding: const EdgeInsets.symmetric(
//                     vertical: 12,
//                     horizontal: 8,
//                   ),
//                   itemCount: messages.length,
//                   itemBuilder: (context, index) {
//                     return _buildMessageBubble(messages[index]);
//                   },
//                 );
//               },
//             ),
//           ),

//           SafeArea(
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 12),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(30),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black.withOpacity(0.03),
//                             blurRadius: 10,
//                             offset: const Offset(0, 3),
//                           ),
//                         ],
//                       ),
//                       child: Row(
//                         children: [
//                           IconButton(
//                             onPressed: () {},
//                             icon: const Icon(Icons.add),
//                             color: AppColors.accent,
//                           ),
//                           Expanded(
//                             child: TextField(
//                               controller: _controller,
//                               decoration: const InputDecoration(
//                                 hintText: 'Type a message',
//                                 border: InputBorder.none,
//                               ),
//                               onSubmitted: (_) => _sendMessage(),
//                             ),
//                           ),
//                           IconButton(
//                             onPressed: () {},
//                             icon: const Icon(Icons.emoji_emotions_outlined),
//                             color: AppColors.accent,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 10),

//                   /// ⭐ FINAL: No Loader — Just Normal Send Icon
//                   Container(
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: AppColors.primary,
//                       boxShadow: [
//                         BoxShadow(
//                           color: AppColors.primary.withOpacity(0.3),
//                           blurRadius: 8,
//                           offset: const Offset(0, 3),
//                         ),
//                       ],
//                     ),
//                     child: IconButton(
//                       onPressed: _sendMessage,
//                       icon: const Icon(Icons.send, color: Colors.white),
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
// }
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mental_healthcare/frontend/widgets/appcolors.dart';

class ChatScreen extends StatefulWidget {
  final String currentUserId = FirebaseAuth.instance.currentUser!.uid;
  final String recievername;
  final String currentUserRole;
  final String peerUserId;
  final String peerUsername;
  final Map<String, dynamic> clientData;

  ChatScreen({
    super.key,
    required this.recievername,
    required this.currentUserRole,
    required this.peerUserId,
    required this.peerUsername,
    required this.clientData,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late final DatabaseReference _messagesRef;

  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // compute deterministic chat id
  String get chatId {
    if (widget.currentUserId.compareTo(widget.peerUserId) <= 0) {
      return '${widget.currentUserId}_${widget.peerUserId}';
    } else {
      return '${widget.peerUserId}_${widget.currentUserId}';
    }
  }

  @override
  void initState() {
    super.initState();
    _messagesRef = FirebaseDatabase.instance.ref('chats/$chatId/messages');
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    try {
      final newRef = _messagesRef.push();
      await newRef.set({
        'id': newRef.key,
        'senderId': widget.currentUserId,
        'receiverId': widget.peerUserId, // store receiver id
        'revievername': widget.recievername,
        'text': text,
        'timestamp': ServerValue.timestamp,
        'deleted': false,
      });

      _controller.clear();

      // scroll after delay
      Future.delayed(const Duration(milliseconds: 80), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent + 80,
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
          );
        }
      });
    } catch (_) {}
  }

  Future<void> _deleteMessage(String messageId, String senderId) async {
    if (senderId != widget.currentUserId) return;

    final msgRef = _messagesRef.child(messageId);
    await msgRef.update({
      'deleted': true,
      'text': 'This message was deleted',
      'deletedBy': widget.currentUserId,
    });
  }

  String _formatTimestamp(dynamic ts) {
    try {
      int millis;
      if (ts == null) return '';
      if (ts is int) {
        millis = ts;
      } else if (ts is double) {
        millis = ts.toInt();
      } else if (ts is String) {
        millis = int.tryParse(ts) ?? 0;
      } else {
        return '';
      }

      final dt = DateTime.fromMillisecondsSinceEpoch(millis);
      final now = DateTime.now();

      if (dt.year == now.year && dt.month == now.month && dt.day == now.day) {
        return DateFormat.jm().format(dt);
      } else {
        return DateFormat('dd MMM, hh:mm a').format(dt);
      }
    } catch (_) {
      return '';
    }
  }

  Widget _buildMessageBubble(Map message) {
    final isMe = message['senderId'] == widget.currentUserId;
    final text = message['text'] ?? '';
    final deleted = message['deleted'] == true;
    final time = _formatTimestamp(message['timestamp']);

    final borderRadiusMe = const BorderRadius.only(
      topLeft: Radius.circular(14),
      topRight: Radius.circular(6),
      bottomLeft: Radius.circular(14),
      bottomRight: Radius.circular(14),
    );

    final borderRadiusOther = const BorderRadius.only(
      topLeft: Radius.circular(6),
      topRight: Radius.circular(14),
      bottomLeft: Radius.circular(14),
      bottomRight: Radius.circular(14),
    );

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.78,
        ),
        child: GestureDetector(
          onLongPress: () async {
            if (isMe) {
              final shouldDelete = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Delete message'),
                  content: const Text('Delete this message for everyone?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, true),
                      child: const Text(
                        'Delete',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              );

              if (shouldDelete == true) {
                await _deleteMessage(message['id'], message['senderId']);
              }
            } else {
              await showModalBottomSheet<bool>(
                context: context,
                builder: (ctx) => SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: const Icon(Icons.copy),
                        title: const Text('Copy'),
                        onTap: () {
                          Clipboard.setData(ClipboardData(text: text));
                          Navigator.pop(ctx, true);
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.cancel),
                        title: const Text('Cancel'),
                        onTap: () => Navigator.pop(ctx, false),
                      ),
                    ],
                  ),
                ),
              );
            }
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            decoration: BoxDecoration(
              color: isMe ? AppColors.primary.withOpacity(0.95) : Colors.white,
              borderRadius: isMe ? borderRadiusMe : borderRadiusOther,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: isMe
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                if (!isMe)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6.0),
                    child: Text(
                      message['revievername'] ?? '',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textColorSecondary,
                      ),
                    ),
                  ),
                SelectableText(
                  text,
                  style: TextStyle(
                    color: isMe ? Colors.white : AppColors.textColorPrimary,
                    fontWeight: deleted ? FontWeight.w400 : FontWeight.w600,
                    fontStyle: deleted ? FontStyle.italic : FontStyle.normal,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      time,
                      style: TextStyle(
                        fontSize: 11,
                        color: isMe
                            ? Colors.white70
                            : AppColors.textColorSecondary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (isMe)
                      Icon(
                        deleted ? Icons.delete_outline : Icons.check,
                        size: 14,
                        color: isMe
                            ? Colors.white70
                            : AppColors.textColorSecondary,
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Map> _parseMessages(DatabaseEvent event) {
    final snapshot = event.snapshot;
    if (!snapshot.exists || snapshot.value == null) return [];

    final raw = snapshot.value;
    final List<Map> messages = [];

    if (raw is Map) {
      raw.forEach((key, value) {
        if (value is Map) {
          final Map<String, dynamic> m = Map<String, dynamic>.from(value);
          messages.add(m);
        }
      });

      messages.sort((a, b) {
        final ta = a['timestamp'] ?? 0;
        final tb = b['timestamp'] ?? 0;
        final ai = (ta is int) ? ta : int.tryParse(ta.toString()) ?? 0;
        final bi = (tb is int) ? tb : int.tryParse(tb.toString()) ?? 0;
        return ai.compareTo(bi);
      });
    }

    return messages;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: AppColors.background,
            size: 25,
          ),
        ),
        backgroundColor: AppColors.primary,
        elevation: 2,
        centerTitle: true,
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person),
            ),
            const SizedBox(width: 12),
            Text(
              widget.recievername,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.info_outline),
              color: Colors.white,
            ),
          ],
        ),
      ),

      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<DatabaseEvent>(
              stream: _messagesRef.orderByChild('timestamp').onValue,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final allMessages = _parseMessages(snapshot.data!);

                // Filter messages: only current user and peer
                final messages = allMessages.where((msg) {
                  final senderId = msg['senderId'] ?? '';
                  final receiverId = msg['receiverId'] ?? '';
                  return (senderId == widget.currentUserId &&
                          receiverId == widget.peerUserId) ||
                      (senderId == widget.peerUserId &&
                          receiverId == widget.currentUserId);
                }).toList();

                if (messages.isEmpty) {
                  return const Center(child: Text('No messages yet'));
                }

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 8,
                  ),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    return _buildMessageBubble(messages[index]);
                  },
                );
              },
            ),
          ),

          SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.03),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.add),
                            color: AppColors.accent,
                          ),
                          Expanded(
                            child: TextField(
                              controller: _controller,
                              decoration: const InputDecoration(
                                hintText: 'Type a message',
                                border: InputBorder.none,
                              ),
                              onSubmitted: (_) => _sendMessage(),
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.emoji_emotions_outlined),
                            color: AppColors.accent,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),

                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: IconButton(
                      onPressed: _sendMessage,
                      icon: const Icon(Icons.send, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
