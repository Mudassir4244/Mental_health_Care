// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class ActivityReminderCountContainer extends StatefulWidget {
//   const ActivityReminderCountContainer({super.key});

//   @override
//   State<ActivityReminderCountContainer> createState() =>
//       _ActivityReminderCountContainerState();
// }

// class _ActivityReminderCountContainerState
//     extends State<ActivityReminderCountContainer> {
//   int activitiesCount = 0;
//   int remindersCount = 0;
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     fetchCounts();
//   }

//   Future<void> fetchCounts() async {
//     final uid = FirebaseAuth.instance.currentUser!.uid;

//     try {
//       /// Fetch Activities count
//       final activitiesSnapshot = await FirebaseFirestore.instance
//           .collection("Impresions")
//           .doc(uid)
//           .collection("activities")
//           .get();

//       /// Fetch Reminders count
//       final remindersSnapshot = await FirebaseFirestore.instance
//           .collection("Impresions")
//           .doc(uid)
//           .collection("reminders")
//           .get();

//       setState(() {
//         activitiesCount = activitiesSnapshot.docs.length;
//         remindersCount = remindersSnapshot.docs.length;
//         isLoading = false;
//       });
//     } catch (e) {
//       print("Error fetching counts: $e");
//       setState(() => isLoading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
//       ),
//       child: isLoading
//           ? Center(child: CircularProgressIndicator())
//           : Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   "Your Stats",
//                   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                 ),

//                 SizedBox(height: 12),

//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     _buildInfoCard("Activities", activitiesCount),
//                     _buildInfoCard("Reminders", remindersCount),
//                   ],
//                 ),
//               ],
//             ),
//     );
//   }

//   /// small box for count
//   Widget _buildInfoCard(String title, int count) {
//     return Container(
//       width: 140,
//       padding: EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.blue.shade100,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Column(
//         children: [
//           Text(
//             title,
//             style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//           ),
//           SizedBox(height: 8),
//           Text(
//             count.toString(),
//             style: TextStyle(
//               fontSize: 28,
//               fontWeight: FontWeight.bold,
//               color: Colors.blue.shade700,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class ActivityReminderCountContainer extends StatefulWidget {
  const ActivityReminderCountContainer({super.key});

  @override
  State<ActivityReminderCountContainer> createState() =>
      _ActivityReminderCountContainerState();
}

class _ActivityReminderCountContainerState
    extends State<ActivityReminderCountContainer> {
  int activitiesCount = 0;
  int remindersCount = 0;
  bool isLoading = true;

  // Data for line chart (last 7 days)
  List<ChartDataPoint> activitiesData = [];
  List<ChartDataPoint> remindersData = [];

  @override
  void initState() {
    super.initState();
    fetchCounts();
  }

  Future<void> fetchCounts() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    try {
      // Fetch Activities
      final activitiesSnapshot = await FirebaseFirestore.instance
          .collection("Impresions")
          .doc(uid)
          .collection("activities")
          .get();

      // Fetch Reminders
      final remindersSnapshot = await FirebaseFirestore.instance
          .collection("Impresions")
          .doc(uid)
          .collection("reminders")
          .get();

      // Process activities for line chart
      List<ActivityEntry> activities = activitiesSnapshot.docs.map((doc) {
        final data = doc.data();
        return ActivityEntry(
          timestamp: data['timestamp'] != null
              ? (data['timestamp'] as Timestamp).toDate()
              : DateTime.now(),
        );
      }).toList();

      // Process reminders for line chart
      List<ActivityEntry> reminders = remindersSnapshot.docs.map((doc) {
        final data = doc.data();
        return ActivityEntry(
          timestamp: data['timestamp'] != null
              ? (data['timestamp'] as Timestamp).toDate()
              : DateTime.now(),
        );
      }).toList();

      // Generate chart data for last 7 days
      activitiesData = _generateChartData(activities);
      remindersData = _generateChartData(reminders);

      setState(() {
        activitiesCount = activitiesSnapshot.docs.length;
        remindersCount = remindersSnapshot.docs.length;
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching counts: $e");
      setState(() => isLoading = false);
    }
  }

  List<ChartDataPoint> _generateChartData(List<ActivityEntry> entries) {
    final now = DateTime.now();
    final List<ChartDataPoint> chartData = [];

    // Generate data for last 7 days
    for (int i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final dayStart = DateTime(date.year, date.month, date.day);
      final dayEnd = dayStart.add(const Duration(days: 1));

      // Count entries for this day
      final count = entries.where((entry) {
        return entry.timestamp.isAfter(dayStart) &&
            entry.timestamp.isBefore(dayEnd);
      }).length;

      chartData.add(ChartDataPoint(date: dayStart, count: count));
    }

    return chartData;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: isLoading
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(40),
                child: CircularProgressIndicator(),
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Your Stats",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.blue.shade200,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 14,
                            color: Colors.blue.shade700,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "Last 7 Days",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.blue.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Summary Cards
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoCard(
                        "Activities",
                        activitiesCount,
                        Icons.fitness_center,
                        Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildInfoCard(
                        "Reminders",
                        remindersCount,
                        Icons.notifications_active,
                        Colors.orange,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Line Chart Section
                const Text(
                  "Weekly Trend",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Track your activities and reminders over time",
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
                const SizedBox(height: 16),

                // Chart
                Container(
                  height: 200,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200, width: 1),
                  ),
                  child: _buildLineChart(),
                ),

                const SizedBox(height: 12),

                // Legend
                _buildLegend(),
              ],
            ),
    );
  }

  Widget _buildInfoCard(String title, int count, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withValues(alpha: 0.1), color.withValues(alpha: 0.05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.2), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 24),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "Total",
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            count.toString(),
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: color,
              height: 1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLineChart() {
    // Calculate max Y value
    int maxActivities = activitiesData.fold(
      0,
      (max, point) => point.count > max ? point.count : max,
    );
    int maxReminders = remindersData.fold(
      0,
      (max, point) => point.count > max ? point.count : max,
    );
    double maxY = (maxActivities > maxReminders ? maxActivities : maxReminders)
        .toDouble();

    // Add padding to maxY
    maxY = maxY < 5 ? 5 : maxY + 2;

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: maxY > 10 ? 2 : 1,
          getDrawingHorizontalLine: (value) {
            return FlLine(color: Colors.grey.shade300, strokeWidth: 1);
          },
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 35,
              interval: maxY > 10 ? 2 : 1,
              getTitlesWidget: (value, meta) {
                if (value == meta.max || value == meta.min) {
                  return const SizedBox();
                }
                return Text(
                  value.toInt().toString(),
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: (value, meta) {
                int index = value.toInt();
                if (index < 0 || index >= activitiesData.length) {
                  return const SizedBox();
                }

                // Show only every other day if needed
                if (activitiesData.length > 5 && index % 2 != 0) {
                  return const SizedBox();
                }

                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    DateFormat('E').format(activitiesData[index].date),
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              },
            ),
          ),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border(
            bottom: BorderSide(color: Colors.grey.shade300, width: 1),
            left: BorderSide(color: Colors.grey.shade300, width: 1),
          ),
        ),
        minX: 0,
        maxX: (activitiesData.length - 1).toDouble(),
        minY: 0,
        maxY: maxY,
        lineTouchData: LineTouchData(
          enabled: true,
          touchTooltipData: LineTouchTooltipData(
            tooltipPadding: const EdgeInsets.all(8),
            tooltipMargin: 8,
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                final date = spot.barIndex < activitiesData.length
                    ? activitiesData[spot.barIndex].date
                    : DateTime.now();
                final isActivities =
                    spot.barIndex == 0 ||
                    (spot.barIndex < activitiesData.length &&
                        spot.y ==
                            activitiesData[spot.barIndex].count.toDouble());

                return LineTooltipItem(
                  '${DateFormat('MMM d').format(date)}\n${spot.y.toInt()} ${isActivities ? "Activities" : "Reminders"}',
                  TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                );
              }).toList();
            },
          ),
        ),
        lineBarsData: [
          // Activities Line
          LineChartBarData(
            spots: activitiesData
                .asMap()
                .entries
                .map((e) => FlSpot(e.key.toDouble(), e.value.count.toDouble()))
                .toList(),
            isCurved: true,
            curveSmoothness: 0.3,
            color: Colors.blue,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 4,
                  color: Colors.white,
                  strokeWidth: 2,
                  strokeColor: Colors.blue,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  Colors.blue.withValues(alpha: 0.3),
                  Colors.blue.withValues(alpha: 0.05),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          // Reminders Line
          LineChartBarData(
            spots: remindersData
                .asMap()
                .entries
                .map((e) => FlSpot(e.key.toDouble(), e.value.count.toDouble()))
                .toList(),
            isCurved: true,
            curveSmoothness: 0.3,
            color: Colors.orange,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 4,
                  color: Colors.white,
                  strokeWidth: 2,
                  strokeColor: Colors.orange,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  Colors.orange.withValues(alpha: 0.3),
                  Colors.orange.withValues(alpha: 0.05),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildLegendItem("Activities", Colors.blue),
        const SizedBox(width: 20),
        _buildLegendItem("Reminders", Colors.orange),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 3,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }
}

// Helper Classes
class ActivityEntry {
  final DateTime timestamp;

  ActivityEntry({required this.timestamp});
}

class ChartDataPoint {
  final DateTime date;
  final int count;

  ChartDataPoint({required this.date, required this.count});
}
