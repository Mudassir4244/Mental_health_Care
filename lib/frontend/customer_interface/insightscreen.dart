// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:mental_healthcare/frontend/widgets/appcolors.dart';
// import 'package:mental_healthcare/frontend/widgets/widgets.dart';

// // --- Data Models ---
// class MoodMetric {
//   final String label;
//   final String value;
//   final IconData icon;
//   final Color color;

//   const MoodMetric({
//     required this.label,
//     required this.value,
//     required this.icon,
//     required this.color,
//   });
// }

// // --- Insights Screen ---
// class InsightsScreen extends StatelessWidget {
//   final String title = 'Insights';
//   const InsightsScreen({super.key});

//   final List<MoodMetric> metrics = const [
//     MoodMetric(
//       label: 'Avg. Mood Score',
//       value: '7.8/10',
//       icon: Icons.score,
//       color: AppColors.primary,
//     ),
//     MoodMetric(
//       label: 'Highest Emotion',
//       value: 'Happy (40%)',
//       icon: Icons.sentiment_satisfied_alt,
//       color: AppColors.primary,
//     ),
//     MoodMetric(
//       label: 'Low Mood Days',
//       value: '2 days',
//       icon: Icons.calendar_today,
//       color: AppColors.sectionTitleColor,
//     ),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     final isWide = MediaQuery.of(context).size.width > 500;

//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Stack(
//         children: [
//           SafeArea(
//             bottom: false,
//             child: Column(
//               children: [
//                 _CustomAppBar(title: title),
//                 Expanded(
//                   child: SingleChildScrollView(
//                     padding: EdgeInsets.symmetric(
//                       horizontal: MediaQuery.of(context).size.width * 0.05,
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const _ScreenBanner(
//                           title: 'Insights',
//                           subtitle: 'Your personalized mental wellness report.',
//                         ),
//                         const SizedBox(height: 20),

//                         const SectionTitle(title: 'Key Metrics'),
//                         const SizedBox(height: 12),
//                         MetricsGrid(
//                           metrics: [
//                             MoodMetric(
//                               label: 'Avg. Mood Score',
//                               value: '7.8/10',
//                               icon: Icons.score,
//                               color: AppColors.primary,
//                             ),
//                             MoodMetric(
//                               label: 'Highest Emotion',
//                               value: 'Happy (40%)',
//                               icon: Icons.sentiment_satisfied_alt,
//                               color: AppColors.primary,
//                             ),
//                             MoodMetric(
//                               label: 'Low Mood Days',
//                               value: '2 days',
//                               icon: Icons.calendar_today,
//                               color: AppColors.sectionTitleColor,
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 24),

//                         const SectionTitle(title: '7-Day Mood Trend'),
//                         const SizedBox(height: 12),
//                         const Insightscreen(),
//                         const SizedBox(height: 24),

//                         const SectionTitle(title: 'Suggestions'),
//                         const SizedBox(height: 12),
//                         const SuggestionCard(
//                           suggestion:
//                               'Try a 10-minute breathing exercise every morning to reduce baseline anxiety.',
//                           icon: Icons.self_improvement,
//                           color: AppColors.accent,
//                         ),
//                         const SizedBox(height: 100),
//                       ],
//                     ),
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

// // --- Custom App Bar ---
// class _CustomAppBar extends StatelessWidget {
//   final String title;
//   const _CustomAppBar({required this.title});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(left: 8.0, top: 8.0),
//       child: Align(
//         alignment: Alignment.centerLeft,
//         child: IconButton(
//           icon: const Icon(
//             Icons.arrow_back_ios,
//             color: AppColors.textColorPrimary,
//             size: 24,
//           ),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//     );
//   }
// }

// // --- Screen Banner ---
// class _ScreenBanner extends StatelessWidget {
//   final String title;
//   final String subtitle;

//   const _ScreenBanner({required this.title, required this.subtitle});

//   @override
//   Widget build(BuildContext context) {
//     final isWide = MediaQuery.of(context).size.width > 400;

//     return Container(
//       width: double.infinity,
//       padding: EdgeInsets.all(isWide ? 24.0 : 16.0),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [AppColors.primary, AppColors.accent],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: AppColors.primary.withOpacity(0.3),
//             blurRadius: 8,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             title,
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: isWide ? 26 : 22,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const SizedBox(height: 6),
//           Text(
//             subtitle,
//             style: TextStyle(
//               color: Colors.white.withOpacity(0.85),
//               fontSize: isWide ? 16 : 14,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // --- Section Title ---
// class SectionTitle extends StatelessWidget {
//   final String title;
//   const SectionTitle({super.key, required this.title});

//   @override
//   Widget build(BuildContext context) {
//     return Text(
//       title,
//       style: const TextStyle(
//         color: AppColors.sectionTitleColor,
//         fontSize: 18,
//         fontWeight: FontWeight.bold,
//       ),
//     );
//   }
// }

// // --- Metrics Grid ---
// class MetricsGrid extends StatelessWidget {
//   final List<MoodMetric> metrics;

//   const MetricsGrid({super.key, required this.metrics});

//   @override
//   Widget build(BuildContext context) {
//     final isWide = MediaQuery.of(context).size.width > 600;
//     return GridView.builder(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: isWide ? 4 : 2,
//         crossAxisSpacing: 12,
//         mainAxisSpacing: 12,
//         childAspectRatio: 1,
//       ),
//       itemCount: metrics.length,
//       itemBuilder: (context, index) {
//         final metric = metrics[index];
//         return Card(
//           color: AppColors.cardColor,
//           elevation: 3,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(15),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(12.0),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(metric.icon, color: metric.color, size: 30),
//                 const SizedBox(height: 8),
//                 Flexible(
//                   child: Text(
//                     metric.value,
//                     textAlign: TextAlign.center,
//                     overflow: TextOverflow.ellipsis,
//                     maxLines: 1,
//                     style: TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.bold,
//                       color: metric.color,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   metric.label,
//                   textAlign: TextAlign.center,
//                   style: const TextStyle(
//                     fontSize: 12,
//                     color: AppColors.textColorSecondary,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

// // --- Mood Trend Chart (Bar Graph) ---
// class Insightscreen extends StatelessWidget {
//   const Insightscreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final moodData = [8.5, 7.2, 6.8, 9.0, 7.5, 8.0, 7.8];
//     final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
//     final isWide = MediaQuery.of(context).size.width > 400;

//     return Card(
//       color: AppColors.cardColor,
//       elevation: 3,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//       child: Container(
//         padding: const EdgeInsets.all(16.0),
//         height: isWide ? 260 : 220,
//         child: BarChart(
//           BarChartData(
//             maxY: 10,
//             gridData: FlGridData(show: true, horizontalInterval: 2),
//             borderData: FlBorderData(show: false),
//             titlesData: FlTitlesData(
//               bottomTitles: AxisTitles(
//                 sideTitles: SideTitles(
//                   showTitles: true,
//                   getTitlesWidget: (value, meta) => Text(
//                     days[value.toInt()],
//                     style: const TextStyle(fontSize: 10),
//                   ),
//                 ),
//               ),
//               leftTitles: AxisTitles(
//                 sideTitles: SideTitles(showTitles: true, reservedSize: 30),
//               ),
//               topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
//               rightTitles: AxisTitles(
//                 sideTitles: SideTitles(showTitles: false),
//               ),
//             ),
//             barGroups: List.generate(moodData.length, (i) {
//               return BarChartGroupData(
//                 x: i,
//                 barRods: [
//                   BarChartRodData(
//                     toY: moodData[i],
//                     gradient: LinearGradient(
//                       colors: [
//                         AppColors.primary.withOpacity(0.8),
//                         AppColors.accent.withOpacity(0.9),
//                       ],
//                       begin: Alignment.bottomCenter,
//                       end: Alignment.topCenter,
//                     ),
//                     width: isWide ? 22 : 16,
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ],
//               );
//             }),
//           ),
//         ),
//       ),
//     );
//   }
// }

// // --- Suggestion Card ---
// class SuggestionCard extends StatelessWidget {
//   final String suggestion;
//   final IconData icon;
//   final Color color;

//   const SuggestionCard({
//     super.key,
//     required this.suggestion,
//     required this.icon,
//     required this.color,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       color: AppColors.cardColor,
//       elevation: 3,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(15),
//         side: BorderSide(color: color.withOpacity(0.5), width: 2),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Icon(icon, color: color, size: 30),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     'Actionable Tip',
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 16,
//                       color: AppColors.textColorPrimary,
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     suggestion,
//                     style: const TextStyle(
//                       fontSize: 14,
//                       color: AppColors.textColorSecondary,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mental_healthcare/activity_reminder.dart';
import 'package:mental_healthcare/frontend/widgets/appcolors.dart';

class Insightscreen extends StatefulWidget {
  const Insightscreen({super.key});

  @override
  State<Insightscreen> createState() => _InsightscreenState();
}

class _InsightscreenState extends State<Insightscreen> {
  List<MoodEntry> moodData = [];
  bool isLoading = true;

  // Mood emojis according to number
  final Map<int, String> moodEmojis = {
    1: "😡",
    2: "☹️",
    3: "😐",
    4: "🙂",
    5: "😊",
    6: "😂",
  };

  @override
  void initState() {
    super.initState();
    fetchMoodData();
  }

  Future<void> fetchMoodData() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection("moods")
          .where('userid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();

      moodData = snap.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return MoodEntry(
          date: (data["date"] as Timestamp).toDate(),
          moodNumber: data["mood number"],
          mood: data["mood"],
        );
      }).toList();

      // Sort by date
      moodData.sort((a, b) => a.date.compareTo(b.date));

      setState(() => isLoading = false);
    } catch (e) {
      print("Error loading mood data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.background,
            fontWeight: FontWeight.bold,
          ),
        ),
        title: const Text(
          "Mood Insights",
          style: TextStyle(
            color: AppColors.cardColor,
            fontWeight: FontWeight.bold,
          ),
        ),
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
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : moodData.isEmpty
            ? const Center(
                child: Text(
                  "No mood check-ins found.",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Mood Trend",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  ActivityReminderCountContainer(),
                  const SizedBox(height: 10),
                  // ---------------- SMALL GRAPH CARD ----------------
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    color: AppColors.cardColor,
                    elevation: 6,
                    child: SizedBox(
                      height: 300,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 25, left: 12),
                        child: BarChart(
                          BarChartData(
                            maxY: 6,
                            minY: 0,
                            gridData: FlGridData(
                              show: true,
                              horizontalInterval: 1,
                            ),
                            borderData: FlBorderData(show: false),

                            // ---------------- LEFT EMOJI + NUMBER AXIS ----------------
                            titlesData: FlTitlesData(
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 55,
                                  getTitlesWidget: (value, meta) {
                                    int val = value.toInt();
                                    if (val < 1 || val > 6) {
                                      return const SizedBox();
                                    }

                                    return Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          moodEmojis[val] ?? "",
                                          style: const TextStyle(fontSize: 30),
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          val.toString(),
                                          style: const TextStyle(
                                            fontSize: 15,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                              rightTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              topTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),

                              // ---------------- BOTTOM DATE LABELS ----------------
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) {
                                    int index = value.toInt();
                                    if (index < 0 || index >= moodData.length) {
                                      return const SizedBox();
                                    }
                                    return Text(
                                      DateFormat(
                                        'dd/MM',
                                      ).format(moodData[index].date),
                                      style: const TextStyle(fontSize: 10),
                                    );
                                  },
                                ),
                              ),
                            ),

                            // ---------------- BAR GROUPS ----------------
                            barGroups: List.generate(moodData.length, (index) {
                              final entry = moodData[index];
                              return BarChartGroupData(
                                x: index,
                                barRods: [
                                  BarChartRodData(
                                    toY: entry.moodNumber.toDouble(),
                                    width: 18,
                                    borderRadius: BorderRadius.circular(6),
                                    gradient: LinearGradient(
                                      colors: [
                                        AppColors.primary.withOpacity(0.8),
                                        AppColors.accent.withOpacity(0.9),
                                      ],
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                    ),
                                  ),
                                ],
                              );
                            }),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

// ----------------- MODEL -----------------
class MoodEntry {
  final DateTime date;
  final int moodNumber;
  final String mood;

  MoodEntry({required this.date, required this.moodNumber, required this.mood});
}
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:mental_healthcare/frontend/widgets/appcolors.dart';

// class Insightscreen extends StatefulWidget {
//   const Insightscreen({super.key});

//   @override
//   State<Insightscreen> createState() => _InsightscreenState();
// }

// class _InsightscreenState extends State<Insightscreen> {
//   List<MoodEntry> moodData = [];
//   bool isLoading = true;

//   // Mood emojis
//   final Map<int, String> moodEmojis = {
//     1: "😡",
//     2: "☹️",
//     3: "😐",
//     4: "🙂",
//     5: "😊",
//     6: "😂",
//   };

//   @override
//   void initState() {
//     super.initState();
//     fetchMoodData();
//   }

//   Future<void> fetchMoodData() async {
//     try {
//       QuerySnapshot snap = await FirebaseFirestore.instance
//           .collection("moods")
//           .where('userid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
//           .get();

//       moodData = snap.docs.map((doc) {
//         final data = doc.data() as Map<String, dynamic>;
//         return MoodEntry(
//           date: (data["date"] as Timestamp).toDate(),
//           moodNumber: data["mood number"],
//           mood: data["mood"],
//         );
//       }).toList();

//       moodData.sort((a, b) => a.date.compareTo(b.date));

//       setState(() => isLoading = false);
//     } catch (e) {
//       print("Error loading mood data: $e");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     double averageMood = moodData.isNotEmpty
//         ? moodData.map((e) => e.moodNumber).reduce((a, b) => a + b) /
//               moodData.length
//         : 0.0;

//     int roundedMood = averageMood.round();
//     String avgEmoji = moodEmojis[roundedMood] ?? "😐";

//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           icon: Icon(
//             Icons.arrow_back_ios_new,
//             color: AppColors.background,
//             size: 20,
//           ),
//         ),
//         title: const Text(
//           "Mood Insights",
//           style: TextStyle(
//             color: AppColors.cardColor,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         flexibleSpace: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [AppColors.primary, AppColors.accent],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//           ),
//         ),
//       ),
//       backgroundColor: AppColors.background,
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: isLoading
//             ? const Center(child: CircularProgressIndicator())
//             : moodData.isEmpty
//             ? const Center(
//                 child: Text(
//                   "No mood check-ins found.",
//                   style: TextStyle(fontSize: 16, color: Colors.grey),
//                 ),
//               )
//             : Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // ---------------- SUMMARY SECTION ----------------
//                   _buildSummarySection(averageMood, avgEmoji),

//                   const SizedBox(height: 20),

//                   // ---------------- REMINDER CONTAINER ----------------
//                   _buildReminderCard(),

//                   const SizedBox(height: 20),

//                   const Text(
//                     "Mood Trend",
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 10),

//                   // ---------------- GRAPH CARD ----------------
//                   _buildGraphCard(),
//                 ],
//               ),
//       ),
//     );
//   }

//   // SUMMARY CARD
//   Widget _buildSummarySection(double averageMood, String avgEmoji) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         // Total Check-ins
//         Container(
//           padding: const EdgeInsets.all(14),
//           width: 155,
//           decoration: BoxDecoration(
//             color: AppColors.cardColor,
//             borderRadius: BorderRadius.circular(16),
//             boxShadow: [
//               BoxShadow(color: Colors.black.withOpacity(.1), blurRadius: 5),
//             ],
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text(
//                 "Total Check-ins",
//                 style: TextStyle(fontSize: 14, color: Colors.white70),
//               ),
//               const SizedBox(height: 4),
//               Text(
//                 moodData.length.toString(),
//                 style: const TextStyle(
//                   fontSize: 26,
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ],
//           ),
//         ),

//         // Average Mood
//         Container(
//           padding: const EdgeInsets.all(14),
//           width: 155,
//           decoration: BoxDecoration(
//             color: AppColors.cardColor,
//             borderRadius: BorderRadius.circular(16),
//             boxShadow: [
//               BoxShadow(color: Colors.black.withOpacity(.1), blurRadius: 5),
//             ],
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text(
//                 "Average Mood",
//                 style: TextStyle(fontSize: 14, color: Colors.white70),
//               ),
//               const SizedBox(height: 4),
//               Row(
//                 children: [
//                   Text(avgEmoji, style: const TextStyle(fontSize: 28)),
//                   const SizedBox(width: 8),
//                   Text(
//                     averageMood.toStringAsFixed(1),
//                     style: const TextStyle(
//                       fontSize: 26,
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   // REMINDER CARD
//   Widget _buildReminderCard() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: AppColors.cardColor,
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Row(
//         children: [
//           const Icon(Icons.notifications_active, color: Colors.amber, size: 30),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Text(
//               "Don't forget to log your mood today!\nStay consistent for better insights.",
//               style: TextStyle(
//                 fontSize: 14,
//                 color: Colors.white.withOpacity(0.9),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // GRAPH CARD (unchanged)
//   Widget _buildGraphCard() {
//     return Card(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       color: AppColors.cardColor,
//       elevation: 3,
//       child: SizedBox(
//         height: 260,
//         child: Padding(
//           padding: const EdgeInsets.all(12.0),
//           child: BarChart(
//             BarChartData(
//               maxY: 6,
//               minY: 1,
//               gridData: FlGridData(show: true, horizontalInterval: 1),
//               borderData: FlBorderData(show: false),

//               // LEFT EMOJIS
//               titlesData: FlTitlesData(
//                 leftTitles: AxisTitles(
//                   sideTitles: SideTitles(
//                     showTitles: true,
//                     reservedSize: 55,
//                     getTitlesWidget: (value, meta) {
//                       int val = value.toInt();
//                       return val >= 1 && val <= 6
//                           ? Row(
//                               children: [
//                                 Text(
//                                   moodEmojis[val] ?? "",
//                                   style: const TextStyle(
//                                     fontSize: 20,
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                                 const SizedBox(width: 4),
//                                 Text(
//                                   val.toString(),
//                                   style: const TextStyle(
//                                     fontSize: 14,
//                                     color: Colors.white70,
//                                   ),
//                                 ),
//                               ],
//                             )
//                           : const SizedBox();
//                     },
//                   ),
//                 ),
//                 rightTitles: AxisTitles(
//                   sideTitles: SideTitles(showTitles: false),
//                 ),
//                 topTitles: AxisTitles(
//                   sideTitles: SideTitles(showTitles: false),
//                 ),
//                 bottomTitles: AxisTitles(
//                   sideTitles: SideTitles(
//                     showTitles: true,
//                     getTitlesWidget: (value, meta) {
//                       int index = value.toInt();
//                       if (index < 0 || index >= moodData.length) {
//                         return const SizedBox();
//                       }
//                       return Text(
//                         DateFormat('dd/MM').format(moodData[index].date),
//                         style: const TextStyle(
//                           fontSize: 10,
//                           color: Colors.white70,
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ),

//               // BARS
//               barGroups: List.generate(moodData.length, (index) {
//                 final entry = moodData[index];
//                 return BarChartGroupData(
//                   x: index,
//                   barRods: [
//                     BarChartRodData(
//                       toY: entry.moodNumber.toDouble(),
//                       width: 18,
//                       borderRadius: BorderRadius.circular(6),
//                       gradient: LinearGradient(
//                         colors: [
//                           AppColors.primary.withOpacity(0.8),
//                           AppColors.accent.withOpacity(0.9),
//                         ],
//                         begin: Alignment.bottomCenter,
//                         end: Alignment.topCenter,
//                       ),
//                     ),
//                   ],
//                 );
//               }),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// // MODEL
// class MoodEntry {
//   final DateTime date;
//   final int moodNumber;
//   final String mood;

//   MoodEntry({required this.date, required this.moodNumber, required this.mood});
// }
