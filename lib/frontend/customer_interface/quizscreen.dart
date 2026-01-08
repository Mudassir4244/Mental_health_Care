import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mental_healthcare/frontend/widgets/appcolors.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// ==========================
/// MODELS
/// ==========================
class QuizQuestion {
  final String questionText;
  final List<String> options;
  final int correctAnswerIndex;

  QuizQuestion({
    required this.questionText,
    required this.options,
    required this.correctAnswerIndex,
  });

  factory QuizQuestion.fromMap(Map<String, dynamic> data) {
    return QuizQuestion(
      questionText: data['question'] ?? '',
      options: List<String>.from(data['options'] ?? []),
      correctAnswerIndex: int.tryParse(data['correct'].toString()) ?? 0,
    );
  }
}

class QuizPaper {
  final String id;
  final String title;
  final String description;
  final List<QuizQuestion> questions;

  QuizPaper({
    required this.id,
    required this.title,
    required this.description,
    required this.questions,
  });

  factory QuizPaper.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final questionsList = (data['questions'] as List<dynamic>? ?? [])
        .map((q) => QuizQuestion.fromMap(q as Map<String, dynamic>))
        .toList();

    return QuizPaper(
      id: doc.id,
      title: data['title'] ?? 'Untitled Quiz',
      description: data['description'] ?? '',
      questions: questionsList,
    );
  }
}

/// ==========================
/// PROVIDER
/// ==========================
class QuizListProvider extends ChangeNotifier {
  List<QuizPaper> _quizzes = [];
  Map<String, int> _userScores = {}; // Map<QuizID, HighScore>
  bool _loading = true;
  String? _errorMessage;

  List<QuizPaper> get quizzes => _quizzes;
  Map<String, int> get userScores => _userScores;
  bool get loading => _loading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchQuizzes() async {
    _loading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // 1. Fetch Quiz Papers
      final snapshot = await FirebaseFirestore.instance
          .collection('QuizPapers')
          .orderBy('timestamp', descending: false)
          .get();

      _quizzes = snapshot.docs
          .map((doc) => QuizPaper.fromDocument(doc))
          .toList();

      // 2. Fetch User Scores
      await fetchUserScores();
    } catch (e) {
      debugPrint("Error fetching quizzes: $e");
      _errorMessage = "Failed to load quizzes.";
    }

    _loading = false;
    notifyListeners();
  }

  Future<void> fetchUserScores() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final snapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid)
          .collection('QuizScores')
          .get();

      _userScores.clear();
      for (var doc in snapshot.docs) {
        _userScores[doc.id] = doc.data()['score'] ?? 0;
      }
      notifyListeners();
    } catch (e) {
      debugPrint("Error fetching user scores: $e");
    }
  }

  Future<void> updateScore(String quizId, int newScore) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      // Check existing high score
      int currentHighScore = _userScores[quizId] ?? 0;

      if (newScore > currentHighScore) {
        // Update Firestore
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(user.uid)
            .collection('QuizScores')
            .doc(quizId)
            .set({
              'score': newScore,
              'timestamp': FieldValue.serverTimestamp(),
            }, SetOptions(merge: true));

        // Update Local State
        _userScores[quizId] = newScore;
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Error updating score: $e");
    }
  }

  void clearQuiz() {
    _quizzes = [];
    _userScores = {};
    _errorMessage = null;
    notifyListeners();
  }
}

/// ==========================
/// MAIN SCREEN: QUIZ LIST
/// ==========================
class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch quizzes on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<QuizListProvider>(context, listen: false).fetchQuizzes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primary, AppColors.accent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(25),
              bottomRight: Radius.circular(25),
            ),
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
        ),
        title: const Text(
          'Mental Health Quizzes',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Consumer<QuizListProvider>(
        builder: (context, provider, _) {
          if (provider.loading) {
            return Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (provider.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 60),
                  const SizedBox(height: 16),
                  Text(
                    provider.errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                  TextButton(
                    onPressed: provider.fetchQuizzes,
                    child: const Text("Retry"),
                  ),
                ],
              ),
            );
          }

          if (provider.quizzes.isEmpty) {
            return const Center(child: Text("No quizzes available yet."));
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            itemCount: provider.quizzes.length,
            itemBuilder: (context, index) {
              final quiz = provider.quizzes[index];
              return FadeInUp(
                duration: const Duration(milliseconds: 400),
                delay: Duration(milliseconds: index * 100),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ActiveQuizScreen(quizPaper: quiz),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        AppColors.primary.withOpacity(0.2),
                                        AppColors.primary.withOpacity(0.1),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Icon(
                                    Icons.psychology,
                                    color: AppColors.primary,
                                    size: 32,
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        quiz.title,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                          height: 1.2,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        "${quiz.questions.length} Questions",
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            if (quiz.description.isNotEmpty) ...[
                              const SizedBox(height: 16),
                              Text(
                                quiz.description,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  height: 1.5,
                                  fontSize: 14,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.orange.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.timer_outlined,
                                        size: 16,
                                        color: Colors.orange,
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        "${(quiz.questions.length * 1.5).ceil()} min", // Rough estimate
                                        style: const TextStyle(
                                          color: Colors.orange,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 10),
                                // High Score Badge
                                if (provider.userScores.containsKey(quiz.id))
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.green.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.emoji_events_outlined,
                                          size: 16,
                                          color: Colors.green,
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          "Best: ${provider.userScores[quiz.id]}/${quiz.questions.length}",
                                          style: const TextStyle(
                                            color: Colors.green,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                const Spacer(),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        AppColors.primary,
                                        AppColors.accent,
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(25),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.primary.withOpacity(
                                          0.3,
                                        ),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: const Row(
                                    children: [
                                      Text(
                                        "Start Quiz",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Icon(
                                        Icons.arrow_forward,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
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

/// ==========================
/// ACTIVE QUIZ SCREEN
/// ==========================
class ActiveQuizScreen extends StatefulWidget {
  final QuizPaper quizPaper;

  const ActiveQuizScreen({super.key, required this.quizPaper});

  @override
  State<ActiveQuizScreen> createState() => _ActiveQuizScreenState();
}

class _ActiveQuizScreenState extends State<ActiveQuizScreen> {
  int currentQuestionIndex = 0;
  int? selectedOptionIndex;
  int score = 0;
  bool answered = false;

  void _handleAnswer(int index) {
    if (answered) return;

    setState(() {
      selectedOptionIndex = index;
      answered = true;

      if (index ==
          widget.quizPaper.questions[currentQuestionIndex].correctAnswerIndex) {
        score++;
      }
    });
  }

  void _nextQuestion() {
    if (currentQuestionIndex < widget.quizPaper.questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        selectedOptionIndex = null;
        answered = false;
      });
    } else {
      _showResultDialog();
    }
  }

  void _showResultDialog() {
    // Save Score
    Provider.of<QuizListProvider>(
      context,
      listen: false,
    ).updateScore(widget.quizPaper.id, score);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => QuizResultDialog(
        score: score,
        total: widget.quizPaper.questions.length,
        onRestart: () {
          Navigator.pop(context);
          setState(() {
            currentQuestionIndex = 0;
            score = 0;
            selectedOptionIndex = null;
            answered = false;
          });
        },
        onExit: () {
          Navigator.pop(context); // Close dialog
          Navigator.pop(context); // Back to list
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final question = widget.quizPaper.questions[currentQuestionIndex];
    final totalQuestions = widget.quizPaper.questions.length;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(widget.quizPaper.title),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          // Progress Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Question ${currentQuestionIndex + 1} / $totalQuestions",
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: (currentQuestionIndex + 1) / totalQuestions,
                    backgroundColor: Colors.grey.shade300,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.primary,
                    ),
                    minHeight: 8,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Question Card
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Text(
                      question.questionText,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Options
                  ...List.generate(question.options.length, (index) {
                    final isSelected = index == selectedOptionIndex;
                    final isCorrect = index == question.correctAnswerIndex;

                    Color borderColor = Colors.grey.shade300;
                    Color backgroundColor = Colors.white;
                    IconData? icon;

                    if (answered) {
                      if (isCorrect) {
                        borderColor = Colors.green;
                        backgroundColor = Colors.green.withOpacity(0.1);
                        icon = Icons.check_circle;
                      } else if (isSelected) {
                        borderColor = Colors.red;
                        backgroundColor = Colors.red.withOpacity(0.1);
                        icon = Icons.cancel;
                      }
                    } else if (isSelected) {
                      borderColor = AppColors.primary;
                      backgroundColor = AppColors.primary.withOpacity(0.1);
                    }

                    return GestureDetector(
                      onTap: () => _handleAnswer(index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.only(bottom: 15),
                        padding: const EdgeInsets.symmetric(
                          vertical: 15,
                          horizontal: 20,
                        ),
                        decoration: BoxDecoration(
                          color: backgroundColor,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: borderColor, width: 2),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 35,
                              height: 35,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: answered && isCorrect
                                    ? Colors.green
                                    : (answered && isSelected
                                          ? Colors.red
                                          : Colors.grey.shade200),
                              ),
                              child: Center(
                                child: Text(
                                  String.fromCharCode(65 + index),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: answered && (isCorrect || isSelected)
                                        ? Colors.white
                                        : Colors.grey.shade700,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: Text(
                                question.options[index],
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            if (answered && icon != null)
                              Icon(icon, color: borderColor),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),

          // Next Button
          if (answered)
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _nextQuestion,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Text(
                    currentQuestionIndex < totalQuestions - 1
                        ? 'Next Question'
                        : 'See Results',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// ==========================
/// RESULT DIALOG
/// ==========================
class QuizResultDialog extends StatelessWidget {
  final int score;
  final int total;
  final VoidCallback onRestart;
  final VoidCallback onExit;

  const QuizResultDialog({
    super.key,
    required this.score,
    required this.total,
    required this.onRestart,
    required this.onExit,
  });

  @override
  Widget build(BuildContext context) {
    bool isPassed = score >= (total / 2);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 10,
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: isPassed
                    ? Colors.green.withOpacity(0.1)
                    : Colors.red.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isPassed ? Icons.emoji_events : Icons.sentiment_dissatisfied,
                color: isPassed ? Colors.green : Colors.red,
                size: 50,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              isPassed ? 'Congratulations!' : 'Keep Trying!',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: isPassed ? Colors.green : Colors.red,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'You scored $score out of $total',
              style: const TextStyle(fontSize: 18, color: Colors.black87),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton(
                  onPressed: onExit,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.grey.shade400),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Exit',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                ElevatedButton(
                  onPressed: onRestart,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Restart',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
