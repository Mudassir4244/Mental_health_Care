import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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

  @override
  void initState() {
    super.initState();
    fetchCounts();
  }

  Future<void> fetchCounts() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    try {
      /// Fetch Activities count
      final activitiesSnapshot = await FirebaseFirestore.instance
          .collection("Impresions")
          .doc(uid)
          .collection("activities")
          .get();

      /// Fetch Reminders count
      final remindersSnapshot = await FirebaseFirestore.instance
          .collection("Impresions")
          .doc(uid)
          .collection("reminders")
          .get();

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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Your Stats",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),

                SizedBox(height: 12),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildInfoCard("Activities", activitiesCount),
                    _buildInfoCard("Reminders", remindersCount),
                  ],
                ),
              ],
            ),
    );
  }

  /// small box for count
  Widget _buildInfoCard(String title, int count) {
    return Container(
      width: 140,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 8),
          Text(
            count.toString(),
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade700,
            ),
          ),
        ],
      ),
    );
  }
}
