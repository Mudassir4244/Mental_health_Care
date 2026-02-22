import 'package:flutter/material.dart';

class MobileAdminHome extends StatelessWidget {
  const MobileAdminHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin"),
        // backgroundColor: Colors.blueGrey[900],
      ),
      drawer: MobileDrawer(),
      body: MobileDashboard(),
    );
  }
}

// Mobile Drawer
class MobileDrawer extends StatelessWidget {
  final List<Map<String, dynamic>> menuItems = [
    {"title": "Dashboard", "icon": Icons.dashboard},
    {"title": "Professional Dashboard", "icon": Icons.people_alt},
    {"title": "Total Users", "icon": Icons.people},
    {"title": "Upload Content", "icon": Icons.upload_file},
    {"title": "Levels / Courses", "icon": Icons.layers},
    {"title": "Reports / Feedback", "icon": Icons.report},
    {"title": "Settings", "icon": Icons.settings},
    {"title": "Logout", "icon": Icons.logout},
  ];

  MobileDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Text("Mind Assist Admin", style: TextStyle(fontSize: 20)),
          ),
          ...menuItems.map((item) {
            return ListTile(
              leading: Icon(item['icon']),
              title: Text(item['title']),
              onTap: () => print("${item['title']} clicked"),
            );
          }),
        ],
      ),
    );
  }
}

// Mobile Dashboard Cards
class MobileDashboard extends StatelessWidget {
  final List<Map<String, dynamic>> options = [
    {"title": "Professional Dashboard", "icon": Icons.dashboard},
    {"title": "Total Users", "icon": Icons.people},
    {"title": "Upload Content", "icon": Icons.upload_file},
    {"title": "Levels / Courses", "icon": Icons.layers},
    {"title": "Reports / Feedback", "icon": Icons.report},
    {"title": "Settings", "icon": Icons.settings},
  ];

  MobileDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: GridView.builder(
        itemCount: options.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // 2 columns for mobile
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1, // Square cards
        ),
        itemBuilder: (context, index) {
          final option = options[index];
          return GestureDetector(
            onTap: () => print("${option['title']} clicked"),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(option['icon'], size: 45, color: Colors.blue),
                  SizedBox(height: 10),
                  Text(
                    option['title'],
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ------------------ Common Widgets ------------------
class AdminHeader extends StatelessWidget {
  const AdminHeader({super.key, required bool showMenuIcon, required Null Function() onMenuTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueGrey[800],
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Mind Assist Admin Panel",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              Icon(Icons.notifications, color: Colors.white),
              SizedBox(width: 16),
              CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, color: Colors.blueGrey[900]),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DashboardCard extends StatelessWidget {
  final Map<String, dynamic> option;
  const DashboardCard({super.key, required this.option});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => print("${option['title']} card clicked"),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(option['icon'], size: 50, color: Colors.blue),
            SizedBox(height: 10),
            Text(
              option['title'],
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
