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
enum ActivityType { meditation, therapy, journal }

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
        // orElse: () => ActivityType.custom,
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

  void clearData() {
    try {
      _activitySub.cancel();
    } catch (_) {}
    try {
      _moodSub.cancel();
    } catch (_) {}
    try {
      _journalSub.cancel();
    } catch (_) {}
    try {
      _remSub.cancel();
    } catch (_) {}

    activities = [];
    moods = [];
    journals = [];
    reminders = [];
    notifyListeners();
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
  Future<void> deleteJournal(String id) => _service.deleteJournal(id);

  Future<void> addReminder(SessionReminder r) => _service.addReminder(r);
  Future<void> deleteReminder(String id) => _service.deleteReminder(id);

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
              'Your Starts to Activity Progress',
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
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Date selector row (simple horizontal week)
                      DateSelector(
                        selected: selectedDate,
                        onSelect: (d) => setState(() => selectedDate = d),
                      ),

                      // Today summary
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: _TodaySummary(
                          activitiesCount: activities.length,
                          journalsCount: journals.length,
                          remindersCount: reminders.length,
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Timeline & Lists
                      Padding(
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
                            ...journals.map((j) => _JournalTile(entry: j)),

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

                            const SizedBox(
                              height: 80,
                            ), // Added extra padding for FAB
                          ],
                        ),
                      ),
                    ],
                  ),
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

class DateSelector extends StatefulWidget {
  final DateTime selected;
  final void Function(DateTime) onSelect;

  const DateSelector({
    required this.selected,
    required this.onSelect,
    super.key,
  });

  @override
  State<DateSelector> createState() => _DateSelectorState();
}

class _DateSelectorState extends State<DateSelector> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    // Calculate initial offset to center the selected date (approximate)
    // Item width = 72 + 8 spacing = 80
    final dayIndex = widget.selected.day - 1;
    final offset = (dayIndex * 80.0) - 150; // shift back to center somewhat
    _scrollController = ScrollController(
      initialScrollOffset: offset < 0 ? 0 : offset,
    );
  }

  @override
  void didUpdateWidget(DateSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selected.month != widget.selected.month) {
      // If month changes, reset scroll or jump to day
      final dayIndex = widget.selected.day - 1;
      final offset = (dayIndex * 80.0) - 150;
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(offset < 0 ? 0 : offset);
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final selected = widget.selected;

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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${DateFormat.yMMMM().format(selected)} • Today: ${now.day}",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textColorPrimary,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left),
                    onPressed: () {
                      final prevMonth = DateTime(
                        selected.year,
                        selected.month - 1,
                        1,
                      );
                      widget.onSelect(prevMonth);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right),
                    onPressed: () {
                      final nextMonth = DateTime(
                        selected.year,
                        selected.month + 1,
                        1,
                      );
                      widget.onSelect(nextMonth);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // --------- Horizontal Date List ----------
        SizedBox(
          height: 92,
          child: ListView.separated(
            controller: _scrollController,
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
                onTap: () => widget.onSelect(d),
                child: Container(
                  width: 72,
                  padding: const EdgeInsets.all(4), // Reduced padding
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
                          fontSize: 13, // Slightly reduced font size
                        ),
                      ),
                      const SizedBox(height: 2), // Reduced spacing
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
  final int journalsCount;
  final int remindersCount;

  const _TodaySummary({
    required this.activitiesCount,
    required this.journalsCount,
    required this.remindersCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _SummaryCard(
            label: 'Activities',
            value: activitiesCount.toString(),
            icon: Icons.check_circle_outline,
            color: Colors.blue,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _SummaryCard(
            label: 'Journals',
            value: journalsCount.toString(),
            icon: Icons.book,
            color: Colors.orange,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _SummaryCard(
            label: 'Reminders',
            value: remindersCount.toString(),
            icon: Icons.notifications_none,
            color: Colors.redAccent,
          ),
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _SummaryCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: color.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
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
    final color = _colorForType(activity.type);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: IntrinsicHeight(
          child: Row(
            children: [
              // Colored Strip
              Container(width: 6, color: color),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      // Icon
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _iconForType(activity.type),
                          color: color,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Content
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              activity.title,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                decoration: activity.completed
                                    ? TextDecoration.lineThrough
                                    : null,
                                color: activity.completed
                                    ? Colors.grey
                                    : Colors.black87,
                              ),
                            ),
                            if (activity.notes != null &&
                                activity.notes!.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Text(
                                activity.notes!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                            const SizedBox(height: 4),
                            Text(
                              time,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade500,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Checkbox
                      Transform.scale(
                        scale: 1.2,
                        child: Checkbox(
                          value: activity.completed,
                          onChanged: (v) => onToggle(v ?? false),
                          activeColor: color,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          side: BorderSide(color: Colors.grey.shade400),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _iconForType(ActivityType t) {
    switch (t) {
      case ActivityType.meditation:
        return Icons.self_improvement_rounded;
      case ActivityType.therapy:
        return Icons.spa_rounded;
      case ActivityType.journal:
        return Icons.menu_book_rounded;
    }
  }

  Color _colorForType(ActivityType t) {
    switch (t) {
      case ActivityType.meditation:
        return const Color(0xFF009688); // Teal
      case ActivityType.therapy:
        return const Color(0xFFFF7043); // Deep Orange
      case ActivityType.journal:
        return const Color(0xFF5C6BC0); // Indigo
    }
  }
}

class _JournalTile extends StatelessWidget {
  final JournalEntry entry;
  const _JournalTile({required this.entry});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Delete Journal?'),
            content: Text('Delete "${entry.title}"?'),
            actions: [
              TextButton(
                onPressed: () {
                  Provider.of<ActivityProvider>(
                    context,
                    listen: false,
                  ).deleteJournal(entry.id);
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Journal deleted')),
                  );
                },
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancel'),
              ),
            ],
          ),
        );
      },
      onTap: () {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Text(entry.title),
            content: SingleChildScrollView(
              child: Text(
                entry.content,
                style: const TextStyle(fontSize: 16, height: 1.5),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF9C4), // Light yellow for journal feel
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.auto_stories,
                  color: Colors.orange.shade800,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    entry.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown.shade800,
                    ),
                  ),
                ),
                Text(
                  DateFormat('MMM d').format(entry.date),
                  style: TextStyle(fontSize: 12, color: Colors.brown.shade600),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              entry.content,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 14,
                color: Colors.brown.shade700,
                height: 1.4,
              ),
            ),
          ],
        ),
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
    return GestureDetector(
      onLongPress: () {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Delete Reminder?'),
            content: Text('Delete "${reminder.title}"?'),
            actions: [
              TextButton(
                onPressed: () {
                  Provider.of<ActivityProvider>(
                    context,
                    listen: false,
                  ).deleteReminder(reminder.id);
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Reminder deleted')),
                  );
                },
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancel'),
              ),
            ],
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFFFEBEE), // Light red
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.notifications_active_rounded,
              color: Color(0xFFE57373),
            ),
          ),
          title: Text(
            reminder.title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              decoration: reminder.done ? TextDecoration.lineThrough : null,
              color: reminder.done ? Colors.grey : Colors.black87,
            ),
          ),
          subtitle: Text(
            '${DateFormat.yMMMd().format(reminder.dateTime)} • $time',
            style: TextStyle(color: Colors.grey.shade600),
          ),
          trailing: Transform.scale(
            scale: 1.2,
            child: Checkbox(
              value: reminder.done,
              onChanged: (v) => onToggle(v ?? false),
              activeColor: const Color(0xFFE57373),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              side: BorderSide(color: Colors.grey.shade400),
            ),
          ),
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
      margin: const EdgeInsets.symmetric(vertical: 24),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.spa_outlined, size: 64, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
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
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(
        20,
        20,
        20,
        MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Create New',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 20),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ActivityType.values.map((t) {
                final isSelected = _type == t;
                return GestureDetector(
                  onTap: () => setState(() => _type = t),
                  child: Container(
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary
                          : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : Colors.transparent,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: AppColors.primary.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : [],
                    ),
                    child: Row(
                      children: [
                        Icon(
                          _getIcon(t),
                          size: 20,
                          color: isSelected
                              ? Colors.white
                              : Colors.grey.shade600,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          t == ActivityType.therapy
                              ? 'Reminder'
                              : t.name.capitalize(),
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _title,
            decoration: InputDecoration(
              labelText: 'Title',
              hintText: 'What are you doing?',
              filled: true,
              fillColor: Colors.grey.shade50,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              prefixIcon: const Icon(Icons.title),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _notes,
            decoration: InputDecoration(
              labelText: 'Notes (Optional)',
              hintText: 'Add details...',
              filled: true,
              fillColor: Colors.grey.shade50,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              prefixIcon: const Icon(Icons.notes),
            ),
            maxLines: 3,
            minLines: 1,
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: _pickDate,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          size: 18,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          DateFormat.yMMMd().format(_dateTime),
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: _pickTime,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.access_time,
                          size: 18,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          DateFormat.jm().format(_dateTime),
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Create',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIcon(ActivityType t) {
    switch (t) {
      case ActivityType.meditation:
        return Icons.self_improvement;
      case ActivityType.therapy:
        return Icons.spa;
      case ActivityType.journal:
        return Icons.menu_book;

      default:
        return Icons.task_alt;
    }
  }

  Future<void> _pickDate() async {
    final d = await showDatePicker(
      context: context,
      initialDate: _dateTime,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (d != null) {
      setState(() {
        _dateTime = DateTime(
          d.year,
          d.month,
          d.day,
          _dateTime.hour,
          _dateTime.minute,
        );
      });
    }
  }

  Future<void> _pickTime() async {
    final t = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_dateTime),
    );
    if (t != null) {
      setState(() {
        _dateTime = DateTime(
          _dateTime.year,
          _dateTime.month,
          _dateTime.day,
          t.hour,
          t.minute,
        );
      });
    }
  }

  Future<void> _submit() async {
    if (_title.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter a title')));
      return;
    }

    // Journal Logic
    if (_type == ActivityType.journal) {
      final prov = Provider.of<ActivityProvider>(context, listen: false);
      await prov.addJournal(
        JournalEntry(
          id: '',
          date: _dateTime,
          title: _title.text.trim(),
          content: _notes.text.trim(),
        ),
      );
      if (mounted) Navigator.pop(context);
      return;
    }

    // Therapy -> Reminder Logic
    if (_type == ActivityType.therapy) {
      final prov = Provider.of<ActivityProvider>(context, listen: false);
      await prov.addReminder(
        SessionReminder(
          id: FirebaseAuth.instance.currentUser!.uid,
          dateTime: _dateTime,
          title: _title.text.trim(),
          notes: _notes.text.trim(),
        ),
      );
      if (mounted) Navigator.pop(context);
      return;
    }

    // Default Activity Logic
    widget.onCreate(
      _type,
      _title.text.trim(),
      _notes.text.trim(),
      _dateTime,
      userId,
    );
    // widget.onCreate handles Navigator.pop
  }
}

/// -----------------------------
/// Helpers / String ext
/// -----------------------------
extension StringCaps on String {
  String capitalize() => isEmpty ? this : this[0].toUpperCase() + substring(1);
}
