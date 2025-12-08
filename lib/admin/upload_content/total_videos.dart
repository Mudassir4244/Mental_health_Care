import 'package:flutter/material.dart';

class TotalVideos extends StatefulWidget {
  const TotalVideos({super.key});

  @override
  State<TotalVideos> createState() => _TotalVideosState();
}

class _TotalVideosState extends State<TotalVideos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Total Videos')),
      body: Center(child: Text('Total Videos Screen')),
    );
  }
}
