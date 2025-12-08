import 'package:flutter/material.dart';
class TotalReportScreen extends StatefulWidget {
  const TotalReportScreen({super.key});

  @override
  State<TotalReportScreen> createState() => _TotalReportScreenState();
}

class _TotalReportScreenState extends State<TotalReportScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Total Reports')),
      body: Center(child: Text('Total Reports Screen')),
    );
  }
}