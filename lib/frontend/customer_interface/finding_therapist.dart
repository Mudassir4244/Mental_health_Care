// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:mental_healthcare/frontend/customer_interface/therapist_details.dart';
// import 'package:mental_healthcare/frontend/widgets/appcolors.dart';

// class FindingTherapist extends StatefulWidget {
//   const FindingTherapist({super.key});

//   @override
//   State<FindingTherapist> createState() => _FindingTherapistState();
// }

// class _FindingTherapistState extends State<FindingTherapist> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       appBar: AppBar(
//         elevation: 0,
//         centerTitle: true,
//         title: const Text(
//           'Find a Practitioner',
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         leading: IconButton(
//           icon: const Icon(
//             Icons.arrow_back_ios,
//             color: AppColors.textColorPrimary,
//           ),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),

//       // ---- FUTURE BUILDER ----
//       body: FutureBuilder(
//         future: FirebaseFirestore.instance
//             .collection('Users')
//             .where('role', isEqualTo: 'Practitioner')
//             .get()
//             .then(
//               (snapshot) => snapshot.docs.map((doc) => doc.data()).toList(),
//             ),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           if (snapshot.hasError) {
//             return Center(child: Text("Error: ${snapshot.error}"));
//           }

//           if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return const Center(child: Text("No practitioners found."));
//           }

//           final data = snapshot.data!;

//           return ListView.builder(
//             padding: const EdgeInsets.all(16),
//             itemCount: data.length,
//             itemBuilder: (context, index) {
//               final practitioner = data[index];

//               return Container(
//                 margin: const EdgeInsets.only(bottom: 16),
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(18),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black12,
//                       blurRadius: 10,
//                       offset: const Offset(0, 4),
//                     ),
//                   ],
//                 ),
//                 child: Row(
//                   children: [
//                     // --- Profile Avatar ---
//                     Container(
//                       padding: const EdgeInsets.all(12),
//                       decoration: BoxDecoration(
//                         color: Colors.blue[50],
//                         shape: BoxShape.circle,
//                       ),
//                       child: const Icon(
//                         Icons.person,
//                         size: 30,
//                         color: Colors.blue,
//                       ),
//                     ),

//                     const SizedBox(width: 16),

//                     // --- Name and Speciality ---
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             practitioner['username'] ?? "Unknown",
//                             style: const TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           const SizedBox(height: 4),
//                           Text(
//                             practitioner['Speciality'] ?? "No Specialty",
//                             style: TextStyle(
//                               fontSize: 14,
//                               color: Colors.grey[600],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),

//                     // Arrow button
//                     IconButton(
//                       icon: const Icon(Icons.arrow_forward_ios_rounded),
//                       color: Colors.grey[700],
//                       onPressed: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (_) =>
//                                 TherapistDetails(data: practitioner),
//                           ),
//                         );
//                       },
//                     ),
//                   ],
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mental_healthcare/frontend/customer_interface/therapist_details.dart';
import 'package:mental_healthcare/frontend/widgets/appcolors.dart';

class FindingTherapist extends StatefulWidget {
  const FindingTherapist({super.key});

  @override
  State<FindingTherapist> createState() => _FindingTherapistState();
}

class _FindingTherapistState extends State<FindingTherapist> {
  List<Map<String, dynamic>> practitioners = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPractitioners(); // Fetch only 1st time
  }

  // --- Fetch function ---
  Future<void> fetchPractitioners() async {
    setState(() => isLoading = true);

    final snapshot = await FirebaseFirestore.instance
        .collection('Users')
        .where('role', isEqualTo: 'Practitioner')
        .get();

    practitioners = snapshot.docs.map((doc) => doc.data()).toList();

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Find a Practitioner',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.textColorPrimary,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      // Pull-to-refresh wrapper
      body: RefreshIndicator(
        onRefresh: fetchPractitioners, // Refresh when swiped down
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : practitioners.isEmpty
            ? const Center(child: Text("No practitioners found."))
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: practitioners.length,
                itemBuilder: (context, index) {
                  final practitioner = practitioners[index];

                  return GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TherapistDetails(data: practitioner),
                      ),
                    ),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          // Avatar
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.blue[50],
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.person,
                              size: 30,
                              color: Colors.blue,
                            ),
                          ),

                          const SizedBox(width: 16),

                          // Info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  practitioner['username'] ?? "Unknown",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  practitioner['Speciality'] ?? "No Specialty",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          IconButton(
                            icon: const Icon(Icons.arrow_forward_ios_rounded),
                            color: Colors.grey[700],
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      TherapistDetails(data: practitioner),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
