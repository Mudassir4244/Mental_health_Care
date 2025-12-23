import 'package:flutter/material.dart';
import 'package:mental_healthcare/frontend/widgets/appcolors.dart';
import 'package:url_launcher/url_launcher.dart';

class GuidedVoiceCoachScreen extends StatelessWidget {
  const GuidedVoiceCoachScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), // Light background
      appBar: AppBar(
        title: const Text(
          "Guided Voice Coach",
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 25),
            const Text(
              "Recommended Sessions",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 15),
            _buildSessionList(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primary.withValues(alpha: 0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
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
            style: TextStyle(fontSize: 16, color: Colors.white, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionList(BuildContext context) {
    final List<Session> sessions = [
      Session(
        title: "5-Minute Stress Relief",
        description:
            "Quick relaxation for high stress. Reset your mind in 5 mins.",
        url: "https://www.youtube.com/watch?v=ztTexqGQ0VI",
        color: Colors.blueAccent,
        icon: Icons.timer,
      ),
      Session(
        title: "Panic Attack Emergency",
        description:
            "Guided breathing to stop panic attacks. Immediate help now.",
        url: "https://www.youtube.com/watch?v=WGG7MGgptxE&t=28s",
        color: Colors.redAccent,
        icon: Icons.favorite,
      ),
      Session(
        title: "Deep Sleep Meditation",
        description: "Relax for deep sleep. Let go of the day's worries.",
        url: "https://www.youtube.com/watch?v=g0jfhRcXtLQ",
        color: Colors.indigoAccent,
        icon: Icons.nightlight_round,
      ),
    ];

    return Column(
      children: sessions
          .map((session) => _buildSessionCard(context, session))
          .toList(),
    );
  }

  Widget _buildSessionCard(BuildContext context, Session session) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () async {
            final Uri uri = Uri.parse(session.url);
            try {
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              } else {
                throw 'Could not launch $uri';
              }
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Could not launch session")),
                );
              }
            }
          },
          borderRadius: BorderRadius.circular(15),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: session.color.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(session.icon, color: session.color, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        session.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        session.description,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Icon(
                  Icons.play_circle_fill,
                  color: AppColors.primary,
                  size: 36,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Session {
  final String title;
  final String description;
  final String url;
  final Color color;
  final IconData icon;

  Session({
    required this.title,
    required this.description,
    required this.url,
    required this.color,
    required this.icon,
  });
}
