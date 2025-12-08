import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import '../models/mood_entry.dart';

class MoodService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  String get uid => FirebaseAuth.instance.currentUser!.uid;
  final now = DateTime.now();
  CollectionReference get _moodCol => _db.collection('moods');

  /// Save / Update mood for today's date
  Future<void> saveMood(String mood, String note, int number) async {
    // final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day);
    final end = start.add(const Duration(days: 1));
    final userid = FirebaseAuth.instance.currentUser!.uid;
    final todayQuery = await _moodCol
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
        .where('date', isLessThan: Timestamp.fromDate(end))
        .get();

    final data = {
      'mood': mood,
      'note': note,
      'date': Timestamp.now(),
      'userid': userid,
      'mood number': number,
    };

    if (todayQuery.docs.isNotEmpty) {
      // Update existing mood for today
      await _moodCol.doc(todayQuery.docs.first.id).update(data);
    } else {
      // Add new mood for today
      await _moodCol.add(data);
    }
  }
}
