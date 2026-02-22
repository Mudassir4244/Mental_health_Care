// admin_video_upload_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import '../../provider Classes/video_upload_provider.dart';

class AdminVideoUploadScreen extends StatefulWidget {
  const AdminVideoUploadScreen({super.key});

  @override
  State<AdminVideoUploadScreen> createState() => _AdminVideoUploadScreenState();
}

class _AdminVideoUploadScreenState extends State<AdminVideoUploadScreen> {
  // controls visibility & auto hide timer
  bool _showControls = true;
  Timer? _hideTimer;
  bool _showVolumeSlider = false;

  // start/refresh auto-hide timer
  void _startHideTimer() {
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 3), () {
      setState(() => _showControls = false);
    });
  }

  void _onTapVideo() {
    setState(() {
      _showControls = !_showControls;
      if (_showControls) _startHideTimer();
    });
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    super.dispose();
  }

  // helper to format duration like 01:23
  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  // open fullscreen route
  Future<void> _openFullscreen(
    BuildContext context,
    VideoPlayerController controller,
  ) async {
    // Hide system overlays for fullscreen on mobile (best-effort)
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => FullscreenVideoPage(controller: controller),
      ),
    );
    // restore overlays
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<VideoUploadProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Admin Video Upload')),
      body: Center(
        child: Container(
          width: 900,
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Upload button
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: provider.pickVideo,
                      icon: const Icon(Icons.upload_file),
                      label: const Text('Upload Video'),
                    ),
                    const SizedBox(width: 12),
                    if (provider.pickedVideo != null)
                      Text(
                        provider.pickedVideo!.name,
                        style: const TextStyle(fontSize: 14),
                      ),
                  ],
                ),

                const SizedBox(height: 20),

                if (provider.isLoading) const CircularProgressIndicator(),

                if (!provider.isLoading && provider.pickedVideo == null)
                  const SizedBox(
                    height: 300,
                    child: Center(
                      child: Text(
                        'No video selected',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),

                if (provider.controller != null &&
                    provider.controller!.value.isInitialized)
                  // Video container with overlayed controls
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final vw = provider.controller!.value.size.width ?? 16;
                      final vh = provider.controller!.value.size.height ?? 9;
                      final aspect = vw / vh;
                      final maxWidth = constraints.maxWidth < 700
                          ? constraints.maxWidth
                          : 700.0;

                      return Column(
                        children: [
                          // AspectRatio container
                          GestureDetector(
                            onTap: _onTapVideo,
                            child: MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  // video
                                  AspectRatio(
                                    aspectRatio:
                                        provider.controller!.value.aspectRatio,
                                    child: VideoPlayer(provider.controller!),
                                  ),

                                  // Double tap left/right to seek
                                  Positioned.fill(
                                    child: Row(
                                      children: [
                                        // left half
                                        Expanded(
                                          child: GestureDetector(
                                            behavior:
                                                HitTestBehavior.translucent,
                                            onDoubleTap: () {
                                              provider.backward10();
                                              setState(
                                                () => _showControls = true,
                                              );
                                              _startHideTimer();
                                            },
                                            child: Container(),
                                          ),
                                        ),
                                        // right half
                                        Expanded(
                                          child: GestureDetector(
                                            behavior:
                                                HitTestBehavior.translucent,
                                            onDoubleTap: () {
                                              provider.forward10();
                                              setState(
                                                () => _showControls = true,
                                              );
                                              _startHideTimer();
                                            },
                                            child: Container(),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Center play/pause big button
                                  if (_showControls)
                                    Positioned.fill(
                                      child: Center(
                                        child: GestureDetector(
                                          onTap: () {
                                            provider.playPause();
                                            _startHideTimer();
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.black45,
                                              shape: BoxShape.circle,
                                            ),
                                            padding: const EdgeInsets.all(12),
                                            child: Icon(
                                              provider
                                                      .controller!
                                                      .value
                                                      .isPlaying
                                                  ? Icons.pause
                                                  : Icons.play_arrow,
                                              size: 48,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),

                                  // Top-right close button
                                  if (_showControls)
                                    Positioned(
                                      top: 8,
                                      right: 8,
                                      child: Row(
                                        children: [
                                          IconButton(
                                            icon: const Icon(
                                              Icons.close,
                                              color: Colors.white,
                                            ),
                                            onPressed: () {
                                              provider.deleteVideo();
                                            },
                                          ),
                                        ],
                                      ),
                                    ),

                                  // Top-left menu + settings
                                  if (_showControls)
                                    Positioned(
                                      top: 8,
                                      left: 8,
                                      child: Row(
                                        children: [
                                          // settings / 3 dots
                                          PopupMenuButton<String>(
                                            color: Colors.grey[900],
                                            icon: const Icon(
                                              Icons.more_vert,
                                              color: Colors.white,
                                            ),
                                            itemBuilder: (ctx) => [
                                              const PopupMenuItem(
                                                value: 'delete',
                                                child: Text('Delete'),
                                              ),
                                              const PopupMenuItem(
                                                value: 'loop',
                                                child: Text('Toggle Loop'),
                                              ),
                                              const PopupMenuItem(
                                                value: 'info',
                                                child: Text('Info'),
                                              ),
                                            ],
                                            onSelected: (val) {
                                              if (val == 'delete') {
                                                provider.deleteVideo();
                                              }
                                              if (val == 'loop') {
                                                provider.setLooping(
                                                  !(provider
                                                      .controller!
                                                      .value
                                                      .isLooping),
                                                );
                                              }
                                              if (val == 'info') {
                                                final dur = provider
                                                    .controller!
                                                    .value
                                                    .duration;
                                                final sz = provider
                                                    .controller!
                                                    .value
                                                    .size;
                                                showDialog(
                                                  context: context,
                                                  builder: (_) => AlertDialog(
                                                    title: const Text(
                                                      'Video Info',
                                                    ),
                                                    content: Text(
                                                      'Duration: ${_formatDuration(dur)}\nResolution: ${sz.width.toInt()} x ${sz.height.toInt()}',
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                              context,
                                                            ),
                                                        child: const Text('OK'),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              }
                                            },
                                          ),

                                          // volume icon toggles volume slider
                                          IconButton(
                                            icon: Icon(
                                              (provider
                                                          .controller!
                                                          .value
                                                          .volume >
                                                      0)
                                                  ? Icons.volume_up
                                                  : Icons.volume_off,
                                              color: Colors.white,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                _showVolumeSlider =
                                                    !_showVolumeSlider;
                                                _showControls = true;
                                              });
                                              _startHideTimer();
                                            },
                                          ),
                                        ],
                                      ),
                                    ),

                                  // Small forward/backward buttons overlay
                                  if (_showControls)
                                    Positioned(
                                      bottom: 70,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              provider.backward10();
                                              _startHideTimer();
                                            },
                                            icon: const CircleAvatar(
                                              backgroundColor: Colors.black45,
                                              child: Icon(
                                                Icons.replay_10,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          IconButton(
                                            onPressed: () {
                                              provider.forward10();
                                              _startHideTimer();
                                            },
                                            icon: const CircleAvatar(
                                              backgroundColor: Colors.black45,
                                              child: Icon(
                                                Icons.forward_10,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                  // Volume slider popup (vertical)
                                  if (_showControls && _showVolumeSlider)
                                    Positioned(
                                      right: 56,
                                      top: 50,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.black54,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: RotatedBox(
                                          quarterTurns: -1,
                                          child: SizedBox(
                                            width: 120,
                                            child: Slider(
                                              value: provider
                                                  .controller!
                                                  .value
                                                  .volume,
                                              min: 0,
                                              max: 1,
                                              onChanged: (v) {
                                                provider.setVolume(v);
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),

                                  // Bottom overlay: seek bar + time + fullscreen
                                  Positioned(
                                    left: 0,
                                    right: 0,
                                    bottom: 0,
                                    child: AnimatedOpacity(
                                      duration: const Duration(
                                        milliseconds: 250,
                                      ),
                                      opacity: _showControls ? 1.0 : 0.0,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.black54,
                                              Colors.black26.withOpacity(0.0),
                                            ],
                                            begin: Alignment.bottomCenter,
                                            end: Alignment.topCenter,
                                          ),
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            // Seek Bar
                                            Row(
                                              children: [
                                                // current time
                                                Text(
                                                  _formatDuration(
                                                    provider
                                                        .controller!
                                                        .value
                                                        .position,
                                                  ),
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                                Expanded(
                                                  child: SliderTheme(
                                                    data: SliderTheme.of(context).copyWith(
                                                      trackHeight: 4,
                                                      thumbShape:
                                                          const RoundSliderThumbShape(
                                                            enabledThumbRadius:
                                                                6,
                                                          ),
                                                      overlayShape:
                                                          const RoundSliderOverlayShape(
                                                            overlayRadius: 12,
                                                          ),
                                                    ),
                                                    child: Slider(
                                                      min: 0,
                                                      max: provider
                                                          .controller!
                                                          .value
                                                          .duration
                                                          .inMilliseconds
                                                          .toDouble(),
                                                      value: provider
                                                          .controller!
                                                          .value
                                                          .position
                                                          .inMilliseconds
                                                          .toDouble()
                                                          .clamp(
                                                            0,
                                                            provider
                                                                .controller!
                                                                .value
                                                                .duration
                                                                .inMilliseconds
                                                                .toDouble(),
                                                          ),
                                                      onChanged: (v) {
                                                        provider.seekTo(
                                                          Duration(
                                                            milliseconds: v
                                                                .toInt(),
                                                          ),
                                                        );
                                                      },
                                                      onChangeStart: (_) {
                                                        // pause auto-hide while dragging
                                                        _hideTimer?.cancel();
                                                      },
                                                      onChangeEnd: (_) {
                                                        _startHideTimer();
                                                      },
                                                    ),
                                                  ),
                                                ),
                                                // total time
                                                Text(
                                                  _formatDuration(
                                                    provider
                                                        .controller!
                                                        .value
                                                        .duration,
                                                  ),
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),

                                            // bottom row: play / fullscreen / spacer
                                            Row(
                                              children: [
                                                IconButton(
                                                  onPressed: () {
                                                    provider.playPause();
                                                    _startHideTimer();
                                                  },
                                                  icon: Icon(
                                                    provider
                                                            .controller!
                                                            .value
                                                            .isPlaying
                                                        ? Icons.pause
                                                        : Icons.play_arrow,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                IconButton(
                                                  onPressed: () {
                                                    _openFullscreen(
                                                      context,
                                                      provider.controller!,
                                                    );
                                                  },
                                                  icon: const Icon(
                                                    Icons.fullscreen,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                const Spacer(),
                                                // small label or other buttons can be added here
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 12),
                          // Optional: small controls below video for accessibility (duplicate)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton.icon(
                                onPressed: () {
                                  provider.seekTo(const Duration(seconds: 0));
                                },
                                icon: const Icon(Icons.stop),
                                label: const Text('Restart'),
                              ),
                              const SizedBox(width: 12),
                              ElevatedButton.icon(
                                onPressed: () {
                                  provider.deleteVideo();
                                },
                                icon: const Icon(Icons.delete),
                                label: const Text('Delete'),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Fullscreen page - reuses the same controller (so state remains)
class FullscreenVideoPage extends StatefulWidget {
  final VideoPlayerController controller;
  const FullscreenVideoPage({required this.controller, super.key});

  @override
  State<FullscreenVideoPage> createState() => _FullscreenVideoPageState();
}

class _FullscreenVideoPageState extends State<FullscreenVideoPage> {
  bool _showControls = true;
  Timer? _hideTimer;
  final bool _showVolumeSlider = false;

  void _startHideTimer() {
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 3), () {
      setState(() => _showControls = false);
    });
  }

  void _onTap() {
    setState(() {
      _showControls = !_showControls;
      if (_showControls) _startHideTimer();
    });
  }

  @override
  void initState() {
    super.initState();
    // ensure video is playing when entering fullscreen
    if (!widget.controller.value.isPlaying) widget.controller.play();
    _startHideTimer();
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    // Do NOT dispose controller - provider owns it
    super.dispose();
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: GestureDetector(
            onTap: _onTap,
            child: Stack(
              alignment: Alignment.center,
              children: [
                AspectRatio(
                  aspectRatio: controller.value.aspectRatio,
                  child: VideoPlayer(controller),
                ),

                if (_showControls)
                  Positioned.fill(
                    child: Center(
                      child: GestureDetector(
                        onTap: () {
                          controller.value.isPlaying
                              ? controller.pause()
                              : controller.play();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black45,
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(12),
                          child: Icon(
                            controller.value.isPlaying
                                ? Icons.pause
                                : Icons.play_arrow,
                            size: 56,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),

                // bottom overlay
                if (_showControls)
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 8,
                      ),
                      color: Colors.black26,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              Text(
                                _formatDuration(controller.value.position),
                                style: const TextStyle(color: Colors.white),
                              ),
                              Expanded(
                                child: Slider(
                                  min: 0,
                                  max: controller.value.duration.inMilliseconds
                                      .toDouble(),
                                  value: controller
                                      .value
                                      .position
                                      .inMilliseconds
                                      .toDouble()
                                      .clamp(
                                        0,
                                        controller.value.duration.inMilliseconds
                                            .toDouble(),
                                      ),
                                  onChanged: (v) {
                                    controller.seekTo(
                                      Duration(milliseconds: v.toInt()),
                                    );
                                  },
                                ),
                              ),
                              Text(
                                _formatDuration(controller.value.duration),
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                // top-left back
                if (_showControls)
                  Positioned(
                    top: 12,
                    left: 12,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
