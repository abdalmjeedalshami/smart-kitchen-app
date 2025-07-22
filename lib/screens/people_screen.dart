import 'package:flutter/material.dart';

import 'disease_screen.dart'; // استيراد شاشة الأمراض

class PeopleScreen extends StatefulWidget {
  final List<String> ingredients;

  const PeopleScreen({
    super.key,
    required this.ingredients,
    required Map<String, int> ingredientsWithQuantity,
  });

  @override
  State<PeopleScreen> createState() => _PeopleScreenState();
}

class _PeopleScreenState extends State<PeopleScreen> {
  int _peopleCount = 1;

  void _goToDiseaseScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => DiseaseScreen(
              ingredients: widget.ingredients,
              peopleCount: _peopleCount,
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 250, 240),
      appBar: AppBar(title: const Text('Number of people')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('How many people will be eating this meal?'),
            const SizedBox(height: 20),
            DropdownButton<int>(
              value: _peopleCount,
              onChanged: (value) {
                setState(() {
                  _peopleCount = value!;
                });
              },
              items:
                  List.generate(10, (index) => index + 1)
                      .map(
                        (e) => DropdownMenuItem(
                          value: e,
                          child: Text('$e person'),
                        ),
                      )
                      .toList(),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _goToDiseaseScreen,
              child: const Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}
