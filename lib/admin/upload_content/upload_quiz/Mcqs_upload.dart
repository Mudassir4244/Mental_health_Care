import 'package:flutter/material.dart';
import 'package:mental_healthcare/admin/admin_backend/quiz_upload_backend.dart';
import 'package:mental_healthcare/admin/provider%20Classes/quiz_provider.dart';
import 'package:mental_healthcare/admin/total_quizes.dart';
import 'package:provider/provider.dart';

class QuizUploadScreen extends StatefulWidget {
  const QuizUploadScreen({super.key});

  @override
  State<QuizUploadScreen> createState() => _QuizUploadScreenState();
}

class _QuizUploadScreenState extends State<QuizUploadScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController questionController = TextEditingController();
  final List<TextEditingController> optionControllers = List.generate(
    4,
    (_) => TextEditingController(),
  );

  final QuizService _quizService = QuizService();
  bool _isUploading = false;

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    questionController.dispose();
    for (var c in optionControllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _clearQuestionFields() {
    questionController.clear();
    for (var c in optionControllers) {
      c.clear();
    }
  }

  void _clearAllFields() {
    titleController.clear();
    descriptionController.clear();
    _clearQuestionFields();
  }

  @override
  Widget build(BuildContext context) {
    final quizProvider = Provider.of<QuizProvider>(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) {
                  return const TotalQuizes();
                },
              ),
            );
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
        title: const Text("Create Quiz Paper"),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ----------------------------
            // 1. Quiz Paper Details
            // ----------------------------
            const Text(
              "Quiz Details",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: titleController,
              onChanged: quizProvider.updateQuizTitle,
              decoration: _inputDecoration("Quiz Title (e.g. Anxiety Test)"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: descriptionController,
              onChanged: quizProvider.updateQuizDescription,
              decoration: _inputDecoration("Description (Optional)"),
            ),
            const SizedBox(height: 30),

            // ----------------------------
            // 2. Add New Question
            // ----------------------------
            const Text(
              "Add Question",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),

            // Question Text
            TextField(
              controller: questionController,
              onChanged: quizProvider.updateQuestion,
              decoration: _inputDecoration("Question Text"),
            ),
            const SizedBox(height: 15),

            // Options
            const Text(
              "Options:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            for (int i = 0; i < 4; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: optionControllers[i],
                        onChanged: (val) => quizProvider.updateOption(i, val),
                        decoration: _inputDecoration("Option ${i + 1}"),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Radio<int>(
                      value: i,
                      groupValue: quizProvider.correctIndex,
                      onChanged: (val) {
                        if (val != null) quizProvider.setCorrectIndex(val);
                      },
                      activeColor: Colors.deepPurple,
                    ),
                    const Text("Correct"),
                  ],
                ),
              ),

            // Add Question Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  if (quizProvider.question.isEmpty ||
                      quizProvider.options.any((o) => o.isEmpty) ||
                      quizProvider.correctIndex == -1) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Please fill all fields and select correct answer",
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  quizProvider.addQuestion();
                  _clearQuestionFields();

                  // Reset provider's correct index
                  // Note: addQuestion() already resets internal state, but we need to ensure UI reflects it?
                  // The Radio widget listens to quizProvider.correctIndex, which is reset to -1 in addQuestion().
                },
                icon: const Icon(Icons.add),
                label: const Text("Add Question"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // ----------------------------
            // 3. Questions Preview List
            // ----------------------------
            if (quizProvider.questions.isNotEmpty) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Questions (${quizProvider.questions.length})",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      quizProvider.clearQuiz();
                      _clearQuestionFields();
                    },
                    child: const Text(
                      "Clear All",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: quizProvider.questions.length,
                itemBuilder: (context, index) {
                  final q = quizProvider.questions[index];
                  final options = List<String>.from(q['options']);
                  final correctIndex = q['correct'] as int;

                  return Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    elevation: 2,
                    child: ExpansionTile(
                      title: Text(
                        "${index + 1}. ${q['question']}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text("Correct: ${options[correctIndex]}"),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => quizProvider.removeQuestion(index),
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: options.asMap().entries.map((entry) {
                              final isCorrect = entry.key == correctIndex;
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4,
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      isCorrect
                                          ? Icons.check_circle
                                          : Icons.circle_outlined,
                                      color: isCorrect
                                          ? Colors.green
                                          : Colors.grey,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      entry.value,
                                      style: TextStyle(
                                        color: isCorrect
                                            ? Colors.green
                                            : Colors.black,
                                        fontWeight: isCorrect
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],

            const SizedBox(height: 30),

            // ----------------------------
            // 4. Upload Button
            // ----------------------------
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isUploading
                    ? null
                    : () async {
                        if (quizProvider.quizTitle.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Please enter a Quiz Title"),
                            ),
                          );
                          return;
                        }
                        if (quizProvider.questions.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Please add at least one question"),
                            ),
                          );
                          return;
                        }

                        setState(() => _isUploading = true);

                        try {
                          await _quizService.uploadQuizPaper(
                            title: quizProvider.quizTitle,
                            description: quizProvider.quizDescription,
                            questions: quizProvider.questions,
                          );

                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Quiz uploaded successfully!"),
                                backgroundColor: Colors.green,
                              ),
                            );

                            // Reset everything
                            quizProvider.clearQuiz();
                            // Also reset title/desc in provider (need to add method or direct access)
                            quizProvider.updateQuizTitle("");
                            quizProvider.updateQuizDescription("");

                            _clearAllFields();
                          }
                        } catch (e) {
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Error: $e")),
                            );
                          }
                        } finally {
                          if (mounted) setState(() => _isUploading = false);
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.grey,
                ),
                child: _isUploading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "UPLOAD QUIZ PAPER",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      labelText: hint,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      filled: true,
      fillColor: Colors.grey[50],
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }
}
