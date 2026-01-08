import 'package:flutter/material.dart';
import 'package:mental_healthcare/frontend/widgets/appcolors.dart';

class UserListScreen extends StatelessWidget {
  const UserListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 🔹 Dummy user data
    final List<Map<String, String>> dummyUsers = [
      {
        "name": "Ayesha Khan",
        "role": "Therapist",
        "status": "Online",
        "avatar": "https://randomuser.me/api/portraits/women/44.jpg",
      },
      {
        "name": "Hamza Malik",
        "role": "Customer",
        "status": "Offline",
        "avatar": "https://randomuser.me/api/portraits/men/46.jpg",
      },
      {
        "name": "Sara Ahmed",
        "role": "Psychologist",
        "status": "Online",
        "avatar": "https://randomuser.me/api/portraits/women/68.jpg",
      },
      {
        "name": "Ali Raza",
        "role": "Customer",
        "status": "Away",
        "avatar": "https://randomuser.me/api/portraits/men/55.jpg",
      },
      {
        "name": "Dr. Fatima Noor",
        "role": "Practitioner",
        "status": "Online",
        "avatar": "https://randomuser.me/api/portraits/women/57.jpg",
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back_ios),
        ),
        title: const Text(
          "User Directory",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primary,
      ),
      body: Container(
        decoration: const BoxDecoration(
          // gradient: LinearGradient(
          //   colors: [Color(0xFF3A7BD5), Color(0xFF00D2FF)],
          //   begin: Alignment.topLeft,
          //   end: Alignment.bottomRight,
          // ),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: dummyUsers.length,
          itemBuilder: (context, index) {
            final user = dummyUsers[index];
            return Card(
              elevation: 4,
              color: AppColors.cardColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(user["avatar"]!),
                  radius: 28,
                ),
                title: Text(
                  user["name"]!,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textColorPrimary,
                    fontSize: 16,
                  ),
                ),
                subtitle: Text(
                  user["role"]!,
                  style: const TextStyle(color: AppColors.textColorSecondary),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.circle,
                      color: user["status"] == "Online"
                          ? Colors.green
                          : user["status"] == "Away"
                          ? Colors.orange
                          : Colors.grey,
                      size: 12,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      user["status"]!,
                      style: TextStyle(
                        color: user["status"] == "Online"
                            ? Colors.green
                            : user["status"] == "Away"
                            ? Colors.orange
                            : Colors.grey,
                        fontWeight: FontWeight.w600,
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
