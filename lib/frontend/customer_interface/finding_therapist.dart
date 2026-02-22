import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mental_healthcare/frontend/customer_interface/therapist_details.dart';
import 'package:mental_healthcare/frontend/widgets/appcolors.dart';
import 'package:mental_healthcare/frontend/widgets/error_handler.dart';

class FindingTherapist extends StatefulWidget {
  const FindingTherapist({super.key});

  @override
  State<FindingTherapist> createState() => _FindingTherapistState();
}

class _FindingTherapistState extends State<FindingTherapist> {
  List<Map<String, dynamic>> _allPractitioners = [];
  List<Map<String, dynamic>> _filteredPractitioners = [];
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';

  final List<String> _categories = [
    'All',
    'Psychologist',
    'Psychiatrist',
    'Therapist',
    'Counselor',
    'Coach',
  ];

  @override
  void initState() {
    super.initState();
    _fetchPractitioners();
    _searchController.addListener(_filterPractitioners);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchPractitioners() async {
    setState(() => _isLoading = true);
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('Users')
          .where('role', isEqualTo: 'Practitioner')
          .get();

      final data = snapshot.docs.map((doc) => doc.data()).toList();
      data.shuffle(); // Randomize the order

      if (mounted) {
        setState(() {
          _allPractitioners = data;
          _filteredPractitioners = data;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        ErrorHandler.showErrorSnackBar(context, "Failed to load practitioners");
        setState(() => _isLoading = false);
      }
    }
  }

  void _filterPractitioners() {
    final query = _searchController.text.toLowerCase();

    setState(() {
      _filteredPractitioners = _allPractitioners.where((practitioner) {
        final name = (practitioner['username'] ?? '').toString().toLowerCase();
        final speciality = (practitioner['Speciality'] ?? '')
            .toString()
            .toLowerCase();

        final matchesSearch =
            name.contains(query) || speciality.contains(query);
        final matchesCategory =
            _selectedCategory == 'All' ||
            speciality.contains(_selectedCategory.toLowerCase());

        return matchesSearch && matchesCategory;
      }).toList();
    });
  }

  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
    });
    _filterPractitioners();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff8f9fb),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: const Text(
          'Find a Practitioner',
          style: TextStyle(
            color: AppColors.textColorPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.textColorPrimary,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search by name or speciality...',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: AppColors.primary,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                ),
              ),
            ),
          ),

          // Categories
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: _categories.map((category) {
                final isSelected = _selectedCategory == category;
                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: GestureDetector(
                    onTap: () => _onCategorySelected(category),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary : Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : Colors.grey.shade300,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: AppColors.primary.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ]
                            : null,
                      ),
                      child: Text(
                        category,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.grey[600],
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          // Practitioners List
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  )
                : _filteredPractitioners.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off_rounded,
                          size: 60,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "No practitioners found",
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredPractitioners.length,
                    itemBuilder: (context, index) {
                      final practitioner = _filteredPractitioners[index];
                      return PractitionerCard(practitioner: practitioner);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class PractitionerCard extends StatelessWidget {
  final Map<String, dynamic> practitioner;

  const PractitionerCard({super.key, required this.practitioner});

  @override
  Widget build(BuildContext context) {
    final name = practitioner['username'] ?? "Unknown Practitioner";
    final speciality =
        practitioner['Speciality'] ?? "Mental Health Professional";
    // Placeholder for other potential fields
    // final rating = practitioner['rating'] ?? 4.5;
    // final reviews = practitioner['reviews'] ?? 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => TherapistDetails(data: practitioner),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary.withOpacity(0.1),
                  ),
                  child: Center(
                    child: (() {
                      final imageUrl =
                          practitioner['ImageUrl']?.toString() ?? "";

                      // If URL exists and is not empty
                      if (imageUrl.isNotEmpty) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(48),
                          child: Image.network(
                            imageUrl,
                            width: 70,
                            height: 70,
                            fit: BoxFit.cover,
                            // Fallback if image fails to load
                            errorBuilder: (context, error, stackTrace) {
                              return _buildFallback(name);
                            },
                          ),
                        );
                      } else {
                        // If URL is null or empty
                        return _buildFallback(name);
                      }
                    })(),
                  ),
                ),

                // Helper function for fallback (shows first letter or ?)
                const SizedBox(width: 16),

                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff222B45),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        speciality,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.primary.withOpacity(0.8),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                // Arrow/Action
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.05),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 16,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget _buildFallback(String name) {
  return Text(
    name.isNotEmpty ? name[0].toUpperCase() : '?',
    style: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color: AppColors.primary,
    ),
  );
}
