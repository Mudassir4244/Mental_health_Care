// import 'package:audioplayers/audioplayers.dart';
// import 'package:flutter/material.dart';
// import 'package:mental_healthcare/frontend/widgets/appcolors.dart';
// import 'package:mental_healthcare/l10n/app_localizations.dart';

// class PodcastAudioScreen extends StatefulWidget {
//   const PodcastAudioScreen({super.key});

//   @override
//   State<PodcastAudioScreen> createState() => _PodcastAudioScreenState();
// }

// class _PodcastAudioScreenState extends State<PodcastAudioScreen> {
//   // Audio Player instance
//   final AudioPlayer _audioPlayer = AudioPlayer();

//   // State variables
//   bool isPlaying = false;
//   Duration duration = Duration.zero;
//   Duration position = Duration.zero;
//   int? currentTrackIndex;

//   // List of 7 Audio Tracks
//   final List<Map<String, String>> _tracks = [
//     {
//       "title": "Cooper Creek Meditation",
//       "author": "Forest Sounds",
//       "duration": "5:30",
//       "image": "assets/training.png",
//       "path":
//           "audios/cooper-creek-flowing-heart-of-the-forest-meditation-for-mental-health-409967.mp3",
//     },
//     {
//       "title": "Jindalba River Flute",
//       "author": "Ancient Flute",
//       "duration": "10:00",
//       "image": "assets/resources.png",
//       "path":
//           "audios/jindalba-foot-of-the-mountain-river-ancient-flute-for-mental-health-409966.mp3",
//     },
//     {
//       "title": "Healing Meditation Music",
//       "author": "Spiritual Healing",
//       "duration": "4:15",
//       "image": "assets/helpnow.png",
//       "path":
//           "audios/meditation-healing-mental-health-spiritual-music-233534.mp3",
//     },
//     {
//       "title": "Mental Health Focus",
//       "author": "Focus Music",
//       "duration": "15:20",
//       "image": "assets/checkin.png",
//       "path": "audios/mental-health-163877.mp3",
//     },
//     {
//       "title": "Clinic Relaxation",
//       "author": "Healthcare Music",
//       "duration": "8:45",
//       "image": "assets/training.png",
//       "path": "audios/mental-health-clinic-healthcare-music-269378.mp3",
//     },
//     {
//       "title": "Ancient Voices Zen",
//       "author": "Yoga Meditation",
//       "duration": "3:30",
//       "image": "assets/resources.png",
//       "path":
//           "audios/ngadiku-ancient-voices-spiritual-zen-yoga-meditation-for-mental-health-409965.mp3",
//     },
//     {
//       "title": "World Mental Health Day",
//       "author": "Awareness",
//       "duration": "6:10",
//       "image": "assets/helpnow.png",
//       "path": "audios/world-mental-health-day-426002.mp3",
//     },
//   ];

//   @override
//   void initState() {
//     super.initState();

//     // Listen to player state changes
//     _audioPlayer.onPlayerStateChanged.listen((state) {
//       if (mounted) {
//         setState(() {
//           isPlaying = state == PlayerState.playing;
//         });
//       }
//     });

//     // Listen to audio duration
//     _audioPlayer.onDurationChanged.listen((newDuration) {
//       if (mounted) {
//         setState(() {
//           duration = newDuration;
//         });
//       }
//     });

//     // Listen to audio position
//     _audioPlayer.onPositionChanged.listen((newPosition) {
//       if (mounted) {
//         setState(() {
//           position = newPosition;
//         });
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _audioPlayer.dispose();
//     super.dispose();
//   }

//   Future<void> _playTrack(int index) async {
//     try {
//       if (currentTrackIndex == index && isPlaying) {
//         await _audioPlayer.pause();
//       } else if (currentTrackIndex == index && !isPlaying) {
//         await _audioPlayer.resume();
//       } else {
//         // Play new track
//         await _audioPlayer.stop();
//         setState(() {
//           currentTrackIndex = index;
//           position = Duration.zero;
//         });

//         // Ensure Path is not null
//         String? path = _tracks[index]['path'];
//         if (path != null && path.isNotEmpty) {
//           await _audioPlayer.play(AssetSource(path));
//         }
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text("Error playing audio: $e")));
//     }
//   }

//   String _formatDuration(Duration d) {
//     String twoDigits(int n) => n.toString().padLeft(2, "0");
//     String twoDigitMinutes = twoDigits(d.inMinutes.remainder(60));
//     String twoDigitSeconds = twoDigits(d.inSeconds.remainder(60));
//     return "$twoDigitMinutes:$twoDigitSeconds";
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.background,
//       body: Column(
//         children: [
//           // Header
//           Container(
//             padding: const EdgeInsets.only(
//               top: 50,
//               bottom: 20,
//               left: 16,
//               right: 16,
//             ),
//             decoration: const BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [AppColors.primary, AppColors.accent],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//               borderRadius: BorderRadius.only(
//                 bottomLeft: Radius.circular(30),
//                 bottomRight: Radius.circular(30),
//               ),
//             ),
//             child: Row(
//               children: [
//                 IconButton(
//                   icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
//                   onPressed: () => Navigator.pop(context),
//                 ),
//                 const Expanded(
//                   child: Text(
//                     "Therapeutic Audios",
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 22,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 40), // Balance the back button
//               ],
//             ),
//           ),

//           // Playlist
//           Expanded(
//             child: ListView.builder(
//               padding: const EdgeInsets.all(16),
//               itemCount: _tracks.length,
//               itemBuilder: (context, index) {
//                 final track = _tracks[index];
//                 final bool isCurrentTrack = currentTrackIndex == index;

//                 return Container(
//                   margin: const EdgeInsets.only(bottom: 12),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(15),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.grey.withOpacity(0.1),
//                         blurRadius: 5,
//                         offset: const Offset(0, 3),
//                       ),
//                     ],
//                     border: isCurrentTrack
//                         ? Border.all(color: AppColors.primary, width: 2)
//                         : null,
//                   ),
//                   child: ListTile(
//                     contentPadding: const EdgeInsets.symmetric(
//                       horizontal: 16,
//                       vertical: 8,
//                     ),
//                     leading: Container(
//                       width: 50,
//                       height: 50,
//                       decoration: BoxDecoration(
//                         color: AppColors.primary.withOpacity(0.1),
//                         borderRadius: BorderRadius.circular(10),
//                         image: DecorationImage(
//                           image: AssetImage(track['image']!),
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                       child: isCurrentTrack && isPlaying
//                           ? Center(
//                               child: Icon(
//                                 Icons.equalizer,
//                                 color: AppColors.primary,
//                               ),
//                             )
//                           : null,
//                     ),
//                     title: Text(
//                       track['title']!,
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         color: isCurrentTrack
//                             ? AppColors.primary
//                             : Colors.black87,
//                       ),
//                     ),
//                     subtitle: Text(
//                       track['author']!,
//                       style: const TextStyle(color: Colors.grey),
//                     ),
//                     trailing: IconButton(
//                       icon: Icon(
//                         isCurrentTrack && isPlaying
//                             ? Icons.pause_circle_filled
//                             : Icons.play_circle_fill,
//                         color: AppColors.primary,
//                         size: 35,
//                       ),
//                       onPressed: () => _playTrack(index),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),

//           // Mini Player (Visible when a track is selected)
//           if (currentTrackIndex != null)
//             Container(
//               padding: const EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: const BorderRadius.only(
//                   topLeft: Radius.circular(30),
//                   topRight: Radius.circular(30),
//                 ),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.1),
//                     blurRadius: 10,
//                     offset: const Offset(0, -5),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Row(
//                     children: [
//                       Container(
//                         width: 50,
//                         height: 50,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(10),
//                           image: DecorationImage(
//                             image: AssetImage(
//                               _tracks[currentTrackIndex!]['image']!,
//                             ),
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 15),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               _tracks[currentTrackIndex!]['title']!,
//                               style: const TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 16,
//                               ),
//                               maxLines: 1,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                             Text(
//                               _tracks[currentTrackIndex!]['author']!,
//                               style: const TextStyle(
//                                 color: Colors.grey,
//                                 fontSize: 12,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       IconButton(
//                         icon: Icon(
//                           isPlaying
//                               ? Icons.pause_circle_filled
//                               : Icons.play_circle_filled,
//                           color: AppColors.primary,
//                           size: 45,
//                         ),
//                         onPressed: () => _playTrack(currentTrackIndex!),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 10),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         _formatDuration(position),
//                         style: const TextStyle(fontSize: 12),
//                       ),
//                       Expanded(
//                         child: SliderTheme(
//                           data: SliderTheme.of(context).copyWith(
//                             thumbShape: const RoundSliderThumbShape(
//                               enabledThumbRadius: 6,
//                             ),
//                             trackHeight: 4,
//                             activeTrackColor: AppColors.primary,
//                             inactiveTrackColor: Colors.grey[300],
//                           ),
//                           child: Slider(
//                             value: position.inSeconds.toDouble(),
//                             max: duration.inSeconds.toDouble(),
//                             onChanged: (value) async {
//                               final newPosition = Duration(
//                                 seconds: value.toInt(),
//                               );
//                               await _audioPlayer.seek(newPosition);
//                             },
//                           ),
//                         ),
//                       ),
//                       Text(
//                         _formatDuration(duration),
//                         style: const TextStyle(fontSize: 12),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:mental_healthcare/frontend/widgets/appcolors.dart';
import 'package:mental_healthcare/l10n/app_localizations.dart';

class PodcastAudioScreen extends StatefulWidget {
  const PodcastAudioScreen({super.key});

  @override
  State<PodcastAudioScreen> createState() => _PodcastAudioScreenState();
}

class _PodcastAudioScreenState extends State<PodcastAudioScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  int? currentTrackIndex;

  /// Localized track keys (NO hardcoded strings)
  final List<Map<String, String>> _tracks = [
    {
      "titleKey": "track_cooper_title",
      "authorKey": "track_cooper_author",
      "duration": "5:30",
      "image": "assets/training.png",
      "path":
          "audios/cooper-creek-flowing-heart-of-the-forest-meditation-for-mental-health-409967.mp3",
    },
    {
      "titleKey": "track_jindalba_title",
      "authorKey": "track_jindalba_author",
      "duration": "10:00",
      "image": "assets/resources.png",
      "path":
          "audios/jindalba-foot-of-the-mountain-river-ancient-flute-for-mental-health-409966.mp3",
    },
    {
      "titleKey": "track_healing_title",
      "authorKey": "track_healing_author",
      "duration": "4:15",
      "image": "assets/helpnow.png",
      "path":
          "audios/meditation-healing-mental-health-spiritual-music-233534.mp3",
    },
    {
      "titleKey": "track_focus_title",
      "authorKey": "track_focus_author",
      "duration": "15:20",
      "image": "assets/checkin.png",
      "path": "audios/mental-health-163877.mp3",
    },
    {
      "titleKey": "track_clinic_title",
      "authorKey": "track_clinic_author",
      "duration": "8:45",
      "image": "assets/training.png",
      "path": "audios/mental-health-clinic-healthcare-music-269378.mp3",
    },
    {
      "titleKey": "track_zen_title",
      "authorKey": "track_zen_author",
      "duration": "3:30",
      "image": "assets/resources.png",
      "path":
          "audios/ngadiku-ancient-voices-spiritual-zen-yoga-meditation-for-mental-health-409965.mp3",
    },
    {
      "titleKey": "track_world_title",
      "authorKey": "track_world_author",
      "duration": "6:10",
      "image": "assets/helpnow.png",
      "path": "audios/world-mental-health-day-426002.mp3",
    },
  ];

  /// 🔑 SAFE localization resolver
  String _localized(BuildContext context, String key) {
    final loc = AppLocalizations.of(context)!;

    switch (key) {
      case 'track_cooper_title':
        return loc.track_cooper_title;
      case 'track_cooper_author':
        return loc.track_cooper_author;

      case 'track_jindalba_title':
        return loc.track_jindalba_title;
      case 'track_jindalba_author':
        return loc.track_jindalba_author;

      case 'track_healing_title':
        return loc.track_healing_title;
      case 'track_healing_author':
        return loc.track_healing_author;

      case 'track_focus_title':
        return loc.track_focus_title;
      case 'track_focus_author':
        return loc.track_focus_author;

      case 'track_clinic_title':
        return loc.track_clinic_title;
      case 'track_clinic_author':
        return loc.track_clinic_author;

      case 'track_zen_title':
        return loc.track_zen_title;
      case 'track_zen_author':
        return loc.track_zen_author;

      case 'track_world_title':
        return loc.track_world_title;
      case 'track_world_author':
        return loc.track_world_author;

      default:
        return '';
    }
  }

  @override
  void initState() {
    super.initState();

    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (!mounted) return;
      setState(() => isPlaying = state == PlayerState.playing);
    });

    _audioPlayer.onDurationChanged.listen((d) {
      if (!mounted) return;
      setState(() => duration = d);
    });

    _audioPlayer.onPositionChanged.listen((p) {
      if (!mounted) return;
      setState(() => position = p);
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

        final path = _tracks[index]['path'];
        if (path != null && path.isNotEmpty) {
          await _audioPlayer.play(AssetSource(path));
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("${AppLocalizations.of(context)!.audio_error}: $e"),
        ),
      );
    }
  }

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return "${twoDigits(d.inMinutes.remainder(60))}:${twoDigits(d.inSeconds.remainder(60))}";
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          /// HEADER
          Container(
            padding: const EdgeInsets.only(
              top: 50,
              bottom: 20,
              left: 16,
              right: 16,
            ),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.accent],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                Expanded(
                  child: Text(
                    loc.therapeutic_audios,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 40),
              ],
            ),
          ),

          /// PLAYLIST
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _tracks.length,
              itemBuilder: (context, index) {
                final track = _tracks[index];
                final isCurrent = currentTrackIndex == index;

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: isCurrent
                        ? Border.all(color: AppColors.primary, width: 2)
                        : null,
                  ),
                  child: ListTile(
                    leading: Image.asset(track['image']!, width: 50),
                    title: Text(
                      _localized(context, track['titleKey']!),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isCurrent ? AppColors.primary : Colors.black87,
                      ),
                    ),
                    subtitle: Text(_localized(context, track['authorKey']!)),
                    trailing: IconButton(
                      icon: Icon(
                        isCurrent && isPlaying
                            ? Icons.pause_circle_filled
                            : Icons.play_circle_fill,
                        size: 35,
                        color: AppColors.primary,
                      ),
                      onPressed: () => _playTrack(index),
                    ),
                  ),
                );
              },
            ),
          ),

          /// MINI PLAYER
          /// MINI PLAYER WITH PROGRESS
          if (currentTrackIndex != null)
            Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  /// TITLE
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _localized(
                            context,
                            _tracks[currentTrackIndex!]['titleKey']!,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          isPlaying
                              ? Icons.pause_circle_filled
                              : Icons.play_circle_filled,
                          size: 38,
                          color: AppColors.primary,
                        ),
                        onPressed: () => _playTrack(currentTrackIndex!),
                      ),
                    ],
                  ),

                  /// SLIDER
                  Slider(
                    min: 0,
                    max: duration.inSeconds.toDouble(),
                    value: position.inSeconds
                        .clamp(0, duration.inSeconds)
                        .toDouble(),
                    activeColor: AppColors.primary,
                    onChanged: (value) async {
                      final newPos = Duration(seconds: value.toInt());
                      await _audioPlayer.seek(newPos);
                    },
                  ),

                  /// TIME
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(_formatDuration(position)),
                      Text(_formatDuration(duration)),
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
