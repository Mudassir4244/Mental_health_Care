import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mental_healthcare/frontend/widgets/widgets.dart'
    hide WelcomeBanner;
import 'package:mental_healthcare/frontend/widgets/appcolors.dart';

// --- Color Definitions (Re-added for self-contained file) ---

// --- Screen Implementation (Dashboard Screen) ---

class HomeScreen extends StatelessWidget {
  final String title = 'Home';

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    DateTime? lastPressed;
    return WillPopScope(
      onWillPop: () async {
        final now = DateTime.now();

        if (lastPressed == null ||
            now.difference(lastPressed!) > const Duration(seconds: 2)) {
          // If pressed for the first time OR after 2 seconds
          lastPressed = now;
          Fluttertoast.showToast(msg: "Press again to exit ");
          return false; // Prevent exiting
        }
        // If pressed again within 2 seconds
        SystemNavigator.pop();
        return false; // Exit app
      },
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: AppColors.cardColor),
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
            'MindAssist',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor: AppColors.primary,
        ),
        backgroundColor: AppColors.background,
        drawer: Mydrawer(), // ✅ Your custom drawer
        body: Stack(
          children: [
            SafeArea(
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 10.0,
                    ),
                    padding: const EdgeInsets.all(20.0),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Hello Peter!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "How are you doing today?",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: FeatureGrid(),
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: BottomNavBar(currentScreen: title),
            ),
          ],
        ),
      ),
    );
  }
}
