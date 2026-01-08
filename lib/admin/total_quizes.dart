import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mental_healthcare/admin/admin_backend/quiz_upload_backend.dart';
import 'package:mental_healthcare/admin/admin_homescreen.dart';
import 'package:mental_healthcare/admin/upload_content/upload_quiz/Mcqs_upload.dart';

class TotalQuizes extends StatefulWidget {
  const TotalQuizes({super.key});

  @override
  State<TotalQuizes> createState() => _TotalQuizesState();
}

class _TotalQuizesState extends State<TotalQuizes> {
  final QuizService quizService = QuizService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to quiz upload screen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) {
                return const QuizUploadScreen();
              },
            ),
          );
        },
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) {
                  return AdminHomescreen();
                },
              ),
            );
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'All Quiz Papers',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('QuizPapers')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("No quizzes found.", style: TextStyle(fontSize: 18)),
            );
          }

          final quizzes = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: quizzes.length,
            itemBuilder: (context, index) {
              final doc = quizzes[index];
              final id = doc.id;
              final data = doc.data() as Map<String, dynamic>;

              final title = data['title'] ?? 'Untitled Quiz';
              final description = data['description'] ?? '';
              final questionCount = data['questionCount'] ?? 0;

              return Card(
                elevation: 4,
                margin: const EdgeInsets.only(bottom: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                child: ExpansionTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.deepPurple.withOpacity(0.1),
                    child: Text(
                      "${index + 1}",
                      style: const TextStyle(
                        color: Colors.deepPurple,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (description.isNotEmpty)
                        Text(
                          description,
                          style: TextStyle(color: Colors.grey[600]),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      const SizedBox(height: 5),
                      Text(
                        "$questionCount Questions",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                    ],
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton.icon(
                            onPressed: () async {
                              // Confirm Dialog
                              bool? confirm = await showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text("Delete Quiz?"),
                                  content: const Text(
                                    "Are you sure you want to delete this quiz paper? This cannot be undone.",
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, false),
                                      child: const Text("Cancel"),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, true),
                                      child: const Text(
                                        "Delete",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ],
                                ),
                              );

                              if (confirm == true) {
                                await quizService.deleteQuizPaper(id);
                              }
                            },
                            icon: const Icon(Icons.delete, color: Colors.red),
                            label: const Text(
                              "Delete Paper",
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
