
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mental_healthcare/frontend/widgets/appcolors.dart';
import 'package:provider/provider.dart';

/// ==========================
/// QUIZ QUESTION MODEL
/// ==========================
class QuizQuestion {
  final String questionText;
  final List<String> options;
  final int correctAnswerIndex;
  final String? correctOption;

  QuizQuestion({
    required this.questionText,
    required this.options,
    required this.correctAnswerIndex,
    this.correctOption,
  });
}

/// ==========================
/// PROVIDER TO FETCH QUIZ DATA
/// ==========================
class FetchQuizProvider extends ChangeNotifier {
  List<QuizQuestion> _questions = [];
  bool _loading = true;

  List<QuizQuestion> get questions => _questions;
  bool get loading => _loading;

  Future<void> fetchQuizzes() async {
    _loading = true;
    notifyListeners();

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('Quizes')
          .get();

      _questions = snapshot.docs.map((doc) {
        final data = doc.data();

        final options = List<String>.from(data['options'] ?? []);
        final correctOption = data['correctOption'];

        int correctIndex;

        // CASE 1: Firestore stores correct answer as text
        if (correctOption != null && options.contains(correctOption)) {
          correctIndex = options.indexOf(correctOption);
        }
        // CASE 2: Firestore stores correctIndex as int or string
        else {
          correctIndex = int.tryParse(data['correctIndex'].toString()) ?? 0;
        }

        return QuizQuestion(
          questionText: data['question'] ?? '',
          options: options,
          correctAnswerIndex: correctIndex,
          correctOption: correctOption,
        );
      }).toList();
    } catch (e) {
      print("Error fetching quizzes: $e");
    }

    _loading = false;
    notifyListeners();
  }
}

/// ==========================
/// RESULT DIALOG
/// ==========================
class QuizResultDialog extends StatelessWidget {
  final int score;
  final int total;
  final VoidCallback onRestart;

  const QuizResultDialog({
    super.key,
    required this.score,
    required this.total,
    required this.onRestart,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Quiz Completed'),
      content: Text('You scored $score out of $total'),
      actions: [
        TextButton(onPressed: onRestart, child: const Text('Restart Quiz')),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Exit'),
        ),
      ],
    );
  }
}

/// ==========================
/// QUIZ SCREEN UI
/// ==========================
class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int currentQuestionIndex = 0;
  int? selectedOptionIndex;
  int score = 0;
  bool answered = false;

  @override
  void initState() {
    super.initState();
    Provider.of<FetchQuizProvider>(context, listen: false).fetchQuizzes();
  }

  void _handleAnswer(int index, QuizQuestion question) {
    if (answered) return;

    setState(() {
      selectedOptionIndex = index;
      answered = true;

      if (index == question.correctAnswerIndex) {
        score++;
      }
    });
  }

  void _nextQuestion(List<QuizQuestion> questions) {
    setState(() {
      if (currentQuestionIndex < questions.length - 1) {
        currentQuestionIndex++;
        selectedOptionIndex = null;
        answered = false;
      } else {
        showDialog(
          context: context,
          builder: (_) => QuizResultDialog(
            score: score,
            total: questions.length,
            onRestart: () {
              Navigator.pop(context);
              setState(() {
                currentQuestionIndex = 0;
                score = 0;
                selectedOptionIndex = null;
                answered = false;
              });
            },
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
        title: const Text('Quiz', style: TextStyle(color: Colors.white)),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primary, AppColors.accent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Consumer<FetchQuizProvider>(
          builder: (context, provider, _) {
            if (provider.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (provider.questions.isEmpty) {
              return const Center(child: Text("No quizzes found"));
            }

            final question = provider.questions[currentQuestionIndex];

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'Quiz ${currentQuestionIndex + 1}/${provider.questions.length}',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        Text(
                          question.questionText,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 20),

                        ...List.generate(question.options.length, (index) {
                          final isSelected = index == selectedOptionIndex;

                          return GestureDetector(
                            onTap: () => _handleAnswer(index, question),
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: isSelected ? Colors.blue : Colors.grey,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(10),
                                color: isSelected
                                    ? Colors.blue.shade100
                                    : Colors.white,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      '${index + 1}. ${question.options[index]}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: isSelected
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                      ),
                                    ),
                                  ),

                                  if (answered && isSelected)
                                    Icon(
                                      index == question.correctAnswerIndex
                                          ? Icons.check_circle
                                          : Icons.cancel,
                                      color:
                                          index == question.correctAnswerIndex
                                          ? Colors.green
                                          : Colors.red,
                                    ),
                                ],
                              ),
                            ),
                          );
                        }),

                        const SizedBox(height: 20),

                        ElevatedButton(
                          onPressed: answered
                              ? () => _nextQuestion(provider.questions)
                              : null,
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 50),
                          ),
                          child: Text(
                            currentQuestionIndex < provider.questions.length - 1
                                ? 'Next Question'
                                : 'Finish Quiz',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
