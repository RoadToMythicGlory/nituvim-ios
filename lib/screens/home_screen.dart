import 'package:flutter/material.dart';

import '../utils/constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(HebrewStrings.appTitle),
        centerTitle: true,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.rocket_launch,
              size: 64,
              color: AppColors.primary,
            ),
            SizedBox(height: 16),
            Text(
              'ניתובים AI',
              style: AppTextStyles.h1,
            ),
            SizedBox(height: 8),
            Text(
              'מעבד אקסל מתקדם לניתובים',
              style: AppTextStyles.bodyLarge,
            ),
            SizedBox(height: 32),
            Text(
              'האפליקציה מוכנה לפיתוח!',
              style: AppTextStyles.h3,
            ),
          ],
        ),
      ),
    );
  }
} 