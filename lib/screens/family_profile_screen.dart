import 'package:flutter/material.dart';
import '../services/family_profile_service.dart';
import '../services/profile_service.dart';
import 'home_page.dart';

class FamilyProfileScreen extends StatefulWidget {
  const FamilyProfileScreen({super.key});

  @override
  State<FamilyProfileScreen> createState() => _FamilyProfileScreenState();
}

class _FamilyProfileScreenState extends State<FamilyProfileScreen> {
  int _peopleCount = 1;
  bool _hasFamilyProfile = false;
  bool _loading = true;
  String? _errorMsg;

  @override
  void initState() {
    super.initState();
    _loadFamilyProfile();
  }

  Future<void> _loadFamilyProfile() async {
    setState(() {
      _loading = true;
      _errorMsg = null;
    });
    final result = await FamilyProfileService.showFamilyProfile();
    if (result['success'] &&
        result['data'] != null &&
        result['data']['number_of_people'] != null) {
      setState(() {
        _peopleCount = result['data']['number_of_people'] ?? 1;
        _hasFamilyProfile = true;
        _loading = false;
        _errorMsg = null;
      });
    } else {
      setState(() {
        _hasFamilyProfile = false;
        _loading = false;
        _errorMsg = result['message'] ?? 'تعذر جلب ملف العائلة من السيرفر';
      });
    }
  }

  Future<void> _addOrUpdateProfile() async {
    setState(() => _loading = true);
    if (_hasFamilyProfile) {
      final result = await FamilyProfileService.updateFamilyProfile(
        _peopleCount,
      );
      setState(() => _loading = false);
      if (result['success']) {
        await ProfileService.savePeopleCount(_peopleCount);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم تعديل ملف العائلة بنجاح')),
        );
        await _loadFamilyProfile();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'] ?? 'فشل التعديل')),
        );
      }
    } else {
      final result = await FamilyProfileService.addFamilyProfile(_peopleCount);
      if (result['success']) {
        setState(() => _loading = false);
        await ProfileService.savePeopleCount(_peopleCount);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم إضافة ملف العائلة بنجاح')),
        );
        await _loadFamilyProfile();
      } else if (result['message']?.contains('لديك ملف عائلة بالفعل') == true ||
          result['message']?.contains('يمكنك تعديله فقط') == true) {
        // الملف موجود مسبقاً: جلب بيانات الملف القديم وتحديث الحالة فوراً
        final oldProfile = await FamilyProfileService.showFamilyProfile();
        if (oldProfile['success'] &&
            oldProfile['data'] != null &&
            oldProfile['data']['data'] != null) {
          setState(() {
            _peopleCount = oldProfile['data']['data']['number_of_people'] ?? 1;
            _hasFamilyProfile = true;
            _loading = false;
          });
          // إعادة تحميل الشاشة بالكامل
          Future.microtask(() {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const FamilyProfileScreen(),
              ),
            );
          });
        } else {
          setState(() {
            _hasFamilyProfile = true;
            _loading = false;
          });
          Future.microtask(() {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const FamilyProfileScreen(),
              ),
            );
          });
        }
        // لا تعرض أي SnackBar هنا
      } else {
        setState(() => _loading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'] ?? 'فشل الإضافة')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF6F0),
      appBar: AppBar(
        title: const Text(
          'Family Profile',
          style: TextStyle(color: Colors.orange),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.orange),
        automaticallyImplyLeading: false,
        leading:
            _hasFamilyProfile
                ? TextButton.icon(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                  ),
                  icon: const Icon(Icons.arrow_back, color: Colors.blue),
                  label: const Text(
                    'رجوع للرئيسية',
                    style: TextStyle(color: Colors.blue),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => const HomePage()),
                    );
                  },
                )
                : null,
      ),
      body:
          _loading
              ? const Center(child: CircularProgressIndicator())
              : _errorMsg != null
              ? Center(
                child: Text(
                  _errorMsg!,
                  style: const TextStyle(color: Colors.red, fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              )
              : Center(
                child: Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 40,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.family_restroom,
                          color: Colors.orange,
                          size: 60,
                        ),
                        const SizedBox(height: 16),
                        if (_hasFamilyProfile) ...[
                          Container(
                            padding: const EdgeInsets.all(8),
                            margin: const EdgeInsets.only(bottom: 8),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.info, color: Colors.blue.shade700),
                                  const SizedBox(height: 4),
                                  Text(
                                    'لديك ملف عائلة محفوظ بالفعل. يمكنك تعديله فقط.',
                                    style: TextStyle(
                                      color: Colors.blue.shade700,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'عدد أفراد العائلة الحالي: $_peopleCount',
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.orange,
                            ),
                          ),
                          const SizedBox(height: 20),
                        ] else ...[
                          const Text(
                            'أدخل عدد أفراد العائلة',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                        DropdownButtonFormField<int>(
                          value: _peopleCount,
                          decoration: const InputDecoration(
                            labelText: 'عدد الأفراد',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            setState(() {
                              _peopleCount = value!;
                            });
                          },
                          items:
                              List.generate(20, (index) => index + 1)
                                  .map(
                                    (e) => DropdownMenuItem(
                                      value: e,
                                      child: Text('$e شخص'),
                                    ),
                                  )
                                  .toList(),
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            icon: Icon(
                              _hasFamilyProfile ? Icons.edit : Icons.add,
                            ),
                            label: Text(
                              _hasFamilyProfile
                                  ? 'تعديل ملف العائلة'
                                  : 'إضافة ملف العائلة',
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  _hasFamilyProfile
                                      ? Colors.blue
                                      : Colors.green,
                              foregroundColor: Colors.white,
                              textStyle: const TextStyle(fontSize: 18),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            onPressed: _addOrUpdateProfile,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
    );
  }
}
