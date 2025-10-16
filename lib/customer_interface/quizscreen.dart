import 'package:flutter/material.dart';
import 'package:mental_healthcare/widgets/appcolors.dart';
import 'package:mental_healthcare/widgets/widgets.dart';

// --- Data Models ---
class QuizQuestion {
  final String questionText;
  final List<String> options;
  final int correctAnswerIndex; // 0-indexed

  const QuizQuestion({
    required this.questionText,
    required this.options,
    required this.correctAnswerIndex,
  });
}

// --- Quiz Screen Implementation ---

class QuizScreen extends StatefulWidget {
  final String title = 'Quiz';
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final List<QuizQuestion> quizQuestions = const [
    QuizQuestion(
      questionText:
          "What is the most important step in Mental Health First Aid?",
      options: [
        "Assess for risk of suicide or harm.",
        "Listen non-judgmentally.",
        "Give reassurance and information.",
        "Encourage professional help.",
      ],
      correctAnswerIndex: 0,
    ),
    QuizQuestion(
      questionText: "Which emotion is NOT one of the five basic emotions?",
      options: ["Joy", "Anger", "Confusion", "Fear"],
      correctAnswerIndex: 2,
    ),
  ];

  int currentQuestionIndex = 0;
  int? selectedOptionIndex;
  bool answered = false;
  int score = 0;

  void _handleAnswer(int index) {
    if (answered) return;

    setState(() {
      selectedOptionIndex = index;
      answered = true;
      if (index == quizQuestions[currentQuestionIndex].correctAnswerIndex) {
        score++;
      }
    });
  }

  void _nextQuestion() {
    setState(() {
      if (currentQuestionIndex < quizQuestions.length - 1) {
        currentQuestionIndex++;
        selectedOptionIndex = null;
        answered = false;
      } else {
        // End of quiz, navigate to result or reset
        showDialog(
          context: context,
          builder: (context) => _QuizResultDialog(
            score: score,
            total: quizQuestions.length,
            onRestart: _resetQuiz,
          ),
        );
      }
    });
  }

  void _resetQuiz() {
    Navigator.of(context).pop(); // Close dialog
    setState(() {
      currentQuestionIndex = 0;
      score = 0;
      selectedOptionIndex = null;
      answered = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final question = quizQuestions[currentQuestionIndex];

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // const _StripedBackground(),
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                _CustomAppBar(title: widget.title),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Screen Banner (Quiz Ready)
                        _ScreenBanner(
                          title:
                              'Quiz ${currentQuestionIndex + 1}/${quizQuestions.length}',
                          subtitle: 'Ready for today\'s quiz?',
                        ),
                        const SizedBox(height: 20),

                        // Question Card
                        _QuestionCard(
                          question: question,
                          currentQuestionIndex: currentQuestionIndex,
                          totalQuestions: quizQuestions.length,
                          selectedOptionIndex: selectedOptionIndex,
                          onOptionTap: _handleAnswer,
                          answered: answered,
                        ),

                        // Navigation Button
                        const SizedBox(height: 32),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: _NavigationButton(
                            text:
                                currentQuestionIndex < quizQuestions.length - 1
                                ? 'Next Question'
                                : 'Finish Quiz',
                            onTap: answered ? _nextQuestion : null,
                          ),
                        ),
                        const SizedBox(
                          height: 100,
                        ), // Padding above the bottom nav bar
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: BottomNavBar(currentScreen: widget.title),
          ),
        ],
      ),
    );
  }
}

// --- Custom Widgets for Quiz Screen ---

class _CustomAppBar extends StatelessWidget {
  final String title;
  const _CustomAppBar({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 320),
      child: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios,
          color: AppColors.textColorPrimary,
          size: 24,
        ),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }
}

class _ScreenBanner extends StatelessWidget {
  final String title;
  final String subtitle;

  const _ScreenBanner({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuestionCard extends StatelessWidget {
  final QuizQuestion question;
  final int currentQuestionIndex;
  final int totalQuestions;
  final int? selectedOptionIndex;
  final Function(int) onOptionTap;
  final bool answered;

  const _QuestionCard({
    required this.question,
    required this.currentQuestionIndex,
    required this.totalQuestions,
    required this.selectedOptionIndex,
    required this.onOptionTap,
    required this.answered,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.cardColor,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Question Text
            Text(
              question.questionText,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textColorPrimary,
              ),
            ),
            const SizedBox(height: 20),

            // Options
            ...List.generate(question.options.length, (index) {
              final isCorrect =
                  answered && index == question.correctAnswerIndex;
              final isSelected = index == selectedOptionIndex;

              Color borderColor = AppColors.stripedColor;
              Color textColor = AppColors.textColorPrimary;
              Color iconColor = AppColors.textColorSecondary;

              if (answered) {
                if (isCorrect) {
                  // Correctly answered
                  borderColor = AppColors.success;
                  textColor = AppColors.success;
                  iconColor = AppColors.success;
                } else if (isSelected) {
                  // Incorrectly answered
                  borderColor = AppColors.error;
                  textColor = AppColors.error;
                  iconColor = AppColors.error;
                }
              }

              return GestureDetector(
                onTap: () => onOptionTap(index),
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isSelected && !answered
                        ? AppColors.stripedColor.withOpacity(0.5)
                        : AppColors.background,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: borderColor, width: 2),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${index + 1}. ${question.options[index]}',
                          style: TextStyle(
                            fontSize: 16,
                            color: textColor,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                      if (answered)
                        Icon(
                          isCorrect
                              ? Icons.check_circle
                              : (isSelected ? Icons.cancel : null),
                          color: iconColor,
                        ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _NavigationButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;

  const _NavigationButton({required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.accent,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 5,
        minimumSize: const Size(double.infinity, 50),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _QuizResultDialog extends StatelessWidget {
  final int score;
  final int total;
  final VoidCallback onRestart;

  const _QuizResultDialog({
    required this.score,
    required this.total,
    required this.onRestart,
  });

  @override
  Widget build(BuildContext context) {
    final passed = score == total;
    return AlertDialog(
      backgroundColor: AppColors.cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(
        passed ? 'Congratulations!' : 'Try Again!',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: passed ? AppColors.success : AppColors.error,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'You scored $score out of $total questions correctly.',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.textColorPrimary,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('View Summary'),
          ),
          TextButton(
            onPressed: onRestart,
            child: const Text(
              'Restart Quiz',
              style: TextStyle(color: AppColors.accent),
            ),
          ),
        ],
      ),
    );
  }
}
