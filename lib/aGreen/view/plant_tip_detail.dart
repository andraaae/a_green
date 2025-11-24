import 'package:flutter/material.dart';

class PlantTipDetail extends StatelessWidget {
  final String title;
  final String detail;

  const PlantTipDetail({super.key, required this.title, required this.detail});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor:
            theme.appBarTheme.backgroundColor ?? theme.primaryColor,
        iconTheme:
            theme.appBarTheme.iconTheme ??
            IconThemeData(color: colors.onPrimary),
        title: Text(
          title,
          style:
              theme.appBarTheme.titleTextStyle ??
              TextStyle(
                color: colors.onPrimary,
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
              color: colors.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}
