import 'package:flutter/material.dart';
import 'package:mental_healthcare/backend/checkin_backend.dart';
import 'package:mental_healthcare/frontend/widgets/appcolors.dart';
import 'package:provider/provider.dart';

// =====================================================
//                MOOD PROVIDER
// =====================================================
class MoodProvider extends ChangeNotifier {
  final MoodService _service = MoodService();

  String? selectedMood;
  String note = "";
  bool isLoading = false;

  // Mood → Number Mapping
  final Map<String, int> moodValues = {
    "Happy": 6,
    "Good": 5,
    "Okay": 4,
    "Sad": 3,
    "Stressed": 2,
    "Angry": 1,
  };

  // List of submitted check-ins
  List<Map<String, String>> submittedMoods = [];

  // Save mood
  Future<void> submitMood() async {
    if (selectedMood == null) return;

    isLoading = true;
    notifyListeners();

    int moodNumber = moodValues[selectedMood!]!;

    // Save to Firestore
    await _service.saveMood(selectedMood!, note.trim(), moodNumber);

    // Add to UI list
    submittedMoods.insert(0, {
      "mood": selectedMood!,
      "note": note,
      "date": DateTime.now().toString().split(" ")[0],
      "number": moodNumber.toString(),
    });

    // Reset
    selectedMood = null;
    note = "";
    isLoading = false;
    notifyListeners();
  }

  void setMood(String mood) {
    selectedMood = mood;
    notifyListeners();
  }

  void setNote(String value) {
    note = value;

    notifyListeners();
  }

  void deleteMood(int index) {
    submittedMoods.removeAt(index);
    notifyListeners();
  }
}

// =====================================================
//                CHECK-IN SCREEN UI
// =====================================================

class CheckInScreen extends StatelessWidget {
  const CheckInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<MoodProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black54),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Daily Check-In",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                  child: const Center(
                    child: Text(
                      "How are you feeling today?",
                      style: TextStyle(
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
                  children: [
                    _moodCard(
                      context,
                      "Happy",
                      Icons.sentiment_very_satisfied,
                      Colors.green,
                    ),
                    _moodCard(
                      context,
                      "Good",
                      Icons.sentiment_satisfied,
                      Colors.lightBlue,
                    ),
                    _moodCard(
                      context,
                      "Okay",
                      Icons.sentiment_neutral,
                      Colors.blueGrey,
                    ),
                    _moodCard(
                      context,
                      "Sad",
                      Icons.sentiment_dissatisfied,
                      Colors.purple,
                    ),
                    _moodCard(
                      context,
                      "Stressed",
                      Icons.sentiment_very_dissatisfied,
                      Colors.orange,
                    ),
                    _moodCard(context, "Angry", Icons.mood_bad, Colors.red),
                  ],
                ),
                const SizedBox(height: 30),

                // Notes
                Text(
                  "Add a short note (optional)",
                  style: TextStyle(
                    color: AppColors.textColorPrimary.withOpacity(0.8),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 10),

                TextField(
                  maxLines: 4,
                  onChanged: prov.setNote,
                  decoration: InputDecoration(
                    hintText: "Write how you're feeling...",
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
                          await prov.submitMood();

                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Check-in submitted!"),
                            ),
                          );
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
                        prov.isLoading ? "Submitting..." : "Submit",
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
                if (prov.submittedMoods.isNotEmpty)
                  const Text(
                    "Your Check-ins",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textColorPrimary,
                    ),
                  ),
                const SizedBox(height: 10),

                ...prov.submittedMoods.asMap().entries.map((entry) {
                  int index = entry.key;
                  var moodData = entry.value;

                  return Card(
                    color: AppColors.cardColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: Icon(
                        _moodIcon(moodData["mood"]!),
                        color: _moodColor(moodData["mood"]!),
                        size: 30,
                      ),

                      title: Text(
                        "${moodData["mood"]!}  (Score: ${moodData["number"]!})",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),

                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          SelectableText(
                            moodData["note"]!,
                            style: const TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Date: ${moodData["date"]!}",
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => prov.deleteMood(index),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),

          // Loading overlay
          if (prov.isLoading)
            Container(
              color: Colors.black26,
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }

  // =====================================================
  //                 WIDGET HELPERS
  // =====================================================

  Widget _moodCard(
    BuildContext context,
    String title,
    IconData icon,
    Color highlightColor,
  ) {
    final prov = Provider.of<MoodProvider>(context);
    final bool isSelected = prov.selectedMood == title;

    return GestureDetector(
      onTap: () => prov.setMood(title),
      child: Container(
        width: 100,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected
              ? highlightColor.withOpacity(.2)
              : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? highlightColor : Colors.black26,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? highlightColor : Colors.black54,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? highlightColor : AppColors.textColorPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _moodIcon(String mood) {
    switch (mood) {
      case "Happy":
        return Icons.sentiment_very_satisfied;
      case "Good":
        return Icons.sentiment_satisfied;
      case "Okay":
        return Icons.sentiment_neutral;
      case "Sad":
        return Icons.sentiment_dissatisfied;
      case "Stressed":
        return Icons.sentiment_very_dissatisfied;
      case "Angry":
        return Icons.mood_bad;
      default:
        return Icons.sentiment_neutral;
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
}
