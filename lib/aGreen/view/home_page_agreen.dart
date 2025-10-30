import 'package:flutter/material.dart';

class HomePageAgreen extends StatefulWidget {
  const HomePageAgreen({super.key});

  @override
  State<HomePageAgreen> createState() => _HomePageAgreenState();
}

class _HomePageAgreenState extends State<HomePageAgreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffCBF3BB),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(8.0),
         child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Hello,')
          ],
         ),
        ),),
    );
  }
}