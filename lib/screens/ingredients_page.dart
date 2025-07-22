import 'package:flutter/material.dart';

import 'people_screen.dart';

class IngredientsScreen extends StatefulWidget {
  const IngredientsScreen({super.key});

  @override
  State<IngredientsScreen> createState() => _IngredientsScreenState();
}

class _IngredientsScreenState extends State<IngredientsScreen> {
  final TextEditingController _controller = TextEditingController();

  // المكونات التي تم اختيارها مع الكميات (بالغرام)
  final Map<String, int> _selectedIngredients = {};

  // المكونات الجاهزة
  final List<String> _availableIngredients = [
    'بيض',
    'جبن',
    'طماطم',
    'خيار',
    'زيت',
    'سكر',
    'ملح',
    'دقيق',
    'ماء',
    'عسل',
    'لبن',
    'خبز',
  ];

  String _searchQuery = '';

  void _addIngredient(String name) {
    if (!_selectedIngredients.containsKey(name)) {
      setState(() {
        _selectedIngredients[name] = 100; // الكمية الابتدائية بالغرام
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
              ingredients: [],
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredIngredients =
        _availableIngredients
            .where((item) => item.contains(_searchQuery))
            .toList();

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 250, 240),
      appBar: AppBar(title: const Text('Insert ingredients')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // مربع البحث
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Search or enter an ingredient',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    final name = _controller.text.trim();
                    if (name.isNotEmpty) {
                      _addIngredient(name);
                      _controller.clear();
                    }
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16), // ✅ الحواف الدائرية
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16), // ✅ عند عدم التركيز
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16), // ✅ عند التركيز
                  borderSide: const BorderSide(color: Colors.blue),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.trim();
                });
              },
            ),

            const SizedBox(height: 12),

            // شبكة المكونات الجاهزة
            Expanded(
              child: GridView.builder(
                itemCount: filteredIngredients.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 0.75,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
                itemBuilder: (context, index) {
                  final item = filteredIngredients[index];
                  return GestureDetector(
                    onTap: () => _addIngredient(item),
                    child: Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.fastfood,
                            size: 40,
                            color: Colors.orange,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            item,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
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
                                //const Text('غرام'),
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
