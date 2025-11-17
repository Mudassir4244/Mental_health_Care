import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mental_healthcare/frontend/chats/chatscreen.dart';
import 'package:mental_healthcare/frontend/practioner_interface/prac_homescreen.dart';
import 'package:mental_healthcare/frontend/widgets/appcolors.dart';
import 'package:provider/provider.dart';

class PremiumClientDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> clientData;
  final String currentUserId;
  final String currentUsername;
  final String currentUserRole;
  final String recieverId;
  final String recievername;
  const PremiumClientDetailsScreen({
    super.key,
    required this.clientData,

    required this.currentUserId,
    required this.currentUsername,
    required this.currentUserRole,
    required this.recievername,
    required this.recieverId,
  });

  @override
  Widget build(BuildContext context) {
    final clients = Provider.of<PremiumClientProvider>(context).premiumClients;
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_new,
            fontWeight: FontWeight.bold,
            color: AppColors.cardColor,
          ),
        ),
        backgroundColor: AppColors.primary,
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
            // ---------------- PROFILE HEADER ----------------
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primary,
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
                  CircleAvatar(
                    radius: 45,
                    backgroundColor: Colors.white,
                    child: Text(
                      clientData["username"][0],
                      style: const TextStyle(
                        fontSize: 40,
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
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

            // ---------------- DETAILS BOX ----------------
            detailTile(
              title: "Email",
              value: clientData["email"],
              icon: Icons.email,
              clickable: true,
            ),

            detailTile(
              title: "Payment Status",
              value: clientData["payment Status"],
              icon: Icons.payment,
            ),

            detailTile(
              title: "Role",
              value: clientData["role"],
              icon: Icons.person,
            ),

            detailTile(
              title: "Plan",
              value: clientData["plan"] ?? "Premium",
              icon: Icons.stars,
            ),

            const SizedBox(height: 25),

            // ---------------- SEND MESSAGE BUTTON ----------------
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 5,
              ),
              onPressed: () {
                // you can add chat logic here

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatScreen(
                      peerUserId: recieverId,
                      peerUsername: recievername,
                      recievername: clientData['username'],
                      currentUserRole: currentUserRole,
                      clientData: {},
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
          ],
        ),
      ),
    );
  }

  //---------------------------------------------------------------------------
  // CUSTOM DETAIL TILE WIDGET
  //---------------------------------------------------------------------------
  Widget detailTile({
    required String title,
    required dynamic value,
    required IconData icon,
    bool clickable = false,
  }) {
    return GestureDetector(
      onTap: clickable
          ? () {
              Clipboard.setData(ClipboardData(text: value.toString()));
            }
          : null,
      onLongPress: clickable
          ? () {
              Clipboard.setData(ClipboardData(text: value.toString()));
              HapticFeedback.mediumImpact();
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
            Icon(icon, color: AppColors.accent, size: 26),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                "$title:  ${value ?? 'N/A'}",
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
