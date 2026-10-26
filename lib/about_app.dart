import 'package:flutter/material.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About App'),
        backgroundColor: Colors.green,
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          'This Diet & Nutrition Tracker app helps users track their daily calorie, protein, and water intake. '
              'Designed to promote healthier living, the app offers personalized goals and analytics. '
              'Developed with ❤️ by Ashish.',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
