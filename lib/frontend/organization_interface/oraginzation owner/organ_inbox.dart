import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mental_healthcare/frontend/chats/screens/chat_list_screen.dart';
import 'package:mental_healthcare/frontend/organization_interface/oraginzation%20owner/organization_homescreen.dart';
import 'package:mental_healthcare/frontend/organization_interface/widgets/organ_widigets.dart';
import 'package:mental_healthcare/frontend/widgets/appcolors.dart';

class OrganationInbox extends StatefulWidget {
  const OrganationInbox({super.key});

  @override
  State<OrganationInbox> createState() => _OrganationInboxState();
}

class _OrganationInboxState extends State<OrganationInbox>
    with SingleTickerProviderStateMixin {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? currentUserId;

  @override
  void initState() {
    super.initState();
    currentUserId = _auth.currentUser?.uid;
  }

  @override
  Widget build(BuildContext context) {
    if (currentUserId == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const organ_owner_homescreen()),
        );
        return true;
      },
      child: Scaffold(
        backgroundColor: const Color(0xfff8f9fb),
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          leading: Builder(
            builder: (context) => IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: const Icon(Icons.menu),
            ),
          ),
          centerTitle: true,
          title: const Text(
            'Inbox',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 22,
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
          shadowColor: AppColors.primary.withOpacity(0.3),
        ),
        drawer: const Mydrawer(),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xffe9f5ff), Color(0xfff8f9fb)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Messages 💌',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff222B45),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Stay connected with your team and respond quickly.',
                  style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: _firestore.collection("Chats").snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      var chatDocs = snapshot.data!.docs;

                      // Filter chats for the current organization owner
                      chatDocs = chatDocs.where((doc) {
                        final data = doc.data() as Map<String, dynamic>;
                        // 1. Check participants array if exists
                        if (data.containsKey('participants') &&
                            data['participants'] is List) {
                          final participants = List.from(data['participants']);
                          if (participants.contains(currentUserId)) return true;
                        }
                        // 2. Fallback to senderId/receiverId check
                        return data['senderId'] == currentUserId ||
                            data['receiverId'] == currentUserId;
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
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.chat_bubble_outline,
                                size: 60,
                                color: Colors.grey.shade400,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "No messages yet",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      return ListView.builder(
                        itemCount: chatDocs.length,
                        itemBuilder: (context, index) {
                          // return InboxScreen();
                          return ChatListItem(
                            chatDoc: chatDocs[index],
                            currentUid: currentUserId!,
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: const organ_bottomNavbbar(currentScreen: 'Inbox'),
      ),
    );
  }
}
