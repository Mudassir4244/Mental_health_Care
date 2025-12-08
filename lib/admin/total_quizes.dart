// import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mental_healthcare/admin/admin_backend/quiz_upload_backend.dart';

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
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: const Text(
          'All Quizzes',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Quizes')
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

              final question = doc['question'];
              final options = List<String>.from(doc['options']);
              final correctIndex = doc['correctIndex'];

              return Card(
                elevation: 4,
                margin: const EdgeInsets.only(bottom: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Question
                      Text(
                        "Q${index + 1}: $question",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Options List
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(options.length, (i) {
                          final isCorrect = i == correctIndex;
                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isCorrect
                                  ? Colors.green.withOpacity(0.2)
                                  : Colors.grey.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                              border: isCorrect
                                  ? Border.all(color: Colors.green, width: 1)
                                  : null,
                            ),
                            child: Text(
                              "${String.fromCharCode(65 + i)}. ${options[i]}",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: isCorrect
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: isCorrect
                                    ? Colors.green.shade800
                                    : Colors.black87,
                              ),
                            ),
                          );
                        }),
                      ),

                      const SizedBox(height: 15),

                      // Action Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // EDIT (Optional Navigation)
                          // TextButton.icon(
                          //   onPressed: () {
                          //     // TODO: Add your update screen here
                          //   },
                          //   icon: const Icon(Icons.edit, color: Colors.blue),
                          //   label: const Text(
                          //     "Edit",
                          //     style: TextStyle(color: Colors.blue),
                          //   ),
                          // ),
                          const SizedBox(width: 10),

                          // DELETE
                          TextButton.icon(
                            onPressed: () async {
                              await quizService.deleteQuiz(id);
                            },
                            icon: const Icon(Icons.delete, color: Colors.red),
                            label: const Text(
                              "Delete",
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
