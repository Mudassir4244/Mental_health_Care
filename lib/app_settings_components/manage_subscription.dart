// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class SubscriptionScreen extends StatefulWidget {
//   const SubscriptionScreen({super.key});

//   @override
//   State<SubscriptionScreen> createState() => _SubscriptionScreenState();
// }

// class _SubscriptionScreenState extends State<SubscriptionScreen> {
//   /// Fetch subscription plan of current user
//   Future<String?> _getSubscriptionPlan() async {
//     final uid = FirebaseAuth.instance.currentUser!.uid;

//     final doc = await FirebaseFirestore.instance
//         .collection('Users') // your users collection
//         .doc(uid) // current user doc
//         .get();

//     if (!doc.exists) return null;

//     return doc.data()!['Payment Status']; // field name
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("My Subscription"), centerTitle: true),

//       body: FutureBuilder<String?>(
//         future: _getSubscriptionPlan(),
//         builder: (context, snapshot) {
//           // 🔄 Loading
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           // ❌ Error
//           if (snapshot.hasError) {
//             return const Center(child: Text("Something went wrong"));
//           }

//           // 😶 No subscription found
//           if (!snapshot.hasData || snapshot.data == null) {
//             return const Center(
//               child: Text(
//                 "No subscription plan found",
//                 style: TextStyle(fontSize: 18),
//               ),
//             );
//           }

//           // 🎉 Show subscription plan
//           return Center(
//             child: Text(
//               "Your Current Plan: ${snapshot.data}",
//               style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mental_healthcare/frontend/widgets/appcolors.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  /// Fetch current user's subscription/payment status
  Future<String?> _getSubscriptionStatus() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    final doc = await FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .get();

    if (!doc.exists) return null;

    return doc.data()!['Payment Status']; // completed / pending
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
        title: const Text(
          "My Subscription",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primary, AppColors.accent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),

      body: FutureBuilder<String?>(
        future: _getSubscriptionStatus(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text("Something went wrong"));
          }

          final status = snapshot.data;

          // No subscription yet
          if (status == null || status == "Pending") {
            return _buildUpgradeToPremiumUI();
          }

          // Subscription completed
          if (status == "Completed") {
            return _buildPremiumUI();
          }

          // Default fallback
          return const Center(child: Text("No subscription information found"));
        },
      ),
    );
  }

  /// UI when user is already a premium member
  Widget _buildPremiumUI() {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.orange.withOpacity(0.4),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.verified, color: Colors.white, size: 60),
            SizedBox(height: 10),
            Text(
              "Premium Member",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "You have full access to all premium features.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  /// UI when payment status is pending or not completed
  Widget _buildUpgradeToPremiumUI() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          "Upgrade to Premium",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),

        const Text(
          "Unlock all MindAssist premium features:",
          style: TextStyle(fontSize: 16),
        ),

        const SizedBox(height: 20),

        _featureTile(
          Icons.lock_open,
          "Access to exclusive mental health tools",
        ),
        _featureTile(Icons.chat_bubble, "Priority chat with practitioners"),
        _featureTile(Icons.auto_graph, "Advanced analytics & progress tracker"),
        _featureTile(Icons.nightlight, "Sleep & focus audio library"),

        const SizedBox(height: 30),

        // Premium card
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xff6A11CB), Color(0xff2575FC)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: const [
              Text(
                "Premium Plan",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5),
              Text(
                "PKR 999 / month",
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
            ],
          ),
        ),

        const SizedBox(height: 30),

        // Pay Now Button
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            backgroundColor: Colors.deepPurple,
          ),
          onPressed: () {
            // TODO: integrate Easypaisa / JazzCash / Stripe
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Redirecting to payment...")),
            );
          },
          child: const Text(
            "Pay Now",
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
      ],
    );
  }

  /// Reusable feature tile
  Widget _featureTile(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: Colors.deepPurple),
      title: Text(title, style: const TextStyle(fontSize: 16)),
    );
  }
}
