import 'package:flutter/material.dart';

import '../services/fridge_service.dart';
import '../services/ingredient_service.dart';

class FridgeScreen extends StatefulWidget {
  const FridgeScreen({super.key});

  @override
  State<FridgeScreen> createState() => _FridgeScreenState();
}

class _FridgeScreenState extends State<FridgeScreen> {
  bool _loading = true;
  List<Map<String, dynamic>> _allIngredients = [];

  @override
  void initState() {
    super.initState();
    _fetchAll();
  }

  Future<void> _fetchAll() async {
    setState(() {
      _loading = true;
    });
    final itemsRaw = await FridgeService.getAllFridgeItems();
    final ingredientsRaw = await IngredientService.getAllIngredients();
    List<Map<String, dynamic>> ingredients = [];
    bool noFamilyProfile = false;
    if (itemsRaw == null) {
      // لا يوجد ملف عائلة
      noFamilyProfile = true;
    } else {
      ingredients = List<Map<String, dynamic>>.from(
      ingredientsRaw.whereType<Map<String, dynamic>>(),
    );
    }
      setState(() {
      _allIngredients = ingredients;
      _loading = false;
      _noFamilyProfile = noFamilyProfile;
    });
  }

  bool _noFamilyProfile = false;

  Future<void> _addFridgeItemDialog() async {
    int? selectedIngredientId;
    final quantityController = TextEditingController();
    DateTime? expirationDate;
    await showDialog(
      context: context,
      builder:
          (context) => StatefulBuilder(
            builder:
                (context, setStateDialog) => AlertDialog(
                  title: const Text('إضافة مكون للثلاجة'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DropdownButtonFormField<int>(
                        value: selectedIngredientId,
                        items:
                            _allIngredients.map((ing) {
                              return DropdownMenuItem<int>(
                                value: ing['id'],
                                child: Text(ing['name'] ?? ''),
                              );
                            }).toList(),
                        onChanged:
                            (val) => setStateDialog(
                              () => selectedIngredientId = val,
                            ),
                        decoration: const InputDecoration(labelText: 'المكون'),
                      ),
                      TextField(
                        controller: quantityController,
                        decoration: const InputDecoration(labelText: 'الكمية'),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            expirationDate == null
                                ? 'تاريخ الانتهاء'
                                : expirationDate.toString().split(' ')[0],
                          ),
                          IconButton(
                            icon: const Icon(Icons.calendar_today),
                            onPressed: () async {
                              final picked = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime(2100),
                              );
                              if (picked != null) {
                                setStateDialog(() => expirationDate = picked);
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('إلغاء'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (selectedIngredientId == null ||
                            quantityController.text.isEmpty ||
                            expirationDate == null) {
                          return;
                        }
                        final result = await FridgeService.addItemsToFridge([
                          {
                            'ingredient_id': selectedIngredientId,
                            'quantity': quantityController.text.trim(),
                            'expiration_date':
                                expirationDate!.toIso8601String().split('T')[0],
                          },
                        ]);
                        Navigator.pop(context);
                        if (result['success']) {
                          await _fetchAll();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('تمت إضافة المكون للثلاجة'),
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



  Future<void> _showExpirationsDialog() async {
    final expired = await FridgeService.checkExpirationsForUser();
    await showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('المكونات المنتهية الصلاحية'),
            content: SizedBox(
              width: 300,
              child:
                  expired.isEmpty
                      ? const Text('لا يوجد مكونات منتهية الصلاحية')
                      : Column(
                        mainAxisSize: MainAxisSize.min,
                        children:
                            expired.map<Widget>((item) {
                              return ListTile(
                                title: Text(item['ingredient_name'] ?? ''),
                                subtitle: Text(
                                  'انتهت في: ${item['expiration_date'] ?? ''}',
                                ),
                              );
                            }).toList(),
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
        title: const Text('الثلاجة'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addFridgeItemDialog,
            tooltip: 'إضافة مكون للثلاجة',
          ),
          IconButton(
            icon: const Icon(Icons.warning, color: Colors.red),
            onPressed: _showExpirationsDialog,
            tooltip: 'عرض المنتهية الصلاحية',
          ),
        ],
      ),
      body:
          _loading
              ? const Center(child: CircularProgressIndicator())
              : _noFamilyProfile
              ? Center(
                child: Text(
                  'لا يوجد ملف عائلة مرتبط بالمستخدم. الرجاء إنشاء ملف عائلة أولاً من صفحة البروفايل.',
                  style: TextStyle(color: Colors.red, fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              )
              : ListView.builder(
                itemCount: _allIngredients.length,
                itemBuilder: (context, index) {
                  final ing = _allIngredients[index];
                  return Card(
                    child: ListTile(
                      leading:
                          ing['image_url'] != null
                              ? Image.network(
                                ing['image_url'].toString().startsWith('http')
                                    ? ing['image_url']
                                    : 'http://localhost:8000/' +
                                        ing['image_url'],
                                width: 40,
                                height: 40,
                                errorBuilder:
                                    (
                                      context,
                                      error,
                                      stackTrace,
                                    ) => Image.network(
                                      'http://localhost:8000/images/no-image.png',
                                      width: 40,
                                      height: 40,
                                    ),
                              )
                              : Image.network(
                                'http://localhost:8000/images/no-image.png',
                                width: 40,
                                height: 40,
                              ),
                      title: Text(ing['name'] ?? ''),
                      subtitle:
                          ing['aliases'] != null && ing['aliases'].isNotEmpty
                              ? Text(
                                'أسماء بديلة: ${ing['aliases'].join(", ")}',
                              )
                              : null,
                      trailing: IconButton(
                        icon: const Icon(Icons.add),
                        tooltip: 'إضافة للثلاجة',
                        onPressed: () async {
                          // فتح نافذة إضافة مع تعبئة المكون تلقائياً
                          int? selectedIngredientId = ing['id'];
                          final quantityController = TextEditingController();
                          DateTime? expirationDate;
                          await showDialog(
                            context: context,
                            builder:
                                (context) => StatefulBuilder(
                                  builder:
                                      (context, setStateDialog) => AlertDialog(
                                        title: Text(
                                          'إضافة ${ing['name']} للثلاجة',
                                        ),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            TextField(
                                              controller: quantityController,
                                              decoration: const InputDecoration(
                                                labelText: 'الكمية',
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Row(
                                              children: [
                                                Text(
                                                  expirationDate == null
                                                      ? 'تاريخ الانتهاء'
                                                      : expirationDate
                                                          .toString()
                                                          .split(' ')[0],
                                                ),
                                                IconButton(
                                                  icon: const Icon(
                                                    Icons.calendar_today,
                                                  ),
                                                  onPressed: () async {
                                                    final picked =
                                                        await showDatePicker(
                                                          context: context,
                                                          initialDate:
                                                              DateTime.now(),
                                                          firstDate:
                                                              DateTime.now(),
                                                          lastDate: DateTime(
                                                            2100,
                                                          ),
                                                        );
                                                    if (picked != null) {
                                                      setStateDialog(
                                                        () =>
                                                            expirationDate =
                                                                picked,
                                                      );
                                                    }
                                                  },
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed:
                                                () => Navigator.pop(context),
                                            child: const Text('إلغاء'),
                                          ),
                                          ElevatedButton(
                                            onPressed: () async {
                                              if (quantityController
                                                      .text
                                                      .isEmpty ||
                                                  expirationDate == null) {
                                                return;
                                              }
                                              final result =
                                                  await FridgeService.addItemsToFridge([
                                                    {
                                                      'ingredient_id':
                                                          selectedIngredientId,
                                                      'quantity':
                                                          quantityController
                                                              .text
                                                              .trim(),
                                                      'expiration_date':
                                                          expirationDate!
                                                              .toIso8601String()
                                                              .split('T')[0],
                                                    },
                                                  ]);
                                              Navigator.pop(context);
                                              if (result['success']) {
                                                await _fetchAll();
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  const SnackBar(
                                                    content: Text(
                                                      'تمت إضافة المكون للثلاجة',
                                                    ),
                                                  ),
                                                );
                                              } else {
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      result['message'] ??
                                                          'فشل الإضافة',
                                                    ),
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
                        },
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
