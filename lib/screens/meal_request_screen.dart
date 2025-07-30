import 'package:flutter/material.dart';

import '../services/family_profile_service.dart';
import '../services/health_condition_service.dart';
import '../services/ingredient_service.dart';
import '../services/meal_request_service.dart';

class MealRequestScreen extends StatefulWidget {
  const MealRequestScreen({super.key});

  @override
  State<MealRequestScreen> createState() => _MealRequestScreenState();
}

class _MealRequestScreenState extends State<MealRequestScreen> {
  int? _familyProfileId;
  int _numberOfPeople = 1;
  String? _mealType;
  List<Map<String, dynamic>> _ingredients = [];
  List<Map<String, dynamic>> _healthConditions = [];
  final List<int> _selectedIngredientIds = [];
  final List<Map<String, dynamic>> _selectedHealthConditions = [];
  bool _loading = true;
  bool _useProfile = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() {
      _loading = true;
    });
    final family = await FamilyProfileService.showFamilyProfile();
    final ingredients = await IngredientService.getAllIngredients();
    final conditions = await HealthConditionService.getAllConditions();
    setState(() {
      _familyProfileId = family['data']?['id'];
      _numberOfPeople = family['data']?['number_of_people'] ?? 1;
      _ingredients = List<Map<String, dynamic>>.from(ingredients);
      _healthConditions = List<Map<String, dynamic>>.from(conditions);
      _useProfile = _familyProfileId != null;
      _loading = false;
    });
  }

  void _addHealthCondition() {
    _selectedHealthConditions.add({
      'health_condition_id': null,
      'affected_people_count': 1,
    });
    setState(() {});
  }

  void _removeHealthCondition(int index) {
    _selectedHealthConditions.removeAt(index);
    setState(() {});
  }

  Future<void> _submitRequest() async {
    if (_mealType == null || _selectedIngredientIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى تعبئة جميع الحقول المطلوبة')),
      );
      return;
    }
    final requestData = <String, dynamic>{
      'meal_type': _mealType,
      'ingredient_ids': _selectedIngredientIds,
    };
    if (_useProfile && _familyProfileId != null) {
      requestData['family_profile_id'] = _familyProfileId;
      requestData['number_of_people'] = _numberOfPeople;
      // الحالات الصحية من البروفايل (يمكنك تعديلها إذا كان هناك دالة لجلبها)
      requestData['health_conditions'] =
          _selectedHealthConditions
              .where((c) => c['health_condition_id'] != null)
              .toList();
    } else {
      requestData['number_of_people'] = _numberOfPeople;
      requestData['health_conditions'] =
          _selectedHealthConditions
              .where((c) => c['health_condition_id'] != null)
              .toList();
    }
    final result = await MealRequestService.addMealRequest(requestData);
    if (result['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم إرسال طلب الوجبة بنجاح')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'] ?? 'فشل إرسال الطلب')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('طلب وجبة')),
      body:
          _loading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_familyProfileId != null) ...[
                      Row(
                        children: [
                          const Text('استخدام بيانات البروفايل'),
                          Switch(
                            value: _useProfile,
                            onChanged: (val) {
                              setState(() {
                                _useProfile = val;
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                    DropdownButtonFormField<String>(
                      value: _mealType,
                      items: const [
                        DropdownMenuItem(
                          value: 'breakfast',
                          child: Text('فطور'),
                        ),
                        DropdownMenuItem(value: 'lunch', child: Text('غداء')),
                        DropdownMenuItem(value: 'dinner', child: Text('عشاء')),
                      ],
                      onChanged: (val) => setState(() => _mealType = val),
                      decoration: const InputDecoration(
                        labelText: 'نوع الوجبة',
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (_useProfile && _familyProfileId != null)
                      Text('عدد الأشخاص: $_numberOfPeople')
                    else ...[
                      Row(
                        children: [
                          const Text('عدد الأشخاص: '),
                          SizedBox(
                            width: 60,
                            child: TextFormField(
                              initialValue: _numberOfPeople.toString(),
                              keyboardType: TextInputType.number,
                              onChanged: (val) {
                                final parsed = int.tryParse(val);
                                if (parsed != null && parsed > 0) {
                                  setState(() {
                                    _numberOfPeople = parsed;
                                  });
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 16),
                    const Text('المكونات:'),
                    Wrap(
                      spacing: 8,
                      children:
                          _ingredients.map((ing) {
                            final idRaw = ing['id'];
                            final int? id =
                                idRaw is int
                                    ? idRaw
                                    : int.tryParse(idRaw?.toString() ?? '');
                            final name = ing['name'] ?? '';
                            final selected = _selectedIngredientIds.contains(
                              id,
                            );
                            return FilterChip(
                              label: Text(name),
                              selected: selected,
                              onSelected: (val) {
                                setState(() {
                                  if (val) {
                                    _selectedIngredientIds.add(id!);
                                  } else {
                                    _selectedIngredientIds.remove(id);
                                  }
                                });
                              },
                            );
                          }).toList(),
                    ),
                    const SizedBox(height: 16),
                    const Text('الحالات الصحية:'),
                    if (!_useProfile || _familyProfileId == null) ...[
                      ..._selectedHealthConditions.asMap().entries.map((entry) {
                        final index = entry.key;
                        final cond = entry.value;
                        return Row(
                          children: [
                            Expanded(
                              child: DropdownButtonFormField<int>(
                                value: cond['health_condition_id'],
                                items:
                                    _healthConditions.map((c) {
                                      return DropdownMenuItem<int>(
                                        value: c['id'],
                                        child: Text(c['name'] ?? ''),
                                      );
                                    }).toList(),
                                onChanged: (val) {
                                  setState(() {
                                    cond['health_condition_id'] = val;
                                  });
                                },
                                decoration: const InputDecoration(
                                  labelText: 'الحالة الصحية',
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            SizedBox(
                              width: 60,
                              child: TextFormField(
                                initialValue:
                                    cond['affected_people_count'].toString(),
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: 'عدد',
                                ),
                                onChanged: (val) {
                                  final parsed = int.tryParse(val);
                                  if (parsed != null && parsed > 0) {
                                    cond['affected_people_count'] = parsed;
                                  }
                                },
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _removeHealthCondition(index),
                            ),
                          ],
                        );
                      }),
                      TextButton.icon(
                        icon: const Icon(Icons.add),
                        label: const Text('إضافة حالة صحية'),
                        onPressed: _addHealthCondition,
                      ),
                    ],
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _submitRequest,
                        child: const Text('إرسال الطلب'),
                      ),
                    ),
                  ],
                ),
              ),
    );
  }
}
