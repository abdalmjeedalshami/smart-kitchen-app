import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:meal_app_planner/screens/login_screen.dart';
import '../services/api_service.dart';
import '../services/family_profile_service.dart';
import '../services/profile_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _peopleCount = 1;
  final List<String> _selectedDiseases = [];
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  bool _hasFamilyProfile = false;

  final List<String> _availableDiseases = [
    'Diabetes',
    'Hypertension',
    'Heart Disease',
    'Kidney Disease',
    'Liver Disease',
    'Celiac Disease',
    'Lactose Intolerance',
    'Nut Allergy',
    'Gluten Allergy',
    'Peanut Allergy',
    'Shellfish Allergy',
    'Egg Allergy',
    'Soy Allergy',
    'Wheat Allergy',
    'Fish Allergy',
    'None',
  ];

  List<String> _filteredDiseases = [];

  @override
  void initState() {
    super.initState();
    _loadFamilyProfile();
  }

  Future<void> _loadFamilyProfile() async {
    final result = await FamilyProfileService.showFamilyProfile();
    if (result['success'] &&
        result['data'] != null &&
        result['data']['data'] != null) {
      setState(() {
        _peopleCount = result['data']['data']['number_of_people'] ?? 1;
        _hasFamilyProfile = true;
      });
    } else {
      setState(() {
        _hasFamilyProfile = false;
      });
    }
  }


  void _toggleDisease(String disease) {
    setState(() {
      if (disease == 'None') {
        _selectedDiseases.clear();
        _selectedDiseases.add('None');
      } else {
        _selectedDiseases.remove('None');
        if (_selectedDiseases.contains(disease)) {
          _selectedDiseases.remove(disease);
        } else {
          _selectedDiseases.add(disease);
        }
        if (_selectedDiseases.isEmpty) {
          _selectedDiseases.add('None');
        }
      }
    });
  }

  void _searchDiseases(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredDiseases = List.from(_availableDiseases);
      } else {
        _filteredDiseases =
            _availableDiseases
                .where(
                  (disease) =>
                      disease.toLowerCase().contains(query.toLowerCase()),
                )
                .toList();
      }
    });
  }

  void _addCustomDisease(String disease) {
    if (disease.isNotEmpty && !_availableDiseases.contains(disease)) {
      setState(() {
        _availableDiseases.add(disease);
        _filteredDiseases = List.from(_availableDiseases);
        _selectedDiseases.add(disease);
        _searchController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 250, 240),
      appBar: AppBar(
        title: const Text(
          'الملف الشخصي',
          style: TextStyle(fontSize: 24, color: Colors.orange),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_hasFamilyProfile)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'لديك ملف عائلة محفوظ. يمكنك تعديله مباشرة من هنا.',
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            // Personal Information Section
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'المعلومات الشخصية',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'الاسم',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Number of People Section
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'عدد الأشخاص الذين سيتناولون الوجبة',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<int>(
                      value: _peopleCount,
                      decoration: const InputDecoration(
                        labelText: 'اختر عدد الأشخاص',
                        border: OutlineInputBorder(),
                      ),
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
                                  child: Text('$e شخص'),
                                ),
                              )
                              .toList(),
                    ),
                    const SizedBox(height: 12),
                    if (_hasFamilyProfile)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.edit),
                          label: const Text('تعديل ملف العائلة'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () async {
                            final result =
                                await FamilyProfileService.updateFamilyProfile(
                                  _peopleCount,
                                );
                            if (result['success']) {
                              await ProfileService.savePeopleCount(
                                _peopleCount,
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('تم تعديل ملف العائلة بنجاح'),
                                ),
                              );
                              // إعادة تحميل الصفحة الرئيسية
                              Navigator.of(
                                context,
                              ).popUntil((route) => route.isFirst);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    result['message'] ??
                                        'فشل تعديل ملف العائلة',
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    if (!_hasFamilyProfile)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.add),
                          label: const Text('إضافة ملف العائلة'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () async {
                            final result =
                                await FamilyProfileService.addFamilyProfile(
                                  _peopleCount,
                                );
                            if (result['success']) {
                              setState(() {
                                _hasFamilyProfile = true;
                              });
                              await ProfileService.savePeopleCount(
                                _peopleCount,
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('تم إضافة ملف العائلة بنجاح'),
                                ),
                              );
                              // إعادة تحميل الصفحة الرئيسية
                              Navigator.of(
                                context,
                              ).popUntil((route) => route.isFirst);
                            } else if (result['message']?.contains(
                                  'لديك ملف عائلة بالفعل',
                                ) ==
                                true) {
                              setState(() {
                                _hasFamilyProfile = true;
                              });
                              await _loadFamilyProfile();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    result['message'] ??
                                        'لديك ملف عائلة بالفعل. يمكنك تعديله فقط.',
                                  ),
                                ),
                              );
                              Navigator.of(
                                context,
                              ).popUntil((route) => route.isFirst);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    result['message'] ??
                                        'فشل إضافة ملف العائلة',
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Diseases Section
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'الأمراض والحساسية',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'اختر الأمراض أو الحساسية التي تعاني منها:',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 16),

                    // Search Bar
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              labelText: 'البحث عن مرض أو إضافة مرض جديد',
                              border: const OutlineInputBorder(),
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.search),
                                onPressed: () {
                                  _searchDiseases(_searchController.text);
                                },
                              ),
                            ),
                            onChanged: _searchDiseases,
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            if (_searchController.text.isNotEmpty) {
                              _addCustomDisease(_searchController.text);
                            }
                          },
                          child: const Text('إضافة'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Selected Diseases
                    if (_selectedDiseases.isNotEmpty &&
                        !_selectedDiseases.contains('None'))
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'الأمراض المختارة:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children:
                                _selectedDiseases
                                    .where((disease) => disease != 'None')
                                    .map(
                                      (disease) => Chip(
                                        label: Text(disease),
                                        deleteIcon: const Icon(Icons.close),
                                        onDeleted:
                                            () => _toggleDisease(disease),
                                        backgroundColor: Colors.orange
                                            .withOpacity(0.3),
                                      ),
                                    )
                                    .toList(),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),

                    // Available Diseases
                    const Text(
                      'الأمراض المتاحة:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children:
                          _filteredDiseases.map((disease) {
                            bool isSelected = _selectedDiseases.contains(
                              disease,
                            );
                            return FilterChip(
                              label: Text(disease),
                              selected: isSelected,
                              onSelected: (selected) => _toggleDisease(disease),
                              selectedColor: Colors.orange.withOpacity(0.3),
                              checkmarkColor: Colors.orange,
                            );
                          }).toList(),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Save Button
            // احذف زر الحفظ القديم من الأسفل ("حفظ البيانات") نهائياً من الشاشة
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            icon: const Icon(Icons.logout),
            label: const Text('تسجيل الخروج'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              // استدعاء دالة تسجيل الخروج
              // ملاحظة: يجب جلب التوكن من التخزين أو الحالة
              String? token;
              // مثال: جلب التوكن من SharedPreferences
              final prefs = await SharedPreferences.getInstance();
              token = prefs.getString('token');
              if (token != null) {
                final result = await ApiService.logoutUser(token);
                if (result['success']) {
                  // حذف التوكن من التخزين
                  await prefs.remove('token');
                  // إعادة التوجيه لشاشة تسجيل الدخول
                  if (context.mounted) {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => LoginScreen()),
                      (route) => false,
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(result['message'] ?? 'فشل تسجيل الخروج'),
                    ),
                  );
                }
              }
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _searchController.dispose();
    super.dispose();
  }
}
