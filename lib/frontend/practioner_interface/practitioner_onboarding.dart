import 'package:flutter/material.dart';
import 'package:mental_healthcare/backend/practionar.dart';
import 'package:mental_healthcare/frontend/practioner_interface/prac_homescreen.dart';
import 'package:mental_healthcare/payment_process/stripe_services.dart';
import 'package:mental_healthcare/frontend/widgets/error_handler.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PractitionerOnboardingScreen extends StatefulWidget {
  const PractitionerOnboardingScreen({super.key});

  @override
  State<PractitionerOnboardingScreen> createState() =>
      _PractitionerOnboardingScreenState();
}

class _PractitionerOnboardingScreenState
    extends State<PractitionerOnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _isProcessing = false;

  final List<Map<String, dynamic>> _pages = [
    {
      "title": "Welcome, Practitioner! 👋",
      "description":
          "We are thrilled to welcome you to our mental health community. Your expertise will help change lives.",
      "icon": Icons.volunteer_activism,
    },
    {
      "title": "Grow Your Practice 🚀",
      "description":
          "Connect with potential clients effortlessly. Manage appointments, chat securely, and expand your reach.",
      "icon": Icons.people_outline,
    },
    {
      "title": "Membership Plan 💎",
      "description":
          "To maintain our high-quality platform, we charge a small monthly fee. You can cancel anytime.",
      "price": "\$30 / month",
      "icon": Icons.workspace_premium,
    },
  ];

  void _onNext() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _processPayment();
    }
  }

  Future<void> _processPayment() async {
    setState(() => _isProcessing = true);
    final stripe = StripeServices();
    final auth = PracAuth();
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ErrorHandler.showErrorSnackBar(context, "User not found. Please login.");
      return;
    }

    try {
      // Trigger Stripe Payment
      await stripe.makePayment(30, 'USD');

      // Update backend status on success
      bool success = await auth.updatePaymentStatus(user.uid);

      if (success) {
        if (mounted) {
          ErrorHandler.showSuccessSnackBar(
            context,
            "Payment Successful! Welcome aboard.",
          );
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => PracHomescreen()),
            (route) => false,
          );
        }
      } else {
        throw "Failed to update payment status.";
      }
    } catch (e) {
      if (mounted) {
        ErrorHandler.showErrorDialog(context, "Payment Failed", e.toString());
      }
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF6A5AE0), Color(0xFF00C2FF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // 2. Circular Blobs
          Positioned(
            top: -100,
            left: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.1),
              ),
            ),
          ),
          Positioned(
            bottom: -120,
            right: -60,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.1),
              ),
            ),
          ),

          // 3. Content
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) =>
                        setState(() => _currentPage = index),
                    itemCount: _pages.length,
                    itemBuilder: (context, index) {
                      final page = _pages[index];
                      return _buildPageContent(page);
                    },
                  ),
                ),

                // 4. Bottom Controls
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      // Page Indicators
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          _pages.length,
                          (index) => AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            height: 8,
                            width: _currentPage == index ? 24 : 8,
                            decoration: BoxDecoration(
                              color: _currentPage == index
                                  ? Colors.white
                                  : Colors.white38,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Action Button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _isProcessing ? null : _onNext,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF6A5AE0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 5,
                          ),
                          child: _isProcessing
                              ? const CircularProgressIndicator(
                                  color: Color(0xFF6A5AE0),
                                )
                              : Text(
                                  _currentPage == _pages.length - 1
                                      ? "Pay \$30 & Join"
                                      : "Next",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageContent(Map<String, dynamic> page) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Icon(page['icon'], size: 80, color: Colors.white),
          ),
          const SizedBox(height: 40),
          Text(
            page['title'],
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            page['description'],
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              height: 1.5,
              color: Colors.white70,
            ),
          ),
          if (page.containsKey('price')) ...[
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white54),
              ),
              child: Text(
                page['price'],
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
