// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:mental_healthcare/backend/checkin_backend.dart';
// import 'package:mental_healthcare/frontend/customer_interface/loginscreen.dart';
// import 'package:mental_healthcare/frontend/widgets/appcolors.dart';
// import 'package:provider/provider.dart';
// import 'package:intl/intl.dart';

// // =====================================================
// //                MOOD PROVIDER
// // =====================================================
// class MoodProvider extends ChangeNotifier {
//   final MoodService _service = MoodService();

//   String? selectedMood;
//   String note = "";
//   bool isLoading = false;

//   // Mood → Number Mapping
//   final Map<String, int> moodValues = {
//     "Happy": 6,
//     "Good": 5,
//     "Okay": 4,
//     "Sad": 3,
//     "Stressed": 2,
//     "Angry": 1,
//   };

//   // List of submitted check-ins
//   List<Map<String, dynamic>> submittedMoods = [];

//   // Load moods from backend
//   Future<void> loadMoods() async {
//     isLoading = true;
//     // notifyListeners(); // Defer notification to avoid build conflicts if called from initState

//     try {
//       final fetched = await _service.fetchMoods();
//       submittedMoods = fetched.map((m) {
//         final dateObj = (m['date'] as DateTime).toLocal();
//         // Format: YYYY-MM-DD HH:MM
//         final dateStr =
//             "${dateObj.year}-${dateObj.month.toString().padLeft(2, '0')}-${dateObj.day.toString().padLeft(2, '0')} ${dateObj.hour.toString().padLeft(2, '0')}:${dateObj.minute.toString().padLeft(2, '0')}";

//         return {
//           "id": m['id'].toString(),
//           "mood": m['mood'].toString(),
//           "note": m['note'].toString(),
//           "date": dateStr,
//           "number": m['number'].toString(),
//         };
//       }).toList();
//     } catch (e) {
//       print("Error loading moods: $e");
//     } finally {
//       isLoading = false;
//       notifyListeners();
//     }
//   }

//   // Save mood
//   Future<bool> submitMood() async {
//     if (selectedMood == null) return false;

//     isLoading = true;
//     notifyListeners();

//     try {
//       int moodNumber = moodValues[selectedMood!]!;

//       // Save to Firestore
//       await _service.saveMood(selectedMood!, note.trim(), moodNumber);

//       // Refresh list from backend to handle updates/inserts correctly
//       await loadMoods();

//       // Reset
//       selectedMood = null;
//       note = "";
//       return true;
//     } catch (e) {
//       print("Error submitting mood: $e");
//       return false;
//     } finally {
//       isLoading = false;
//       notifyListeners();
//     }
//   }

//   void setMood(String mood) {
//     selectedMood = mood;
//     notifyListeners();
//   }

//   void setNote(String value) {
//     note = value;

//     notifyListeners();
//   }

//   Future<void> deleteMood(String id) async {
//     // Optimistic update
//     submittedMoods.removeWhere((m) => m['id'] == id);
//     notifyListeners();

//     try {
//       await _service.deleteMood(id);
//     } catch (e) {
//       print("Error deleting mood: $e");
//       // Optionally reload or show error if deletion failed
//       await loadMoods();
//     }
//   }

//   void clearMoods() {
//     submittedMoods = [];
//     selectedMood = null;
//     note = "";
//     isLoading = false;
//     notifyListeners();
//   }
// }

// // =====================================================
// //                CHECK-IN SCREEN UI
// // =====================================================

// class CheckInScreen extends StatefulWidget {
//   const CheckInScreen({super.key});

//   @override
//   State<CheckInScreen> createState() => _CheckInScreenState();
// }

// class _CheckInScreenState extends State<CheckInScreen> {
//   final TextEditingController _noteController = TextEditingController();
//   DateTime? _filterDate;

//   @override
//   void dispose() {
//     _noteController.dispose();
//     super.dispose();
//   }

//   @override
//   void initState() {
//     super.initState();
//     // Load moods when screen initializes
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (mounted) {
//         final prov = Provider.of<MoodProvider>(context, listen: false);
//         prov.loadMoods();
//         _noteController.text = prov.note;
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final prov = Provider.of<MoodProvider>(context);

//     return Scaffold(
//       backgroundColor: AppColors.background,
//       appBar: AppBar(
//         backgroundColor: AppColors.background,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios, color: Colors.black54),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: const Text(
//           "Daily Check-In",
//           style: TextStyle(
//             color: Colors.black87,
//             fontWeight: FontWeight.bold,
//             fontSize: 18,
//           ),
//         ),
//         centerTitle: true,
//         actions: [
//           IconButton(
//             icon: Icon(
//               _filterDate == null
//                   ? Icons.calendar_month
//                   : Icons.calendar_month_outlined,
//               color: _filterDate == null ? Colors.black54 : AppColors.primary,
//             ),
//             onPressed: _pickDate,
//           ),
//           if (_filterDate != null)
//             IconButton(
//               icon: const Icon(Icons.close, color: Colors.red),
//               onPressed: () {
//                 setState(() {
//                   _filterDate = null;
//                 });
//               },
//             ),
//         ],
//       ),
//       body: Stack(
//         children: [
//           SingleChildScrollView(
//             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 // Header
//                 Container(
//                   width: double.infinity,
//                   padding: const EdgeInsets.symmetric(vertical: 18),
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       colors: [AppColors.primary, AppColors.accent],
//                       begin: Alignment.topLeft,
//                       end: Alignment.bottomRight,
//                     ),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: const Center(
//                     child: Text(
//                       "How are you feeling today?",
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 17,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 25),

//                 // Mood Cards
//                 Wrap(
//                   spacing: 15,
//                   runSpacing: 15,
//                   alignment: WrapAlignment.center,
//                   children: [
//                     _moodCard(context, "Happy", "🤩", Colors.green),
//                     _moodCard(context, "Good", "😊", Colors.lightBlue),
//                     _moodCard(context, "Okay", "😐", Colors.blueGrey),
//                     _moodCard(context, "Sad", "😢", Colors.purple),
//                     _moodCard(context, "Stressed", "😫", Colors.orange),
//                     _moodCard(context, "Angry", "😡", Colors.red),
//                   ],
//                 ),
//                 const SizedBox(height: 30),

//                 // Notes
//                 Text(
//                   "Add a short note (optional)",
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     color: AppColors.textColorPrimary.withOpacity(0.8),
//                     fontSize: 16,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//                 const SizedBox(height: 10),

//                 TextField(
//                   controller: _noteController,
//                   maxLines: 4,
//                   onChanged: prov.setNote,
//                   decoration: InputDecoration(
//                     hintText: "Write how you're feeling...",
//                     filled: true,
//                     fillColor: AppColors.cardColor,
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                       borderSide: BorderSide.none,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 25),

//                 // Submit Button
//                 GestureDetector(
//                   onTap: prov.isLoading
//                       ? null
//                       : () async {
//                           if (FirebaseAuth.instance.currentUser == null) {
//                             showDialog(
//                               context: context,
//                               builder: (context) => AlertDialog(
//                                 title: const Text("Access Restricted"),
//                                 content: const Text(
//                                   "You must login to check in your mood.",
//                                 ),
//                                 actions: [
//                                   TextButton(
//                                     onPressed: () => Navigator.pop(context),
//                                     child: const Text("Cancel"),
//                                   ),
//                                   ElevatedButton(
//                                     style: ElevatedButton.styleFrom(
//                                       backgroundColor: AppColors.primary,
//                                     ),
//                                     onPressed: () {
//                                       Navigator.pop(context); // Close dialog
//                                       Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                           builder: (_) => const LoginScreen(),
//                                         ),
//                                       );
//                                     },
//                                     child: const Text(
//                                       "Login",
//                                       style: TextStyle(color: Colors.white),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             );
//                             return;
//                           }

//                           if (prov.selectedMood == null) {
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               const SnackBar(
//                                 content: Text("Please select a mood first!"),
//                                 backgroundColor: Colors.redAccent,
//                               ),
//                             );
//                             return;
//                           }

//                           bool success = await prov.submitMood();

//                           if (!context.mounted) return;

//                           if (success) {
//                             _noteController.clear();
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               const SnackBar(
//                                 content: Text("Check-in submitted!"),
//                                 backgroundColor: Colors.green,
//                               ),
//                             );
//                           }
//                         },
//                   child: Container(
//                     width: double.infinity,
//                     padding: const EdgeInsets.symmetric(vertical: 14),
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                         colors: [AppColors.primary, AppColors.accent],
//                         begin: Alignment.topLeft,
//                         end: Alignment.bottomRight,
//                       ),
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Center(
//                       child: Text(
//                         prov.isLoading ? "Submitting..." : "Submit",
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 16,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),

//                 const SizedBox(height: 30),

//                 // List of Check-ins
//                 if (prov.submittedMoods.isNotEmpty) ...[
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       const Text(
//                         "Your Check-ins",
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                           color: AppColors.textColorPrimary,
//                         ),
//                       ),
//                       if (_filterDate != null) ...[
//                         const SizedBox(width: 8),
//                         Text(
//                           "(${DateFormat('MMM d').format(_filterDate!)})",
//                           style: TextStyle(
//                             fontSize: 14,
//                             color: AppColors.primary,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ],
//                     ],
//                   ),
//                   const SizedBox(height: 10),
//                   ..._buildGroupedMoods(prov.submittedMoods, prov),
//                 ],
//               ],
//             ),
//           ),

//           // Loading overlay
//           if (prov.isLoading)
//             Container(
//               color: Colors.black26,
//               child: const Center(child: CircularProgressIndicator()),
//             ),
//         ],
//       ),
//     );
//   }

//   // =====================================================
//   //                 WIDGET HELPERS
//   // =====================================================

//   Future<void> _pickDate() async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: _filterDate ?? DateTime.now(),
//       firstDate: DateTime(2020),
//       lastDate: DateTime.now(),
//       builder: (context, child) {
//         return Theme(
//           data: Theme.of(context).copyWith(
//             colorScheme: ColorScheme.light(
//               primary: AppColors.primary,
//               onPrimary: Colors.white,
//               onSurface: Colors.black,
//             ),
//           ),
//           child: child!,
//         );
//       },
//     );

//     if (picked != null && picked != _filterDate) {
//       setState(() {
//         _filterDate = picked;
//       });
//     }
//   }

//   Widget _moodCard(
//     BuildContext context,
//     String title,
//     String emoji,
//     Color highlightColor,
//   ) {
//     final prov = Provider.of<MoodProvider>(context);
//     final bool isSelected = prov.selectedMood == title;

//     return GestureDetector(
//       onTap: () => prov.setMood(title),
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 200),
//         width: 100,
//         padding: const EdgeInsets.symmetric(vertical: 16),
//         decoration: BoxDecoration(
//           color: isSelected ? highlightColor.withOpacity(0.15) : Colors.white,
//           borderRadius: BorderRadius.circular(20),
//           border: Border.all(
//             color: isSelected ? highlightColor : Colors.grey.shade200,
//             width: isSelected ? 2 : 1,
//           ),
//           boxShadow: isSelected
//               ? [
//                   BoxShadow(
//                     color: highlightColor.withOpacity(0.3),
//                     blurRadius: 12,
//                     offset: const Offset(0, 6),
//                   ),
//                 ]
//               : [
//                   BoxShadow(
//                     color: Colors.grey.withOpacity(0.05),
//                     blurRadius: 6,
//                     offset: const Offset(0, 3),
//                   ),
//                 ],
//         ),
//         child: Column(
//           children: [
//             AnimatedScale(
//               scale: isSelected ? 1.2 : 1.0,
//               duration: const Duration(milliseconds: 200),
//               curve: Curves.easeInOutBack,
//               child: Text(emoji, style: const TextStyle(fontSize: 40)),
//             ),
//             const SizedBox(height: 12),
//             Text(
//               title,
//               style: TextStyle(
//                 color: isSelected ? highlightColor : AppColors.textColorPrimary,
//                 fontSize: 14,
//                 fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   String _moodEmoji(String mood) {
//     switch (mood) {
//       case "Happy":
//         return "🤩";
//       case "Good":
//         return "😊";
//       case "Okay":
//         return "😐";
//       case "Sad":
//         return "😢";
//       case "Stressed":
//         return "😫";
//       case "Angry":
//         return "😡";
//       default:
//         return "😐";
//     }
//   }

//   Color _moodColor(String mood) {
//     switch (mood) {
//       case "Happy":
//         return Colors.green;
//       case "Good":
//         return Colors.lightBlue;
//       case "Okay":
//         return Colors.blueGrey;
//       case "Sad":
//         return Colors.purple;
//       case "Stressed":
//         return Colors.orange;
//       case "Angry":
//         return Colors.red;
//       default:
//         return Colors.grey;
//     }
//   }

//   List<Widget> _buildGroupedMoods(
//     List<Map<String, dynamic>> moods,
//     MoodProvider prov,
//   ) {
//     // 1. Prepare data with original indices
//     List<Map<String, dynamic>> moodsWithIndex = moods.asMap().entries.map((e) {
//       var m = Map<String, dynamic>.from(e.value);
//       m['originalIndex'] = e.key;
//       return m;
//     }).toList();

//     // 2. Group by Date
//     Map<String, List<Map<String, dynamic>>> grouped = {};
//     for (var m in moodsWithIndex) {
//       String rawDate = m['date'];
//       String datePart = rawDate.split(' ')[0]; // "2025-12-12"
//       DateTime dt = DateTime.parse(datePart);

//       // Filter logic
//       if (_filterDate != null) {
//         bool isSameDay =
//             dt.year == _filterDate!.year &&
//             dt.month == _filterDate!.month &&
//             dt.day == _filterDate!.day;
//         if (!isSameDay) continue;
//       }

//       String formattedDate = DateFormat(
//         'dd MMMM yyyy',
//       ).format(dt); // "12 December 2025"

//       if (!grouped.containsKey(formattedDate)) {
//         grouped[formattedDate] = [];
//       }
//       grouped[formattedDate]!.add(m);
//     }

//     if (grouped.isEmpty && _filterDate != null) {
//       return [
//         const Padding(
//           padding: EdgeInsets.symmetric(vertical: 30),
//           child: Center(child: Text("No entries found for this date.")),
//         ),
//       ];
//     }

//     List<Widget> widgets = [];

//     grouped.forEach((date, dateMoods) {
//       // Add Date Header
//       widgets.add(
//         Padding(
//           padding: const EdgeInsets.only(top: 20, bottom: 10),
//           child: Center(
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//               decoration: BoxDecoration(
//                 color: Colors.grey.shade200,
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               child: Text(
//                 date,
//                 style: const TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 14,
//                   color: Colors.black87,
//                 ),
//               ),
//             ),
//           ),
//         ),
//       );

//       // Add Mood Cards for this date
//       for (var moodData in dateMoods) {
//         widgets.add(_buildMoodItem(moodData, prov));
//       }
//     });

//     return widgets;
//   }

//   Widget _buildMoodItem(Map<String, dynamic> moodData, MoodProvider prov) {
//     return Card(
//       color: AppColors.cardColor,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       margin: const EdgeInsets.symmetric(vertical: 8),
//       child: ListTile(
//         leading: Text(
//           _moodEmoji(moodData["mood"]!),
//           style: const TextStyle(fontSize: 30),
//         ),

//         title: Text(
//           "${moodData["mood"]!}  (Score: ${moodData["number"]!})",
//           style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//         ),

//         subtitle: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const SizedBox(height: 4),
//             if (moodData["note"] != null &&
//                 moodData["note"].toString().isNotEmpty)
//               SelectableText(
//                 moodData["note"]!,
//                 style: const TextStyle(fontSize: 14),
//               ),
//             const SizedBox(height: 4),
//             Text(
//               "Time: ${moodData["date"]!.split(' ')[1]}",
//               style: const TextStyle(fontSize: 12, color: Colors.grey),
//             ),
//           ],
//         ),
//         trailing: IconButton(
//           icon: const Icon(Icons.delete, color: Colors.red),
//           onPressed: () => prov.deleteMood(moodData['id']),
//         ),
//       ),
//     );
//   }
// }
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mental_healthcare/backend/checkin_backend.dart';
import 'package:mental_healthcare/frontend/customer_interface/loginscreen.dart';
import 'package:mental_healthcare/frontend/widgets/appcolors.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:mental_healthcare/l10n/app_localizations.dart';

// =====================================================
//                MOOD PROVIDER
// =====================================================
class MoodProvider extends ChangeNotifier {
  final MoodService _service = MoodService();

  String? selectedMood;
  String note = "";
  bool isLoading = false;

  final Map<String, int> moodValues = {
    "Happy": 6,
    "Good": 5,
    "Okay": 4,
    "Sad": 3,
    "Stressed": 2,
    "Angry": 1,
  };

  List<Map<String, dynamic>> submittedMoods = [];

  Future<void> loadMoods() async {
    isLoading = true;

    try {
      final fetched = await _service.fetchMoods();
      submittedMoods = fetched.map((m) {
        final dateObj = (m['date'] as DateTime).toLocal();
        final dateStr =
            "${dateObj.year}-${dateObj.month.toString().padLeft(2, '0')}-${dateObj.day.toString().padLeft(2, '0')} ${dateObj.hour.toString().padLeft(2, '0')}:${dateObj.minute.toString().padLeft(2, '0')}";
        return {
          "id": m['id'].toString(),
          "mood": m['mood'].toString(),
          "note": m['note'].toString(),
          "date": dateStr,
          "number": m['number'].toString(),
        };
      }).toList();
    } catch (e) {
      print("Error loading moods: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> submitMood() async {
    if (selectedMood == null) return false;

    isLoading = true;
    notifyListeners();

    try {
      int moodNumber = moodValues[selectedMood!]!;
      await _service.saveMood(selectedMood!, note.trim(), moodNumber);
      await loadMoods();
      selectedMood = null;
      note = "";
      return true;
    } catch (e) {
      print("Error submitting mood: $e");
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void setMood(String mood) {
    selectedMood = mood;
    notifyListeners();
  }

  void setNote(String value) {
    note = value;
    notifyListeners();
  }

  Future<void> deleteMood(String id) async {
    submittedMoods.removeWhere((m) => m['id'] == id);
    notifyListeners();

    try {
      await _service.deleteMood(id);
    } catch (e) {
      print("Error deleting mood: $e");
      await loadMoods();
    }
  }

  void clearMoods() {
    submittedMoods = [];
    selectedMood = null;
    note = "";
    isLoading = false;
    notifyListeners();
  }
}

// =====================================================
//                CHECK-IN SCREEN UI
// =====================================================
class CheckInScreen extends StatefulWidget {
  const CheckInScreen({super.key});

  @override
  State<CheckInScreen> createState() => _CheckInScreenState();
}

class _CheckInScreenState extends State<CheckInScreen> {
  final TextEditingController _noteController = TextEditingController();
  DateTime? _filterDate;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final prov = Provider.of<MoodProvider>(context, listen: false);
        prov.loadMoods();
        _noteController.text = prov.note;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<MoodProvider>(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black54),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          l10n.dailyCheckIn,
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              _filterDate == null
                  ? Icons.calendar_month
                  : Icons.calendar_month_outlined,
              color: _filterDate == null ? Colors.black54 : AppColors.primary,
            ),
            onPressed: _pickDate,
          ),
          if (_filterDate != null)
            IconButton(
              icon: const Icon(Icons.close, color: Colors.red),
              onPressed: () {
                setState(() {
                  _filterDate = null;
                });
              },
            ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.primary, AppColors.accent],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      l10n.howFeelingToday,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 25),

                // Mood Cards
                Wrap(
                  spacing: 15,
                  runSpacing: 15,
                  alignment: WrapAlignment.center,
                  children: [
                    _moodCard(context, l10n.happy, "🤩", Colors.green),
                    _moodCard(context, l10n.good, "😊", Colors.lightBlue),
                    _moodCard(context, l10n.okay, "😐", Colors.blueGrey),
                    _moodCard(context, l10n.sad, "😢", Colors.purple),
                    _moodCard(context, l10n.stressed, "😫", Colors.orange),
                    _moodCard(context, l10n.angry, "😡", Colors.red),
                  ],
                ),
                const SizedBox(height: 30),

                // Notes
                Text(
                  l10n.addShortNote,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textColorPrimary.withOpacity(0.8),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 10),

                TextField(
                  controller: _noteController,
                  maxLines: 4,
                  onChanged: prov.setNote,
                  decoration: InputDecoration(
                    hintText: l10n.writeFeeling,
                    filled: true,
                    fillColor: AppColors.cardColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 25),

                // Submit Button
                GestureDetector(
                  onTap: prov.isLoading
                      ? null
                      : () async {
                          if (FirebaseAuth.instance.currentUser == null) {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text(l10n.accessRestricted),
                                content: Text(l10n.mustLoginMood),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text(l10n.cancel),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primary,
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => const LoginScreen(),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      l10n.login,
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                            return;
                          }

                          if (prov.selectedMood == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(l10n.selectMoodFirst),
                                backgroundColor: Colors.redAccent,
                              ),
                            );
                            return;
                          }

                          bool success = await prov.submitMood();
                          if (!context.mounted) return;

                          if (success) {
                            _noteController.clear();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(l10n.checkInSubmitted),
                                backgroundColor: Colors.green,
                              ),
                            );
                          }
                        },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.primary, AppColors.accent],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        prov.isLoading ? l10n.submitting : l10n.submit,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // List of Check-ins
                if (prov.submittedMoods.isNotEmpty) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        l10n.yourCheckIns,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textColorPrimary,
                        ),
                      ),
                      if (_filterDate != null) ...[
                        const SizedBox(width: 8),
                        Text(
                          "(${DateFormat('MMM d').format(_filterDate!)})",
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 10),
                  ..._buildGroupedMoods(prov.submittedMoods, prov),
                ],
              ],
            ),
          ),
          if (prov.isLoading)
            Container(
              color: Colors.black26,
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }

  // ----------------------- WIDGET HELPERS -----------------------

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _filterDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _filterDate) {
      setState(() {
        _filterDate = picked;
      });
    }
  }

  Widget _moodCard(
    BuildContext context,
    String title,
    String emoji,
    Color highlightColor,
  ) {
    final prov = Provider.of<MoodProvider>(context);
    final bool isSelected = prov.selectedMood == title;

    return GestureDetector(
      onTap: () => prov.setMood(title),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 100,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? highlightColor.withOpacity(0.15) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? highlightColor : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: highlightColor.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.05),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
        ),
        child: Column(
          children: [
            AnimatedScale(
              scale: isSelected ? 1.2 : 1.0,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOutBack,
              child: Text(emoji, style: const TextStyle(fontSize: 40)),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? highlightColor : AppColors.textColorPrimary,
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _moodEmoji(String mood) {
    switch (mood) {
      case "Happy":
        return "🤩";
      case "Good":
        return "😊";
      case "Okay":
        return "😐";
      case "Sad":
        return "😢";
      case "Stressed":
        return "😫";
      case "Angry":
        return "😡";
      default:
        return "😐";
    }
  }

  Color _moodColor(String mood) {
    switch (mood) {
      case "Happy":
        return Colors.green;
      case "Good":
        return Colors.lightBlue;
      case "Okay":
        return Colors.blueGrey;
      case "Sad":
        return Colors.purple;
      case "Stressed":
        return Colors.orange;
      case "Angry":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  List<Widget> _buildGroupedMoods(
    List<Map<String, dynamic>> moods,
    MoodProvider prov,
  ) {
    List<Map<String, dynamic>> moodsWithIndex = moods.asMap().entries.map((e) {
      var m = Map<String, dynamic>.from(e.value);
      m['originalIndex'] = e.key;
      return m;
    }).toList();

    Map<String, List<Map<String, dynamic>>> grouped = {};
    for (var m in moodsWithIndex) {
      String rawDate = m['date'];
      String datePart = rawDate.split(' ')[0];
      DateTime dt = DateTime.parse(datePart);

      if (_filterDate != null) {
        bool isSameDay =
            dt.year == _filterDate!.year &&
            dt.month == _filterDate!.month &&
            dt.day == _filterDate!.day;
        if (!isSameDay) continue;
      }

      String formattedDate = DateFormat('dd MMMM yyyy').format(dt);

      if (!grouped.containsKey(formattedDate)) {
        grouped[formattedDate] = [];
      }
      grouped[formattedDate]!.add(m);
    }

    if (grouped.isEmpty && _filterDate != null) {
      return [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 30),
          child: Center(child: Text("No entries found for this date.")),
        ),
      ];
    }

    List<Widget> widgets = [];

    grouped.forEach((date, dateMoods) {
      widgets.add(
        Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 10),
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                date,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
        ),
      );

      for (var moodData in dateMoods) {
        widgets.add(_buildMoodItem(moodData, prov));
      }
    });

    return widgets;
  }

  Widget _buildMoodItem(Map<String, dynamic> moodData, MoodProvider prov) {
    return Card(
      color: AppColors.cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Text(
          _moodEmoji(moodData["mood"]!),
          style: const TextStyle(fontSize: 30),
        ),
        title: Text(
          "${moodData["mood"]!}  (Score: ${moodData["number"]!})",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            if (moodData["note"] != null &&
                moodData["note"].toString().isNotEmpty)
              SelectableText(
                moodData["note"]!,
                style: const TextStyle(fontSize: 14),
              ),
            const SizedBox(height: 4),
            Text(
              "Time: ${moodData["date"]!.split(' ')[1]}",
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () => prov.deleteMood(moodData['id']),
        ),
      ),
    );
  }
}
