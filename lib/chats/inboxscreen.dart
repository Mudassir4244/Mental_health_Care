import 'package:flutter/material.dart';
import 'package:mental_healthcare/customer_interface/homescreen.dart';
import 'package:mental_healthcare/widgets/appcolors.dart';
import 'package:mental_healthcare/widgets/widgets.dart';
// make sure this file is correctly imported

class InboxScreen extends StatelessWidget {
  const InboxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final String title = 'Inbox';
    final List<Map<String, String>> chats = [
      {
        'name': 'Sarah Ahmed',
        'message': 'Hey, how are you doing today?',
        'time': '10:45 AM',
        'avatar': 'assets/images/avatar1.png',
      },
      {
        'name': 'Ali Khan',
        'message': 'Can you check the new design?',
        'time': '09:30 AM',
        'avatar': 'assets/images/avatar2.png',
      },
      {
        'name': 'John Doe',
        'message': 'See you at the event tomorrow!',
        'time': 'Yesterday',
        'avatar': 'assets/images/avatar3.png',
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => HomeScreen()),
            );
          },
          child: Icon(Icons.arrow_back_ios_new),
        ),
        backgroundColor: AppColors.primary,
        iconTheme: IconThemeData(color: AppColors.cardColor),
        elevation: 0,
        title: const Text(
          'Inbox',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      drawer: Mydrawer(),
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  // 🔍 Search Bar
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Search messages...',
                      prefixIcon: const Icon(
                        Icons.search,
                        color: AppColors.accent,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: AppColors.stripedColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 🗨️ Chat List
                  Expanded(
                    child: ListView.separated(
                      itemCount: chats.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final chat = chats[index];
                        return InkWell(
                          onTap: () {
                            // 🧭 Navigate to chat detail screen
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    ChatDetailScreen(name: chat['name']!),
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.cardColor,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                // 🖼️ Avatar
                                CircleAvatar(
                                  radius: 28,
                                  backgroundImage: AssetImage(chat['avatar']!),
                                ),
                                const SizedBox(width: 12),

                                // 📝 Chat Info
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        chat['name']!,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.textColorPrimary,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        chat['message']!,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: AppColors.textColorSecondary,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // 🕒 Time
                                Text(
                                  chat['time']!,
                                  style: const TextStyle(
                                    color: AppColors.textColorSecondary,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: BottomNavBar(currentScreen: title),
          ),
        ],
      ),
    );
  }
}

// 📱 Dummy Chat Detail Screen
class ChatDetailScreen extends StatelessWidget {
  final String name;
  const ChatDetailScreen({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(name), backgroundColor: AppColors.primary),
      body: const Center(
        child: Text(
          'Chat Details Coming Soon...',
          style: TextStyle(fontSize: 18, color: AppColors.textColorPrimary),
        ),
      ),
    );
  }
}
