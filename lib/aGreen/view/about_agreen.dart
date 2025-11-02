import 'package:flutter/material.dart';

class AboutAgreen extends StatefulWidget {
  const AboutAgreen({super.key});

  @override
  State<AboutAgreen> createState() => _AboutAgreenState();
}

class _AboutAgreenState extends State<AboutAgreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About aGreen'),
        backgroundColor: const Color(0xffCBF3BB),
      ),
      backgroundColor: Color(0xffCBF3BB),
      body: const Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Icon(
                Icons.eco,
                size: 80,
                color:  Color(0xff94BF9E),
              ),
            ),
             SizedBox(height: 16),
             Text(
              'aGreen is your plant care partner — helping you grow and care for your green friends with confidence and ease. 🌱',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, height: 1.5),
            ),
             SizedBox(height: 20),
             Divider(thickness: 1.2),
             SizedBox(height: 12),
             Text(
              '🌿 Key Features:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
             SizedBox(height: 8),
             Text(
              '• Get personalized care reminders'
              '• Track plant growth with a built-in journal\n'
              '• Receive simple and helpful plant tips',
              style: TextStyle(fontSize: 16, height: 1.6),
            ),
             Spacer(),
             Divider(thickness: 1.2),
             SizedBox(height: 8),
             Text(
              'Version: 1.0.0\n'
              'Developed by: and\n'
              'Contact: agreen.support@gmail.com',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
             SizedBox(height: 12),
          ],
        ),
      ),
      );
    

    
  }
}