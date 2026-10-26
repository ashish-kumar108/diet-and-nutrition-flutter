import 'package:flutter/material.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
        backgroundColor: Colors.green,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          Text(
            'FAQs',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text('Q: How do I update my goals?\nA: Go to the home screen and tap on "Edit Goals".'),
          SizedBox(height: 20),
          Text('Q: How do I reset my data?\nA: Go to Profile > Logout to reset and re-enter data.'),
          SizedBox(height: 20),
          Text('Need more help? Reach out at: sanatanii.ashish@gmail.com'),
        ],
      ),
    );
  }
}
