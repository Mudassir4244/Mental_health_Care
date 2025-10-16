import 'package:flutter/material.dart';
import 'package:mental_healthcare/practioner_interface/prac_homescreen.dart';
import 'package:mental_healthcare/practioner_interface/widgets/pract_custom_wdgets.dart';
import 'package:mental_healthcare/widgets/appcolors.dart';

class PractitionarTraining extends StatefulWidget {
  const PractitionarTraining({super.key});

  @override
  State<PractitionarTraining> createState() => _PractitionarTrainingState();
}

class _PractitionarTrainingState extends State<PractitionarTraining>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  final List<Map<String, dynamic>> _trainingModules = [
    {
      'title': 'Mindfulness Techniques 🧘‍♀️',
      'desc': 'Learn effective techniques to help clients reduce stress.',
      'progress': 0.8,
      'color': Colors.blueAccent,
    },
    {
      'title': 'Cognitive Behavioral Therapy 💭',
      'desc': 'Understand CBT fundamentals and practical applications.',
      'progress': 0.45,
      'color': Colors.purpleAccent,
    },
    {
      'title': 'Emotional Intelligence 🧠',
      'desc': 'Develop empathy and better emotional communication skills.',
      'progress': 0.6,
      'color': Colors.teal,
    },
    {
      'title': 'Depression Management 🌧️',
      'desc': 'Explore strategies to assist clients facing depression.',
      'progress': 0.2,
      'color': Colors.orangeAccent,
    },
  ];

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
              color: module['color'].withOpacity(0.25),
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
              module['title'],
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              module['desc'],
              style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: module['progress'],
                color: module['color'],
                backgroundColor: module['color'].withOpacity(0.1),
                minHeight: 8,
              ),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Opening ${module['title']}..."),
                      behavior: SnackBarBehavior.floating,
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: module['color'],
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
    return Scaffold(
      backgroundColor: const Color(0xfff8f9fb),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => PracHomescreen()),
            );
          },
          icon: Icon(Icons.arrow_back_ios),
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
        backgroundColor: AppColors.primary,
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
          child: ListView(
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
              ..._trainingModules.asMap().entries.map(
                (entry) => _buildTrainingCard(entry.value, entry.key),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: prac_bottomNavbbar(currentScreen: 'Training'),
    );
  }
}
