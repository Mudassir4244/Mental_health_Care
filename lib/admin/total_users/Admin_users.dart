import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// ----------------- Total Customers -----------------
class TotalCustomers extends StatelessWidget {
  const TotalCustomers({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Total Customers")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: StreamBuilder<QuerySnapshot>(
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

            final users = snapshot.data!.docs;

            if (users.isEmpty) {
              return const Center(child: Text("No customers found"));
            }

            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final data = users[index].data() as Map<String, dynamic>;
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: CircleAvatar(child: Icon(Icons.person)),
                    title: Text(data['username'] ?? "N/A"),
                    subtitle: Text(data['email'] ?? "N/A"),
                    trailing: Text(
                      data['payment Status'] ?? "unpaid",
                      style: TextStyle(
                        color: data['payment Status'] == "paid"
                            ? Colors.green
                            : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

// ----------------- Total Practitioners -----------------
class TotalPractitioners extends StatelessWidget {
  const TotalPractitioners({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Total Practitioners")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: StreamBuilder<QuerySnapshot>(
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

            final users = snapshot.data!.docs;

            if (users.isEmpty) {
              return const Center(child: Text("No practitioners found"));
            }

            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final data = users[index].data() as Map<String, dynamic>;
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: CircleAvatar(child: Text(data['name']?[0] ?? "?")),
                    title: Text(data['name'] ?? "N/A"),
                    subtitle: Text(data['email'] ?? "N/A"),
                    trailing: Text(
                      data['payment Status'] ?? "unpaid",
                      style: TextStyle(
                        color: data['payment Status'] == "paid"
                            ? Colors.green
                            : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

// ----------------- Total Organizations -----------------
class TotalOrganizations extends StatelessWidget {
  const TotalOrganizations({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Total Organization Owners")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: StreamBuilder<QuerySnapshot>(
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

            final users = snapshot.data!.docs;

            if (users.isEmpty) {
              return const Center(child: Text("No organization owners found"));
            }

            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final data = users[index].data() as Map<String, dynamic>;
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    onTap: () {
                      // Navigate to organization details page
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => organ_employees()),
                      );
                    },
                    leading: CircleAvatar(
                      child: Text(data['username']?[0] ?? "?"),
                    ),
                    title: Text(data['Organization name'] ?? "N/A"),
                    subtitle: Text(data['Organization owner email'] ?? "N/A"),
                    trailing: Text(
                      data['payment Status'] ?? "unpaid",
                      style: TextStyle(
                        color: data['Payment Status'] == "paid"
                            ? Colors.green
                            : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class organ_employees extends StatelessWidget {
  const organ_employees({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Organization Employees")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Users')
              .where('role', isEqualTo: "Organization Employee")
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            }

            final users = snapshot.data!.docs;

            if (users.isEmpty) {
              return const Center(child: Text("No organization owners found"));
            }

            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final data = users[index].data() as Map<String, dynamic>;
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    onTap: () {
                      // Navigate to organization details page
                    },
                    leading: CircleAvatar(child: Text(data['name']?[0] ?? "?")),
                    title: Text(data['username'] ?? "N/A"),
                    subtitle: Text(data['email'] ?? "N/A"),
                    trailing: Text(
                      data['payment Status'] ?? "unpaid",
                      style: TextStyle(
                        color: data['payment Status'] == "paid"
                            ? Colors.green
                            : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
