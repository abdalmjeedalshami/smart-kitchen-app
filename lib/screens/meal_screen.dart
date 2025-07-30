import 'package:flutter/material.dart';
import 'package:meal_app_planner/services/meal_service.dart';
import 'package:meal_app_planner/services/ingredient_service.dart';

class MealScreen extends StatefulWidget {
  const MealScreen({super.key});

  @override
  State<MealScreen> createState() => _MealScreenState();
}

class _MealScreenState extends State<MealScreen> {
  List<Map<String, dynamic>> _meals = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchMeals();
  }

  Future<void> _fetchMeals() async {
    setState(() {
      _loading = true;
    });
    final meals = await MealService.getAllMeals();
    setState(() {
      _meals = List<Map<String, dynamic>>.from(meals);
      _loading = false;
    });
  }

  Future<void> _deleteMeal(int id) async {
    final result = await MealService.deleteMeal(id);
    if (result['success']) {
      await _fetchMeals();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('تم حذف الوجبة')));
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(result['message'] ?? 'فشل الحذف')));
    }
  }

  Future<void> _addMealDialog() async {
    final nameController = TextEditingController();
    final typeController = TextEditingController();
    final caloriesController = TextEditingController();
    final imageController = TextEditingController();
    final instructionsController = TextEditingController();
    final allIngredientsRaw = await IngredientService.getAllIngredients();
    List<Map<String, dynamic>> allIngredients = List<Map<String, dynamic>>.from(
      allIngredientsRaw,
    );
    List<int> selectedIngredientIds = [];
    Map<int, String> ingredientQuantities = {};
    await showDialog(
      context: context,
      builder:
          (context) => StatefulBuilder(
            builder:
                (context, setStateDialog) => AlertDialog(
                  title: const Text('إضافة وجبة جديدة'),
                  content: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: nameController,
                          decoration: const InputDecoration(
                            labelText: 'اسم الوجبة',
                          ),
                        ),
                        TextField(
                          controller: typeController,
                          decoration: const InputDecoration(
                            labelText: 'نوع الوجبة',
                          ),
                        ),
                        TextField(
                          controller: caloriesController,
                          decoration: const InputDecoration(
                            labelText: 'السعرات',
                          ),
                          keyboardType: TextInputType.number,
                        ),
                        TextField(
                          controller: imageController,
                          decoration: const InputDecoration(
                            labelText: 'رابط الصورة',
                          ),
                        ),
                        TextField(
                          controller: instructionsController,
                          decoration: const InputDecoration(
                            labelText: 'طريقة التحضير',
                          ),
                          maxLines: 2,
                        ),
                        const SizedBox(height: 8),
                        const Text('المكونات المطلوبة:'),
                        SizedBox(
                          height: 120,
                          child: ListView(
                            children:
                                allIngredients.map((ing) {
                                  final idRaw = ing['id'];
                                  final int? id =
                                      idRaw is int
                                          ? idRaw
                                          : int.tryParse(
                                            idRaw?.toString() ?? '',
                                          );
                                  final name = ing['name'] ?? '';
                                  final selected = selectedIngredientIds
                                      .contains(id);
                                  return CheckboxListTile(
                                    value: selected,
                                    title: Row(
                                      children: [
                                        Text(name),
                                        if (selected)
                                          SizedBox(
                                            width: 60,
                                            child: TextField(
                                              decoration: const InputDecoration(
                                                labelText: 'كمية',
                                              ),
                                              keyboardType:
                                                  TextInputType.number,
                                              onChanged: (val) {
                                                ingredientQuantities[id!] = val;
                                              },
                                            ),
                                          ),
                                      ],
                                    ),
                                    onChanged: (val) {
                                      setStateDialog(() {
                                        if (val == true) {
                                          selectedIngredientIds.add(id!);
                                        } else {
                                          selectedIngredientIds.remove(id);
                                          ingredientQuantities.remove(id);
                                        }
                                      });
                                    },
                                  );
                                }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('إلغاء'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (nameController.text.isEmpty ||
                            typeController.text.isEmpty ||
                            selectedIngredientIds.isEmpty)
                          return;
                        final mealData = {
                          'name': nameController.text.trim(),
                          'meal_type': typeController.text.trim(),
                          'calories': caloriesController.text.trim(),
                          'image_meal': imageController.text.trim(),
                          'instructions': instructionsController.text.trim(),
                          'ingredients':
                              selectedIngredientIds
                                  .map(
                                    (id) => {
                                      'id': id,
                                      'quantity':
                                          double.tryParse(
                                            ingredientQuantities[id] ?? '1',
                                          ) ??
                                          1,
                                    },
                                  )
                                  .toList(),
                        };
                        final result = await MealService.addMeal(mealData);
                        Navigator.pop(context);
                        if (result['success']) {
                          await _fetchMeals();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('تمت إضافة الوجبة بنجاح'),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(result['message'] ?? 'فشل الإضافة'),
                            ),
                          );
                        }
                      },
                      child: const Text('إضافة'),
                    ),
                  ],
                ),
          ),
    );
  }

  void _showMealDetails(Map<String, dynamic> meal) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(meal['name'] ?? ''),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (meal['image_meal'] != null)
                    Image.network(
                      meal['image_meal'],
                      height: 120,
                      fit: BoxFit.cover,
                    ),
                  const SizedBox(height: 8),
                  Text('النوع: ${meal['meal_type'] ?? ''}'),
                  Text('السعرات: ${meal['calories'] ?? ''}'),
                  const SizedBox(height: 8),
                  Text('المكونات:'),
                  if (meal['ingredients'] != null)
                    ...List.generate(meal['ingredients'].length, (i) {
                      final ing = meal['ingredients'][i];
                      return Text(
                        '- ${ing['name'] ?? ''} (${ing['quantity'] ?? ''})',
                      );
                    }),
                  const SizedBox(height: 8),
                  Text('طريقة التحضير:'),
                  Text(meal['instructions'] ?? ''),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('إغلاق'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الوجبات'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addMealDialog,
            tooltip: 'إضافة وجبة جديدة',
          ),
        ],
      ),
      body:
          _loading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                itemCount: _meals.length,
                itemBuilder: (context, index) {
                  final meal = _meals[index];
                  return Card(
                    child: ListTile(
                      title: Text(meal['name'] ?? ''),
                      subtitle: Text(meal['meal_type'] ?? ''),
                      onTap: () => _showMealDetails(meal),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteMeal(meal['id']),
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
