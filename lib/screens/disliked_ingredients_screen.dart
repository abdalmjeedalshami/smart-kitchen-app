import 'package:flutter/material.dart';

import '../services/disliked_ingredient_service.dart';
import '../services/ingredient_service.dart';


class DislikedIngredientsScreen extends StatefulWidget {
  const DislikedIngredientsScreen({super.key});

  @override
  State<DislikedIngredientsScreen> createState() =>
      _DislikedIngredientsScreenState();
}

class _DislikedIngredientsScreenState extends State<DislikedIngredientsScreen> {
  List<Map<String, dynamic>> _dislikedIngredients = [];
  List<Map<String, dynamic>> _allIngredients = [];
  bool _loading = true;
  bool _showFamily = false;

  @override
  void initState() {
    super.initState();
    _fetchAll();
  }

  Future<void> _fetchAll() async {
    setState(() {
      _loading = true;
    });
    List<dynamic> disliked;
    if (_showFamily) {
      // ملاحظة: يجب جلب familyId من ملف العائلة أو البروفايل
      // هنا نفترض أن id=1 مؤقتاً، ويمكنك تعديله لاحقاً
      disliked = await DislikedIngredientService.getAllDislikedForFamily(1);
    } else {
      disliked = await DislikedIngredientService.getAllDislikedForMe();
    }
    final all = await IngredientService.getAllIngredients();
    setState(() {
      _dislikedIngredients = List<Map<String, dynamic>>.from(disliked);
      _allIngredients = List<Map<String, dynamic>>.from(all);
      _loading = false;
    });
  }

  Future<void> _addDislikedDialog() async {
    List<int> selectedIds = [];
    await showDialog(
      context: context,
      builder:
          (context) => StatefulBuilder(
            builder:
                (context, setStateDialog) => AlertDialog(
                  title: const Text('إضافة مكونات غير مرغوبة'),
                  content: SizedBox(
                    width: 300,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children:
                          _allIngredients.map((ing) {
                            final idRaw = ing['id'];
                            final int? id =
                                idRaw is int
                                    ? idRaw
                                    : int.tryParse(idRaw?.toString() ?? '');
                            final name = ing['name'] ?? '';
                            return CheckboxListTile(
                              value: selectedIds.contains(id),
                              title: Text(name),
                              onChanged: (val) {
                                setStateDialog(() {
                                  if (val == true) {
                                    selectedIds.add(id!);
                                  } else {
                                    selectedIds.remove(id);
                                  }
                                });
                              },
                            );
                          }).toList(),
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('إلغاء'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (selectedIds.isEmpty) return;
                        final result =
                            await DislikedIngredientService.addDisliked(
                              selectedIds,
                            );
                        Navigator.pop(context);
                        if (result['success']) {
                          await _fetchAll();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('تمت إضافة المكونات غير المرغوبة'),
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

  Future<void> _deleteDisliked(int id) async {
    final result = await DislikedIngredientService.deleteDisliked(id);
    if (result['success']) {
      await _fetchAll();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم حذف المكون غير المرغوب')),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(result['message'] ?? 'فشل الحذف')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('المكونات غير المرغوبة'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addDislikedDialog,
            tooltip: 'إضافة مكونات غير مرغوبة',
          ),
        ],
      ),
      body:
          _loading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: SwitchListTile(
                          title: const Text('عرض مكونات العائلة غير المرغوبة'),
                          value: _showFamily,
                          onChanged: (val) async {
                            setState(() {
                              _showFamily = val;
                            });
                            await _fetchAll();
                          },
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _dislikedIngredients.length,
                      itemBuilder: (context, index) {
                        final item = _dislikedIngredients[index];
                        return Card(
                          child: ListTile(
                            title: Text(item['ingredient_name'] ?? ''),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteDisliked(item['id']),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
    );
  }
}
