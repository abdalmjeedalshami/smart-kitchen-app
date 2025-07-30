import 'package:shared_preferences/shared_preferences.dart';

class ProfileService {
  static const String _userNameKey = 'userName';
  static const String _userAgeKey = 'userAge';
  static const String _userWeightKey = 'userWeight';
  static const String _userHeightKey = 'userHeight';
  static const String _peopleCountKey = 'peopleCount';
  static const String _userDiseasesKey = 'userDiseases';

  // حفظ بيانات المستخدم
  static Future<void> saveUserProfile({
    required String name,
    required String age,
    required String weight,
    required String height,
    required int peopleCount,
    required List<String> diseases,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userNameKey, name);
    await prefs.setInt(_peopleCountKey, peopleCount);
    await prefs.setStringList(_userDiseasesKey, diseases);
  }

  // جلب بيانات المستخدم
  static Future<Map<String, dynamic>> getUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'name': prefs.getString(_userNameKey) ?? '',
      'age': '',
      'weight': '',
      'height': '',
      'peopleCount': prefs.getInt(_peopleCountKey) ?? 1,
      'diseases': prefs.getStringList(_userDiseasesKey) ?? [],
    };
  }

  // حفظ عدد الأشخاص فقط
  static Future<void> savePeopleCount(int count) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_peopleCountKey, count);
  }

  // جلب عدد الأشخاص
  static Future<int> getPeopleCount() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_peopleCountKey) ?? 1;
  }

  // حفظ الأمراض فقط
  static Future<void> saveDiseases(List<String> diseases) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_userDiseasesKey, diseases);
  }

  // جلب الأمراض
  static Future<List<String>> getDiseases() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_userDiseasesKey) ?? [];
  }

  // التحقق من وجود بيانات البروفايل
  static Future<bool> hasProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString(_userNameKey);
    return name != null && name.isNotEmpty;
  }

  // مسح جميع بيانات البروفايل
  static Future<void> clearProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userNameKey);
    await prefs.remove(_userAgeKey);
    await prefs.remove(_userWeightKey);
    await prefs.remove(_userHeightKey);
    await prefs.remove(_peopleCountKey);
    await prefs.remove(_userDiseasesKey);
  }
}
