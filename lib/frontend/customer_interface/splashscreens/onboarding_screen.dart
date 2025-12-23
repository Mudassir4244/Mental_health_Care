import 'package:flutter/material.dart';
import 'package:mental_healthcare/frontend/customer_interface/choice_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 🌈 Layer 1: Royal blue gradient background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 27, 84, 255), // Deep royal blue (top)
                  Color.fromARGB(
                    255,
                    0,
                    41,
                    244,
                  ), // Vibrant royal blue (middle)
                  Color.fromARGB(
                    255,
                    54,
                    65,
                    210,
                  ), // Sky blue highlight (bottom)
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // ✨ Layer 2: Shiny diagonal highlight overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.2),
                  Colors.transparent,
                  Colors.white.withOpacity(0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: const [0.0, 0.4, 1.0],
              ),
            ),
          ),

          // 💫 Optional soft radial glow near the logo
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.topCenter,
                radius: 1.2,
                colors: [Color.fromARGB(60, 255, 255, 255), Colors.transparent],
              ),
            ),
          ),

          // 📱 Main content
          Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.2),
              const Padding(
                padding: EdgeInsets.all(12.0),
                child: Text(
                  'It’s a new day. Check-in, lift someone else up, and start receiving affirmations!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 30),

              // 🧠 Logo
              Container(
                color: Colors.transparent,
                child: Center(
                  child: Image.asset('assets/logo.png', height: 150),
                ),
              ),

              const SizedBox(height: 40),
              const Text(
                "MindAssist",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Linking minds, lifting spirits",
                style: TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.w500,
                  fontSize: 17,
                ),
              ),

              const Spacer(),

              // 🚀 Get Started Button
              Padding(
                padding: const EdgeInsets.all(20),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ChoiceScreen()),
                    );
                  },
                  child: Container(
                    height: 60,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF007BFF), // Bright royal blue
                          Color(0xFF0040FF), // Deep royal
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.25),
                          offset: const Offset(0, 4),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        'Get Started',
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
