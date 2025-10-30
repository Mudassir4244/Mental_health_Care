import 'package:flutter/material.dart';
import 'package:mental_healthcare/frontend/widgets/appcolors.dart';
import 'package:mental_healthcare/frontend/widgets/widgets.dart';

// --- Data Models (Mock data for charts and stats) ---
class MoodMetric {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const MoodMetric({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });
}

// --- Insights Screen Implementation ---

class InsightsScreen extends StatelessWidget {
  final String title = 'Insights';
  const InsightsScreen({super.key});

  final List<MoodMetric> metrics = const [
    MoodMetric(
      label: 'Avg. Mood Score',
      value: '7.8/10',
      icon: Icons.score,
      color: AppColors.primary,
    ),
    MoodMetric(
      label: 'Highest Emotion',
      value: 'Happy (40%)',
      icon: Icons.sentiment_satisfied_alt,
      color: AppColors.primary,
    ),
    MoodMetric(
      label: 'Low Mood Days',
      value: '2 days',
      icon: Icons.calendar_today,
      color: AppColors.sectionTitleColor,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: Stack(
        children: [
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                _CustomAppBar(title: title),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Screen Banner
                        const _ScreenBanner(
                          title: 'Insights',
                          subtitle: 'Your personalized mental wellness report.',
                        ),
                        const SizedBox(height: 20),

                        // Key Metrics
                        const SectionTitle(title: 'Key Metrics'),
                        const SizedBox(height: 12),
                        MetricsGrid(metrics: metrics),
                        const SizedBox(height: 24),

                        // Mood Trend Chart (Placeholder)
                        const SectionTitle(title: '7-Day Mood Trend'),
                        const SizedBox(height: 12),
                        const MoodTrendChart(),
                        const SizedBox(height: 24),

                        // Actionable Suggestions
                        const SectionTitle(title: 'Suggestions'),
                        const SizedBox(height: 12),
                        const SuggestionCard(
                          suggestion:
                              'Try a 10-minute breathing exercise every morning to reduce baseline anxiety.',
                          icon: Icons.self_improvement,
                          color: AppColors.accent,
                        ),
                        const SizedBox(
                          height: 100,
                        ), // Padding above the bottom nav bar
                      ],
                    ),
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
    );
  }
}

// --- Custom Widgets for Insights Screen ---

class _CustomAppBar extends StatelessWidget {
  final String title;
  const _CustomAppBar({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 340),
      child: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios,
          color: AppColors.textColorPrimary,
          size: 24,
        ),
        onPressed: () => Navigator.pop(context),
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

class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: AppColors.sectionTitleColor,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class MetricsGrid extends StatelessWidget {
  final List<MoodMetric> metrics;

  const MetricsGrid({super.key, required this.metrics});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.8, // Adjust aspect ratio for a taller card
      ),
      itemCount: metrics.length,
      itemBuilder: (context, index) {
        final metric = metrics[index];
        return Card(
          color: AppColors.cardColor,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(metric.icon, color: metric.color, size: 30),
                const SizedBox(height: 8),
                Text(
                  metric.value,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: metric.color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  metric.label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 10,
                    color: AppColors.textColorSecondary,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class MoodTrendChart extends StatelessWidget {
  const MoodTrendChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.cardColor,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        height: 200, // Fixed height for the chart area
        alignment: Alignment.center,
        child: Text(
          'Mood Trend Chart Placeholder\n(Line or Bar Graph)',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.textColorSecondary.withOpacity(0.6),
          ),
        ),
      ),
    );
  }
}

class SuggestionCard extends StatelessWidget {
  final String suggestion;
  final IconData icon;
  final Color color;

  const SuggestionCard({
    super.key,
    required this.suggestion,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.cardColor,
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(color: color.withOpacity(0.5), width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 30),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Actionable Tip',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppColors.textColorPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    suggestion,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textColorSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
