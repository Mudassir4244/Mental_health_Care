import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mental_healthcare/frontend/customer_interface/Activityscreeen.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  String get uid => FirebaseAuth.instance.currentUser!.uid;

  CollectionReference _col(String name) =>
      _db.collection('Impresions').doc(uid).collection(name);

  // Activities
  Stream<List<ActivityModel>> activitiesStream({DateTime? day}) {
    // We'll fetch all and let provider filter by date (simple)
    return _col('activities')
        .where('Userid', isEqualTo: uid)
        // .orderBy('dateTime', descending: true) // Removed to avoid index requirement
        .snapshots()
        .map((snap) {
          final list = snap.docs.map((d) => ActivityModel.fromDoc(d)).toList();
          // Sort client-side
          list.sort((a, b) => b.dateTime.compareTo(a.dateTime));
          return list;
        });
  }

  Future<void> addActivity(ActivityModel m) =>
      _col('activities').add(m.toMap());

  Future<void> updateActivityCompletion(String id, bool completed) =>
      _col('activities').doc(id).update({'completed': completed});

  // Mood entries (one per day ideally)
  Stream<List<MoodEntry>> moodStream() => _col('moods').snapshots().map(
    (snap) => snap.docs.map((d) => MoodEntry.fromDoc(d)).toList(),
  );
  Future<void> deleteActivity(String id) async {
    await _col('activities').doc(id).delete();
  }

  Future<void> deleteJournal(String id) async {
    await _col('journals').doc(id).delete();
  }

  Future<void> deleteReminder(String id) async {
    await _col('reminders').doc(id).delete();
  }

  Future<void> upsertMood(MoodEntry mood) async {
    // Try to find a mood entry for same date (midnight)
    final dayStart = DateTime(
      mood.date.year,
      mood.date.month,
      mood.date.day,
    ); // 00:00
    final dayEnd = dayStart.add(const Duration(days: 1));
    final q = await _col('moods')
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(dayStart))
        .where('date', isLessThan: Timestamp.fromDate(dayEnd))
        .get();

    if (q.docs.isNotEmpty) {
      await _col('moods').doc(q.docs.first.id).update(mood.toMap());
    } else {
      await _col('moods').add(mood.toMap());
    }
  }

  // Journal
  Stream<List<JournalEntry>> journalsStream() => _col('journals')
      .snapshots()
      .map((snap) => snap.docs.map((d) => JournalEntry.fromDoc(d)).toList());

  Future<void> addJournal(JournalEntry j) => _col('journals').add(j.toMap());

  // Reminders
  Stream<List<SessionReminder>> remindersStream() => _col('reminders')
      .snapshots()
      .map((snap) => snap.docs.map((d) => SessionReminder.fromDoc(d)).toList());

  Future<void> addReminder(SessionReminder r) =>
      _col('reminders').add(r.toMap());

  Future<void> toggleReminderDone(String id, bool done) =>
      _col('reminders').doc(id).update({'done': done});
}

class TodaySummary {
  final int activitiesCount;
  final double? moodScore; // nullable if no mood today
  final int journalsCount;
  final int remindersCount;

  TodaySummary({
    required this.activitiesCount,
    required this.moodScore,
    required this.journalsCount,
    required this.remindersCount,
  });
}

extension FirestoreServiceExtensions on FirestoreService {
  Future<TodaySummary> fetchTodaySummary() async {
    final startOfDay = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );
    final endOfDay = startOfDay.add(const Duration(days: 1));

    // --- Activities ---
    final activitiesSnap = await _col('activities')
        .where(
          'dateTime',
          isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay),
        )
        .where('dateTime', isLessThan: Timestamp.fromDate(endOfDay))
        .get();
    final activitiesCount = activitiesSnap.docs.length;

    // --- Mood ---
    final moodSnap = await _col('moods')
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
        .where('date', isLessThan: Timestamp.fromDate(endOfDay))
        .get();
    double? moodScore;
    if (moodSnap.docs.isNotEmpty) {
      final scores = moodSnap.docs
          .map((d) => (d.data() as Map<String, dynamic>)['moodScore'] as num)
          .toList();
      moodScore = scores.reduce((a, b) => a + b) / scores.length;
    }

    // --- Journals ---
    final journalsSnap = await _col('journals')
        .where(
          'dateTime',
          isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay),
        )
        .where('dateTime', isLessThan: Timestamp.fromDate(endOfDay))
        .get();
    final journalsCount = journalsSnap.docs.length;

    // --- Reminders ---
    final remindersSnap = await _col('reminders')
        .where(
          'dateTime',
          isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay),
        )
        .where('dateTime', isLessThan: Timestamp.fromDate(endOfDay))
        .get();
    final remindersCount = remindersSnap.docs.length;

    return TodaySummary(
      activitiesCount: activitiesCount,
      moodScore: moodScore,
      journalsCount: journalsCount,
      remindersCount: remindersCount,
    );
  }
}
