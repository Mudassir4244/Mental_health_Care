import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TrainingProvider extends ChangeNotifier {
  // Module Details
  String moduleTitle = "";
  String moduleDescription = "";

  // List of Slides
  // Each slide: { "title": "Slide Title", "content": [ { "type": "text", "data": "..." }, ... ] }
  List<Map<String, dynamic>> _slides = [];

  List<Map<String, dynamic>> get slides => _slides;

  bool _isUploading = false;
  bool get isUploading => _isUploading;

  // --- Module Metadata ---
  void updateModuleTitle(String title) {
    moduleTitle = title;
    notifyListeners();
  }

  void updateModuleDescription(String desc) {
    moduleDescription = desc;
    notifyListeners();
  }

  // --- Slide Management ---
  void addSlide() {
    _slides.add({"title": "New Slide ${_slides.length + 1}", "content": []});
    notifyListeners();
  }

  void removeSlide(int index) {
    _slides.removeAt(index);
    notifyListeners();
  }

  void updateSlideTitle(int index, String title) {
    _slides[index]['title'] = title;
    notifyListeners();
  }

  // --- Content Management (Inside a Slide) ---
  void addTextContent(int slideIndex, String text) {
    if (slideIndex < 0 || slideIndex >= _slides.length) return;
    _slides[slideIndex]['content'].add({"type": "text", "data": text});
    notifyListeners();
  }

  void addBulletList(int slideIndex, List<String> items) {
    if (slideIndex < 0 || slideIndex >= _slides.length) return;
    _slides[slideIndex]['content'].add({"type": "bullet_list", "data": items});
    notifyListeners();
  }

  void addComparison(
    int slideIndex,
    String title1,
    List<String> list1,
    String title2,
    List<String> list2,
  ) {
    if (slideIndex < 0 || slideIndex >= _slides.length) return;
    _slides[slideIndex]['content'].add({
      "type": "comparison",
      "data": {
        "title1": title1,
        "list1": list1,
        "title2": title2,
        "list2": list2,
      },
    });
    notifyListeners();
  }

  void addTable(int slideIndex, List<String> headers, List<List<String>> rows) {
    if (slideIndex < 0 || slideIndex >= _slides.length) return;
    _slides[slideIndex]['content'].add({
      "type": "table",
      "data": {"headers": headers, "rows": rows},
    });
    notifyListeners();
  }

  void removeContentBlock(int slideIndex, int blockIndex) {
    if (slideIndex < 0 || slideIndex >= _slides.length) return;
    _slides[slideIndex]['content'].removeAt(blockIndex);
    notifyListeners();
  }

  // --- Upload to Firestore ---
  Future<void> uploadTrainingModule() async {
    if (moduleTitle.isEmpty || _slides.isEmpty) {
      throw Exception("Title and at least one slide are required.");
    }

    _isUploading = true;
    notifyListeners();

    try {
      // Deep copy and sanitize slides for Firestore (nested arrays not allowed)
      List<Map<String, dynamic>> sanitizedSlides = _slides.map((slide) {
        Map<String, dynamic> newSlide = Map.from(slide);
        List<dynamic> content = List.from(newSlide['content']);

        newSlide['content'] = content.map((block) {
          Map<String, dynamic> newBlock = Map.from(block);
          if (newBlock['type'] == 'table') {
            Map<String, dynamic> data = Map.from(newBlock['data']);
            List<List<String>> rows = data['rows'];
            // Convert List<List<String>> to List<Map<String, dynamic>>
            // Firestore doesn't support nested arrays directly in document fields
            data['rows'] = rows.map((r) => {'cells': r}).toList();
            newBlock['data'] = data;
          }
          return newBlock;
        }).toList();

        return newSlide;
      }).toList();

      await FirebaseFirestore.instance.collection('TrainingModules').add({
        "title": moduleTitle,
        "description": moduleDescription,
        "slides": sanitizedSlides,
        "slideCount": _slides.length,
        "timestamp": FieldValue.serverTimestamp(),
      });

      clearModule();
    } catch (e) {
      rethrow;
    } finally {
      _isUploading = false;
      notifyListeners();
    }
  }

  void clearModule() {
    moduleTitle = "";
    moduleDescription = "";
    _slides = [];
    notifyListeners();
  }
}
