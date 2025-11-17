import 'package:flutter/material.dart';
import 'package:mental_healthcare/frontend/customer_interface/homescreen.dart';
import 'package:mental_healthcare/frontend/customer_interface/quizscreen.dart';
import 'package:mental_healthcare/frontend/widgets/appcolors.dart';
import 'package:mental_healthcare/frontend/widgets/widgets.dart';

class TrainingModule {
  final int moduleId;
  final String title;
  final String iconEmoji; // E.g., '🧠', '❤️', '🔒'
  final double completionPercentage; // 0.0 to 1.0
  final bool isLocked;

  const TrainingModule({
    required this.moduleId,
    required this.title,
    required this.iconEmoji,
    required this.completionPercentage,
    this.isLocked = false,
  });
}

// --- Training Screen Implementation ---

class TrainingScreen extends StatelessWidget {
  final String title = 'Training';
  const TrainingScreen({super.key});

  final List<TrainingModule> modules = const [
    TrainingModule(
      moduleId: 1,
      title: 'Module 1: Introduction to Mental Health',
      iconEmoji: '🧠',
      completionPercentage: 1.0, // 100% Completed
      isLocked: false,
    ),
    TrainingModule(
      moduleId: 2,
      title: 'Module 2: Recognizing Signs & Symptoms',
      iconEmoji: '❤️',
      completionPercentage: 0.5, // 50% Completed
      isLocked: false,
    ),
    TrainingModule(
      moduleId: 3,
      title: 'Module 3: Crisis Response & Support',
      iconEmoji: '🧠',
      completionPercentage: 0.0,
      isLocked: true, // Locked
    ),
    TrainingModule(
      moduleId: 4,
      title: 'Module 4: Providing Ongoing Support',
      iconEmoji: '🧠',
      completionPercentage: 0.0,
      isLocked: true, // Locked
    ),
  ];

  void _navigateToQuiz(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const QuizScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Calculate overall course completion
    final totalModules = modules.length;
    final completedModules = modules
        .where((m) => m.completionPercentage == 1.0)
        .length;
    final overallCompletion = completedModules / totalModules;

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
          child: Icon(Icons.arrow_back_ios, fontWeight: FontWeight.bold),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        // leading: Builder(
        //   builder: (_) => IconButton(
        //     onPressed: () {
        //       Scaffold.of(context).openDrawer();
        //     },
        //     icon: Icon(Icons.menu),
        //   ),
        // ),
        backgroundColor: AppColors.primary,
      ),
      drawer: Mydrawer(),

      body: Stack(
        children: [
          // const _StripedBackground(),
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                // _CustomAppBar(title: title),
                SizedBox(height: 10),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Screen Banner (uses AppColors.primary)
                        const _ScreenBanner(
                          title: 'Training',
                          subtitle: 'Mental Health First Aid',
                        ),
                        const SizedBox(height: 20),

                        // Overall Course Progress
                        CourseProgressCard(
                          overallCompletion: overallCompletion,
                        ),
                        const SizedBox(height: 20),

                        // Module List
                        ...modules.map(
                          (module) => Padding(
                            padding: const EdgeInsets.only(bottom: 15.0),
                            child: ModuleTile(module: module),
                          ),
                        ),

                        const SizedBox(
                          height: 100,
                        ), // Padding for Floating Button
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Floating Quiz Button

          // Bottom Navigation Bar
          Align(
            alignment: Alignment.bottomCenter,
            child: BottomNavBar(currentScreen: title),
          ),
        ],
      ),
    );
  }
}

class _ScreenBanner extends StatelessWidget {
  final String title;
  final String subtitle;

  const _ScreenBanner({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

class CourseProgressCard extends StatelessWidget {
  final double overallCompletion;
  const CourseProgressCard({super.key, required this.overallCompletion});

  @override
  Widget build(BuildContext context) {
    final percent = (overallCompletion * 100).toInt();

    return Card(
      color: AppColors.cardColor,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            // Icon (Brain)
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: const Text('🧠', style: TextStyle(fontSize: 24)),
            ),
            const SizedBox(width: 15),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Completion Text
                  Text(
                    '$percent% Completed',
                    style: TextStyle(
                      color: AppColors.textColorPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Progress Bar
                  LinearProgressIndicator(
                    value: overallCompletion,
                    backgroundColor: AppColors.stripedColor.withOpacity(0.5),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppColors.success,
                    ),
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ],
              ),
            ),

            // Checkmark icon if 100% complete
            if (overallCompletion == 1.0)
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Icon(
                  Icons.check_circle,
                  color: AppColors.success,
                  size: 28,
                ),
              )
            else
              const SizedBox(width: 38), // Space to align with checkmark
          ],
        ),
      ),
    );
  }
}

class ModuleTile extends StatelessWidget {
  final TrainingModule module;
  const ModuleTile({super.key, required this.module});

  @override
  Widget build(BuildContext context) {
    final percent = (module.completionPercentage * 100).toInt();

    Color progressColor;
    if (module.completionPercentage == 1.0) {
      progressColor = AppColors.success;
    } else if (module.completionPercentage > 0.0) {
      progressColor = AppColors.accent; // In-progress color
    } else {
      progressColor = AppColors.stripedColor; // Not started color
    }

    // Determine icon and tap behavior
    final icon = module.isLocked ? Icons.lock_outline : Icons.chevron_right;
    final iconColor = module.isLocked
        ? AppColors.textColorSecondary.withOpacity(0.7)
        : AppColors.primary;
    final onTap = module.isLocked
        ? null
        : () {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Starting ${module.title}')));
          };

    return Card(
      color: AppColors.cardColor,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              // Icon Container
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Text(
                  module.iconEmoji,
                  style: const TextStyle(fontSize: 24),
                ),
              ),
              const SizedBox(width: 15),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      module.title,
                      style: TextStyle(
                        color: module.isLocked
                            ? AppColors.textColorSecondary
                            : AppColors.textColorPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 6),

                    if (module.completionPercentage < 1.0 && !module.isLocked)
                      // Progress Bar and Text (for in-progress/not started)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$percent% Completed',
                            style: TextStyle(
                              color: AppColors.textColorSecondary,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 4),
                          LinearProgressIndicator(
                            value: module.completionPercentage,
                            backgroundColor: AppColors.stripedColor.withOpacity(
                              0.5,
                            ),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              progressColor,
                            ),
                            minHeight: 6,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ],
                      )
                    else if (module.completionPercentage == 1.0)
                      // Completed Text
                      Row(
                        children: [
                          Text(
                            '100% Completed',
                            style: TextStyle(
                              color: AppColors.success,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.check_circle_outline,
                            color: AppColors.success,
                            size: 14,
                          ),
                        ],
                      )
                    else
                      // Locked Status Text
                      Text(
                        'Locked',
                        style: TextStyle(
                          color: AppColors.textColorSecondary.withOpacity(0.7),
                          fontSize: 12,
                        ),
                      ),
                  ],
                ),
              ),

              // Trailing Icon
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Icon(icon, color: iconColor, size: 28),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FloatingQuizButton extends StatelessWidget {
  final VoidCallback onTap;
  const _FloatingQuizButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: onTap,
      label: const Text(
        'Quiz',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      icon: const Icon(Icons.school),
      backgroundColor: AppColors.accent,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 6,
    );
  }
}
