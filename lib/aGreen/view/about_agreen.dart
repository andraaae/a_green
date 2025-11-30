import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:a_green/theme/theme_provider.dart';

class AboutAgreen extends StatelessWidget {
  const AboutAgreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    final lightMint = const Color(0xFFCBF3BB);
    final bgColor = isDark ? const Color(0xFF1E1E1E) : lightMint;
    final cardColor = isDark ? const Color(0xFF2B2B2B) : lightMint;
    final textColor = isDark ? Colors.white : Colors.black87;
    final subTextColor = isDark ? Colors.grey[400] : Colors.grey[700];
    final accentColor = isDark
        ? const Color(0xffA0C878)
        : const Color(0xff94BF9E);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: cardColor,
        elevation: 0,
        title: Text(
          'About aGreen',
          style: TextStyle(color: textColor, fontWeight: FontWeight.w600),
        ),
        iconTheme: IconThemeData(color: textColor),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        children: [
          Center(child: Icon(Icons.eco, size: 80, color: accentColor)),
          const SizedBox(height: 20),
          Text(
            'aGreen is your gentle companion for nurturing plants and mindfulness. '
            'We believe that caring for your plants is also a way to care for yourself — '
            'one leaf, one day at a time. 🌱\n\n'
            'With aGreen, you can track growth, stay organized, and build small, meaningful habits '
            'that help your green friends thrive effortlessly.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, height: 1.5, color: textColor),
          ),
          const SizedBox(height: 24),
          Divider(thickness: 1, color: accentColor.withOpacity(0.4)),
          const SizedBox(height: 16),
          Text(
            '🌿 Key Features:',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '• Get personalized care reminders and track plant growth in one place\n'
            '• Stay mindful with journaling for your green companions\n'
            '• Receive simple and helpful plant care tips to keep your plants thriving',
            style: TextStyle(fontSize: 16, height: 1.6, color: subTextColor),
          ),
          const SizedBox(height: 24),
          Divider(thickness: 1, color: accentColor.withOpacity(0.4)),
          const SizedBox(height: 8),
          Text(
            'Version: 1.0.0\n'
            'Developed by: andra\n'
            'Contact: agreen.support@gmail.com',
            style: TextStyle(fontSize: 14, color: subTextColor),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
