import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class WeeklyMoodFrequencyGraph extends StatelessWidget {
  const WeeklyMoodFrequencyGraph({super.key});

  // 🔹 Get start of last 7 days (including today)
  DateTime get weekStart {
    final now = DateTime.now();
    return DateTime(
      now.year,
      now.month,
      now.day,
    ).subtract(const Duration(days: 6));
  }

  // 🔹 Mood colors
  Color _getMoodColor(String mood) {
    switch (mood.toLowerCase()) {
      case 'happy':
        return Colors.amber;
      case 'sad':
        return Colors.blue;
      case 'angry':
        return Colors.red;
      case 'anxious':
        return Colors.purple;
      case 'calm':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Weekly Mood Frequency')),
        body: const Center(child: Text('Please log in')),
      );
    }

    // 🔍 DEBUG: Print the query parameters
    print('🔍 DEBUG INFO:');
    print('User ID: $uid');
    print('Week Start: $weekStart');
    print('Query Date: ${Timestamp.fromDate(weekStart)}');

    return Scaffold(
      appBar: AppBar(title: const Text('Weekly Mood Frequency')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('moods')
            .where('userId', isEqualTo: uid)
            .where(
              'createdAt',
              isGreaterThanOrEqualTo: Timestamp.fromDate(weekStart),
            )
            .snapshots(),
        builder: (context, snapshot) {
          // 🔍 DEBUG: Print connection state
          print('Connection State: ${snapshot.connectionState}');

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // 🔍 DEBUG: Check for errors
          if (snapshot.hasError) {
            print('❌ Error: ${snapshot.error}');
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          // 🔍 DEBUG: Print document count
          print('Documents found: ${snapshot.data?.docs.length ?? 0}');

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            // 🔍 Let's also check without date filter
            return FutureBuilder<QuerySnapshot>(
              future: FirebaseFirestore.instance
                  .collection('moods')
                  .where('userId', isEqualTo: uid)
                  .get(),
              builder: (context, allSnapshot) {
                if (allSnapshot.hasData) {
                  print(
                    '📊 Total moods for user (all time): ${allSnapshot.data!.docs.length}',
                  );

                  // Print details of each mood
                  for (var doc in allSnapshot.data!.docs) {
                    print('Mood: ${doc['mood']}, Created: ${doc['createdAt']}');
                  }
                }

                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('No mood data this week'),
                      const SizedBox(height: 16),
                      Text(
                        'Total moods: ${allSnapshot.data?.docs.length ?? 0}',
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () {
                          print('Check console for debug info');
                        },
                        child: const Text('Check Debug Info'),
                      ),
                    ],
                  ),
                );
              },
            );
          }

          // 🔹 Count frequency
          final Map<String, int> moodCounts = {};

          for (var doc in snapshot.data!.docs) {
            final mood = doc['mood'] as String;
            moodCounts[mood] = (moodCounts[mood] ?? 0) + 1;
            print('Processing mood: $mood, Count: ${moodCounts[mood]}');
          }

          print('Final mood counts: $moodCounts');

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // 🔍 Show debug info
                Container(
                  padding: const EdgeInsets.all(8),
                  color: Colors.grey[200],
                  child: Text(
                    'Showing ${snapshot.data!.docs.length} moods from ${weekStart.toString().split(' ')[0]}',
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      barGroups: _buildBars(moodCounts),
                      titlesData: _buildTitles(moodCounts),
                      borderData: FlBorderData(show: false),
                      gridData: const FlGridData(
                        show: true,
                        drawVerticalLine: false,
                      ),
                      barTouchData: BarTouchData(
                        touchTooltipData: BarTouchTooltipData(
                          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                            final moods = moodCounts.keys.toList();
                            return BarTooltipItem(
                              '${moods[group.x.toInt()]}\n${rod.toY.toInt()}',
                              const TextStyle(color: Colors.white),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // 🔹 Build bars with colors
  List<BarChartGroupData> _buildBars(Map<String, int> data) {
    int index = 0;
    return data.entries.map((entry) {
      return BarChartGroupData(
        x: index++,
        barRods: [
          BarChartRodData(
            toY: entry.value.toDouble(),
            width: 20,
            color: _getMoodColor(entry.key),
            borderRadius: BorderRadius.circular(6),
          ),
        ],
      );
    }).toList();
  }

  // 🔹 Bottom titles (mood names)
  FlTitlesData _buildTitles(Map<String, int> data) {
    return FlTitlesData(
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 40,
          getTitlesWidget: (value, meta) {
            return Text(
              value.toInt().toString(),
              style: const TextStyle(fontSize: 12),
            );
          },
        ),
      ),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 40,
          getTitlesWidget: (value, meta) {
            final moods = data.keys.toList();
            if (value.toInt() >= moods.length) return const SizedBox();
            return Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                moods[value.toInt()],
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
