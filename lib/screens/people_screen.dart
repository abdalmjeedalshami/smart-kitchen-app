import 'package:flutter/material.dart';

import 'disease_screen.dart';
import 'package:meal_app_planner/services/family_profile_service.dart';

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
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchFamilyProfile();
  }

  Future<void> _fetchFamilyProfile() async {
    setState(() {
      _loading = true;
    });
    final result = await FamilyProfileService.showFamilyProfile();
    if (result['success']) {
      final data = result['data'];
      setState(() {
        _peopleCount = data['number_of_people'] ?? 1;
        _loading = false;
      });
    } else {
      setState(() {
        _loading = false;
      });
      // يمكن عرض رسالة خطأ إذا رغبت
    }
  }

  Future<void> _savePeopleCount() async {
    // جرب التحديث أولاً، إذا فشل جرب الإضافة
    var result = await FamilyProfileService.updateFamilyProfile(_peopleCount);
    if (!result['success']) {
      result = await FamilyProfileService.addFamilyProfile(_peopleCount);
    }
    if (!result['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'] ?? 'فشل حفظ عدد الأشخاص')),
      );
    }
  }

  void _goToDiseaseScreen() async {
    await _savePeopleCount();
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
      body:
          _loading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('How many people will be eating this meal?'),
                    const SizedBox(height: 20),
                    DropdownButton<int>(
                      value: _peopleCount,
                      onChanged: (value) async {
                        setState(() {
                          _peopleCount = value!;
                        });
                        await _savePeopleCount();
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
