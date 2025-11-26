import 'package:flutter/material.dart';
import '../models/class_session.dart';

class ClassScreen extends StatelessWidget {
  final ClassSession classSession;

  const ClassScreen({super.key, required this.classSession});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(classSession.name),
      ),
      body: Center(
        child: Text('Class Screen - Coming Soon'),
      ),
    );
  }
}