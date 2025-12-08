// activity_full.dart
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mental_healthcare/backend/activityscreen_backnd.dart';
import 'package:provider/provider.dart';
import 'package:mental_healthcare/frontend/widgets/appcolors.dart';

/// -----------------------------
/// Models
/// -----------------------------
enum ActivityType { meditation, therapy, journal, breathing, custom }

class ActivityModel {
  final String id;
  final DateTime dateTime;
  final ActivityType type;
  final String title;
  final String? notes;
  final bool completed;
  final String Userid = FirebaseAuth.instance.currentUser!.uid;
  ActivityModel({
    required this.id,
    required this.dateTime,
    required this.type,
    required this.title,
    this.notes,
    this.completed = false,
  });

  Map<String, dynamic> toMap() => {
    'dateTime': Timestamp.fromDate(dateTime),
    'type': type.name,
    'title': title,
    'notes': notes,
    'completed': completed,
    'Userid': Userid,
  };

  static ActivityModel fromDoc(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    return ActivityModel(
      id: doc.id,
      dateTime: (d['dateTime'] as Timestamp).toDate(),
      type: ActivityType.values.firstWhere(
        (e) => e.name == (d['type'] as String),
        orElse: () => ActivityType.custom,
      ),
      title: d['title'] ?? '',
      notes: d['notes'] as String?,
      completed: (d['completed'] ?? false) as bool,
    );
  }
}

class MoodEntry {
  final String id;
  final DateTime date;
  final int moodScore; // 1..5
  final String? note;

  MoodEntry({
    required this.id,
    required this.date,
    required this.moodScore,
    this.note,
  });

  Map<String, dynamic> toMap() => {
    'date': Timestamp.fromDate(date),
    'moodScore': moodScore,
    'note': note,
  };

  static MoodEntry fromDoc(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    return MoodEntry(
      id: doc.id,
      date: (d['date'] as Timestamp).toDate(),
      moodScore: (d['moodScore'] ?? 3) as int,
      note: d['note'] as String?,
    );
  }
}

class JournalEntry {
  final String id;
  final DateTime date;
  final String title;
  final String content;

  JournalEntry({
    required this.id,
    required this.date,
    required this.title,
    required this.content,
  });

  Map<String, dynamic> toMap() => {
    'date': Timestamp.fromDate(date),
    'title': title,
    'content': content,
  };

  static JournalEntry fromDoc(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    return JournalEntry(
      id: doc.id,
      date: (d['date'] as Timestamp).toDate(),
      title: d['title'] ?? '',
      content: d['content'] ?? '',
    );
  }
}

class SessionReminder {
  final String id;
  final DateTime dateTime;
  final String title;
  final String? notes;
  final bool done;

  SessionReminder({
    required this.id,
    required this.dateTime,
    required this.title,
    this.notes,
    this.done = false,
  });

  Map<String, dynamic> toMap() => {
    'dateTime': Timestamp.fromDate(dateTime),
    'title': title,
    'notes': notes,
    'done': done,
  };

  static SessionReminder fromDoc(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    return SessionReminder(
      id: doc.id,
      dateTime: (d['dateTime'] as Timestamp).toDate(),
      title: d['title'] ?? '',
      notes: d['notes'] as String?,
      done: (d['done'] ?? false) as bool,
    );
  }
}

/// -----------------------------
/// Firestore service
/// -----------------------------

/// -----------------------------
/// Provider
/// -----------------------------
class ActivityProvider extends ChangeNotifier {
  final FirestoreService _service = FirestoreService();

  List<ActivityModel> activities = [];
  List<MoodEntry> moods = [];
  List<JournalEntry> journals = [];
  List<SessionReminder> reminders = [];

  late final StreamSubscription _activitySub;
  late final StreamSubscription _moodSub;
  late final StreamSubscription _journalSub;
  late final StreamSubscription _remSub;

  ActivityProvider() {
    _activitySub = _service.activitiesStream().listen((list) {
      activities = list;
      notifyListeners();
    });
    _moodSub = _service.moodStream().listen((list) {
      moods = list;
      notifyListeners();
    });
    _journalSub = _service.journalsStream().listen((list) {
      journals = list;
      notifyListeners();
    });
    _remSub = _service.remindersStream().listen((list) {
      reminders = list;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _activitySub.cancel();
    _moodSub.cancel();
    _journalSub.cancel();
    _remSub.cancel();
    super.dispose();
  }

  // Helpers
  List<ActivityModel> activitiesForDay(DateTime date) {
    final start = DateTime(date.year, date.month, date.day);
    final end = start.add(const Duration(days: 1));
    return activities
        .where((a) => a.dateTime.isAfter(start) && a.dateTime.isBefore(end))
        .toList();
  }

  MoodEntry? moodForDay(DateTime date) {
    final start = DateTime(date.year, date.month, date.day);
    final end = start.add(const Duration(days: 1));
    return moods.firstWhereOrNull(
      (m) => m.date.isAfter(start) && m.date.isBefore(end),
    );
  }

  List<JournalEntry> journalsForDay(DateTime date) {
    final start = DateTime(date.year, date.month, date.day);
    final end = start.add(const Duration(days: 1));
    return journals
        .where((j) => j.date.isAfter(start) && j.date.isBefore(end))
        .toList();
  }

  List<SessionReminder> remindersForDay(DateTime date) {
    final start = DateTime(date.year, date.month, date.day);
    final end = start.add(const Duration(days: 1));
    return reminders
        .where((r) => r.dateTime.isAfter(start) && r.dateTime.isBefore(end))
        .toList();
  }

  // Actions
  Future<void> addActivity(ActivityModel m) => _service.addActivity(m);
  Future<void> toggleActivity(String id, bool completed) =>
      _service.updateActivityCompletion(id, completed);

  Future<void> upsertMood(MoodEntry mood) => _service.upsertMood(mood);

  Future<void> addJournal(JournalEntry j) => _service.addJournal(j);

  Future<void> addReminder(SessionReminder r) => _service.addReminder(r);

  Future<void> toggleReminderDone(String id, bool done) =>
      _service.toggleReminderDone(id, done);
}

/// -----------------------------
/// Extensions / Utils
/// -----------------------------
extension FirstWhereOrNullExtension<E> on Iterable<E> {
  E? firstWhereOrNull(bool Function(E) test) {
    for (var element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}

/// -----------------------------
/// UI Screen: Full Activity Screen
/// -----------------------------
class FullActivityScreen extends StatefulWidget {
  const FullActivityScreen({super.key});

  @override
  State<FullActivityScreen> createState() => _FullActivityScreenState();
}

class _FullActivityScreenState extends State<FullActivityScreen> {
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ActivityProvider>(
      create: (_) => ActivityProvider(),
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            title: const Text(
              'Activity Screen',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            centerTitle: true,
            elevation: 0,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primary, AppColors.accent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            actions: [
              IconButton(
                onPressed: () => _openAddSheet(context),
                icon: const Icon(Icons.add_circle_outline, color: Colors.white),
              ),
            ],
          ),
          body: Consumer<ActivityProvider>(
            builder: (context, prov, _) {
              final activities = prov.activitiesForDay(selectedDate);
              final mood = prov.moodForDay(selectedDate);
              final journals = prov.journalsForDay(selectedDate);
              final reminders = prov.remindersForDay(selectedDate);
              final fs = FirestoreService();
              final todaySummary = fs.fetchTodaySummary();
              return Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xffe9f5ff), Color(0xfff8f9fb)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  children: [
                    // Date selector row (simple horizontal week)
                    // DateSelector(
                    //   selected: selectedDate,
                    //   onSelect: (d) => setState(() => selectedDate = d),
                    // ),

                    // Today summary
                    // Padding(
                    //   padding: const EdgeInsets.all(12.0),
                    //   child: _TodaySummary(
                    //     activitiesCount: activities.length,
                    //     moodScore: mood?.moodScore,
                    //     journalsCount: journals.length,
                    //     remindersCount: reminders.length,
                    //   ),
                    // ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: FutureBuilder<TodaySummary>(
                        future: FirestoreService()
                            .fetchTodaySummary(), // Call your backend function
                        builder: (context, snapshot) {
                          // 🔄 Loading state
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          // ❌ Error state
                          if (snapshot.hasError) {
                            return Center(
                              child: Text('Error: ${snapshot.error}'),
                            );
                          }

                          // ✅ Data loaded
                          if (snapshot.hasData) {
                            final data = snapshot.data!;

                            return _TodaySummary(
                              activitiesCount: data.activitiesCount,
                              moodScore: data.moodScore?.toInt(),
                              journalsCount: data.journalsCount,
                              remindersCount: data.remindersCount,
                            );
                          }

                          // 😶 No data case
                          return const Center(
                            child: Text('No data for today.'),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Timeline & Lists
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Activities Timeline
                            const SizedBox(height: 8),
                            const Text(
                              "Today's Activities",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.sectionTitleColor,
                              ),
                            ),
                            const SizedBox(height: 8),
                            if (activities.isEmpty)
                              _EmptyPlaceholder(
                                title: 'No activities',
                                subtitle:
                                    'Add activities or mark them complete when done.',
                              )
                            else
                              ...activities.map(
                                (a) => GestureDetector(
                                  onLongPress: () {
                                    showDialog(
                                      context: context,
                                      builder: (ContextAction) {
                                        return AlertDialog(
                                          content: Text(
                                            'Delete "${a.title}" ?',
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                final fs = FirestoreService();
                                                fs
                                                    .deleteActivity(a.id)
                                                    .then((_) {
                                                      ScaffoldMessenger.of(
                                                        context,
                                                      ).showSnackBar(
                                                        const SnackBar(
                                                          content: Text(
                                                            'Activity deleted',
                                                          ),
                                                        ),
                                                      );
                                                      Navigator.of(
                                                        context,
                                                      ).pop();
                                                    })
                                                    .catchError((e) {
                                                      ScaffoldMessenger.of(
                                                        context,
                                                      ).showSnackBar(
                                                        SnackBar(
                                                          content: Text(
                                                            'Error deleting activity: $e',
                                                          ),
                                                        ),
                                                      );
                                                    });
                                              },
                                              child: const Text('Delete'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text('Cancel'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  child: _ActivityTile(
                                    activity: a,
                                    onToggle: (val) {
                                      prov.toggleActivity(a.id, val);
                                    },
                                  ),
                                ),
                              ),

                            const SizedBox(height: 16),

                            // Journals
                            const Text(
                              "Journal Entries",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.sectionTitleColor,
                              ),
                            ),
                            const SizedBox(height: 8),
                            if (journals.isEmpty)
                              _EmptyPlaceholder(
                                title: 'No journal entries',
                                subtitle: 'Write a short reflection.',
                              ),
                            ...journals
                                .map((j) => _JournalTile(entry: j))
                                ,

                            const SizedBox(height: 16),

                            // Mood
                            // const Text(
                            //   "Mood",
                            //   style: TextStyle(
                            //     fontSize: 18,
                            //     fontWeight: FontWeight.bold,
                            //     color: AppColors.sectionTitleColor,
                            //   ),
                            // ),
                            // const SizedBox(height: 8),

                            // _MoodCard(
                            //   date: selectedDate,
                            //   mood: mood,
                            //   onSave: (score, note) async {
                            //     final me = MoodEntry(
                            //       id: '',
                            //       date: DateTime(
                            //         selectedDate.year,
                            //         selectedDate.month,
                            //         selectedDate.day,
                            //       ),
                            //       moodScore: score,
                            //       note: note,
                            //     );
                            //     await prov.upsertMood(me);
                            //     ScaffoldMessenger.of(context).showSnackBar(
                            //       const SnackBar(content: Text('Mood saved')),
                            //     );
                            //   },
                            // ),
                            const SizedBox(height: 16),

                            // Reminders
                            const Text(
                              "Session Reminders",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.sectionTitleColor,
                              ),
                            ),
                            const SizedBox(height: 8),
                            if (reminders.isEmpty)
                              _EmptyPlaceholder(
                                title: 'No reminders',
                                subtitle:
                                    'Add a therapy session reminder or appointment.',
                              )
                            else
                              ...reminders.map(
                                (r) => _ReminderTile(
                                  reminder: r,
                                  onToggle: (val) =>
                                      prov.toggleReminderDone(r.id, val),
                                ),
                              ),

                            const SizedBox(height: 40),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => _openAddSheet(context),
            label: const Text(
              'Add Activity',
              style: TextStyle(color: Colors.white),
            ),
            icon: const Icon(Icons.add, color: Colors.white),
            backgroundColor: AppColors.primary,
          ),
        );
      },
    );
  }

  void _openAddSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // important for full height
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        // Wrap with LayoutBuilder for responsive height
        return LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.only(
                bottom:
                    MediaQuery.of(ctx).viewInsets.bottom + 16, // keyboard safe
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight * 0.3,
                  maxHeight: constraints.maxHeight * 0.9,
                ),
                child: _AddActionSheet(
                  onCreate: (type, title, notes, dateTime, Userid) {
                    final prov = Provider.of<ActivityProvider>(
                      context,
                      listen: false,
                    );

                    final m = ActivityModel(
                      id: FirebaseAuth
                          .instance
                          .currentUser!
                          .uid, // Firestore will assign
                      dateTime: dateTime,
                      type: type,
                      title: title,
                      notes: notes,
                    );

                    prov.addActivity(m);
                    Navigator.pop(ctx);
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}

/// -----------------------------
/// UI Components & small widgets
/// -----------------------------

class DateSelector extends StatelessWidget {
  final DateTime selected;
  final void Function(DateTime) onSelect;

  const DateSelector({
    required this.selected,
    required this.onSelect,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    // First and last day of current month
    final firstDay = DateTime(selected.year, selected.month, 1);
    final lastDay = DateTime(selected.year, selected.month + 1, 0);

    // Generate list of all days in current month
    final days = List.generate(
      lastDay.day,
      (i) => DateTime(selected.year, selected.month, i + 1),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --------- Header ----------
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            "${DateFormat.yMMMM().format(selected)} • Today: ${now.day}",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textColorPrimary,
            ),
          ),
        ),
        const SizedBox(height: 12),

        // --------- Horizontal Date List ----------
        SizedBox(
          height: 92,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            scrollDirection: Axis.horizontal,
            itemCount: days.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final d = days[index];

              final isSelected =
                  d.year == selected.year &&
                  d.month == selected.month &&
                  d.day == selected.day;

              final isToday =
                  d.year == now.year &&
                  d.month == now.month &&
                  d.day == now.day;

              return GestureDetector(
                onTap: () => onSelect(d),
                child: Container(
                  width: 72,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: isToday && !isSelected
                        ? Border.all(color: AppColors.primary, width: 2)
                        : null,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        DateFormat.E().format(d), // Mon, Tue...
                        style: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : AppColors.textColorPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        d.day.toString(),
                        style: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : AppColors.textColorPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _TodaySummary extends StatelessWidget {
  final int activitiesCount;
  final int? moodScore;
  final int journalsCount;
  final int remindersCount;

  const _TodaySummary({
    required this.activitiesCount,
    required this.moodScore,
    required this.journalsCount,
    required this.remindersCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _SummaryItem(label: 'Activities', value: activitiesCount.toString()),
          // _SummaryItem(
          //   label: 'Mood',
          //   value: moodScore == null ? '-' : moodScore.toString(),
          // ),
          _SummaryItem(label: 'Journals', value: journalsCount.toString()),
          _SummaryItem(label: 'Reminders', value: remindersCount.toString()),
        ],
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final String label;
  final String value;
  const _SummaryItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 6),
        Text(label, style: TextStyle(color: Colors.grey.shade600)),
      ],
    );
  }
}

class _ActivityTile extends StatelessWidget {
  final ActivityModel activity;
  final void Function(bool) onToggle;

  const _ActivityTile({required this.activity, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    final time = DateFormat.jm().format(activity.dateTime);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _colorForType(activity.type).withOpacity(0.15),
          child: Icon(
            _iconForType(activity.type),
            color: _colorForType(activity.type),
          ),
        ),
        title: Text(
          activity.title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(activity.notes ?? ''),
        trailing: Checkbox(
          value: activity.completed,
          onChanged: (v) => onToggle(v ?? false),
          activeColor: AppColors.primary,
        ),
        dense: false,
      ),
    );
  }

  IconData _iconForType(ActivityType t) {
    switch (t) {
      case ActivityType.meditation:
        return Icons.self_improvement;
      case ActivityType.therapy:
        return Icons.local_hospital;
      case ActivityType.journal:
        return Icons.book;
      case ActivityType.breathing:
        return Icons.air;
      default:
        return Icons.event;
    }
  }

  Color _colorForType(ActivityType t) {
    switch (t) {
      case ActivityType.meditation:
        return Colors.teal;
      case ActivityType.therapy:
        return Colors.deepOrange;
      case ActivityType.journal:
        return AppColors.accent;
      case ActivityType.breathing:
        return Colors.blue;
      default:
        return AppColors.primary;
    }
  }
}

class _JournalTile extends StatelessWidget {
  final JournalEntry entry;
  const _JournalTile({required this.entry});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        title: Text(
          entry.title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          entry.content,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Text(DateFormat('MMM d').format(entry.date)),
        onTap: () {
          // open full journal view dialog
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: Text(entry.title),
              content: SingleChildScrollView(child: Text(entry.content)),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _MoodCard extends StatefulWidget {
  final DateTime date;
  final MoodEntry? mood;
  final Future<void> Function(int score, String? note) onSave;

  const _MoodCard({
    required this.date,
    required this.mood,
    required this.onSave,
  });

  @override
  State<_MoodCard> createState() => _MoodCardState();
}

class _MoodCardState extends State<_MoodCard> {
  int _score = 0;
  TextEditingController noteC = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.mood != null) {
      _score = widget.mood!.moodScore;
      noteC.text = widget.mood!.note ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            'How are you feeling today?',
            style: TextStyle(color: AppColors.textColorPrimary),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(5, (i) {
              final idx = i + 1;
              final selected = _score == idx;
              return GestureDetector(
                onTap: () => setState(() => _score = idx),
                child: Column(
                  children: [
                    CircleAvatar(
                      backgroundColor: selected
                          ? AppColors.primary
                          : Colors.grey.shade200,
                      child: Text(
                        idx.toString(),
                        style: TextStyle(
                          color: selected ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(['😞', '😐', '🙂', '😊', '🤩'][i]),
                  ],
                ),
              );
            }),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: noteC,
            decoration: const InputDecoration(
              hintText: 'Add a short note (optional)',
              border: OutlineInputBorder(),
              isDense: true,
            ),
            maxLines: 2,
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () async {
              await widget
                  .onSave(_score, noteC.text.isEmpty ? null : noteC.text)
                  .then((_) {
                    noteC.clear();
                  });
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: const Text(
              'Save Mood',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReminderTile extends StatelessWidget {
  final SessionReminder reminder;
  final void Function(bool) onToggle;

  const _ReminderTile({required this.reminder, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    final time = DateFormat.jm().format(reminder.dateTime);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(Icons.calendar_today, color: AppColors.primary),
        title: Text(reminder.title),
        subtitle: Text(
          '${DateFormat.yMMMd().format(reminder.dateTime)} • $time',
        ),
        trailing: Checkbox(
          value: reminder.done,
          onChanged: (v) => onToggle(v ?? false),
        ),
      ),
    );
  }
}

class _EmptyPlaceholder extends StatelessWidget {
  final String title;
  final String subtitle;
  const _EmptyPlaceholder({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.sentiment_dissatisfied),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(subtitle, style: TextStyle(color: Colors.grey.shade600)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// -----------------------------
/// Add sheet (create activity / journal / reminder)
/// -----------------------------
class _AddActionSheet extends StatefulWidget {
  final void Function(
    ActivityType type,
    String title,
    String? notes,
    DateTime dateTime,
    String userId,
  )
  onCreate;

  const _AddActionSheet({required this.onCreate});

  @override
  State<_AddActionSheet> createState() => _AddActionSheetState();
}

class _AddActionSheetState extends State<_AddActionSheet> {
  ActivityType _type = ActivityType.meditation;
  final userId = FirebaseAuth.instance.currentUser!.uid;
  final TextEditingController _title = TextEditingController();
  final TextEditingController _notes = TextEditingController();
  DateTime _dateTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        // bottom: MediaQuery.of(context).viewInsets.bottom + 12,
        left: 12,
        right: 12,
        top: 12,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Create Activity / Reminder',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: ActivityType.values.map((t) {
              return ChoiceChip(
                label: Text(t.name.capitalize()),
                selected: _type == t,
                onSelected: (_) => setState(() => _type = t),
              );
            }).toList(),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _title,
            decoration: const InputDecoration(labelText: 'Title'),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _notes,
            decoration: const InputDecoration(labelText: 'Notes (optional)'),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text(DateFormat.yMMMd().add_jm().format(_dateTime)),
              ),
              TextButton(
                onPressed: () async {
                  final d = await showDatePicker(
                    context: context,
                    initialDate: _dateTime,
                    firstDate: DateTime.now().subtract(
                      const Duration(days: 365),
                    ),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (d == null) return;
                  final t = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.fromDateTime(_dateTime),
                  );
                  if (t == null) return;
                  setState(
                    () => _dateTime = DateTime(
                      d.year,
                      d.month,
                      d.day,
                      t.hour,
                      t.minute,
                    ),
                  );
                },
                child: const Text('Change'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_title.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Enter title')),
                          );
                          return;
                        }

                        // If type is journal -> open journal create popup
                        if (_type == ActivityType.journal) {
                          // create journal
                          final prov = Provider.of<ActivityProvider>(
                            context,
                            listen: false,
                          );
                          await prov.addJournal(
                            JournalEntry(
                              id: '',
                              date: _dateTime,
                              title: _title.text.trim(),
                              content: _notes.text.trim(),
                            ),
                          );
                          Navigator.pop(context);
                          return;
                        }

                        // If type is therapy -> treat as reminder
                        if (_type == ActivityType.therapy) {
                          final prov = Provider.of<ActivityProvider>(
                            context,
                            listen: false,
                          );
                          await prov.addReminder(
                            SessionReminder(
                              id: FirebaseAuth.instance.currentUser!.uid,
                              dateTime: _dateTime,
                              title: _title.text.trim(),
                              notes: _notes.text.trim(),
                            ),
                          );
                          Navigator.pop(context);
                          return;
                        }

                        widget.onCreate(
                          _type,
                          _title.text.trim(),
                          _notes.text.trim(),
                          _dateTime,
                          userId,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accent,
                      ),
                      child: const Text(
                        'Create',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          // const SizedBox(height: 12),
        ],
      ),
    );
  }
}

/// -----------------------------
/// Helpers / String ext
/// -----------------------------
extension StringCaps on String {
  String capitalize() => isEmpty ? this : this[0].toUpperCase() + substring(1);
}
