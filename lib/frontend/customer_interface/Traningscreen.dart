// import 'package:flutter/material.dart';
// import 'package:mental_healthcare/frontend/customer_interface/homescreen.dart';
// import 'package:mental_healthcare/frontend/customer_interface/profilescreen.dart';
// import 'package:mental_healthcare/frontend/training_components/level_1.dart';
// import 'package:mental_healthcare/frontend/training_components/level_2.dart';
// import 'package:mental_healthcare/frontend/training_components/level_3.dart';
// import 'package:mental_healthcare/frontend/training_components/level_4.dart';
// import 'package:provider/provider.dart';
// import 'package:mental_healthcare/frontend/widgets/appcolors.dart';
// import 'package:mental_healthcare/frontend/widgets/widgets.dart';

// class TrainingScreen extends StatefulWidget {
//   const TrainingScreen({super.key});

//   @override
//   State<TrainingScreen> createState() => _TrainingScreenState();
// }

// class _TrainingScreenState extends State<TrainingScreen>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;

//   final List<Map<String, dynamic>> _trainingModules = [
//     {
//       'title': 'Mindfulness Techniques 🧘‍♀️',
//       'desc': 'Learn effective techniques to help clients reduce stress.',
//       'progress': 0.8,
//       'color': Colors.blueAccent,
//       'screen': Level1(),
//     },
//     {
//       'title': 'Cognitive Behavioral Therapy 💭',
//       'desc': 'Understand CBT fundamentals and practical applications.',
//       'progress': 0.45,
//       'color': Colors.purpleAccent,
//       'screen': Level2(),
//     },
//     {
//       'title': 'Emotional Intelligence 🧠',
//       'desc': 'Develop empathy and better emotional communication skills.',
//       'progress': 0.6,
//       'color': Colors.teal,
//       'screen': Level3(),
//     },
//     {
//       'title': 'Depression Management 🌧️',
//       'desc': 'Explore strategies to assist clients facing depression.',
//       'progress': 0.2,
//       'color': Colors.orangeAccent,
//       'screen': Level4(),
//     },
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 1),
//     )..forward();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   Widget _buildTrainingCard(Map<String, dynamic> module, int index) {
//     final provider = Provider.of<ProfileProvider>(context);
//     final bool ispremium = provider.isPremium;

//     final animation =
//         Tween<Offset>(
//           begin: Offset(0, 0.3 * (index + 1)),
//           end: Offset.zero,
//         ).animate(
//           CurvedAnimation(
//             parent: _controller,
//             curve: Interval(0, 1, curve: Curves.easeOut),
//           ),
//         );

//     return SlideTransition(
//       position: animation,
//       child: Container(
//         margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
//         padding: const EdgeInsets.all(18),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(20),
//           boxShadow: [
//             BoxShadow(
//               color: module['color'].withOpacity(0.25),
//               blurRadius: 10,
//               spreadRadius: 2,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               module['title'],
//               style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               module['desc'],
//               style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
//             ),
//             const SizedBox(height: 16),
//             ClipRRect(
//               borderRadius: BorderRadius.circular(10),
//               child: LinearProgressIndicator(
//                 value: module['progress'],
//                 color: module['color'],
//                 backgroundColor: module['color'].withOpacity(0.1),
//                 minHeight: 8,
//               ),
//             ),
//             const SizedBox(height: 10),
//             Align(
//               alignment: Alignment.bottomRight,
//               child: ElevatedButton.icon(
//                 onPressed: ispremium
//                     ? () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(builder: (_) => module['screen']),
//                         );
//                       }
//                     : provider.paymentLoading
//                     ? null
//                     : () => provider.makePayment(context),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: ispremium
//                       ? module['color']
//                       : (provider.paymentLoading
//                             ? Colors.grey
//                             : Colors.grey.shade600),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//                 icon: provider.paymentLoading
//                     ? SizedBox(
//                         width: 20,
//                         height: 20,
//                         child: CircularProgressIndicator(
//                           strokeWidth: 2,
//                           color: Colors.white,
//                         ),
//                       )
//                     : Icon(
//                         ispremium
//                             ? Icons.play_circle_fill
//                             : Icons.lock_outlined,
//                         color: Colors.white,
//                       ),
//                 label: provider.paymentLoading
//                     ? const Text(
//                         'Processing...',
//                         style: TextStyle(color: Colors.white),
//                       )
//                     : Text(
//                         ispremium ? 'Start Training' : 'Upgrade to Premium',
//                         style: const TextStyle(color: Colors.white),
//                       ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final provider = Provider.of<ProfileProvider>(context);
//     bool ispremium = provider.isPremium;

//     return WillPopScope(
//       onWillPop: () async {
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (_) => HomeScreen()),
//         );
//         return false;
//       },
//       child: Scaffold(
//         backgroundColor: const Color(0xfff8f9fb),
//         appBar: AppBar(
//           iconTheme: const IconThemeData(color: Colors.white),
//           leading: IconButton(
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (_) => HomeScreen()),
//               );
//             },
//             icon: const Icon(Icons.arrow_back_ios),
//           ),
//           elevation: 4,
//           title: const Text(
//             'Training',
//             style: TextStyle(
//               color: Colors.white,
//               fontWeight: FontWeight.bold,
//               fontSize: 20,
//             ),
//           ),
//           centerTitle: true,
//           flexibleSpace: Container(
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [AppColors.primary, AppColors.accent],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//             ),
//           ),
//         ),
//         body: Container(
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               colors: [Color(0xffe9f5ff), Color(0xfff8f9fb)],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: ListView(
//               physics: const BouncingScrollPhysics(),
//               children: [
//                 const Text(
//                   'Welcome Back 👋',
//                   style: TextStyle(
//                     fontSize: 26,
//                     fontWeight: FontWeight.bold,
//                     color: Color(0xff222B45),
//                   ),
//                 ),
//                 const SizedBox(height: 6),
//                 Text(
//                   'Continue your professional growth with engaging modules.',
//                   style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
//                 ),
//                 const SizedBox(height: 20),
//                 ..._trainingModules.asMap().entries.map(
//                   (entry) => _buildTrainingCard(entry.value, entry.key),
//                 ),
//               ],
//             ),
//           ),
//         ),
//         bottomNavigationBar: BottomNavBar(currentScreen: 'Training'),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:mental_healthcare/frontend/customer_interface/Traningscreen.dart'
    as controller;
import 'package:mental_healthcare/frontend/customer_interface/homescreen.dart';
import 'package:mental_healthcare/frontend/customer_interface/profilescreen.dart';
import 'package:mental_healthcare/frontend/training_components/level_1.dart';
import 'package:mental_healthcare/frontend/training_components/level_2.dart';
import 'package:mental_healthcare/frontend/training_components/level_3.dart';
import 'package:mental_healthcare/frontend/training_components/level_4.dart';
import 'package:provider/provider.dart';
import 'package:mental_healthcare/frontend/widgets/appcolors.dart';
import 'package:mental_healthcare/frontend/widgets/widgets.dart';

class TrainingScreen extends StatefulWidget {
  const TrainingScreen({super.key});

  @override
  State<TrainingScreen> createState() => _TrainingScreenState();
}

class _TrainingScreenState extends State<TrainingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  final List<Map<String, dynamic>> _trainingModules = [
    {
      'title': 'Mindfulness Techniques 🧘‍♀️',
      'desc': 'Learn effective techniques to help clients reduce stress.',
      'progress': 0.8,
      'color': Colors.blueAccent,
      'screen': Level1(),
    },
    {
      'title': 'Cognitive Behavioral Therapy 💭',
      'desc': 'Understand CBT fundamentals and practical applications.',
      'progress': 0.45,
      'color': Colors.purpleAccent,
      'screen': Level2(),
    },
    {
      'title': 'Emotional Intelligence 🧠',
      'desc': 'Develop empathy and emotional communication skills.',
      'progress': 0.6,
      'color': Colors.teal,
      'screen': Level3(),
    },
    {
      'title': 'Depression Management 🌧️',
      'desc': 'Explore strategies to assist clients facing depression.',
      'progress': 0.2,
      'color': Colors.orangeAccent,
      'screen': Level4(),
    },
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProfileProvider>(context, listen: false).loadProfile();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// REFRESH
  Future<void> _refreshScreen() async {
    await Future.delayed(const Duration(milliseconds: 800));
    setState(() {
      _controller.reset();
      _controller.forward();
    });
  }

  Widget _buildTrainingCard(Map<String, dynamic> module, int index) {
    final provider = Provider.of<ProfileProvider>(context);
    final bool ispremium = provider.isPremium;

    final animation = Tween<Offset>(
      begin: Offset(0, 0.3 * (index + 1)),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    return SlideTransition(
      position: animation,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: module['color'].withOpacity(0.25),
              blurRadius: 10,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              module['title'],
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(module['desc'], style: TextStyle(color: Colors.grey.shade700)),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: module['progress'],
                color: module['color'],
                backgroundColor: module['color'].withOpacity(0.1),
                minHeight: 8,
              ),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton.icon(
                onPressed: ispremium
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => module['screen']),
                        );
                      }
                    : provider.paymentLoading
                    ? null
                    : () => provider.makePayment(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: ispremium
                      ? module['color']
                      : provider.paymentLoading
                      ? Colors.grey
                      : Colors.grey.shade700,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: provider.paymentLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Icon(
                        ispremium ? Icons.play_circle_fill : Icons.lock_outline,
                        color: Colors.white,
                      ),
                label: provider.paymentLoading
                    ? const Text(
                        "Processing...",
                        style: TextStyle(color: Colors.white),
                      )
                    : Text(
                        ispremium ? "Start Training" : "Upgrade to Premium",
                        style: const TextStyle(color: Colors.white),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(
      builder: (context, provider, child) {
        bool ispremium = provider.isPremium;

        return WillPopScope(
          onWillPop: () async {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => HomeScreen()),
            );
            return false;
          },
          child: Scaffold(
            backgroundColor: const Color(0xfff8f9fb),
            appBar: AppBar(
              iconTheme: const IconThemeData(color: Colors.white),
              leading: IconButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => HomeScreen()),
                ),
                icon: const Icon(Icons.arrow_back_ios),
              ),
              elevation: 4,
              title: const Text(
                'Training',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              centerTitle: true,
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

            body: RefreshIndicator(
              onRefresh: _refreshScreen,
              color: AppColors.primary,
              child: ListView(
                padding: const EdgeInsets.all(16),
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  const Text(
                    'Welcome Back 👋',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff222B45),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Continue your professional growth with engaging modules.',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 20),

                  ..._trainingModules.asMap().entries.map(
                    (entry) => _buildTrainingCard(entry.value, entry.key),
                  ),
                ],
              ),
            ),

            bottomNavigationBar: BottomNavBar(currentScreen: 'Training'),
          ),
        );
      },
    );
  }
}
