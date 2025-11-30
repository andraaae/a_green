import 'package:flutter/material.dart';

class PlantTipDetail extends StatelessWidget {
  final String title;
  final String detail;

  const PlantTipDetail({super.key, required this.title, required this.detail});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: isDark
            ? const Color(0xFF1E1E1E)   // background dark mode
            : const Color(0xFFCBF3BB), // background light mode
        elevation: 0,

        // back button color
        iconTheme: IconThemeData(
          color: isDark ? Colors.white : Colors.black87,
        ),

        // title text color
        title: Text(
          title,
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Text(
            detail,
            style: TextStyle(
              fontSize: 18,
              height: 1.45,
              color: isDark ? Colors.white70 : Colors.black87,
            ),
          ),
        ),
      ),
    );
  }
}
