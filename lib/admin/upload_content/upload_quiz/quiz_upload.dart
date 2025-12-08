// import 'package:flutter/material.dart';
// import 'package:mental_healthcare/admin/admin_backend/quiz_upload_backend.dart';
// import 'package:mental_healthcare/admin/provider%20Classes/quiz_provider.dart';
// import 'package:provider/provider.dart';
// // import 'quiz_provider.dart';

// class QuizUploadScreen extends StatelessWidget {
//   const QuizUploadScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final quiz = Provider.of<QuizProvider>(context);
//     final quiz_backend = QuizService();
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Upload Quiz (Admin Panel)"),
//         backgroundColor: Colors.blueGrey,
//       ),

//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // ----------------------------
//             // Question Input
//             // ----------------------------
//             Text("Enter Question:", style: labelStyle()),
//             const SizedBox(height: 10),

//             TextField(
//               onChanged: quiz.updateQuestion,
//               decoration: inputDecoration("Write your question here"),
//             ),

//             const SizedBox(height: 25),

//             // ----------------------------
//             // Options Input
//             // ----------------------------
//             Text("Options:", style: labelStyle()),
//             const SizedBox(height: 10),

//             for (int i = 1; i < 5; i++) optionTile(i, quiz as QuizProvider),

//             const SizedBox(height: 20),

//             // ----------------------------
//             // Correct Answer
//             // ----------------------------
//             Text("Select Correct Answer:", style: labelStyle()),
//             const SizedBox(height: 10),

//             Row(
//               children: List.generate(4, (i) {
//                 return Row(
//                   children: [
//                     Radio(
//                       value: i,
//                       groupValue: quiz.correctIndex,
//                       onChanged: (value) => quiz.setCorrectIndex(value!),
//                     ),
//                     Text("Option ${i + 1}"),
//                   ],
//                 );
//               }),
//             ),

//             const SizedBox(height: 25),

//             ElevatedButton(
//               onPressed: () {
//                 quiz.addQuestion();
//                 ScaffoldMessenger.of(
//                   context,
//                 ).showSnackBar(const SnackBar(content: Text("Question Added")));
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.green,
//                 padding: const EdgeInsets.symmetric(
//                   vertical: 12,
//                   horizontal: 20,
//                 ),
//               ),
//               child: const Text("Add Question"),
//             ),

//             const SizedBox(height: 40),

//             // ----------------------------
//             // Preview Questions
//             // ----------------------------
//             Text("Preview Quiz:", style: titleStyle()),
//             const SizedBox(height: 15),

//             ...quiz.questions.asMap().entries.map((entry) {
//               int index = entry.key;
//               var q = entry.value;

//               return Card(
//                 elevation: 3,
//                 child: ListTile(
//                   title: Text(q["question"]),
//                   subtitle: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       for (int i = 1; i < q["options"].length; i++)
//                         Text(
//                           "${i + 1}. ${q["options"][i]} "
//                           "${q["correct"] == i ? "(Correct)" : ""}",
//                           style: TextStyle(
//                             color: q["correct"] == i
//                                 ? Colors.green
//                                 : Colors.black,
//                             fontWeight: q["correct"] == i
//                                 ? FontWeight.bold
//                                 : FontWeight.normal,
//                           ),
//                         ),
//                     ],
//                   ),
//                   trailing: IconButton(
//                     icon: const Icon(Icons.delete, color: Colors.red),
//                     onPressed: () {
//                       quiz.removeQuestion(index);
//                     },
//                   ),
//                 ),
//               );
//             }).toList(),

//             const SizedBox(height: 20),

//             // ----------------------------
//             // Upload Full Quiz
//             // ----------------------------
//             ElevatedButton(
//               onPressed: () async {
//                 try {
//                   // Loop through all questions stored in your provider
//                   for (var q in quiz.questions) {
//                     await quiz_backend.addQuiz({
//                       "question": q["question"],
//                       "options": q["options"],
//                       "correct": q["correct['correct']"],
//                     });
//                   }

//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(
//                       content: Text("Quiz uploaded successfully!"),
//                     ),
//                   );

//                   quiz.clearQuiz(); // clear local quiz after upload
//                 } catch (e) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(content: Text("Error uploading quiz: $e")),
//                   );
//                 }
//               },
//               child: const Text("Upload Quiz"),

//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.blue,
//                 padding: const EdgeInsets.symmetric(
//                   vertical: 12,
//                   horizontal: 20,
//                 ),
//               ),
//             ),

//             const SizedBox(height: 15),

//             ElevatedButton(
//               onPressed: quiz.clearQuiz,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.red,
//                 padding: const EdgeInsets.symmetric(
//                   vertical: 12,
//                   horizontal: 20,
//                 ),
//               ),
//               child: const Text("Clear All"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // ----------------------------
//   // UI Helper Widgets
//   // ----------------------------

//   Widget optionTile(int index, QuizProvider quiz) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 10),
//       child: TextField(
//         onChanged: (value) => quiz.updateOption(index, value),
//         decoration: inputDecoration("Option ${index + 1}"),
//       ),
//     );
//   }

//   // ----------------------------
//   // Styles
//   // ----------------------------

//   InputDecoration inputDecoration(String text) {
//     return InputDecoration(
//       hintText: text,
//       border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//       filled: true,
//       fillColor: Colors.white,
//     );
//   }

//   TextStyle labelStyle() =>
//       const TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
//   TextStyle titleStyle() =>
//       const TextStyle(fontSize: 22, fontWeight: FontWeight.bold);
// }

import 'package:flutter/material.dart';
import 'package:mental_healthcare/admin/admin_backend/quiz_upload_backend.dart';
import 'package:provider/provider.dart';
import 'package:mental_healthcare/admin/provider Classes/quiz_provider.dart';

class QuizUploadScreen extends StatefulWidget {
  const QuizUploadScreen({super.key});

  @override
  State<QuizUploadScreen> createState() => _QuizUploadScreenState();
}

class _QuizUploadScreenState extends State<QuizUploadScreen> {
  final TextEditingController questionController = TextEditingController();
  final List<TextEditingController> optionControllers = List.generate(
    4,
    (_) => TextEditingController(),
  );

  final QuizService quizService = QuizService();

  @override
  void dispose() {
    questionController.dispose();
    for (var c in optionControllers) {
      c.dispose();
    }
    super.dispose();
  }

  void clearAllFieldsAndProvider(QuizProvider quiz) {
    quiz.clearQuiz(); // provider state cleared
    // clear the visible text fields
    questionController.clear();
    for (var c in optionControllers) {
      c.clear();
    }
    // also ensure provider internal fields are blank (if your provider relies on update methods)
    quiz.updateQuestion('');
    for (int i = 0; i < 4; i++) {
      quiz.updateOption(i, '');
    }
    quiz.setCorrectIndex(0);
  }

  @override
  Widget build(BuildContext context) {
    final quiz = Provider.of<QuizProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Upload Quiz (Admin Panel)"),
        backgroundColor: Colors.blueGrey,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Enter Question:", style: labelStyle()),
            const SizedBox(height: 10),
            TextField(
              controller: questionController,
              onChanged: quiz.updateQuestion,
              decoration: inputDecoration("Write your question here"),
            ),
            const SizedBox(height: 25),
            Text("Options:", style: labelStyle()),
            const SizedBox(height: 10),
            for (int i = 0; i < 4; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: TextField(
                  controller: optionControllers[i],
                  onChanged: (v) => quiz.updateOption(i, v),
                  decoration: inputDecoration("Option ${i + 1}"),
                ),
              ),
            const SizedBox(height: 20),
            Text("Select Correct Answer:", style: labelStyle()),
            const SizedBox(height: 10),
            Row(
              children: List.generate(4, (i) {
                return Row(
                  children: [
                    Radio(
                      value: i,
                      groupValue: quiz.correctIndex,
                      onChanged: (value) => quiz.setCorrectIndex(value!),
                    ),
                    Text("Option ${i + 1}"),
                  ],
                );
              }),
            ),
            const SizedBox(height: 25),
            ElevatedButton(
              onPressed: () {
                quiz.addQuestion();
                // After adding question, clear fields for next input
                questionController.clear();
                for (var c in optionControllers) {
                  c.clear();
                }
                // Also reset provider inputs (if not already cleared by addQuestion)
                quiz.updateQuestion('');
                for (int i = 0; i < 4; i++) {
                  quiz.updateOption(i, '');
                }
                quiz.setCorrectIndex(0);

                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text("Question Added")));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 20,
                ),
              ),
              child: const Text("Add Question"),
            ),
            const SizedBox(height: 40),
            Text("Preview Quiz:", style: titleStyle()),
            const SizedBox(height: 15),
            ...quiz.questions.asMap().entries.map((entry) {
              int index = entry.key;
              var q = entry.value;
              return Card(
                elevation: 3,
                child: ListTile(
                  title: Text(q["question"]),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (int i = 0; i < q["options"].length; i++)
                        Text(
                          "${i + 1}. ${q["options"][i]} "
                          "${q["correct"] == i ? "(Correct)" : ""}",
                          style: TextStyle(
                            color: q["correct"] == i
                                ? Colors.green
                                : Colors.black,
                            fontWeight: q["correct"] == i
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      quiz.removeQuestion(index);
                    },
                  ),
                ),
              );
            }),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                try {
                  for (var q in quiz.questions) {
                    await quizService.addQuiz({
                      "question": q["question"],
                      "options": q["options"],
                      "correctIndex": q["correct"],
                    });
                  }

                  // clearAllFieldsAndProvider(quiz);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Quiz uploaded successfully!"),
                    ),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Error uploading quiz: $e")),
                  );
                }
              },

              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 20,
                ),
              ),
              child: const Text("Upload Quiz"),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {
                clearAllFieldsAndProvider(quiz);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 20,
                ),
              ),
              child: const Text("Clear All"),
            ),
          ],
        ),
      ),
    );
  }

  // helper widgets (reuse your originals)
  InputDecoration inputDecoration(String text) {
    return InputDecoration(
      hintText: text,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      filled: true,
      fillColor: Colors.white,
    );
  }

  TextStyle labelStyle() =>
      const TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
  TextStyle titleStyle() =>
      const TextStyle(fontSize: 22, fontWeight: FontWeight.bold);
}
// This is the screne from I  uplaod Quiz for the users 