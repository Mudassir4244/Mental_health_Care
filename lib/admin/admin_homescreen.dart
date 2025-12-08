// import 'package:flutter/material.dart';
// import 'package:mental_healthcare/admin/admin_dashboard.dart';
// import 'package:mental_healthcare/admin/admin_mobile_UI.dart';
// import 'package:mental_healthcare/admin/admin_settings.dart';
// import 'package:mental_healthcare/admin/total_users/total_users.dart';
// import 'package:mental_healthcare/admin/upload_content/admin_upload_panel.dart';

// class AdminHomescreen extends StatelessWidget {
//   const AdminHomescreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: "Mind Assist Admin Panel",
//       theme: ThemeData(primarySwatch: Colors.blue),
//       home:DesktopAdminHome(),
//     );
//   }
// }

// // ------------------ Responsive Wrapper ------------------
// class AdminResponsiveScreen extends StatelessWidget {
//   const AdminResponsiveScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final width = MediaQuery.of(context).size.width;

//     if (width > 800) {
//       return DesktopAdminHome();
//     } else {
//       return MobileAdminHome();
//     }
//   }
// }

// // ---------------------------------------------------------------------------
// // RESPONSIVE ADMIN HOME
// // ---------------------------------------------------------------------------

// // ------------------ MAIN ADMIN LAYOUT ------------------
// class DesktopAdminHome extends StatefulWidget {
//   const DesktopAdminHome({super.key});

//   @override
//   State<DesktopAdminHome> createState() => _DesktopAdminHomeState();
// }

// class _DesktopAdminHomeState extends State<DesktopAdminHome> {
//   int selectedIndex = 0;

//   final List<Map<String, dynamic>> menuItems = [
//     {"title": "Dashboard", "icon": Icons.dashboard},
//     // {"title": "Users", "icon": Icons.people},
//     {"title": "Upload Content", "icon": Icons.upload_file},
//     {"title": "Reports", "icon": Icons.report},
//     {"title": "Settings", "icon": Icons.settings},
//     {"title": "Logout", "icon": Icons.logout},
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[100],

//       body: Row(
//         children: [
//           // ---------------- Sidebar ----------------
//           Container(
//             width: 260,
//             color: Colors.blueGrey[900],
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Logo/Header
//                 Container(
//                   height: 70,
//                   padding: const EdgeInsets.all(16),
//                   alignment: Alignment.centerLeft,
//                   child: const Text(
//                     "Mind Assist Admin",
//                     style: TextStyle(color: Colors.white, fontSize: 18),
//                   ),
//                 ),

//                 const Divider(color: Colors.white24),

//                 // Menu Items
//                 Expanded(
//                   child: ListView.builder(
//                     itemCount: menuItems.length,
//                     itemBuilder: (context, index) {
//                       bool isSelected = selectedIndex == index;

//                       return InkWell(
//                         onTap: () => setState(() => selectedIndex = index),
//                         child: Container(
//                           decoration: BoxDecoration(
//                             color: isSelected
//                                 ? Colors.white.withOpacity(0.12)
//                                 : Colors.transparent,
//                           ),
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 16,
//                             vertical: 12,
//                           ),
//                           child: Row(
//                             children: [
//                               Icon(
//                                 menuItems[index]["icon"],
//                                 color: Colors.white,
//                                 size: 22,
//                               ),
//                               const SizedBox(width: 12),
//                               Text(
//                                 menuItems[index]["title"],
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 15,
//                                   fontWeight: isSelected
//                                       ? FontWeight.bold
//                                       : null,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           // ---------------- Main Content Area ----------------
//           Expanded(
//             child: Column(
//               children: [
//                 // Header Bar
//                 AdminHeader(),

//                 Expanded(
//                   child: IndexedStack(
//                     index: selectedIndex,
//                     children: [
//                       DesktopDashboard(), // Dashboard
//                       // UsersScreen(),
//                       UploadContentScreen(),

//                       ReportsScreen(),
//                       SettingsScreen(),
//                       Center(child: Text("Logout Page")),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ------------------ HEADER ------------------
// class AdminHeader extends StatelessWidget {
//   const AdminHeader({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 60,
//       padding: const EdgeInsets.symmetric(horizontal: 20),
//       color: Colors.white,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           const Text(
//             "Admin Panel",
//             style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//           ),
//           Row(
//             children: const [
//               Icon(Icons.notifications_outlined, size: 26),
//               SizedBox(width: 20),
//               CircleAvatar(child: Icon(Icons.person)),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ------------------ DASHBOARD ------------------

// // ------------------ DASHBOARD CARD ------------------
// class DashboardCard extends StatelessWidget {
//   final Map<String, dynamic> option;
//   const DashboardCard({super.key, required this.option});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: const [
//           BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
//         ],
//       ),
//       child: Row(
//         children: [
//           Icon(option['icon'], size: 40, color: Colors.blueGrey),
//           const SizedBox(width: 20),
//           Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Expanded(
//                 child: Text(
//                   option['title'],
//                   style: const TextStyle(fontSize: 16, color: Colors.black54),
//                 ),
//               ),
//               Expanded(
//                 child: Text(
//                   option['value'],
//                   style: const TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ------------------ DIFFERENT SCREENS ------------------
// class UsersScreen extends StatelessWidget {
//   const UsersScreen({super.key});
//   @override
//   Widget build(BuildContext context) => TotalUsersSummary();
// }

// class UploadContentScreen extends StatelessWidget {
//   const UploadContentScreen({super.key});
//   @override
//   Widget build(BuildContext context) => const Center(child: AdminUploadPanel());
// }

// class ReportsScreen extends StatelessWidget {
//   const ReportsScreen({super.key});
//   @override
//   Widget build(BuildContext context) => const Center(child: Text("Reports"));
// }

// class SettingsScreen extends StatelessWidget {
//   const SettingsScreen({super.key});
//   @override
//   Widget build(BuildContext context) =>
//       const Center(child: AdminSettingsScreen());
// }
import 'package:flutter/material.dart';
import 'package:mental_healthcare/admin/admin_dashboard.dart';
import 'package:mental_healthcare/admin/admin_settings.dart';
import 'package:mental_healthcare/admin/total_users/total_users.dart';
import 'package:mental_healthcare/admin/upload_content/admin_upload_panel.dart';
// import 'admin_mobile_UI.dart';

class AdminHomescreen extends StatelessWidget {
  const AdminHomescreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Mind Assist Admin Panel",
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MobileAdminHomeResponsive(),
    );
  }
}

// ******************************************************************
// RESPONSIVE SCREEN WRAPPER
// ******************************************************************
class AdminResponsiveScreen extends StatelessWidget {
  const AdminResponsiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    /// Desktop / Laptop
    if (width > 800) {
      return const DesktopAdminHome();
    }

    /// Mobile / Small Tablets
    return const MobileAdminHomeResponsive();
  }
}

// ******************************************************************
// DESKTOP VERSION
// ******************************************************************
class DesktopAdminHome extends StatefulWidget {
  const DesktopAdminHome({super.key});

  @override
  State<DesktopAdminHome> createState() => _DesktopAdminHomeState();
}

class _DesktopAdminHomeState extends State<DesktopAdminHome> {
  int selectedIndex = 0;

  final List<Map<String, dynamic>> menuItems = [
    {"title": "Dashboard", "icon": Icons.dashboard},
    {"title": "Upload Content", "icon": Icons.upload_file},
    {"title": "Reports", "icon": Icons.report},
    {"title": "Settings", "icon": Icons.settings},
    {"title": "Logout", "icon": Icons.logout},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Row(
        children: [
          // ------------------------------------------------------------
          // DESKTOP SIDEBAR (always visible)
          // ------------------------------------------------------------
          Container(
            width: 260,
            color: Colors.blueGrey[900],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 70,
                  padding: const EdgeInsets.all(16),
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    "Mind Assist Admin",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
                const Divider(color: Colors.white24),

                Expanded(
                  child: ListView.builder(
                    itemCount: menuItems.length,
                    itemBuilder: (context, index) {
                      bool isSelected = selectedIndex == index;

                      return InkWell(
                        onTap: () => setState(() => selectedIndex = index),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.white.withOpacity(0.12)
                                : Colors.transparent,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                menuItems[index]["icon"],
                                color: Colors.white,
                                size: 22,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                menuItems[index]["title"],
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
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

          // ------------------------------------------------------------
          // Main Content Area
          // ------------------------------------------------------------
          Expanded(
            child: Column(
              children: [
                const AdminHeaderDesktop(),

                Expanded(
                  child: IndexedStack(
                    index: selectedIndex,
                    children: [
                      DesktopDashboard(),
                      const AdminUploadPanel(),
                      const Center(child: Text("Reports")),
                      const AdminSettingsScreen(),
                      const Center(child: Text("Logout")),
                    ],
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

// ******************************************************************
// MOBILE VERSION
// ******************************************************************
class MobileAdminHomeResponsive extends StatefulWidget {
  const MobileAdminHomeResponsive({super.key});

  @override
  State<MobileAdminHomeResponsive> createState() =>
      _MobileAdminHomeResponsiveState();
}

class _MobileAdminHomeResponsiveState extends State<MobileAdminHomeResponsive> {
  int selectedIndex = 0;

  final List<Map<String, dynamic>> menuItems = [
    {"title": "Dashboard", "icon": Icons.dashboard},
    {"title": "Upload Content", "icon": Icons.upload_file},
    {"title": "Reports", "icon": Icons.report},
    {"title": "Settings", "icon": Icons.settings},
    {"title": "Logout", "icon": Icons.logout},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        backgroundColor: Colors.blueGrey[900],
        child: Column(
          children: [
            const DrawerHeader(
              child: Center(
                child: Text(
                  "Mind Assist Admin",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: menuItems.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Icon(
                      menuItems[index]["icon"],
                      color: Colors.white,
                    ),
                    title: Text(
                      menuItems[index]["title"],
                      style: const TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      setState(() => selectedIndex = index);
                      Navigator.pop(context); // close drawer
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),

      // ----------------- MOBILE HEADER WITH HAMBURGER -----------------
      appBar: AppBar(
        title: const Text("Admin Panel"),
        backgroundColor: Colors.white,
        elevation: 1,
        foregroundColor: Colors.black,
      ),

      // ----------------- MOBILE CONTENT AREA -----------------
      body: IndexedStack(
        index: selectedIndex,
        children: [
          // MobileAdminHome(),
          const TotalSummary(),
          // DesktopAdminHome(),
          const AdminUploadPanel(),
          const Center(child: Text("Reports")),
          const AdminSettingsScreen(),
          const Center(child: Text("Logout")),
        ],
      ),
    );
  }
}

// ******************************************************************
// DESKTOP HEADER
// ******************************************************************
class AdminHeaderDesktop extends StatelessWidget {
  const AdminHeaderDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Text(
            "Admin Panel",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Row(
            children: [
              Icon(Icons.notifications_outlined, size: 26),
              SizedBox(width: 20),
              CircleAvatar(child: Icon(Icons.person)),
            ],
          ),
        ],
      ),
    );
  }
}

// ******************************************************************
// OTHER SCREENS
// ******************************************************************
class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});
  @override
  Widget build(BuildContext context) => TotalSummary();
}

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});
  @override
  Widget build(BuildContext context) => const Center(child: Text("Reports"));
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Center(child: AdminSettingsScreen());
}
