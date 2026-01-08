// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'dart:math';
// import 'package:mental_healthcare/activity_reminder.dart';
// import 'package:mental_healthcare/frontend/widgets/appcolors.dart';

// class Insightscreen extends StatefulWidget {
//   const Insightscreen({super.key});

//   @override
//   State<Insightscreen> createState() => _InsightscreenState();
// }

// class _InsightscreenState extends State<Insightscreen> {
//   List<MoodEntry> moodData = [];
//   bool isLoading = true;

//   // Mood emojis according to number (Matches Check-In Screen)
//   final Map<int, String> moodEmojis = {
//     1: "😡", // Angry
//     2: "😫", // Stressed
//     3: "😢", // Sad
//     4: "😐", // Okay
//     5: "😊", // Good
//     6: "🤩", // Happy
//   };

//   // Data for Quotes and Suggestions
//   final Map<String, List<String>> _moodQuotes = {
//     "low": [
//       "This too shall pass. It might pass like a kidney stone, but it will pass.",
//       "It’s okay not to be okay as long as you are not giving up.",
//       "Hardships often prepare ordinary people for an extraordinary destiny.",
//       "Breathe. It’s just a bad day, not a bad life.",
//       "You don’t have to control your thoughts. You just have to stop letting them control you.",
//       "Recovery is not a straight line.",
//       "Your feelings are valid, but they are not your identity.",
//       "Be gentle with yourself. You are doing the best you can.",
//       "You are braver than you believe, stronger than you seem, and smarter than you think.",
//       "Tough times never last, but tough people do.",
//     ],
//     "sad": [
//       "Stars can't shine without darkness.",
//       "Happiness can be found even in the darkest of times, if one only remembers to turn on the light.",
//       "You are stronger than you know.",
//       "Every day may not be good, but there is something good in every day.",
//       "Keep your face always toward the sunshine—and shadows will fall behind you.",
//       "The sun is a daily reminder that we too can rise again from the darkness, that we too can shine our own light.",
//       "Embrace the glorious mess that you are.",
//       "Healing takes time, and asking for help is a courageous step.",
//       "Sadness flies away on the wings of time.",
//       "Turn your wounds into wisdom.",
//     ],
//     "okay": [
//       "Peace comes from within. Do not seek it without.",
//       "A calm mind brings inner strength and self-confidence.",
//       "Simplicity is the ultimate sophistication.",
//       "Life is a balance of holding on and letting go.",
//       "Present moment. Wonderful moment.",
//       "Do what you can, with what you have, where you are.",
//       "The best preparation for tomorrow is doing your best today.",
//       "Every moment is a fresh beginning.",
//       "Act as if what you do makes a difference. It does.",
//       "Success is not the key to happiness. Happiness is the key to success.",
//     ],
//     "happy": [
//       "Don't count the days, make the days count.",
//       "The best way to pay for a lovely moment is to enjoy it.",
//       "Happiness is not something ready made. It comes from your own actions.",
//       "Spread love everywhere you go.",
//       "Your positive action combined with positive thinking results in success.",
//       "Count your age by friends, not years. Count your life by smiles, not tears.",
//       "Let your smile change the world, but don't let the world change your smile.",
//       "Be the change that you wish to see in the world.",
//       "The only way to do great work is to love what you do.",
//       "Joy is a net of love by which you can catch souls.",
//     ],
//   };

//   final Map<String, List<String>> _moodSuggestions = {
//     "low": [
//       "Try to take a 5-minute walk outside. Fresh air can help reset your mind.",
//       "Practice 4-7-8 breathing: Inhale for 4, hold for 7, exhale for 8.",
//       "Write down 3 things that are bothering you, then tear up the paper.",
//       "Drink a glass of water and stretch your body.",
//       "Reach out to a friend or loved one just to say hello.",
//       "Avoid social media for an hour to reduce noise.",
//       "Take a warm shower or bath to relax your muscles.",
//     ],
//     "sad": [
//       "Listen to your favorite comfort music.",
//       "Watch a funny video or a clip from your favorite movie.",
//       "Treat yourself to a warm beverage.",
//       "Write down one thing you are grateful for today.",
//       "Do a small act of kindness for someone else.",
//       "Allow yourself to cry if you need to; it releases stress hormones.",
//       "Cuddle with a pet or a soft pillow.",
//     ],
//     "okay": [
//       "Try a 10-minute meditation session.",
//       "Read a chapter of a book you've been meaning to start.",
//       "Organize a small area of your room or desk.",
//       "Plan a fun activity for the weekend.",
//       "Reflect on your goals for the next month.",
//       "Cook a healthy meal for yourself.",
//       "Listen to an inspiring podcast.",
//     ],
//     "happy": [
//       "Share your positive energy with a friend.",
//       "Write down a success you had today.",
//       "Take a moment to appreciate the beauty around you.",
//       "Start a new hobby or project you're excited about.",
//       "Give a compliment to a stranger.",
//       "Take a photo of something that makes you smile.",
//       "Write a thank-you note to someone who helped you.",
//     ],
//   };

//   double averageMood = 0.0;
//   String topEmotion = "None";
//   int lowMoodCount = 0;

//   String motivationalQuote = "Loading positive vibes...";
//   String wellnessSuggestion = "Gathering wellness tips...";

//   @override
//   void initState() {
//     super.initState();
//     fetchMoodData();
//   }

//   Future<void> fetchMoodData() async {
//     try {
//       final uid = FirebaseAuth.instance.currentUser?.uid;
//       if (uid == null) return;

//       // Fetch all moods for the user
//       // Note: We perform client-side sorting to avoid requiring a composite index
//       // on (userid, date) in Firestore.
//       QuerySnapshot snap = await FirebaseFirestore.instance
//           .collection("moods")
//           .where('userid', isEqualTo: uid)
//           .get();

//       final now = DateTime.now();
//       // Calculate 7 days ago (start of that day)
//       final sevenDaysAgo = now.subtract(const Duration(days: 7));

//       List<MoodEntry> allEntries = snap.docs.map((doc) {
//         final data = doc.data() as Map<String, dynamic>;
//         return MoodEntry(
//           date: (data["date"] as Timestamp).toDate(),
//           moodNumber: (data["mood number"] as num).toInt(),
//           mood: data["mood"].toString(),
//           note: data["note"]?.toString() ?? "",
//         );
//       }).toList();

//       // Sort by date (Oldest -> Newest)
//       allEntries.sort((a, b) => a.date.compareTo(b.date));

//       // Filter: Keep only entries from the last 7 days
//       moodData = allEntries.where((entry) {
//         return entry.date.isAfter(sevenDaysAgo);
//       }).toList();

//       _calculateStats();
//       _updateMotivation();

//       setState(() => isLoading = false);
//     } catch (e) {
//       print("Error loading mood data: $e");
//       if (mounted) setState(() => isLoading = false);
//     }
//   }

//   void _calculateStats() {
//     if (moodData.isEmpty) {
//       averageMood = 0.0;
//       topEmotion = "None";
//       lowMoodCount = 0;
//       return;
//     }

//     // 1. Average Mood
//     double sum = moodData.fold(0, (prev, e) => prev + e.moodNumber);
//     averageMood = sum / moodData.length;

//     // 2. Low Mood Days (Score <= 3)
//     // Count unique days where mood was low
//     final lowMoodEntries = moodData.where((e) => e.moodNumber <= 3);
//     final uniqueLowDays = lowMoodEntries
//         .map((e) => DateTime(e.date.year, e.date.month, e.date.day))
//         .toSet();
//     lowMoodCount = uniqueLowDays.length;

//     // 3. Highest Emotion (Mode)
//     Map<String, int> freq = {};
//     for (var m in moodData) {
//       freq[m.mood] = (freq[m.mood] ?? 0) + 1;
//     }

//     // Sort by frequency descending
//     var sorted = freq.entries.toList()
//       ..sort((a, b) => b.value.compareTo(a.value));

//     if (sorted.isNotEmpty) {
//       topEmotion = "${sorted.first.key} (${sorted.first.value})";
//     }
//   }

//   void _updateMotivation() {
//     // Determine category based on averageMood
//     String category;
//     if (averageMood < 2.5) {
//       category = "low";
//     } else if (averageMood < 3.5) {
//       category = "sad";
//     } else if (averageMood < 4.5) {
//       category = "okay";
//     } else {
//       category = "happy";
//     }

//     final random = Random();

//     // Select random quote
//     final quotes = _moodQuotes[category] ?? _moodQuotes["okay"]!;
//     motivationalQuote = quotes[random.nextInt(quotes.length)];

//     // Select random suggestion
//     final suggestions = _moodSuggestions[category] ?? _moodSuggestions["okay"]!;
//     wellnessSuggestion = suggestions[random.nextInt(suggestions.length)];
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.background,
//       appBar: AppBar(
//         leading: IconButton(
//           onPressed: () => Navigator.pop(context),
//           icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
//         ),
//         title: const Text(
//           "Mood Insights",
//           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: isLoading
//             ? const Center(child: CircularProgressIndicator())
//             : moodData.isEmpty
//             ? const Center(
//                 child: Text(
//                   "No mood entries in the last 7 days.",
//                   style: TextStyle(fontSize: 16, color: Colors.grey),
//                 ),
//               )
//             : SingleChildScrollView(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       "Last 7 Days Mood Trend",
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 5),
//                     Text(
//                       "See how your mood has changed over the past week.",
//                       style: TextStyle(fontSize: 14, color: Colors.grey[600]),
//                     ),
//                     const SizedBox(height: 20),

//                     // ---------------- STATS GRID ----------------
//                     _buildStatsGrid(),

//                     const SizedBox(height: 20),

//                     // ---------------- MOTIVATION CARD ----------------
//                     _buildMotivationCard(),

//                     const SizedBox(height: 20),

//                     // ---------------- GRAPH CARD ----------------
//                     Card(
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       color: AppColors.cardColor,
//                       elevation: 4,
//                       child: Padding(
//                         padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
//                         child: AspectRatio(
//                           aspectRatio: 1.4,
//                           child: _buildChart(),
//                         ),
//                       ),
//                     ),

//                     const SizedBox(height: 25),
//                     ActivityReminderCountContainer(),
//                   ],
//                 ),
//               ),
//       ),
//     );
//   }

//   Widget _buildStatsGrid() {
//     return GridView.count(
//       crossAxisCount: 3,
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       crossAxisSpacing: 10,
//       mainAxisSpacing: 10,
//       childAspectRatio: 0.85,
//       children: [
//         _statCard(
//           "Avg. Mood",
//           averageMood.toStringAsFixed(1),
//           Icons.speed,
//           Colors.blue,
//         ),
//         _statCard("Top Mood", topEmotion, Icons.emoji_emotions, Colors.orange),
//         _statCard("Low Days", "$lowMoodCount days", Icons.cloud, Colors.grey),
//       ],
//     );
//   }

//   Widget _buildMotivationCard() {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [
//             AppColors.primary.withValues(alpha: 0.1),
//             AppColors.accent.withValues(alpha: 0.1),
//           ],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(
//           color: AppColors.primary.withValues(alpha: 0.2),
//           width: 1,
//         ),
//       ),
//       child: Column(
//         children: [
//           Row(
//             children: [
//               Icon(Icons.lightbulb, color: Colors.amber[700], size: 24),
//               const SizedBox(width: 8),
//               const Text(
//                 "Daily Inspiration",
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black87,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 12),
//           Text(
//             "\"$motivationalQuote\"",
//             textAlign: TextAlign.center,
//             style: const TextStyle(
//               fontSize: 16,
//               fontStyle: FontStyle.italic,
//               color: Colors.black87,
//               height: 1.4,
//             ),
//           ),
//           const SizedBox(height: 12),
//           Divider(color: Colors.grey.withValues(alpha: 0.2)),
//           const SizedBox(height: 8),
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Icon(Icons.spa, color: Colors.green[600], size: 20),
//               const SizedBox(width: 8),
//               Expanded(
//                 child: Text(
//                   "Tip: $wellnessSuggestion",
//                   style: TextStyle(
//                     fontSize: 14,
//                     color: Colors.grey[800],
//                     height: 1.3,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _statCard(String title, String value, IconData icon, Color color) {
//     return Container(
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: AppColors.cardColor,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withValues(alpha: 0.1),
//             blurRadius: 6,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(icon, color: color, size: 28),
//           const SizedBox(height: 8),
//           Text(
//             value,
//             textAlign: TextAlign.center,
//             style: const TextStyle(
//               fontSize: 14,
//               fontWeight: FontWeight.bold,
//               color: Colors.black87,
//             ),
//           ),
//           const SizedBox(height: 4),
//           Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
//         ],
//       ),
//     );
//   }

//   Widget _buildChart() {
//     return BarChart(
//       BarChartData(
//         alignment: BarChartAlignment.spaceAround,
//         maxY: 6.5,
//         minY: 0,
//         barTouchData: BarTouchData(
//           enabled: true,
//           touchTooltipData: BarTouchTooltipData(
//             tooltipPadding: const EdgeInsets.all(8),
//             tooltipMargin: 8,
//             getTooltipItem: (group, groupIndex, rod, rodIndex) {
//               final entry = moodData[group.x.toInt()];
//               return BarTooltipItem(
//                 "${entry.mood}\n",
//                 const TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 14,
//                 ),
//                 children: [
//                   TextSpan(
//                     text: DateFormat('h:mm a').format(entry.date),
//                     style: const TextStyle(
//                       color: Colors.white70,
//                       fontSize: 12,
//                       fontWeight: FontWeight.normal,
//                     ),
//                   ),
//                   if (entry.note.isNotEmpty)
//                     TextSpan(
//                       text: "\nNote: ${entry.note}",
//                       style: const TextStyle(
//                         color: Colors.white70,
//                         fontSize: 11,
//                         fontStyle: FontStyle.italic,
//                       ),
//                     ),
//                 ],
//               );
//             },
//           ),
//         ),
//         gridData: FlGridData(
//           show: true,
//           drawVerticalLine: false,
//           horizontalInterval: 1,
//           getDrawingHorizontalLine: (value) {
//             return FlLine(
//               color: Colors.grey.withValues(alpha: 0.1),
//               strokeWidth: 1,
//             );
//           },
//         ),
//         borderData: FlBorderData(show: false),
//         titlesData: FlTitlesData(
//           bottomTitles: AxisTitles(
//             sideTitles: SideTitles(
//               showTitles: true,
//               getTitlesWidget: (value, meta) {
//                 int index = value.toInt();
//                 if (index < 0 || index >= moodData.length) {
//                   return const SizedBox();
//                 }
//                 // Avoid overcrowding if too many data points
//                 if (moodData.length > 10 && index % 2 != 0) {
//                   return const SizedBox();
//                 }

//                 return Padding(
//                   padding: const EdgeInsets.only(top: 8.0),
//                   child: Text(
//                     DateFormat('d/M').format(moodData[index].date),
//                     style: const TextStyle(
//                       fontSize: 10,
//                       color: Colors.grey,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 );
//               },
//               reservedSize: 30,
//             ),
//           ),
//           leftTitles: AxisTitles(
//             sideTitles: SideTitles(
//               showTitles: true,
//               reservedSize: 40,
//               interval: 1,
//               getTitlesWidget: (value, meta) {
//                 // Ensure we only render for integer values to avoid duplicates
//                 // (e.g. preventing 6.5 from rounding to 6 and showing twice)
//                 if ((value - value.round()).abs() > 0.01) {
//                   return const SizedBox();
//                 }

//                 int val = value.round();
//                 if (val < 1 || val > 6) return const SizedBox();
//                 return Center(
//                   child: Text(
//                     moodEmojis[val] ?? "",
//                     style: const TextStyle(fontSize: 22),
//                   ),
//                 );
//               },
//             ),
//           ),
//           topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
//           rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
//         ),
//         barGroups: moodData.asMap().entries.map((e) {
//           int index = e.key;
//           MoodEntry entry = e.value;
//           return BarChartGroupData(
//             x: index,
//             barRods: [
//               BarChartRodData(
//                 toY: entry.moodNumber.toDouble(),
//                 gradient: LinearGradient(
//                   colors: [
//                     _getColor(entry.moodNumber).withValues(alpha: 0.6),
//                     _getColor(entry.moodNumber),
//                   ],
//                   begin: Alignment.bottomCenter,
//                   end: Alignment.topCenter,
//                 ),
//                 width: 16,
//                 borderRadius: const BorderRadius.vertical(
//                   top: Radius.circular(8),
//                 ),
//                 backDrawRodData: BackgroundBarChartRodData(
//                   show: true,
//                   toY: 6.5,
//                   color: Colors.grey.withValues(alpha: 0.05),
//                 ),
//               ),
//             ],
//           );
//         }).toList(),
//       ),
//     );
//   }

//   Color _getColor(int score) {
//     switch (score) {
//       case 6: // Happy
//         return Colors.green;
//       case 5: // Good
//         return Colors.lightBlue;
//       case 4: // Okay
//         return Colors.blueGrey;
//       case 3: // Sad
//         return Colors.purple;
//       case 2: // Stressed
//         return Colors.orange;
//       case 1: // Angry
//         return Colors.red;
//       default:
//         return AppColors.primary;
//     }
//   }
// }

// class MoodEntry {
//   final DateTime date;
//   final int moodNumber;
//   final String mood;
//   final String note;

//   MoodEntry({
//     required this.date,
//     required this.moodNumber,
//     required this.mood,
//     required this.note,
//   });
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';
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

  // Mood emojis according to number (Matches Check-In Screen)
  final Map<int, String> moodEmojis = {
    1: "😡", // Angry
    2: "😫", // Stressed
    3: "😢", // Sad
    4: "😐", // Okay
    5: "😊", // Good
    6: "🤩", // Happy
  };

  // Data for Quotes and Suggestions
  final Map<String, List<String>> _moodQuotes = {
    "low": [
      "This too shall pass. It might pass like a kidney stone, but it will pass.",
      "It's okay not to be okay as long as you are not giving up.",
      "Hardships often prepare ordinary people for an extraordinary destiny.",
      "Breathe. It's just a bad day, not a bad life.",
      "You don't have to control your thoughts. You just have to stop letting them control you.",
      "Recovery is not a straight line.",
      "Your feelings are valid, but they are not your identity.",
      "Be gentle with yourself. You are doing the best you can.",
      "You are braver than you believe, stronger than you seem, and smarter than you think.",
      "Tough times never last, but tough people do.",
    ],
    "sad": [
      "Stars can't shine without darkness.",
      "Happiness can be found even in the darkest of times, if one only remembers to turn on the light.",
      "You are stronger than you know.",
      "Every day may not be good, but there is something good in every day.",
      "Keep your face always toward the sunshine—and shadows will fall behind you.",
      "The sun is a daily reminder that we too can rise again from the darkness, that we too can shine our own light.",
      "Embrace the glorious mess that you are.",
      "Healing takes time, and asking for help is a courageous step.",
      "Sadness flies away on the wings of time.",
      "Turn your wounds into wisdom.",
    ],
    "okay": [
      "Peace comes from within. Do not seek it without.",
      "A calm mind brings inner strength and self-confidence.",
      "Simplicity is the ultimate sophistication.",
      "Life is a balance of holding on and letting go.",
      "Present moment. Wonderful moment.",
      "Do what you can, with what you have, where you are.",
      "The best preparation for tomorrow is doing your best today.",
      "Every moment is a fresh beginning.",
      "Act as if what you do makes a difference. It does.",
      "Success is not the key to happiness. Happiness is the key to success.",
    ],
    "happy": [
      "Don't count the days, make the days count.",
      "The best way to pay for a lovely moment is to enjoy it.",
      "Happiness is not something ready made. It comes from your own actions.",
      "Spread love everywhere you go.",
      "Your positive action combined with positive thinking results in success.",
      "Count your age by friends, not years. Count your life by smiles, not tears.",
      "Let your smile change the world, but don't let the world change your smile.",
      "Be the change that you wish to see in the world.",
      "The only way to do great work is to love what you do.",
      "Joy is a net of love by which you can catch souls.",
    ],
  };

  final Map<String, List<String>> _moodSuggestions = {
    "low": [
      "Try to take a 5-minute walk outside. Fresh air can help reset your mind.",
      "Practice 4-7-8 breathing: Inhale for 4, hold for 7, exhale for 8.",
      "Write down 3 things that are bothering you, then tear up the paper.",
      "Drink a glass of water and stretch your body.",
      "Reach out to a friend or loved one just to say hello.",
      "Avoid social media for an hour to reduce noise.",
      "Take a warm shower or bath to relax your muscles.",
    ],
    "sad": [
      "Listen to your favorite comfort music.",
      "Watch a funny video or a clip from your favorite movie.",
      "Treat yourself to a warm beverage.",
      "Write down one thing you are grateful for today.",
      "Do a small act of kindness for someone else.",
      "Allow yourself to cry if you need to; it releases stress hormones.",
      "Cuddle with a pet or a soft pillow.",
    ],
    "okay": [
      "Try a 10-minute meditation session.",
      "Read a chapter of a book you've been meaning to start.",
      "Organize a small area of your room or desk.",
      "Plan a fun activity for the weekend.",
      "Reflect on your goals for the next month.",
      "Cook a healthy meal for yourself.",
      "Listen to an inspiring podcast.",
    ],
    "happy": [
      "Share your positive energy with a friend.",
      "Write down a success you had today.",
      "Take a moment to appreciate the beauty around you.",
      "Start a new hobby or project you're excited about.",
      "Give a compliment to a stranger.",
      "Take a photo of something that makes you smile.",
      "Write a thank-you note to someone who helped you.",
    ],
  };

  double averageMood = 0.0;
  String topEmotion = "None";
  int lowMoodCount = 0;

  String motivationalQuote = "Loading positive vibes...";
  String wellnessSuggestion = "Gathering wellness tips...";

  // Pie chart data
  Map<String, int> moodDistribution = {};
  int touchedIndex = -1;

  @override
  void initState() {
    super.initState();
    fetchMoodData();
  }

  Future<void> fetchMoodData() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return;

      // Fetch all moods for the user
      // Note: We perform client-side sorting to avoid requiring a composite index
      // on (userid, date) in Firestore.
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection("moods")
          .where('userid', isEqualTo: uid)
          .get();

      final now = DateTime.now();
      // Calculate 7 days ago (start of that day)
      final sevenDaysAgo = now.subtract(const Duration(days: 7));

      List<MoodEntry> allEntries = snap.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return MoodEntry(
          date: (data["date"] as Timestamp).toDate(),
          moodNumber: (data["mood number"] as num).toInt(),
          mood: data["mood"].toString(),
          note: data["note"]?.toString() ?? "",
        );
      }).toList();

      // Sort by date (Oldest -> Newest)
      allEntries.sort((a, b) => a.date.compareTo(b.date));

      // Filter: Keep only entries from the last 7 days
      moodData = allEntries.where((entry) {
        return entry.date.isAfter(sevenDaysAgo);
      }).toList();

      _calculateStats();
      _calculateMoodDistribution();
      _updateMotivation();

      setState(() => isLoading = false);
    } catch (e) {
      print("Error loading mood data: $e");
      if (mounted) setState(() => isLoading = false);
    }
  }

  void _calculateStats() {
    if (moodData.isEmpty) {
      averageMood = 0.0;
      topEmotion = "None";
      lowMoodCount = 0;
      return;
    }

    // 1. Average Mood
    double sum = moodData.fold(0, (prev, e) => prev + e.moodNumber);
    averageMood = sum / moodData.length;

    // 2. Low Mood Days (Score <= 3)
    // Count unique days where mood was low
    final lowMoodEntries = moodData.where((e) => e.moodNumber <= 3);
    final uniqueLowDays = lowMoodEntries
        .map((e) => DateTime(e.date.year, e.date.month, e.date.day))
        .toSet();
    lowMoodCount = uniqueLowDays.length;

    // 3. Highest Emotion (Mode)
    Map<String, int> freq = {};
    for (var m in moodData) {
      freq[m.mood] = (freq[m.mood] ?? 0) + 1;
    }

    // Sort by frequency descending
    var sorted = freq.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    if (sorted.isNotEmpty) {
      topEmotion = "${sorted.first.key} (${sorted.first.value})";
    }
  }

  void _calculateMoodDistribution() {
    moodDistribution.clear();
    if (moodData.isEmpty) return;

    for (var entry in moodData) {
      moodDistribution[entry.mood] = (moodDistribution[entry.mood] ?? 0) + 1;
    }
  }

  void _updateMotivation() {
    // Determine category based on averageMood
    String category;
    if (averageMood < 2.5) {
      category = "low";
    } else if (averageMood < 3.5) {
      category = "sad";
    } else if (averageMood < 4.5) {
      category = "okay";
    } else {
      category = "happy";
    }

    final random = Random();

    // Select random quote
    final quotes = _moodQuotes[category] ?? _moodQuotes["okay"]!;
    motivationalQuote = quotes[random.nextInt(quotes.length)];

    // Select random suggestion
    final suggestions = _moodSuggestions[category] ?? _moodSuggestions["okay"]!;
    wellnessSuggestion = suggestions[random.nextInt(suggestions.length)];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
        ),
        title: const Text(
          "Mood Insights",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : moodData.isEmpty
            ? const Center(
                child: Text(
                  "No mood entries in the last 7 days.",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Last 7 Days Mood Trend",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "See how your mood has changed over the past week.",
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 20),

                    // ---------------- STATS GRID ----------------
                    _buildStatsGrid(),

                    const SizedBox(height: 20),

                    // ---------------- MOTIVATION CARD ----------------
                    _buildMotivationCard(),

                    const SizedBox(height: 20),

                    // ---------------- PIE CHART CARD ----------------
                    const SizedBox(height: 20),

                    // ---------------- GRAPH CARD ----------------
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      color: AppColors.cardColor,
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                        child: AspectRatio(
                          aspectRatio: 1.4,
                          child: _buildChart(),
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),
                    _buildPieChartCard(),
                    ActivityReminderCountContainer(),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildStatsGrid() {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 0.85,
      children: [
        _statCard(
          "Avg. Mood",
          averageMood.toStringAsFixed(1),
          Icons.speed,
          Colors.blue,
        ),
        _statCard("Top Mood", topEmotion, Icons.emoji_emotions, Colors.orange),
        _statCard("Low Days", "$lowMoodCount days", Icons.cloud, Colors.grey),
      ],
    );
  }

  Widget _buildMotivationCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.1),
            AppColors.accent.withValues(alpha: 0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb, color: Colors.amber[700], size: 24),
              const SizedBox(width: 8),
              const Text(
                "Daily Inspiration",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            "\"$motivationalQuote\"",
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontStyle: FontStyle.italic,
              color: Colors.black87,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          Divider(color: Colors.grey.withValues(alpha: 0.2)),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.spa, color: Colors.green[600], size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  "Tip: $wellnessSuggestion",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[800],
                    height: 1.3,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPieChartCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: AppColors.cardColor,
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Mood Distribution",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              "How your moods are distributed over the week",
              style: TextStyle(fontSize: 13, color: Colors.grey[600]),
            ),
            const SizedBox(height: 20),
            AspectRatio(aspectRatio: 1.3, child: _buildPieChart()),
            const SizedBox(height: 15),
            _buildPieChartLegend(),
          ],
        ),
      ),
    );
  }

  Widget _buildPieChart() {
    if (moodDistribution.isEmpty) {
      return const Center(
        child: Text("No data available", style: TextStyle(color: Colors.grey)),
      );
    }

    int total = moodDistribution.values.fold(0, (sum, count) => sum + count);

    List<PieChartSectionData> sections = [];
    int index = 0;

    moodDistribution.forEach((mood, count) {
      final isTouched = index == touchedIndex;
      final double fontSize = isTouched ? 18 : 14;
      final double radius = isTouched ? 110 : 100;
      final percentage = (count / total * 100).toStringAsFixed(1);

      sections.add(
        PieChartSectionData(
          color: _getColorByMood(mood),
          value: count.toDouble(),
          title: '$percentage%',
          radius: radius,
          titleStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          badgeWidget: isTouched
              ? Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Text(
                    _getEmojiByMood(mood),
                    style: const TextStyle(fontSize: 24),
                  ),
                )
              : null,
          badgePositionPercentageOffset: 1.3,
        ),
      );
      index++;
    });

    return PieChart(
      PieChartData(
        pieTouchData: PieTouchData(
          touchCallback: (FlTouchEvent event, pieTouchResponse) {
            setState(() {
              if (!event.isInterestedForInteractions ||
                  pieTouchResponse == null ||
                  pieTouchResponse.touchedSection == null) {
                touchedIndex = -1;
                return;
              }
              touchedIndex =
                  pieTouchResponse.touchedSection!.touchedSectionIndex;
            });
          },
        ),
        borderData: FlBorderData(show: false),
        sectionsSpace: 2,
        centerSpaceRadius: 40,
        sections: sections,
      ),
    );
  }

  Widget _buildPieChartLegend() {
    return Wrap(
      spacing: 12,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: moodDistribution.entries.map((entry) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: _getColorByMood(entry.key).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: _getColorByMood(entry.key).withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _getEmojiByMood(entry.key),
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(width: 6),
              Text(
                "${entry.key} (${entry.value})",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: _getColorByMood(entry.key),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _statCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildChart() {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 6.5,
        minY: 0,
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            tooltipPadding: const EdgeInsets.all(8),
            tooltipMargin: 8,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              final entry = moodData[group.x.toInt()];
              return BarTooltipItem(
                "${entry.mood}\n",
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                children: [
                  TextSpan(
                    text: DateFormat('h:mm a').format(entry.date),
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  if (entry.note.isNotEmpty)
                    TextSpan(
                      text: "\nNote: ${entry.note}",
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 11,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                ],
              );
            },
          ),
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 1,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.grey.withValues(alpha: 0.1),
              strokeWidth: 1,
            );
          },
        ),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                int index = value.toInt();
                if (index < 0 || index >= moodData.length) {
                  return const SizedBox();
                }
                // Avoid overcrowding if too many data points
                if (moodData.length > 10 && index % 2 != 0) {
                  return const SizedBox();
                }

                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    DateFormat('d/M').format(moodData[index].date),
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
              reservedSize: 30,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              interval: 1,
              getTitlesWidget: (value, meta) {
                // Ensure we only render for integer values to avoid duplicates
                // (e.g. preventing 6.5 from rounding to 6 and showing twice)
                if ((value - value.round()).abs() > 0.01) {
                  return const SizedBox();
                }

                int val = value.round();
                if (val < 1 || val > 6) return const SizedBox();
                return Center(
                  child: Text(
                    moodEmojis[val] ?? "",
                    style: const TextStyle(fontSize: 22),
                  ),
                );
              },
            ),
          ),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        barGroups: moodData.asMap().entries.map((e) {
          int index = e.key;
          MoodEntry entry = e.value;
          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: entry.moodNumber.toDouble(),
                gradient: LinearGradient(
                  colors: [
                    _getColor(entry.moodNumber).withValues(alpha: 0.6),
                    _getColor(entry.moodNumber),
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
                width: 16,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(8),
                ),
                backDrawRodData: BackgroundBarChartRodData(
                  show: true,
                  toY: 6.5,
                  color: Colors.grey.withValues(alpha: 0.05),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Color _getColor(int score) {
    switch (score) {
      case 6: // Happy
        return Colors.green;
      case 5: // Good
        return Colors.lightBlue;
      case 4: // Okay
        return Colors.blueGrey;
      case 3: // Sad
        return Colors.purple;
      case 2: // Stressed
        return Colors.orange;
      case 1: // Angry
        return Colors.red;
      default:
        return AppColors.primary;
    }
  }

  Color _getColorByMood(String mood) {
    switch (mood.toLowerCase()) {
      case "happy":
        return Colors.green;
      case "good":
        return Colors.lightBlue;
      case "okay":
        return Colors.blueGrey;
      case "sad":
        return Colors.purple;
      case "stressed":
        return Colors.orange;
      case "angry":
        return Colors.red;
      default:
        return AppColors.primary;
    }
  }

  String _getEmojiByMood(String mood) {
    switch (mood.toLowerCase()) {
      case "happy":
        return "🤩";
      case "good":
        return "😊";
      case "okay":
        return "😐";
      case "sad":
        return "😢";
      case "stressed":
        return "😫";
      case "angry":
        return "😡";
      default:
        return "😐";
    }
  }
}

class MoodEntry {
  final DateTime date;
  final int moodNumber;
  final String mood;
  final String note;

  MoodEntry({
    required this.date,
    required this.moodNumber,
    required this.mood,
    required this.note,
  });
}
