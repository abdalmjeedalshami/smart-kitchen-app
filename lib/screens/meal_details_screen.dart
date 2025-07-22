import 'package:flutter/material.dart';

class MealDetailsScreen extends StatelessWidget {
  final String mealName;
  final String imageUrl;

  const MealDetailsScreen({
    super.key,
    required this.mealName,
    required this.imageUrl,
  });

  void _confirmMeal(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Meal preparation and storage confirmed')),
    );
    Navigator.popUntil(
      context,
      (route) => route.isFirst,
    ); // العودة إلى الصفحة الرئيسية
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 250, 240),
      appBar: AppBar(title: Text(mealName)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Image.network(imageUrl, height: 200),
            const SizedBox(height: 20),
            const Text(
              'Preparation method',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              '1. Wash the ingredients.\n2. Cook it on low heat.\n3. Serve hot',
              style: TextStyle(fontSize: 16),
            ),
            const Spacer(),
            ElevatedButton.icon(
              icon: const Icon(Icons.check),
              label: const Text('The meal has been prepared'),
              onPressed: () => _confirmMeal(context),
            ),
          ],
        ),
      ),
    );
  }
}
