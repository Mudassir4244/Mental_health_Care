import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import '../models/mood_entry.dart';

class MoodService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  String get uid => FirebaseAuth.instance.currentUser!.uid;
  final now = DateTime.now();
  CollectionReference get _moodCol => _db.collection('moods');

  /// Save a new mood entry (allows multiple per day)
  Future<void> saveMood(String mood, String note, int number) async {
    final userid = FirebaseAuth.instance.currentUser!.uid;

    final data = {
      'mood': mood,
      'note': note,
      'date': Timestamp.now(),
      'userid': userid,
      'mood number': number,
      'Created At': FieldValue.serverTimestamp(),
    };

    // Always add a new document to allow multiple check-ins per day
    await _moodCol.add(data);
  }

  /// Fetch all moods for the current user
  Future<List<Map<String, dynamic>>> fetchMoods() async {
    final userid = FirebaseAuth.instance.currentUser!.uid;

    // Fetch by user ID (no ordering in query to avoid composite index requirement)
    final querySnapshot = await _moodCol
        .where('userid', isEqualTo: userid)
        .get();

    final moods = querySnapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return {
        'id': doc.id,
        'mood': data['mood'] as String? ?? 'Unknown',
        'note': data['note'] as String? ?? '',
        'date': (data['date'] as Timestamp).toDate(),
        'number': (data['mood number'] as int? ?? 0).toString(),
      };
    }).toList();

    // Sort by date descending in Dart
    moods.sort((a, b) {
      final dateA = a['date'] as DateTime;
      final dateB = b['date'] as DateTime;
      return dateB.compareTo(dateA);
    });

    return moods;
  }

  /// Delete a mood entry by ID
  Future<void> deleteMood(String docId) async {
    await _moodCol.doc(docId).delete();
  }
}
