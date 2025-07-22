import 'package:flutter/material.dart';

import 'meal_type_screen.dart'; // شاشة نوع الوجبة

class DiseaseScreen extends StatefulWidget {
  final List<String> ingredients;
  final int peopleCount;

  const DiseaseScreen({
    super.key,
    required this.ingredients,
    required this.peopleCount,
  });

  @override
  State<DiseaseScreen> createState() => _DiseaseScreenState();
}

class _DiseaseScreenState extends State<DiseaseScreen> {
  final List<String> diseases = ['nothing', 'drunken', 'pressure', 'sensitive'];
  late List<String> selectedDiseases;

  @override
  void initState() {
    super.initState();
    selectedDiseases = List.filled(widget.peopleCount, 'nothing');
  }

  void _goToMealTypeScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => MealTypeScreen(
              ingredients: widget.ingredients,
              peopleCount: widget.peopleCount,
              diseases: selectedDiseases,
              selectedIngredients: [],
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 250, 240),
      appBar: AppBar(title: const Text('The health status of each person')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('Choose the disease for each person'),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: widget.peopleCount,
                itemBuilder: (context, index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('The person ${index + 1}'),
                      DropdownButton<String>(
                        value: selectedDiseases[index],
                        onChanged: (value) {
                          setState(() {
                            selectedDiseases[index] = value!;
                          });
                        },
                        items:
                            diseases
                                .map(
                                  (d) => DropdownMenuItem(
                                    value: d,
                                    child: Text(d),
                                  ),
                                )
                                .toList(),
                      ),
                      const Divider(),
                    ],
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: _goToMealTypeScreen,
              child: const Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}
