// import 'package:flutter/material.dart';
// import 'package:mental_healthcare/frontend/widgets/appcolors.dart';
// import 'package:url_launcher/url_launcher.dart';

// class GuidedVoiceCoachScreen extends StatelessWidget {
//   const GuidedVoiceCoachScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F7FA), // Light background
//       appBar: AppBar(
//         title: const Text(
//           "Voice Guided Coach",
//           style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
//         ),
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         centerTitle: true,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black54),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildHeader(),
//             const SizedBox(height: 25),
//             const Text(
//               "Recommended Sessions",
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black87,
//               ),
//             ),
//             const SizedBox(height: 15),
//             _buildSessionList(context),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildHeader() {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [AppColors.primary, AppColors.primary.withValues(alpha: 0.8)],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: AppColors.primary.withValues(alpha: 0.3),
//             blurRadius: 10,
//             offset: const Offset(0, 5),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: const [
//           Text(
//             "Find Your Inner Peace",
//             style: TextStyle(
//               fontSize: 24,
//               fontWeight: FontWeight.bold,
//               color: Colors.white,
//             ),
//           ),
//           SizedBox(height: 10),
//           Text(
//             "Take a moment to breathe, relax, and reconnect with yourself. Select a session below to start your journey.",
//             style: TextStyle(fontSize: 16, color: Colors.white, height: 1.5),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSessionList(BuildContext context) {
//     final List<Session> sessions = [
//       Session(
//         title: "5-Minute Stress Relief",

//         color: Colors.blueAccent,
//         icon: Icons.timer, description: '', url: '',
//       ),
//       Session(
//         title: "Panic Attack Emergency",
//         description:
//             "Guided breathing to stop panic attacks. Immediate help now.",
//         url: "https://www.youtube.com/watch?v=WGG7MGgptxE&t=28s",
//         color: Colors.redAccent,
//         icon: Icons.favorite,
//       ),
//       Session(
//         title: "Deep Sleep Meditation",
//         description: "Relax for deep sleep. Let go of the day's worries.",
//         url: "https://www.youtube.com/watch?v=g0jfhRcXtLQ",
//         color: Colors.indigoAccent,
//         icon: Icons.nightlight_round,
//       ),
//     ];

//     return Column(
//       children: sessions
//           .map((session) => _buildSessionCard(context, session))
//           .toList(),
//     );
//   }

//   Widget _buildSessionCard(BuildContext context, Session session) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 15),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(15),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withValues(alpha: 0.1),
//             blurRadius: 5,
//             offset: const Offset(0, 3),
//           ),
//         ],
//       ),
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           onTap: () async {
//             final Uri uri = Uri.parse(session.url);
//             try {
//               if (await canLaunchUrl(uri)) {
//                 await launchUrl(uri, mode: LaunchMode.externalApplication);
//               } else {
//                 throw 'Could not launch $uri';
//               }
//             } catch (e) {
//               if (context.mounted) {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text("Could not launch session")),
//                 );
//               }
//             }
//           },
//           borderRadius: BorderRadius.circular(15),
//           child: Padding(
//             padding: const EdgeInsets.all(16),
//             child: Row(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color: session.color.withValues(alpha: 0.1),
//                     shape: BoxShape.circle,
//                   ),
//                   child: Icon(session.icon, color: session.color, size: 28),
//                 ),
//                 const SizedBox(width: 16),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         session.title,
//                         style: const TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black87,
//                         ),
//                       ),
//                       const SizedBox(height: 6),
//                       Text(
//                         session.description,
//                         maxLines: 3,
//                         overflow: TextOverflow.ellipsis,
//                         style: TextStyle(
//                           fontSize: 13,
//                           color: Colors.grey[600],
//                           height: 1.3,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 Icon(
//                   Icons.play_circle_fill,
//                   color: AppColors.primary,
//                   size: 36,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class Session {
//   final String title;
//   final String description;
//   final String url;
//   final Color color;
//   final IconData icon;

//   Session({
//     required this.title,
//     required this.description,
//     required this.url,
//     required this.color,
//     required this.icon,
//   });
// }
import 'package:flutter/material.dart';
import 'package:mental_healthcare/frontend/widgets/appcolors.dart';
import 'package:audioplayers/audioplayers.dart';

class GuidedVoiceCoachScreen extends StatefulWidget {
  const GuidedVoiceCoachScreen({super.key});

  @override
  State<GuidedVoiceCoachScreen> createState() => _GuidedVoiceCoachScreenState();
}

class _GuidedVoiceCoachScreenState extends State<GuidedVoiceCoachScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  int? currentTrackIndex;

  final List<Map<String, String>> _tracks = [
    {
      "title": "5-Minute Stress Relief",
      "author": "Forest Sounds",
      "duration": "5:30",
      "image": "assets/training.png",
      "path": "audios/relaxation_stress_relief.mp3",
    },
    {
      "title": "Panic Attack Emergency",
      "author": "Soothing Voice",
      "duration": "10:00",
      "image": "assets/resources.png",
      "path": "audios/panic_attact_emergency.mp3",
    },
    {
      "title": "Deep Sleep Meditation",
      "author": "Spiritual Healing",
      "duration": "4:15",
      "image": "assets/helpnow.png",
      "path": "audios/sleep_meditation.mp3",
    },
  ];

  @override
  void initState() {
    super.initState();

    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) setState(() => isPlaying = state == PlayerState.playing);
    });

    _audioPlayer.onDurationChanged.listen((newDuration) {
      if (mounted) setState(() => duration = newDuration);
    });

    _audioPlayer.onPositionChanged.listen((newPosition) {
      if (mounted) setState(() => position = newPosition);
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playTrack(int index) async {
    try {
      if (currentTrackIndex == index && isPlaying) {
        await _audioPlayer.pause();
      } else if (currentTrackIndex == index && !isPlaying) {
        await _audioPlayer.resume();
      } else {
        await _audioPlayer.stop();
        setState(() {
          currentTrackIndex = index;
          position = Duration.zero;
        });
        String? path = _tracks[index]['path'];
        if (path != null && path.isNotEmpty) {
          await _audioPlayer.play(AssetSource(path));
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error playing audio: $e")));
      }
    }
  }

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(d.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(d.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          "Voice Guided Coach",
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black54),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Find Your Inner Peace",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Take a moment to breathe, relax, and reconnect with yourself. Select a session below to start your journey.",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),

          // Session List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _tracks.length,
              itemBuilder: (context, index) {
                final track = _tracks[index];
                final bool isCurrentTrack = currentTrackIndex == index;

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                    border: isCurrentTrack
                        ? Border.all(color: AppColors.primary, width: 2)
                        : null,
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    leading: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: AssetImage(track['image']!),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: isCurrentTrack && isPlaying
                          ? Center(
                              child: Icon(
                                Icons.equalizer,
                                color: AppColors.primary,
                              ),
                            )
                          : null,
                    ),
                    title: Text(
                      track['title']!,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isCurrentTrack
                            ? AppColors.primary
                            : Colors.black87,
                      ),
                    ),
                    subtitle: Text(
                      track['author']!,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        isCurrentTrack && isPlaying
                            ? Icons.pause_circle_filled
                            : Icons.play_circle_fill,
                        color: AppColors.primary,
                        size: 35,
                      ),
                      onPressed: () => _playTrack(index),
                    ),
                  ),
                );
              },
            ),
          ),

          // Mini Player
          if (currentTrackIndex != null)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: AssetImage(
                              _tracks[currentTrackIndex!]['image']!,
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _tracks[currentTrackIndex!]['title']!,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              _tracks[currentTrackIndex!]['author']!,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          isPlaying
                              ? Icons.pause_circle_filled
                              : Icons.play_circle_fill,
                          color: AppColors.primary,
                          size: 45,
                        ),
                        onPressed: () => _playTrack(currentTrackIndex!),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        _formatDuration(position),
                        style: const TextStyle(fontSize: 12),
                      ),
                      Expanded(
                        child: SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            thumbShape: const RoundSliderThumbShape(
                              enabledThumbRadius: 6,
                            ),
                            trackHeight: 4,
                            activeTrackColor: AppColors.primary,
                            inactiveTrackColor: Colors.grey[300],
                          ),
                          child: Slider(
                            value: position.inSeconds.toDouble(),
                            max: duration.inSeconds.toDouble(),
                            onChanged: (value) async {
                              final newPosition = Duration(
                                seconds: value.toInt(),
                              );
                              await _audioPlayer.seek(newPosition);
                            },
                          ),
                        ),
                      ),
                      Text(
                        _formatDuration(duration),
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
