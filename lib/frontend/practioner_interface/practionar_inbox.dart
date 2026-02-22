// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:mental_healthcare/frontend/practioner_interface/widgets/pract_custom_wdgets.dart';
// import 'package:mental_healthcare/frontend/widgets/appcolors.dart';

// class PractionarInbox extends StatefulWidget {
//   const PractionarInbox({super.key});

//   @override
//   State<PractionarInbox> createState() => _PractionarInboxState();
// }

// class _PractionarInboxState extends State<PractionarInbox>
//     with SingleTickerProviderStateMixin {
//   final List<Map<String, dynamic>> inboxMessages = [
//     {
//       'name': 'Sarah Khan',
//       'message': 'Thank you for today’s session. Feeling better already!',
//       'time': '2m ago',
//       'unread': true,
//     },
//     {
//       'name': 'Ali Raza',
//       'message': 'Can we reschedule our meeting to Monday?',
//       'time': '1h ago',
//       'unread': false,
//     },
//     {
//       'name': 'Emily Carter',
//       'message': 'I tried the breathing exercise, it really helps.',
//       'time': '3h ago',
//       'unread': true,
//     },
//     {
//       'name': 'Ahmed Hassan',
//       'message': 'Will you be available for a call tomorrow?',
//       'time': 'Yesterday',
//       'unread': false,
//     },
//     {
//       'name': 'Maria Johnson',
//       'message': 'Appreciate your guidance, thank you!',
//       'time': '2 days ago',
//       'unread': false,
//     },
//   ];

//   late AnimationController _controller;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 1),
//     );
//     _controller.forward();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   Widget _buildInboxItem(Map<String, dynamic> msg, int index) {
//     return AnimatedBuilder(
//       animation: _controller,
//       builder: (context, child) {
//         final slide = Tween<Offset>(
//           begin: Offset(0, 0.2 * (index + 1)),
//           end: Offset.zero,
//         ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

//         return SlideTransition(
//           position: slide,
//           child: Opacity(
//             opacity: _controller.value,
//             child: Container(
//               margin: const EdgeInsets.symmetric(vertical: 8),
//               decoration: BoxDecoration(
//                 color: msg['unread']
//                     ? Colors.white
//                     : Colors.grey.shade100, // highlight unread messages
//                 borderRadius: BorderRadius.circular(18),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black12,
//                     blurRadius: 6,
//                     offset: const Offset(0, 4),
//                   ),
//                 ],
//               ),
//               child: ListTile(
//                 contentPadding: const EdgeInsets.symmetric(
//                   horizontal: 16,
//                   vertical: 10,
//                 ),
//                 leading: CircleAvatar(
//                   radius: 26,
//                   backgroundColor: AppColors.primary.withOpacity(0.15),
//                   child: Text(
//                     msg['name'][0],
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 20,
//                       color: AppColors.primary,
//                     ),
//                   ),
//                 ),
//                 title: Text(
//                   msg['name'],
//                   style: TextStyle(
//                     fontWeight: msg['unread']
//                         ? FontWeight.bold
//                         : FontWeight.w500,
//                     fontSize: 17,
//                     color: const Color(0xff1E1E1E),
//                   ),
//                 ),
//                 subtitle: Text(
//                   msg['message'],
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                   style: TextStyle(
//                     color: msg['unread']
//                         ? Colors.black87
//                         : Colors.grey.shade700,
//                     fontSize: 14,
//                   ),
//                 ),
//                 trailing: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       msg['time'],
//                       style: TextStyle(
//                         fontSize: 12,
//                         color: Colors.grey.shade600,
//                       ),
//                     ),
//                     if (msg['unread'])
//                       Container(
//                         margin: const EdgeInsets.only(top: 6),
//                         width: 10,
//                         height: 10,
//                         decoration: BoxDecoration(
//                           color: AppColors.primary,
//                           shape: BoxShape.circle,
//                         ),
//                       ),
//                   ],
//                 ),
//                 onTap: () {
//                   Get.snackbar(
//                     'Inbox',
//                     "Opening chat with ${msg['name']}...",
//                     backgroundColor: Colors.white.withOpacity(0.7),
//                   );
//                 },
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xfff8f9fb),
//       appBar: AppBar(
//         iconTheme: IconThemeData(color: Colors.white),
//         leading: Builder(
//           builder: (context) => IconButton(
//             onPressed: () {
//               Scaffold.of(context).openDrawer();
//             },
//             icon: Icon(Icons.menu),
//           ),
//         ),
//         centerTitle: true,
//         title: const Text(
//           'Inbox',
//           style: TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//             fontSize: 22,
//           ),
//         ),
//         backgroundColor: AppColors.primary,
//         elevation: 4,
//         shadowColor: AppColors.primary.withOpacity(0.3),
//       ),
//       drawer: prac_drawer(),
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Color(0xffe9f5ff), Color(0xfff8f9fb)],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: ListView(
//             children: [
//               const Text(
//                 'Messages 💌',
//                 style: TextStyle(
//                   fontSize: 26,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xff222B45),
//                 ),
//               ),
//               const SizedBox(height: 10),
//               Text(
//                 'Stay connected with your clients and respond quickly.',
//                 style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
//               ),
//               const SizedBox(height: 20),
//               ...inboxMessages.asMap().entries.map(
//                 (entry) => _buildInboxItem(entry.value, entry.key),
//               ),
//             ],
//           ),
//         ),
//       ),
//       bottomNavigationBar: prac_bottomNavbbar(
//         currentScreen: 'Inbox',
//         clientData: {},
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:mental_healthcare/frontend/practioner_interface/widgets/pract_custom_wdgets.dart';

class PractionarInbox extends StatefulWidget {
  const PractionarInbox({super.key});

  @override
  State<PractionarInbox> createState() => _PractionarInboxState();
}

class _PractionarInboxState extends State<PractionarInbox> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: prac_bottomNavbbar(
        currentScreen: 'Inbox',
        clientData: {},
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 30, right: 20, left: 20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [],
          ),
        ),
      ),
    );
  }
}
