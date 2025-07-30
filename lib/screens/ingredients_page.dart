import 'package:flutter/material.dart';
import '../services/ingredient_service.dart';
import 'people_screen.dart';

class IngredientsScreen extends StatefulWidget {
  const IngredientsScreen({super.key});

  @override
  State<IngredientsScreen> createState() => _IngredientsScreenState();
}

class _IngredientsScreenState extends State<IngredientsScreen> {
  final TextEditingController _controller = TextEditingController();
  final Map<String, int> _selectedIngredients = {};
  List<Map<String, dynamic>> _availableIngredients = [];
  bool _loading = true;
  bool _showPreferredOnly = false;

  @override
  void initState() {
    super.initState();
    _fetchIngredients();
  }

  Future<void> _fetchIngredients([String? search]) async {
    setState(() {
      _loading = true;
    });
    List<dynamic> data;
    if (_showPreferredOnly) {
      data = await IngredientService.getPreferredIngredients();
    } else if (search != null && search.isNotEmpty) {
      data = await IngredientService.searchIngredients(search);
    } else {
      data = await IngredientService.getAllIngredients();
    }
    List<Map<String, dynamic>> ingredients = [];
    ingredients = List<Map<String, dynamic>>.from(
      data.whereType<Map<String, dynamic>>(),
    );
    // تأكد أن id دائماً int
    ingredients =
        ingredients.map((ingredient) {
          final idRaw = ingredient['id'];
          ingredient['id'] =
              idRaw is int ? idRaw : int.tryParse(idRaw?.toString() ?? '');
          return ingredient;
        }).toList();
      setState(() {
      _availableIngredients = ingredients;
      _loading = false;
    });
  }

  Future<void> _fetchPreferredIngredients() async {
    setState(() {
      _loading = true;
    });
    final data = await IngredientService.getPreferredIngredients();
    List<Map<String, dynamic>> ingredients = [];
    ingredients = List<Map<String, dynamic>>.from(
      data.whereType<Map<String, dynamic>>(),
    );
      setState(() {
      _availableIngredients = ingredients;
      _loading = false;
    });
  }

  Future<void> _showIngredientDetails(Map<String, dynamic> ingredient) async {
    await showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(ingredient['name'] ?? ''),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (ingredient['image_url'] != null &&
                    ingredient['image_url'].toString().isNotEmpty)
                  Image.network(
                    ingredient['image_url'].toString().startsWith('http')
                        ? ingredient['image_url']
                        : 'http://localhost:8000/' + ingredient['image_url'],
                    height: 220,
                    width: 220,
                    fit: BoxFit.contain,
                    errorBuilder:
                        (context, error, stackTrace) => Image.network(
                          'http://localhost:8000/images/no-image.png',
                          width: 220,
                          height: 220,
                        ),
                  )
                else
                  Image.network(
                    'http://localhost:8000/images/no-image.png',
                    width: 220,
                    height: 220,
                  ),
                const SizedBox(height: 8),
                Text('الوحدة: ${ingredient['unit'] ?? ''}'),
                if (ingredient['description'] != null)
                  Text(ingredient['description']),
              ],
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

  Future<void> _editIngredientDialog(Map<String, dynamic> ingredient) async {
    final nameController = TextEditingController(
      text: ingredient['name'] ?? '',
    );
    final unitController = TextEditingController(
      text: ingredient['unit'] ?? '',
    );
    await showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('تعديل المكون'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'اسم المكون'),
                ),
                TextField(
                  controller: unitController,
                  decoration: const InputDecoration(labelText: 'الوحدة'),
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
                  final name = nameController.text.trim();
                  unitController.text.trim();
                  if (name.isEmpty) return;
                  final result = await IngredientService.updateIngredient(
                    ingredient['id'],
                    name,
                  );
                  if (!mounted) return;
                  Navigator.pop(context);
                  if (result['success']) {
                    await _fetchIngredients();
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('تم تعديل المكون بنجاح')),
                    );
                  } else {
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(result['message'] ?? 'فشل التعديل'),
                      ),
                    );
                  }
                },
                child: const Text('تعديل'),
              ),
            ],
          ),
    );
  }

  Future<void> _addIngredientDialog() async {
    final nameController = TextEditingController();
    final unitController = TextEditingController();
    await showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('إضافة مكون جديد'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'اسم المكون'),
                ),
                TextField(
                  controller: unitController,
                  decoration: const InputDecoration(labelText: 'الوحدة'),
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
                  final name = nameController.text.trim();
                  final unit = unitController.text.trim();
                  if (name.isEmpty || unit.isEmpty) return;
                  final result = await IngredientService.addIngredient(
                    name,
                    unit,
                  );
                  if (!mounted) return;
                  Navigator.pop(context);
                  if (result['success']) {
                    await _fetchIngredients();
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('تمت إضافة المكون بنجاح')),
                    );
                  } else {
                    if (!mounted) return;
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

  Future<void> _deleteIngredient(int id) async {
    final result = await IngredientService.deleteIngredient(id);
    if (!mounted) return;
    if (result['success']) {
      await _fetchIngredients();
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('تم حذف المكون')));
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(result['message'] ?? 'فشل الحذف')));
    }
  }

  Future<void> _addAliasDialog(int ingredientId) async {
    final aliasController = TextEditingController();
    await showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('إضافة اسم بديل'),
            content: TextField(
              controller: aliasController,
              decoration: const InputDecoration(labelText: 'الاسم البديل'),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('إلغاء'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final alias = aliasController.text.trim();
                  if (alias.isEmpty) return;
                  final result = await IngredientService.addAlias(
                    ingredientId,
                    alias,
                  );
                  if (!mounted) return;
                  Navigator.pop(context);
                  if (result['success']) {
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('تمت إضافة الاسم البديل بنجاح'),
                      ),
                    );
                  } else {
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          result['message'] ?? 'فشل إضافة الاسم البديل',
                        ),
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

  void _addToSelected(String name) {
    if (!_selectedIngredients.containsKey(name)) {
      setState(() {
        _selectedIngredients[name] = 100;
      });
    }
  }

  void _increment(String name) {
    setState(() {
      _selectedIngredients[name] = (_selectedIngredients[name] ?? 0) + 50;
    });
  }

  void _decrement(String name) {
    final current = _selectedIngredients[name]!;
    if (current > 50) {
      setState(() {
        _selectedIngredients[name] = current - 50;
      });
    }
  }

  void _remove(String name) {
    setState(() {
      _selectedIngredients.remove(name);
    });
  }

  void _updateQuantity(String name, String value) {
    final parsed = int.tryParse(value);
    if (parsed != null && parsed > 0) {
      setState(() {
        _selectedIngredients[name] = parsed;
      });
    }
  }

  void _goToNextScreen() {
    if (_selectedIngredients.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one component')),
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => PeopleScreen(
              ingredientsWithQuantity: _selectedIngredients,
              ingredients: _selectedIngredients.keys.toList(),
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 250, 240),
      appBar: AppBar(
        title: const Text('Insert ingredients'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addIngredientDialog,
            tooltip: 'إضافة مكون جديد',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // خيار تبديل بين كل المكونات والمفضلة
            Row(
              children: [
                Expanded(
                  child: SwitchListTile(
                    title: const Text('عرض المكونات المرغوبة فقط (المفضلة)'),
                    value: _showPreferredOnly,
                    onChanged: (val) async {
                      setState(() {
                        _showPreferredOnly = val;
                      });
                      if (val) {
                        await _fetchPreferredIngredients();
                      } else {
                        await _fetchIngredients();
                      }
                    },
                  ),
                ),
              ],
            ),
            // مربع البحث
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Search or enter an ingredient',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () async {
                    await _fetchIngredients(_controller.text.trim());
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Colors.blue),
                ),
              ),
              onChanged: (value) {
                setState(() {
                });
              },
              onSubmitted: (value) async {
                await _fetchIngredients(value.trim());
              },
            ),
            const SizedBox(height: 12),
            _loading
                ? const Expanded(
                  child: Center(child: CircularProgressIndicator()),
                )
                : _availableIngredients.isEmpty
                ? const Expanded(child: Center(child: Text('لا يوجد نتائج')))
                : Expanded(
                  child: GridView.builder(
                    itemCount: _availableIngredients.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 0.75,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                        ),
                    itemBuilder: (context, index) {
                      final item = _availableIngredients[index];
                      final name = item['name'] ?? '';
                      final idRaw = item['id'];
                      final int? id =
                          idRaw is int
                              ? idRaw
                              : int.tryParse(idRaw?.toString() ?? '');
                      return GestureDetector(
                        onTap: () => _addToSelected(name),
                        child: Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (item['image_url'] != null &&
                                  item['image_url'].toString().isNotEmpty)
                                Image.network(
                                  item['image_url'].toString().startsWith(
                                        'http',
                                      )
                                      ? item['image_url']
                                      : 'http://localhost:8000/' +
                                          item['image_url'],
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                  errorBuilder:
                                      (
                                        context,
                                        error,
                                        stackTrace,
                                      ) => Image.network(
                                        'http://localhost:8000/images/no-image.png',
                                        width: 60,
                                        height: 60,
                                      ),
                                )
                              else
                                Image.network(
                                  'http://localhost:8000/images/no-image.png',
                                  width: 60,
                                  height: 60,
                                ),
                              const SizedBox(height: 8),
                              Text(
                                name,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (id != null) ...[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                        Icons.info,
                                        color: Colors.orange,
                                      ),
                                      tooltip: 'تفاصيل',
                                      onPressed: () async {
                                        await _showIngredientDetails(item);
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.edit,
                                        color: Colors.blue,
                                      ),
                                      tooltip: 'تعديل',
                                      onPressed: () async {
                                        await _editIngredientDialog(item);
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      onPressed: () async {
                                        await _deleteIngredient(id);
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.edit,
                                        color: Colors.green,
                                      ),
                                      tooltip: 'إضافة اسم بديل',
                                      onPressed: () async {
                                        await _addAliasDialog(id);
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
            const SizedBox(height: 10),
            if (_selectedIngredients.isNotEmpty) ...[
              const Text(
                'Selected ingredients',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 200,
                child: ListView(
                  children:
                      _selectedIngredients.entries.map((entry) {
                        final name = entry.key;
                        final quantity = entry.value;
                        return Card(
                          child: ListTile(
                            title: Text(name),
                            subtitle: Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove),
                                  onPressed: () => _decrement(name),
                                ),
                                SizedBox(
                                  width: 60,
                                  child: TextField(
                                    keyboardType: TextInputType.number,
                                    controller: TextEditingController(
                                      text: quantity.toString(),
                                    ),
                                    onSubmitted:
                                        (value) => _updateQuantity(name, value),
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: 8,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 5),
                                IconButton(
                                  icon: const Icon(Icons.add),
                                  onPressed: () => _increment(name),
                                ),
                              ],
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _remove(name),
                            ),
                          ),
                        );
                      }).toList(),
                ),
              ),
            ],
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _goToNextScreen,
              child: const Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}
