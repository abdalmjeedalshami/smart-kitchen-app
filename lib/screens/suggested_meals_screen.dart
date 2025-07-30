import 'package:flutter/material.dart';

import 'meal_details_screen.dart';

class SuggestedMealsScreen extends StatelessWidget {
  final List<String> ingredients;
  final int peopleCount;
  final List<String> diseases;
  final List<String> mealTypes;

  const SuggestedMealsScreen({
    super.key,
    required this.ingredients,
    required this.peopleCount,
    required this.diseases,
    required this.mealTypes,
  });

  // قائمة الوجبات المقترحة بدون روابط صور
  List<Map<String, dynamic>> getSuggestedMeals() {
    return [
      {'name': 'Breakfast', 'icon': Icons.free_breakfast},
      {'name': 'Lunch', 'icon': Icons.lunch_dining},
      {'name': 'Dinner', 'icon': Icons.dinner_dining},
    ];
  }

  @override
  Widget build(BuildContext context) {
    final meals = getSuggestedMeals();

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 250, 240),
      appBar: AppBar(title: const Text('Suggested meals')),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(
          vertical: 24,
        ), 
        itemCount: meals.length,
        separatorBuilder:
            (context, index) =>
                const SizedBox(height: 24), 
        itemBuilder: (context, index) {
          final meal = meals[index];
          return Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              leading: Icon(meal['icon'], size: 40, color: Colors.deepOrange),
              title: Text(
                meal['name'],
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => MealDetailsScreen(
                          mealName: meal['name'],
                          imageUrl: '',
                        ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
