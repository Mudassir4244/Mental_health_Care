import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// ----------------- Total Customers -----------------
class TotalCustomers extends StatefulWidget {
  const TotalCustomers({super.key});

  @override
  State<TotalCustomers> createState() => _TotalCustomersState();
}

class _TotalCustomersState extends State<TotalCustomers> {
  String _selectedFilter = 'All'; // 'All', 'Paid', 'Unpaid'

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Total Customers"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .where('role', isEqualTo: "customer")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final allUsers = snapshot.data!.docs;

          // Calculate counts
          int totalCount = allUsers.length;
          int paidCount = 0;
          int unpaidCount = 0;

          List<DocumentSnapshot> filteredUsers = [];

          for (var user in allUsers) {
            final data = user.data() as Map<String, dynamic>;
            String paymentStatus = (data['Payment Status'] ?? "Pending")
                .toString();
            bool isPaid =
                paymentStatus.toLowerCase() == "paid" ||
                paymentStatus.toLowerCase() == "completed";

            if (isPaid) {
              paidCount++;
            } else {
              unpaidCount++;
            }

            if (_selectedFilter == 'All') {
              filteredUsers.add(user);
            } else if (_selectedFilter == 'Paid' && isPaid) {
              filteredUsers.add(user);
            } else if (_selectedFilter == 'Unpaid' && !isPaid) {
              filteredUsers.add(user);
            }
          }

          return Column(
            children: [
              // Filter Section
              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildFilterChip("All", totalCount, Colors.blue),
                    _buildFilterChip("Paid", paidCount, Colors.green),
                    _buildFilterChip("Unpaid", unpaidCount, Colors.orange),
                  ],
                ),
              ),
              const Divider(height: 1),

              // List Section
              Expanded(
                child: filteredUsers.isEmpty
                    ? Center(child: Text("No $_selectedFilter customers found"))
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: filteredUsers.length,
                        itemBuilder: (context, index) {
                          final data =
                              filteredUsers[index].data()
                                  as Map<String, dynamic>;
                          String paymentStatus =
                              (data['Payment Status'] ?? "Pending").toString();
                          bool isPaid =
                              paymentStatus.toLowerCase() == "paid" ||
                              paymentStatus.toLowerCase() == "completed";

                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(16),
                              leading: CircleAvatar(
                                radius: 25,
                                backgroundColor: Colors.blueAccent.withOpacity(
                                  0.1,
                                ),
                                child: Text(
                                  (data['username'] ?? "?")[0].toUpperCase(),
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blueAccent,
                                  ),
                                ),
                              ),
                              title: Text(
                                data['username'] ?? "N/A",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 5),
                                  Text(data['email'] ?? "N/A"),
                                  const SizedBox(height: 5),
                                  Row(
                                    children: [
                                      const Text(
                                        "Payment Status: ",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: isPaid
                                              ? Colors.green.withOpacity(0.1)
                                              : Colors.orange.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          border: Border.all(
                                            color: isPaid
                                                ? Colors.green
                                                : Colors.orange,
                                          ),
                                        ),
                                        child: Text(
                                          paymentStatus,
                                          style: TextStyle(
                                            color: isPaid
                                                ? Colors.green
                                                : Colors.orange,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFilterChip(String label, int count, Color color) {
    bool isSelected = _selectedFilter == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = label;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? color : color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color, width: 1.5),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withOpacity(0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Row(
          children: [
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : color,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white.withOpacity(0.3)
                    : color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                "$count",
                style: TextStyle(
                  color: isSelected ? Colors.white : color,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ----------------- Total Practitioners -----------------
class TotalPractitioners extends StatefulWidget {
  const TotalPractitioners({super.key});

  @override
  State<TotalPractitioners> createState() => _TotalPractitionersState();
}

class _TotalPractitionersState extends State<TotalPractitioners> {
  String _selectedSpeciality = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Total Practitioners"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .where('role', isEqualTo: "Practitioner")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final allUsers = snapshot.data!.docs;

          // 1. Extract and Count Specialities
          Map<String, int> specialityCounts = {'All': allUsers.length};
          List<String> specialities = ['All'];

          for (var user in allUsers) {
            final data = user.data() as Map<String, dynamic>;
            String speciality = (data['Speciality'] ?? "Unknown")
                .toString()
                .trim();
            if (speciality.isEmpty) speciality = "Unknown";

            if (!specialityCounts.containsKey(speciality)) {
              specialityCounts[speciality] = 0;
              specialities.add(speciality);
            }
            specialityCounts[speciality] = specialityCounts[speciality]! + 1;
          }

          // 2. Filter Users
          List<DocumentSnapshot> filteredUsers = [];
          if (_selectedSpeciality == 'All') {
            filteredUsers = allUsers;
          } else {
            filteredUsers = allUsers.where((user) {
              final data = user.data() as Map<String, dynamic>;
              String speciality = (data['Speciality'] ?? "Unknown")
                  .toString()
                  .trim();
              if (speciality.isEmpty) speciality = "Unknown";
              return speciality == _selectedSpeciality;
            }).toList();
          }

          return Column(
            children: [
              // Filter Section (Horizontal Scroll)
              Container(
                height: 60,
                color: Colors.white,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  scrollDirection: Axis.horizontal,
                  itemCount: specialities.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 10),
                  itemBuilder: (context, index) {
                    String spec = specialities[index];
                    int count = specialityCounts[spec] ?? 0;
                    return _buildFilterChip(spec, count, Colors.teal);
                  },
                ),
              ),
              const Divider(height: 1),

              // List Section
              Expanded(
                child: filteredUsers.isEmpty
                    ? Center(
                        child: Text(
                          "No $_selectedSpeciality practitioners found",
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: filteredUsers.length,
                        itemBuilder: (context, index) {
                          final data =
                              filteredUsers[index].data()
                                  as Map<String, dynamic>;
                          String speciality = (data['Speciality'] ?? "Unknown")
                              .toString();

                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(16),
                              leading: CircleAvatar(
                                radius: 25,
                                backgroundColor: Colors.teal.withOpacity(0.1),
                                child: Text(
                                  (data['username'] ?? "?")[0].toUpperCase(),
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.teal,
                                  ),
                                ),
                              ),
                              title: Text(
                                data['username'] ?? "N/A",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 5),
                                  Text(data['email'] ?? "N/A"),
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 5,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.teal.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: Colors.teal.withOpacity(0.5),
                                      ),
                                    ),
                                    child: Text(
                                      speciality,
                                      style: const TextStyle(
                                        color: Colors.teal,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFilterChip(String label, int count, Color color) {
    bool isSelected = _selectedSpeciality == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedSpeciality = label;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? color : color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color, width: 1.5),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withOpacity(0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : color,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white.withOpacity(0.3)
                    : color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                "$count",
                style: TextStyle(
                  color: isSelected ? Colors.white : color,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ----------------- Total Organizations -----------------
class TotalOrganizations extends StatefulWidget {
  const TotalOrganizations({super.key});

  @override
  State<TotalOrganizations> createState() => _TotalOrganizationsState();
}

class _TotalOrganizationsState extends State<TotalOrganizations> {
  String _selectedFilter = 'All'; // 'All', 'Paid', 'Unpaid'

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Total Organization Owners"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .where('role', isEqualTo: "Organization Owner")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final allUsers = snapshot.data!.docs;

          // Calculate counts
          int totalCount = allUsers.length;
          int paidCount = 0;
          int unpaidCount = 0;

          List<DocumentSnapshot> filteredUsers = [];

          for (var user in allUsers) {
            final data = user.data() as Map<String, dynamic>;
            // Note: Organization fields might have inconsistent casing.
            // Checking both 'Payment Status' and 'payment Status' just in case.
            String paymentStatus =
                (data['Payment Status'] ?? data['payment Status'] ?? "Pending")
                    .toString();
            bool isPaid =
                paymentStatus.toLowerCase() == "paid" ||
                paymentStatus.toLowerCase() == "completed";

            if (isPaid) {
              paidCount++;
            } else {
              unpaidCount++;
            }

            if (_selectedFilter == 'All') {
              filteredUsers.add(user);
            } else if (_selectedFilter == 'Paid' && isPaid) {
              filteredUsers.add(user);
            } else if (_selectedFilter == 'Unpaid' && !isPaid) {
              filteredUsers.add(user);
            }
          }

          return Column(
            children: [
              // Filter Section
              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildFilterChip("All", totalCount, Colors.orange),
                    _buildFilterChip("Paid", paidCount, Colors.green),
                    _buildFilterChip("Unpaid", unpaidCount, Colors.redAccent),
                  ],
                ),
              ),
              const Divider(height: 1),

              // List Section
              Expanded(
                child: filteredUsers.isEmpty
                    ? Center(
                        child: Text("No $_selectedFilter organizations found"),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: filteredUsers.length,
                        itemBuilder: (context, index) {
                          final data =
                              filteredUsers[index].data()
                                  as Map<String, dynamic>;
                          String paymentStatus =
                              (data['Payment Status'] ??
                                      data['payment Status'] ??
                                      "Pending")
                                  .toString();
                          bool isPaid =
                              paymentStatus.toLowerCase() == "paid" ||
                              paymentStatus.toLowerCase() == "completed";

                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(16),
                              onTap: () {
                                // Navigate to organization details page if needed
                              },
                              leading: CircleAvatar(
                                radius: 25,
                                backgroundColor: Colors.orange.withOpacity(0.1),
                                child: Text(
                                  (data['username'] ?? "?")[0].toUpperCase(),
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange,
                                  ),
                                ),
                              ),
                              title: Text(
                                data['Organization name'] ?? "N/A",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Owner: ${data['username'] ?? "N/A"}"),
                                  Text(
                                    data['Organization owner email'] ?? "N/A",
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    children: [
                                      const Text(
                                        "Payment Status: ",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: isPaid
                                              ? Colors.green.withOpacity(0.1)
                                              : Colors.red.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          border: Border.all(
                                            color: isPaid
                                                ? Colors.green
                                                : Colors.red,
                                          ),
                                        ),
                                        child: Text(
                                          paymentStatus,
                                          style: TextStyle(
                                            color: isPaid
                                                ? Colors.green
                                                : Colors.red,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFilterChip(String label, int count, Color color) {
    bool isSelected = _selectedFilter == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = label;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? color : color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color, width: 1.5),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withOpacity(0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Row(
          children: [
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : color,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white.withOpacity(0.3)
                    : color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                "$count",
                style: TextStyle(
                  color: isSelected ? Colors.white : color,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
