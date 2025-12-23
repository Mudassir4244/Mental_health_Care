import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mental_healthcare/frontend/practioner_interface/prac_homescreen.dart';
import 'package:mental_healthcare/frontend/practioner_interface/widgets/pract_custom_wdgets.dart';
import 'package:mental_healthcare/frontend/training_components/module_viewer.dart';
import 'package:mental_healthcare/frontend/widgets/appcolors.dart';

class PractitionarTraining extends StatefulWidget {
  const PractitionarTraining({super.key});

  @override
  State<PractitionarTraining> createState() => _PractitionarTrainingState();
}

class _PractitionarTrainingState extends State<PractitionarTraining>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildTrainingCard(Map<String, dynamic> module, int index) {
    // Generate a color based on index for variety
    final List<Color> colors = [
      Colors.blueAccent,
      Colors.purpleAccent,
      Colors.teal,
      Colors.orangeAccent,
      Colors.pinkAccent,
      Colors.indigoAccent
    ];
    final color = colors[index % colors.length];

    final animation =
        Tween<Offset>(
          begin: Offset(0, 0.3 * (index + 1)),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Interval(0, 1, curve: Curves.easeOut),
          ),
        );

    return SlideTransition(
      position: animation,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.25),
              blurRadius: 10,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              module['title'] ?? "Untitled Module",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              module['description'] ?? "No description available.",
              style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
            ),
            const SizedBox(height: 16),
            // Progress placeholder (random for now as we don't track it yet)
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: 0.0, // Initial state
                color: color,
                backgroundColor: color.withOpacity(0.1),
                minHeight: 8,
              ),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ModuleViewerScreen(moduleData: module),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.play_circle_fill, color: Colors.white),
                label: const Text(
                  'Start Training',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => PracHomescreen()),
        );
        return false;
      },
      child: Scaffold(
        backgroundColor: const Color(0xfff8f9fb),
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          leading: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => PracHomescreen()),
              );
            },
            icon: const Icon(Icons.arrow_back_ios),
          ),
          elevation: 4,
          title: const Text(
            'Practitioner Training',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          centerTitle: true,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.accent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
        ),
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
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('TrainingModules').orderBy('timestamp', descending: true).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return const Center(child: Text("Something went wrong"));
                }

                final docs = snapshot.data?.docs ?? [];

                return ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    const Text(
                      'Welcome Back 👋',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff222B45),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Continue your professional growth with engaging modules.',
                      style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                    ),
                    const SizedBox(height: 20),
                    if (docs.isEmpty)
                      const Center(child: Text("No training modules available."))
                    else
                      ...docs.asMap().entries.map(
                        (entry) => _buildTrainingCard(entry.value.data() as Map<String, dynamic>, entry.key),
                      ),
                  ],
                );
              },
            ),
          ),
        ),
        bottomNavigationBar: prac_bottomNavbbar(
          currentScreen: 'Training',
          clientData: {},
        ),
      ),
    );
  }
}
