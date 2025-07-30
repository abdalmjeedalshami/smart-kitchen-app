import 'package:flutter/material.dart';

import '../services/health_condition_service.dart';
import 'meal_type_screen.dart';

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
  List<Map<String, dynamic>> _diseases = [];
  late List<int?> _selectedDiseaseIds;
  bool _loading = true;
  List<Map<String, dynamic>> _profileDiseases = [];

  @override
  void initState() {
    super.initState();
    _fetchDiseases();
    _fetchProfileDiseases();
  }

  Future<void> _fetchDiseases() async {
    setState(() {
      _loading = true;
    });
    final diseases = await HealthConditionService.getAllConditions();
    setState(() {
      _diseases = List<Map<String, dynamic>>.from(diseases);
      _selectedDiseaseIds = List<int?>.filled(widget.peopleCount, null);
      _loading = false;
    });
  }

  Future<void> _fetchProfileDiseases() async {
    final diseases = await HealthConditionService.getFamilyConditions();
    setState(() {
      _profileDiseases = List<Map<String, dynamic>>.from(diseases);
    });
  }

  Future<void> _detachDisease(int id) async {
    final result = await HealthConditionService.detachConditions([id]);
    if (result['success']) {
      await _fetchProfileDiseases();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم حذف المرض من البروفايل')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'] ?? 'فشل حذف المرض')),
      );
    }
  }

  Future<void> _addDiseaseDialog() async {
    final controller = TextEditingController();
    await showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('إضافة مرض جديد'),
            content: TextField(
              controller: controller,
              decoration: const InputDecoration(labelText: 'اسم المرض'),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('إلغاء'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final name = controller.text.trim();
                  if (name.isEmpty) return;
                  final result = await HealthConditionService.addCondition(
                    name,
                  );
                  Navigator.pop(context);
                  if (result['success']) {
                    await _fetchDiseases();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('تمت إضافة المرض بنجاح')),
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
    );
  }

  Future<void> _attachSelectedDiseases() async {
    final selectedIds = _selectedDiseaseIds.whereType<int>().toSet().toList();
    if (selectedIds.isEmpty) return;
    final result = await HealthConditionService.attachConditions(selectedIds);
    if (!result['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'] ?? 'فشل ربط الأمراض')),
      );
    }
  }

  void _goToMealTypeScreen() async {
    await _attachSelectedDiseases();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => MealTypeScreen(
              ingredients: widget.ingredients,
              peopleCount: widget.peopleCount,
              diseases:
                  _selectedDiseaseIds
                      .map((id) => id?.toString() ?? '')
                      .toList(),
              selectedIngredients: [],
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 250, 240),
      appBar: AppBar(
        title: const Text('The health status of each person'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addDiseaseDialog,
            tooltip: 'إضافة مرض جديد',
          ),
        ],
      ),
      body:
          _loading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text('Choose the disease for each person'),
                    const SizedBox(height: 20),
                    if (_profileDiseases.isNotEmpty) ...[
                      const Text(
                        'الأمراض المرتبطة بالبروفايل:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children:
                            _profileDiseases
                                .map(
                                  (d) => Chip(
                                    label: Text(d['name'] ?? ''),
                                    deleteIcon: const Icon(Icons.close),
                                    onDeleted: () => _detachDisease(d['id']),
                                    backgroundColor: Colors.orange.withOpacity(
                                      0.3,
                                    ),
                                  ),
                                )
                                .toList(),
                      ),
                      const SizedBox(height: 20),
                    ],
                    Expanded(
                      child: ListView.builder(
                        itemCount: widget.peopleCount,
                        itemBuilder: (context, index) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('The person  ${index + 1}'),
                              DropdownButton<int?>(
                                value: _selectedDiseaseIds[index],
                                onChanged: (value) {
                                  setState(() {
                                    _selectedDiseaseIds[index] = value;
                                  });
                                },
                                items:
                                    _diseases
                                        .map(
                                          (d) => DropdownMenuItem(
                                            value:
                                                (() {
                                                  final idRaw = d['id'];
                                                  return idRaw is int
                                                      ? idRaw
                                                      : int.tryParse(
                                                        idRaw?.toString() ?? '',
                                                      );
                                                })(),
                                            child: Text(d['name'] ?? ''),
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
