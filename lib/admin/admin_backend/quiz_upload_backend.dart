// import 'package:cloud_firestore/cloud_firestore.dart';

// class QuizService {
//   final CollectionReference _quizCollection = FirebaseFirestore.instance
//       .collection('Quizes');

//   // -----------------------------
//   // Add a new quiz to Firestore
//   // quizData should contain:
//   // {
//   //   "question": "Question text",
//   //   "options": ["Option1", "Option2", "Option3", "Option4"],
//   //   "correct": 1 // index of correct option
//   // }
//   // -----------------------------
//   Future<void> addQuiz(Map<String, dynamic> quizData) async {
//     try {
//       await _quizCollection.add({
//         "question": quizData["question"],
//         "options": quizData["options"],
//         "correct": quizData["correct"],
//         "timestamp": FieldValue.serverTimestamp(),
//       });
//     } catch (e) {
//       throw Exception("Failed to add quiz: $e");
//     }
//   }

//   // -----------------------------
//   // Edit / Update existing quiz
//   // quizId is the document id in Firestore
//   // quizData same as above
//   // -----------------------------
//   Future<void> editQuiz(String quizId, Map<String, dynamic> quizData) async {
//     try {
//       await _quizCollection.doc(quizId).update({
//         "question": quizData["question"],
//         "options": quizData["options"],
//         "correct": quizData["correct"],
//         "timestamp": FieldValue.serverTimestamp(),
//       });
//     } catch (e) {
//       throw Exception("Failed to edit quiz: $e");
//     }
//   }

//   // -----------------------------
//   // Delete a quiz
//   // -----------------------------
//   Future<void> deleteQuiz(String quizId) async {
//     try {
//       await _quizCollection.doc(quizId).delete();
//     } catch (e) {
//       throw Exception("Failed to delete quiz: $e");
//     }
//   }

//   // -----------------------------
//   // Fetch all quizzes (optional)
//   // Returns List of Map<String, dynamic> with id included
//   // -----------------------------
//   Future<List<Map<String, dynamic>>> fetchQuizzes() async {
//     try {
//       QuerySnapshot snapshot = await _quizCollection
//           .orderBy("timestamp", descending: true)
//           .get();

//       return snapshot.docs.map((doc) {
//         var data = doc.data() as Map<String, dynamic>;
//         data["id"] = doc.id; // include document ID
//         return data;
//       }).toList();
//     } catch (e) {
//       throw Exception("Failed to fetch quizzes: $e");
//     }
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';

class QuizService {
  final CollectionReference _quizCollection = FirebaseFirestore.instance
      .collection('Quizes');

  /// --------------------------------------------------------
  /// ADD A QUIZ
  /// quizData must contain:
  /// {
  ///   "question": "Question text",
  ///   "options": ["A", "B", "C", "D"],
  ///   "correctIndex": 1
  /// }
  /// We will convert correctIndex → correctOptionText
  /// --------------------------------------------------------
  Future<void> addQuiz(Map<String, dynamic> quizData) async {
    try {
      int correctIndex = quizData["correctIndex"];
      List options = quizData["options"];

      await _quizCollection.add({
        "question": quizData["question"],
        "options": options,
        "correctIndex": correctIndex,
        "correctOption": options[correctIndex], // 🔥 correct text saved
        "timestamp": FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception("Failed to add quiz: $e");
    }
  }

  /// --------------------------------------------------------
  /// EDIT A QUIZ
  /// Stores both correctIndex and correctOption
  /// --------------------------------------------------------
  Future<void> editQuiz(String quizId, Map<String, dynamic> quizData) async {
    try {
      int correctIndex = quizData["correctIndex"];
      List options = quizData["options"];

      await _quizCollection.doc(quizId).update({
        "question": quizData["question"],
        "options": options,
        "correctIndex": correctIndex,
        "correctOption": options[correctIndex], // 🔥 correct text saved
        "timestamp": FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception("Failed to edit quiz: $e");
    }
  }

  /// --------------------------------------------------------
  /// DELETE QUIZ
  /// --------------------------------------------------------
  Future<void> deleteQuiz(String quizId) async {
    try {
      await _quizCollection.doc(quizId).delete();
    } catch (e) {
      throw Exception("Failed to delete quiz: $e");
    }
  }

  /// --------------------------------------------------------
  /// FETCH ALL QUIZZES
  /// returns [{... , id: "docId"}]
  /// --------------------------------------------------------
  Future<List<Map<String, dynamic>>> fetchQuizzes() async {
    try {
      QuerySnapshot snapshot = await _quizCollection
          .orderBy("timestamp", descending: true)
          .get();

      return snapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        data["id"] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      throw Exception("Failed to fetch quizzes: $e");
    }
  }
}
