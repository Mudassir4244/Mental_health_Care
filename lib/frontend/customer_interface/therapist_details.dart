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
  bool _isLoadingChat = false;

  /// ===========================================
  /// CREATE OR OPEN CHAT FUNCTION
  /// ===========================================
  Future<void> createOrOpenChat() async {
    if (_isLoadingChat) return;
    setState(() => _isLoadingChat = true);

    try {
      final therapist = widget.data;
      final currentUser = auth.currentUser!;

      // Generate chat ID instantly
      String chatId = currentUser.uid.compareTo(therapist['uid']) < 0
          ? "${currentUser.uid}_${therapist['uid']}"
          : "${therapist['uid']}_${currentUser.uid}";

      // 🔥 Navigate IMMEDIATELY (No delay)
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ChatScreen(
              chatId: chatId,
              senderId: currentUser.uid,
              senderName:
                  currentUser.displayName ?? "User", // Will update after fetch
              receiverId: therapist['uid'],
              receiverName: therapist['username'],
              receiverRole: "Therapist",
              recieverimageurl: therapist['ImageUrl'],
            ),
          ),
        ).then((_) {
          if (mounted) setState(() => _isLoadingChat = false);
        });
      }

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
        "participants": [
          currentUser.uid,
          therapist['uid'],
        ], // Added participants array
        "timestamp": FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      print("❌ ERROR in createOrOpenChat: $e");
      if (mounted) setState(() => _isLoadingChat = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final therapist = widget.data;
    final String aboutText =
        therapist['About'] ??
        therapist['about'] ??
        therapist['About Me'] ??
        therapist['bio'] ??
        "No detailed information available about this practitioner.";

    final String name = therapist['username'] ?? 'Therapist';
    final String speciality = therapist['Speciality'] ?? 'Specialist';

    return Scaffold(
      backgroundColor: const Color(0xfff8f9fb),
      body: CustomScrollView(
        slivers: [
          // =======================
          // SLIVER APP BAR
          // =======================
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: AppColors.primary,
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black26,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                  size: 18,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Gradient Background
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.primary, AppColors.accent],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                  // Profile Content
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.white,
                          child:
                              widget.data['ImageUrl'] != null &&
                                  widget.data['ImageUrl'].toString().isNotEmpty
                              ? CircleAvatar(
                                  radius: 48,
                                  backgroundImage: NetworkImage(
                                    widget.data['ImageUrl'],
                                  ),
                                )
                              : Text(
                                  name.isNotEmpty ? name[0].toUpperCase() : '?',
                                  style: const TextStyle(
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          speciality,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // =======================
          // CONTENT BODY
          // =======================
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // About Section
                  _buildSectionTitle("About Me"),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.08),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Text(
                      aboutText,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey[700],
                        height: 1.6,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Contact & Info Section
                  _buildSectionTitle("Contact & Info"),
                  const SizedBox(height: 12),

                  _buildInfoTile(
                    icon: Icons.email_outlined,
                    title: "Email",
                    subtitle: therapist['email'] ?? "Not Available",
                    color: Colors.blue,
                  ),
                  _buildInfoTile(
                    icon: Icons.phone_outlined,
                    title: "Phone",
                    subtitle: therapist['Phone Number'] ?? "Not Provided",
                    color: Colors.green,
                  ),
                  _buildInfoTile(
                    icon: Icons.workspace_premium_outlined,
                    title: "Experience",
                    subtitle: "${therapist['Experience'] ?? 'N/A'} Years",
                    color: Colors.orange,
                  ),
                  _buildInfoTile(
                    icon: Icons.location_on_outlined,
                    title: "Location",
                    subtitle: therapist['Address'] ?? "Online",
                    color: Colors.redAccent,
                  ),
                  _buildInfoTile(
                    icon: Icons.payment_outlined,
                    title: "Prefered Payment Method",
                    subtitle:
                        therapist['Preferred Payment Method'] ?? "Not Provided",
                    color: Colors.green,
                  ),
                  const SizedBox(height: 30),

                  // Send Message Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: createOrOpenChat,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 4,
                        shadowColor: AppColors.primary.withOpacity(0.4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: _isLoadingChat
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5,
                              ),
                            )
                          : const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.chat_bubble_outline, size: 22),
                                SizedBox(width: 10),
                                Text(
                                  'Text to Connect',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
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

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Color(0xff222B45),
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[500],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff222B45),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
