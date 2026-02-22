import 'package:flutter/material.dart';
import 'package:mental_healthcare/frontend/widgets/appcolors.dart';

class SelfCareScreen extends StatefulWidget {
  const SelfCareScreen({super.key});

  @override
  State<SelfCareScreen> createState() => _SelfCareScreenState();
}

class _SelfCareScreenState extends State<SelfCareScreen> {
  // Sample lists for journaling, mood tracking
  List<String> moods = ["Happy", "Good", "Okay", "Sad", "Stressed"];
  String? selectedMood;
  List<Map<String, String>> journalEntries = [];

  final TextEditingController _journalController = TextEditingController();

  @override
  void dispose() {
    _journalController.dispose();
    super.dispose();
  }

  void _addJournalEntry() {
    if (_journalController.text.isNotEmpty) {
      setState(() {
        journalEntries.insert(0, {
          "mood": selectedMood ?? "N/A",
          "note": _journalController.text,
          "date": DateTime.now().toString().split(" ")[0],
        });
        _journalController.clear();
        selectedMood = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Self-care & Journaling",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Mood selection
            const Text(
              "How are you feeling today?",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textColorPrimary),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              children: moods
                  .map((mood) => ChoiceChip(
                        label: Text(mood),
                        selected: selectedMood == mood,
                        selectedColor: AppColors.accent,
                        onSelected: (val) {
                          setState(() {
                            selectedMood = val ? mood : null;
                          });
                        },
                      ))
                  .toList(),
            ),
            const SizedBox(height: 20),

            // Journal input
            const Text(
              "Write your journal entry",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textColorPrimary),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _journalController,
              maxLines: 4,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: "Write something about your day...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _addJournalEntry,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text(
                "Add Entry",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              "Your Entries",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textColorPrimary),
            ),
            const SizedBox(height: 10),

            // Entries list
            Expanded(
              child: journalEntries.isEmpty
                  ? const Center(
                      child: Text(
                        "No journal entries yet.",
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: journalEntries.length,
                      itemBuilder: (context, index) {
                        final entry = journalEntries[index];
                        return Card(
                          color: AppColors.cardColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      entry["mood"] ?? "N/A",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      entry["date"] ?? "",
                                      style: const TextStyle(
                                          color: Colors.grey, fontSize: 12),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                SelectableText(
                                  entry["note"] ?? "",
                                  style: const TextStyle(
                                      color: Colors.black87, fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
