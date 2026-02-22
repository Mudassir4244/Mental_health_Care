import 'package:flutter/material.dart';

class QuizProvider extends ChangeNotifier {
  final List<Map<String, dynamic>> _questions = [];

  // Quiz Paper Details
  String quizTitle = "";
  String quizDescription = "";

  // Temporary Question Fields
  String question = "";
  List<String> options = ["", "", "", ""];
  int correctIndex = -1;

  List<Map<String, dynamic>> get questions => _questions;

  /// Update Quiz Title
  void updateQuizTitle(String value) {
    quizTitle = value;
    notifyListeners();
  }

  /// Update Quiz Description
  void updateQuizDescription(String value) {
    quizDescription = value;
    notifyListeners();
  }

  /// Update question text
  void updateQuestion(String value) {
    question = value;
    notifyListeners();
  }

  /// Update option text
  void updateOption(int index, String value) {
    options[index] = value;
    notifyListeners();
  }

  /// Update correct answer index
  void setCorrectIndex(int index) {
    correctIndex = index;
    notifyListeners();
  }

  /// Add Question to quiz list
  void addQuestion() {
    if (question.isEmpty ||
        options.any((o) => o.isEmpty) ||
        correctIndex == -1) {
      return;
    }

    _questions.add({
      "question": question,
      "options": List<String>.from(options),
      "correct": correctIndex,
    });

    // Reset fields
    question = "";
    options = ["", "", "", ""];
    correctIndex = -1;

    notifyListeners();
  }

  /// Remove question
  void removeQuestion(int index) {
    _questions.removeAt(index);
    notifyListeners();
  }

  /// Clear entire quiz
  void clearQuiz() {
    _questions.clear();
    notifyListeners();
  }
}
