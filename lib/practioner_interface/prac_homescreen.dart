import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mental_healthcare/practioner_interface/widgets/pract_custom_wdgets.dart';
import 'package:mental_healthcare/widgets/appcolors.dart';

class PracHomescreen extends StatefulWidget {
  const PracHomescreen({super.key});

  @override
  State<PracHomescreen> createState() => _PracHomescreenState();
}

class _PracHomescreenState extends State<PracHomescreen>
    with SingleTickerProviderStateMixin {
  final String title = 'Home';

  // Dummy client list
  final List<Map<String, String>> dummyUsers = [
    {'name': 'Sarah Khan', 'status': 'Active', 'lastSession': '2 days ago'},
    {'name': 'Ali Raza', 'status': 'Pending', 'lastSession': '1 week ago'},
    {'name': 'Maria Johnson', 'status': 'Active', 'lastSession': '3 days ago'},
    {
      'name': 'Ahmed Hassan',
      'status': 'Inactive',
      'lastSession': '2 weeks ago',
    },
    {'name': 'Emily Carter', 'status': 'Active', 'lastSession': 'Yesterday'},
    {'name': 'John Doe', 'status': 'Pending', 'lastSession': '4 days ago'},
  ];

  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'Active':
        return Colors.green;
      case 'Pending':
        return Colors.orange;
      default:
        return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff8f9fb),
      appBar: AppBar(
        
        iconTheme: IconThemeData(color: Colors.white),
        leading: Builder(
          builder: (context) => IconButton(
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            icon: Icon(Icons.menu),
          ),
        ),
        centerTitle: true,
        title: const Text(
          'Mind Assist',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            letterSpacing: 0.8,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.primary,
        elevation: 4,
        shadowColor: AppColors.primary.withOpacity(0.4),
      ),
      drawer: Mydrawer(),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xffe9f5ff), Color(0xfff8f9fb)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Your Clients 👥',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff222B45),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Track your clients’ progress and sessions at a glance.',
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 20),

              // Grid view
              Expanded(
                child: GridView.builder(
                  itemCount: dummyUsers.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    childAspectRatio: 0.95,
                  ),
                  itemBuilder: (context, index) {
                    final user = dummyUsers[index];

                    return AnimatedBuilder(
                      animation: _animationController,
                      builder: (context, child) {
                        final offsetAnimation =
                            Tween<Offset>(
                              begin: Offset(0, 0.4 * (index + 1)),
                              end: Offset.zero,
                            ).animate(
                              CurvedAnimation(
                                parent: _animationController,
                                curve: Interval(0, 1, curve: Curves.easeOut),
                              ),
                            );

                        return SlideTransition(
                          position: offsetAnimation,
                          child: Opacity(
                            opacity: _animationController.value,
                            child: InkWell(
                              onTap: () {
                                Get.snackbar(
                                  'Client Selected',
                                  'Opening ${user['name']}\'s profile...',
                                  backgroundColor: Colors.white.withOpacity(
                                    0.8,
                                  ),
                                );
                              },
                              borderRadius: BorderRadius.circular(20),
                              splashColor: AppColors.primary.withOpacity(0.1),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.15),
                                      blurRadius: 8,
                                      spreadRadius: 2,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CircleAvatar(
                                        radius: 32,
                                        backgroundColor: AppColors.primary
                                            .withOpacity(0.15),
                                        child: Text(
                                          user['name']![0],
                                          style: TextStyle(
                                            fontSize: 24,
                                            color: AppColors.primary,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        user['name']!,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                          color: Color(0xff222B45),
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        user['lastSession']!,
                                        style: TextStyle(
                                          color: Colors.grey.shade600,
                                          fontSize: 13,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Expanded(
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color: _statusColor(
                                              user['status']!,
                                            ).withOpacity(0.15),
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          child: Text(
                                            user['status']!,
                                            style: TextStyle(
                                              color: _statusColor(
                                                user['status']!,
                                              ),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
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
      bottomNavigationBar: prac_bottomNavbbar(currentScreen: title),
    );
  }
}
