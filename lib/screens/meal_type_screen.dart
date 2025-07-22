import 'package:flutter/material.dart';

import 'suggested_meals_screen.dart';

class MealTypeScreen extends StatefulWidget {
  final List<String> ingredients;
  final int peopleCount;
  final List<String> diseases;

  const MealTypeScreen({
    super.key,
    required this.ingredients,
    required this.peopleCount,
    required this.diseases,
    required List selectedIngredients,
  });

  @override
  State<MealTypeScreen> createState() => _MealTypeScreenState();
}

class _MealTypeScreenState extends State<MealTypeScreen> {
  final List<String> mealTypes = ['breakfast', 'lunch', 'dinner'];
  final Set<String> selectedMealTypes = {};

  void _toggleMealType(String mealType) {
    setState(() {
      if (selectedMealTypes.contains(mealType)) {
        selectedMealTypes.remove(mealType);
      } else {
        selectedMealTypes.add(mealType);
      }
    });
  }

  void _goToSuggestedMeals() {
    if (selectedMealTypes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one meal type')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => SuggestedMealsScreen(
              ingredients: widget.ingredients,
              peopleCount: widget.peopleCount,
              diseases: widget.diseases,
              mealTypes: selectedMealTypes.toList(),
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 250, 240),
      appBar: AppBar(title: const Text('Choose the type of meal')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Choose the type of meal (you can choose more than one type)',
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children:
                    mealTypes.map((type) {
                      final isSelected = selectedMealTypes.contains(type);
                      return CheckboxListTile(
                        title: Text(type),
                        value: isSelected,
                        onChanged: (value) => _toggleMealType(type),
                      );
                    }).toList(),
              ),
            ),
            ElevatedButton(
              onPressed: _goToSuggestedMeals,
              child: const Text('View suggested meals'),
            ),
          ],
        ),
      ),
    );
  }
}
