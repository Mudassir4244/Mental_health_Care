import 'package:flutter/material.dart';
import 'package:mental_healthcare/frontend/widgets/appcolors.dart';
import 'package:mental_healthcare/frontend/widgets/widgets.dart';

// --- Data Models ---
class Activity {
  final String time;
  final String title;
  final String description;
  final Color color;

  const Activity({
    required this.time,
    required this.title,
    required this.description,
    required this.color,
  });
}

// --- Activity Screen Implementation ---

class ActivityScreen extends StatelessWidget {
  final String title = 'Activity';
  const ActivityScreen({super.key});

  final List<Activity> activities = const [
    Activity(
      time: '08:00 AM',
      title: 'Mindfulness Meditation',
      description: '15 minutes guided session.',
      color: Color(0xFF5AD2E5), // Light Cyan
    ),
    Activity(
      time: '12:30 PM',
      title: 'Therapy Session',
      description: 'Weekly session with Dr. Jane Doe.',
      color: Color(0xFFF09598), // Light Red
    ),
    Activity(
      time: '06:00 PM',
      title: 'Journal Entry',
      description: 'Daily gratitude journal.',
      color: AppColors.accent, // Teal
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
                        // Screen Banner (Simple title)
                        const _ScreenBanner(
                          title: 'Activity',
                          subtitle: 'Your weekly engagement overview.',
                        ),
                        const SizedBox(height: 20),

                        // Calendar View (Placeholder)
                        const CalendarView(),
                        const SizedBox(height: 24),

                        // Today's Activity Log
                        SectionTitle(title: "Today's Log (Oct 25, 2025)"),
                        const SizedBox(height: 12),
                        ...activities
                            .map(
                              (activity) =>
                                  ActivityTimelineItem(activity: activity),
                            )
                            ,

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

// --- Custom Widgets for Activity Screen ---

class _CustomAppBar extends StatelessWidget {
  final String title;
  const _CustomAppBar({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, top: 10.0, bottom: 8.0),
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

class CalendarView extends StatelessWidget {
  const CalendarView({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.cardColor,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(
                  Icons.chevron_left,
                  color: AppColors.textColorPrimary,
                ),
                Text(
                  'October 2025',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                const Icon(
                  Icons.chevron_right,
                  color: AppColors.textColorPrimary,
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Placeholder for days of the week and dates
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
              itemCount: 7, // Placeholder for 7 days
              itemBuilder: (context, index) {
                final day = ['M', 'T', 'W', 'T', 'F', 'S', 'S'][index];
                final isToday = index == 4; // Mocking Friday as today
                return Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isToday ? AppColors.primary : AppColors.background,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    day,
                    style: TextStyle(
                      color: isToday
                          ? Colors.white
                          : AppColors.textColorPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ActivityTimelineItem extends StatelessWidget {
  final Activity activity;

  const ActivityTimelineItem({super.key, required this.activity});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Time and Connector Line
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                activity.time,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textColorSecondary,
                ),
              ),
              const SizedBox(height: 4),
              // Optional: Add a subtle line connecting timeline items
              Container(
                width: 1,
                height: 50, // Height to match the card height visually
                color: AppColors.stripedColor,
              ),
            ],
          ),
          const SizedBox(width: 16),
          // Dot and Card
          Column(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: activity.color,
                  border: Border.all(color: AppColors.cardColor, width: 2),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          // Activity Card
          Expanded(
            child: Card(
              color: AppColors.cardColor,
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      activity.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppColors.textColorPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      activity.description,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textColorSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
