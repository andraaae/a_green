import 'package:flutter/material.dart';
class PlantTipDetail extends StatelessWidget {
  final String title;
  final String detail;

  const PlantTipDetail({
    super.key,
    required this.title,
    required this.detail,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffCBF3BB),
        title:
         Text(title),
      ), 
      backgroundColor: Colors.white,

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Text(
            detail,
            style: TextStyle(
              fontSize: 18,
              height: 1.45,
              color: colors.onBackground,
            ),
          ),
        ),
      ),
    );
  }
}
