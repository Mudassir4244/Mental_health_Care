// video_upload_provider.dart
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class VideoUploadProvider extends ChangeNotifier {
  XFile? pickedVideo;
  VideoPlayerController? controller;
  bool isLoading = false;
  final ImagePicker picker = ImagePicker();

  Future pickVideo() async {
    try {
      isLoading = true;
      notifyListeners();

      final XFile? file = await picker.pickVideo(source: ImageSource.gallery);

      if (file != null) {
        // dispose previous
        controller?.dispose();
        pickedVideo = file;

        if (kIsWeb) {
          controller = VideoPlayerController.networkUrl(Uri.parse(file.path));
        } else {
          controller = VideoPlayerController.file(File(file.path));
        }

        await controller!.initialize();
        controller!.setLooping(false);

        // update UI for progress / state changes
        controller!.addListener(() {
          notifyListeners();
        });

        notifyListeners();
      }
    } catch (e) {
      // handle error properly in your app
      debugPrint("Error picking video: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void deleteVideo() {
    pickedVideo = null;
    controller?.dispose();
    controller = null;
    notifyListeners();
  }

  void playPause() {
    if (controller == null) return;
    controller!.value.isPlaying ? controller!.pause() : controller!.play();
    notifyListeners();
  }

  void seekTo(Duration position) {
    if (controller == null) return;
    final dur = controller!.value.duration;
    if (position < Duration.zero) position = Duration.zero;
    if (position > dur) position = dur;
    controller!.seekTo(position);
  }

  void forward10() {
    if (controller == null) return;
    final pos = controller!.value.position;
    seekTo(pos + const Duration(seconds: 10));
    notifyListeners();
  }

  void backward10() {
    if (controller == null) return;
    final pos = controller!.value.position;
    seekTo(pos - const Duration(seconds: 10));
    notifyListeners();
  }

  void setVolume(double value) {
    if (controller == null) return;
    controller!.setVolume(value.clamp(0.0, 1.0));
    notifyListeners();
  }

  void setLooping(bool value) {
    if (controller == null) return;
    controller!.setLooping(value);
    notifyListeners();
  }
}
