import 'package:flutter/material.dart';
class Level3 extends StatefulWidget {
  const Level3({super.key});

  @override
  State<Level3> createState() => _Level3State();
}

class _Level3State extends State<Level3> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text('Level 3 Training')), body: Center(child: Text('Level 3 Training Content')));
  }
}