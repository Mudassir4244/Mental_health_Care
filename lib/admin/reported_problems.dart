import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mental_healthcare/admin/admin_homescreen.dart';
import 'package:mental_healthcare/frontend/widgets/appcolors.dart';

class AdminSupportPanel extends StatefulWidget {
  const AdminSupportPanel({super.key});

  @override
  State<AdminSupportPanel> createState() => _AdminSupportPanelState();
}

class _AdminSupportPanelState extends State<AdminSupportPanel> {
  String _selectedFilter = 'All';
  String _selectedTypeFilter = 'All Types';
  String _searchQuery = '';

  final List<String> _statusFilters = [
    'All',
    'Open',
    'In Progress',
    'Resolved',
    'Closed',
  ];
  final List<String> _typeFilters = [
    'All Types',
    'Feedback',
    'Bug Report',
    'Feature Request',
    'Technical Issue',
    'Account Help',
    'Other',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AdminHomescreen()),
          ),
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
        ),
        title: const Text(
          "Support Tickets",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primary, AppColors.accent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () => setState(() {}),
          ),
        ],
      ),
      body: Column(
        children: [
          // Stats Summary Card
          _buildStatsCard(),

          // Filters Section
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Search Bar
                TextField(
                  onChanged: (value) => setState(() => _searchQuery = value),
                  decoration: InputDecoration(
                    hintText: "Search by name, email, or subject...",
                    prefixIcon: Icon(Icons.search, color: AppColors.primary),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Filter Chips
                Row(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: _statusFilters.map((status) {
                            final isSelected = _selectedFilter == status;
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: FilterChip(
                                label: Text(status),
                                selected: isSelected,
                                onSelected: (selected) {
                                  setState(() => _selectedFilter = status);
                                },
                                backgroundColor: Colors.grey.shade200,
                                selectedColor: AppColors.primary.withValues(
                                  alpha: 0.2,
                                ),
                                checkmarkColor: AppColors.primary,
                                labelStyle: TextStyle(
                                  color: isSelected
                                      ? AppColors.primary
                                      : Colors.black87,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Type Filter Dropdown
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedTypeFilter,
                      isExpanded: true,
                      icon: Icon(Icons.filter_list, color: AppColors.primary),
                      items: _typeFilters.map((type) {
                        return DropdownMenuItem(
                          value: type,
                          child: Text(
                            type,
                            style: const TextStyle(fontSize: 14),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() => _selectedTypeFilter = value!);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Tickets List
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _getFilteredStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.red,
                        ),
                        const SizedBox(height: 16),
                        Text('Error: ${snapshot.error}'),
                      ],
                    ),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inbox,
                          size: 80,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No tickets found',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                // Filter by search query
                List<QueryDocumentSnapshot> filteredDocs = snapshot.data!.docs;
                if (_searchQuery.isNotEmpty) {
                  filteredDocs = filteredDocs.where((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    final searchLower = _searchQuery.toLowerCase();
                    return (data['userName']?.toString().toLowerCase().contains(
                              searchLower,
                            ) ??
                            false) ||
                        (data['userEmail']?.toString().toLowerCase().contains(
                              searchLower,
                            ) ??
                            false) ||
                        (data['subject']?.toString().toLowerCase().contains(
                              searchLower,
                            ) ??
                            false);
                  }).toList();
                }

                if (filteredDocs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 80,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No results found',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredDocs.length,
                  itemBuilder: (context, index) {
                    final doc = filteredDocs[index];
                    final data = doc.data() as Map<String, dynamic>;
                    return _buildTicketCard(doc.id, data);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Stream<QuerySnapshot> _getFilteredStream() {
    Query query = FirebaseFirestore.instance
        .collection('support_tickets')
        .orderBy('timestamp', descending: true);

    // Filter by status
    if (_selectedFilter != 'All') {
      query = query.where('status', isEqualTo: _selectedFilter);
    }

    // Filter by type
    if (_selectedTypeFilter != 'All Types') {
      query = query.where('type', isEqualTo: _selectedTypeFilter);
    }

    return query.snapshots();
  }

  Widget _buildStatsCard() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('support_tickets')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox();
        }

        final docs = snapshot.data!.docs;
        final openCount = docs
            .where((d) => (d.data() as Map)['status'] == 'Open')
            .length;
        final inProgressCount = docs
            .where((d) => (d.data() as Map)['status'] == 'In Progress')
            .length;
        final resolvedCount = docs
            .where((d) => (d.data() as Map)['status'] == 'Resolved')
            .length;
        final closedCount = docs
            .where((d) => (d.data() as Map)['status'] == 'Closed')
            .length;

        return Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.analytics, color: AppColors.primary, size: 24),
                  const SizedBox(width: 8),
                  const Text(
                    "Tickets Overview",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildStatItem("Open", openCount, Colors.blue),
                  ),
                  Expanded(
                    child: _buildStatItem(
                      "In Progress",
                      inProgressCount,
                      Colors.orange,
                    ),
                  ),
                  Expanded(
                    child: _buildStatItem(
                      "Resolved",
                      resolvedCount,
                      Colors.green,
                    ),
                  ),
                  Expanded(
                    child: _buildStatItem("Closed", closedCount, Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatItem(String label, int count, Color color) {
    return Column(
      children: [
        Text(
          count.toString(),
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Colors.grey),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildTicketCard(String ticketId, Map<String, dynamic> data) {
    final status = data['status'] ?? 'Open';
    final type = data['type'] ?? 'Other';
    final priority = data['priority'] ?? 'Medium';
    final userName = data['userName'] ?? 'Unknown User';
    final userEmail = data['userEmail'] ?? 'No email';
    final subject = data['subject'] ?? 'No subject';
    final message = data['message'] ?? '';
    final timestamp = data['timestamp'] as Timestamp?;
    final date = timestamp?.toDate() ?? DateTime.now();

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: InkWell(
        onTap: () => _showTicketDetails(ticketId, data),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                children: [
                  // Priority Indicator
                  Container(
                    width: 4,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _getPriorityColor(priority),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // User Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.person,
                              size: 16,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                userName,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Icon(
                              Icons.email,
                              size: 12,
                              color: Colors.grey[500],
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                userEmail,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Status Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(status).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: _getStatusColor(status).withValues(alpha: 0.3),
                      ),
                    ),
                    child: Text(
                      status,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: _getStatusColor(status),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Subject
              Text(
                subject,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 8),

              // Message Preview
              Text(
                message,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[700],
                  height: 1.3,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 12),

              // Footer Row
              Row(
                children: [
                  // Type Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getTypeColor(type).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          _getTypeIcon(type),
                          size: 14,
                          color: _getTypeColor(type),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          type,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: _getTypeColor(type),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  // Date
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 14,
                        color: Colors.grey[500],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        DateFormat('MMM d, y').format(date),
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showTicketDetails(String ticketId, Map<String, dynamic> data) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return TicketDetailsSheet(
            ticketId: ticketId,
            data: data,
            scrollController: scrollController,
            onStatusChanged: () => setState(() {}),
          );
        },
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Open':
        return Colors.blue;
      case 'In Progress':
        return Colors.orange;
      case 'Resolved':
        return Colors.green;
      case 'Closed':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'Low':
        return Colors.green;
      case 'Medium':
        return Colors.orange;
      case 'High':
        return Colors.red;
      case 'Urgent':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'Feedback':
        return Colors.blue;
      case 'Bug Report':
        return Colors.red;
      case 'Feature Request':
        return Colors.purple;
      case 'Technical Issue':
        return Colors.orange;
      case 'Account Help':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'Feedback':
        return Icons.feedback;
      case 'Bug Report':
        return Icons.bug_report;
      case 'Feature Request':
        return Icons.lightbulb;
      case 'Technical Issue':
        return Icons.build;
      case 'Account Help':
        return Icons.person_outline;
      default:
        return Icons.help_outline;
    }
  }
}

// Ticket Details Sheet
class TicketDetailsSheet extends StatefulWidget {
  final String ticketId;
  final Map<String, dynamic> data;
  final ScrollController scrollController;
  final VoidCallback onStatusChanged;

  const TicketDetailsSheet({
    super.key,
    required this.ticketId,
    required this.data,
    required this.scrollController,
    required this.onStatusChanged,
  });

  @override
  State<TicketDetailsSheet> createState() => _TicketDetailsSheetState();
}

class _TicketDetailsSheetState extends State<TicketDetailsSheet> {
  late String _currentStatus;
  final TextEditingController _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _currentStatus = widget.data['status'] ?? 'Open';
  }

  Future<void> _updateStatus(String newStatus) async {
    try {
      await FirebaseFirestore.instance
          .collection('support_tickets')
          .doc(widget.ticketId)
          .update({
            'status': newStatus,
            'lastUpdated': FieldValue.serverTimestamp(),
          });

      setState(() => _currentStatus = newStatus);
      widget.onStatusChanged();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Status updated to $newStatus'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating status: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _addNote() async {
    if (_noteController.text.trim().isEmpty) return;

    try {
      await FirebaseFirestore.instance
          .collection('support_tickets')
          .doc(widget.ticketId)
          .collection('notes')
          .add({
            'note': _noteController.text.trim(),
            'timestamp': FieldValue.serverTimestamp(),
            'createdAt': DateTime.now(),
          });

      _noteController.clear();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Note added successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error adding note: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userName = widget.data['userName'] ?? 'Unknown User';
    final userEmail = widget.data['userEmail'] ?? 'No email';
    final type = widget.data['type'] ?? 'Other';
    final priority = widget.data['priority'] ?? 'Medium';
    final subject = widget.data['subject'] ?? 'No subject';
    final message = widget.data['message'] ?? '';
    final timestamp = widget.data['timestamp'] as Timestamp?;
    final date = timestamp?.toDate() ?? DateTime.now();

    return Container(
      padding: const EdgeInsets.all(24),
      child: ListView(
        controller: widget.scrollController,
        children: [
          // Handle Bar
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Header
          Row(
            children: [
              Expanded(
                child: Text(
                  subject,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // User Info Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.blue,
                      child: Text(
                        userName[0].toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            userEmail,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildInfoChip(
                      type,
                      _getTypeIcon(type),
                      _getTypeColor(type),
                    ),
                    _buildInfoChip(
                      priority,
                      Icons.flag,
                      _getPriorityColor(priority),
                    ),
                    _buildInfoChip(
                      DateFormat('MMM d, y h:mm a').format(date),
                      Icons.access_time,
                      Colors.grey,
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Status Section
          const Text(
            "Status",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: ['Open', 'In Progress', 'Resolved', 'Closed'].map((
              status,
            ) {
              final isSelected = _currentStatus == status;
              return FilterChip(
                label: Text(status),
                selected: isSelected,
                onSelected: (selected) {
                  if (selected) _updateStatus(status);
                },
                backgroundColor: Colors.grey.shade200,
                selectedColor: _getStatusColor(status).withValues(alpha: 0.2),
                checkmarkColor: _getStatusColor(status),
                labelStyle: TextStyle(
                  color: isSelected ? _getStatusColor(status) : Colors.black87,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 20),

          // Message Section
          const Text(
            "Message",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              message,
              style: const TextStyle(fontSize: 14, height: 1.5),
            ),
          ),

          const SizedBox(height: 20),

          // Admin Notes Section
          const Text(
            "Admin Notes",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          // Notes List
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('support_tickets')
                .doc(widget.ticketId)
                .collection('notes')
                .orderBy('timestamp', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'No notes yet',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                );
              }

              return Column(
                children: snapshot.data!.docs.map((doc) {
                  final noteData = doc.data() as Map<String, dynamic>;
                  final note = noteData['note'] ?? '';
                  final noteTimestamp = noteData['timestamp'] as Timestamp?;
                  final noteDate = noteTimestamp?.toDate() ?? DateTime.now();

                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.amber.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(note, style: const TextStyle(fontSize: 14)),
                        const SizedBox(height: 4),
                        Text(
                          DateFormat('MMM d, y h:mm a').format(noteDate),
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              );
            },
          ),

          const SizedBox(height: 12),

          // Add Note Field
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _noteController,
                  decoration: InputDecoration(
                    hintText: "Add a note...",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  maxLines: 2,
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filled(
                onPressed: _addNote,
                icon: const Icon(Icons.send),
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildInfoChip(String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Open':
        return Colors.blue;
      case 'In Progress':
        return Colors.orange;
      case 'Resolved':
        return Colors.green;
      case 'Closed':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'Low':
        return Colors.green;
      case 'Medium':
        return Colors.orange;
      case 'High':
        return Colors.red;
      case 'Urgent':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'Feedback':
        return Colors.blue;
      case 'Bug Report':
        return Colors.red;
      case 'Feature Request':
        return Colors.purple;
      case 'Technical Issue':
        return Colors.orange;
      case 'Account Help':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'Feedback':
        return Icons.feedback;
      case 'Bug Report':
        return Icons.bug_report;
      case 'Feature Request':
        return Icons.lightbulb;
      case 'Technical Issue':
        return Icons.build;
      case 'Account Help':
        return Icons.person_outline;
      default:
        return Icons.help_outline;
    }
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }
}
