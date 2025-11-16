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
        title: Text(title),
      ),
      backgroundColor: colors.background,

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Text(
            detail,
            style: TextStyle(
              fontSize: 15,
              height: 1.45,
              color: colors.onBackground,
            ),
          ),
        ),
      ),
    );
  }
}
