import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:mental_healthcare/frontend/customer_interface/homescreen.dart';
import 'package:mental_healthcare/frontend/customer_interface/profilescreen.dart';
import 'package:mental_healthcare/frontend/training_components/module_viewer.dart';
import 'package:mental_healthcare/frontend/widgets/appcolors.dart';
import 'package:mental_healthcare/frontend/widgets/widgets.dart';

class TrainingScreen extends StatefulWidget {
  const TrainingScreen({super.key});

  @override
  State<TrainingScreen> createState() => _TrainingScreenState();
}

class _TrainingScreenState extends State<TrainingScreen> {
  String _searchQuery = "";
  final TextEditingController _searchController = TextEditingController();

  // Colors to cycle through
  final List<Color> _cardColors = [
    Colors.blueAccent,
    Colors.purpleAccent,
    Colors.teal,
    Colors.orangeAccent,
    Colors.pinkAccent,
    Colors.indigoAccent,
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Assuming ProfileProvider is available in context from main.dart
    final provider = Provider.of<ProfileProvider>(context);
    bool ispremium = provider.isPremium;

    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
        return false;
      },
      child: Scaffold(
        backgroundColor: const Color(0xfff8f9fb),
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          leading: IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const HomeScreen()),
              );
            },
            icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          ),
          title: const Text(
            "Training Modules",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xffe9f5ff), Color(0xfff8f9fb)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                children: [
                  // Search Bar
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value.toLowerCase();
                          });
                        },
                        decoration: InputDecoration(
                          hintText: "Search modules...",
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.grey.shade400,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 15,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // List
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('TrainingModules')
                          .orderBy('timestamp', descending: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (snapshot.hasError) {
                          return Center(
                            child: Text("Error: ${snapshot.error}"),
                          );
                        }

                        final docs = snapshot.data?.docs ?? [];

                        // Filter docs based on search
                        final filteredDocs = docs.where((doc) {
                          final data = doc.data() as Map<String, dynamic>;
                          final title = (data['title'] ?? "")
                              .toString()
                              .toLowerCase();
                          return title.contains(_searchQuery);
                        }).toList();

                        return ListView(
                          padding: const EdgeInsets.fromLTRB(
                            16,
                            16,
                            16,
                            100,
                          ), // Extra padding for navbar
                          physics: const BouncingScrollPhysics(),
                          children: [
                            const Text(
                              'Your Learning Path 🚀',
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff222B45),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Explore modules designed to improve your mental well-being.',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            const SizedBox(height: 20),
                            if (filteredDocs.isEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 50.0),
                                child: Center(
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.search_off,
                                        size: 50,
                                        color: Colors.grey.shade300,
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        docs.isEmpty
                                            ? "No training modules available yet."
                                            : "No matching modules found.",
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            else
                              ...List.generate(filteredDocs.length, (index) {
                                final data =
                                    filteredDocs[index].data()
                                        as Map<String, dynamic>;
                                // Cycle colors
                                final color =
                                    _cardColors[index % _cardColors.length];

                                // Add color to data for passing to card builder
                                final moduleData = Map<String, dynamic>.from(
                                  data,
                                );
                                moduleData['color'] = color;

                                // Animation delay
                                return TweenAnimationBuilder(
                                  tween: Tween<double>(begin: 0.0, end: 1.0),
                                  duration: Duration(
                                    milliseconds: 400 + (index * 100),
                                  ),
                                  curve: Curves.easeOutQuad,
                                  builder: (context, double value, child) {
                                    return Transform.translate(
                                      offset: Offset(0, 50 * (1 - value)),
                                      child: Opacity(
                                        opacity: value,
                                        child: child,
                                      ),
                                    );
                                  },
                                  child: _buildTrainingCard(
                                    moduleData,
                                    index,
                                    ispremium,
                                    provider,
                                  ),
                                );
                              }),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Bottom Navbar
            const Align(
              alignment: Alignment.bottomCenter,
              child: BottomNavBar(currentScreen: 'Training'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrainingCard(
    Map<String, dynamic> module,
    int index,
    bool ispremium,
    ProfileProvider provider,
  ) {
    // Calculate estimated duration
    final slides = module['slides'] as List? ?? [];
    final duration = "${(slides.length * 2).clamp(2, 60)} mins";

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: (module['color'] as Color).withOpacity(0.15),
            blurRadius: 15,
            spreadRadius: 2,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: (module['color'] as Color).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(
                  Icons.auto_stories,
                  color: module['color'],
                  size: 28,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      module['title'] ?? "Untitled",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff222B45),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.timer_outlined,
                          size: 14,
                          color: Colors.grey.shade500,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          duration,
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Icon(
                          Icons.file_copy_outlined,
                          size: 14,
                          color: Colors.grey.shade500,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "${slides.length} Lessons",
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (!ispremium)
                Icon(Icons.lock_outline, color: Colors.grey.shade400),
            ],
          ),

          const SizedBox(height: 16),

          Text(
            module['description'] ?? "No description available.",
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 14,
              height: 1.5,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 20),

          // Action Area
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: 0.0,
                    color: module['color'],
                    backgroundColor: Colors.grey.shade100,
                    minHeight: 6,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: ispremium
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                ModuleViewerScreen(moduleData: module),
                          ),
                        );
                      }
                    : provider.paymentLoading
                    ? null
                    : () => provider.makePayment(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: ispremium
                      ? module['color']
                      : const Color(0xff222B45), // Dark color for upgrade
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: provider.paymentLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        ispremium ? 'Start' : 'Unlock',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
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
