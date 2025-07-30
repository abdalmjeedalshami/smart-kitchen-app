import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class FamilyProfileService {
  static const String baseUrl = 'http://localhost:8000/api';

  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<Map<String, dynamic>> addFamilyProfile(
    int numberOfPeople,
  ) async {
    final token = await _getToken();
    final url = Uri.parse('$baseUrl/addFamilyProfile');
    try {
      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({'number_of_people': numberOfPeople.toString()}),
      );
      final body = json.decode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (body == null) {
          return {'success': true, 'data': null};
        } else {
          return {'success': true, 'data': body};
        }
      } else if (response.statusCode == 409) {
        return {
          'success': false,
          'message':
              body['message'] ?? 'لديك ملف عائلة بالفعل. يمكنك تعديله فقط.',
        };
      } else {
        return {
          'success': false,
          'message': body['message'] ?? 'فشل إضافة الملف',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'خطأ في الاتصال بالخادم'};
    }
  }

  static Future<Map<String, dynamic>> updateFamilyProfile(
    int numberOfPeople,
  ) async {
    final token = await _getToken();
    final url = Uri.parse('$baseUrl/updateFamilyProfile');
    try {
      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({'number_of_people': numberOfPeople.toString()}),
      );
      final body = json.decode(response.body);
      if (response.statusCode == 200) {
        if (body == null) {
          return {'success': true, 'data': null};
        } else {
          return {'success': true, 'data': body};
        }
      } else {
        return {
          'success': false,
          'message': body['error'] ?? body['message'] ?? 'فشل التحديث',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'خطأ في الاتصال بالخادم'};
    }
  }

  static Future<Map<String, dynamic>> showFamilyProfile() async {
    final token = await _getToken();
    final url = Uri.parse('$baseUrl/showFamilyProfile');
    try {
      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      debugPrint('showFamilyProfile RESPONSE: ' + response.body);
      final body = response.body.isNotEmpty ? json.decode(response.body) : null;
      if (response.statusCode == 200) {
        if (body == null) {
          return {'success': true, 'data': null};
        } else {
          return {'success': true, 'data': body};
        }
      } else {
        return {
          'success': false,
          'message':
              (body is Map && body['message'] != null)
                  ? body['message']
                  : 'فشل جلب البيانات',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'خطأ في الاتصال بالخادم'};
    }
  }

  static Future<Map<String, dynamic>> deleteFamilyProfile() async {
    final token = await _getToken();
    final url = Uri.parse('$baseUrl/destroyFamilyProfile');
    try {
      final response = await http.delete(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      final body = json.decode(response.body);
      if (response.statusCode == 200) {
        if (body is Map<String, dynamic>) {
          return {'success': true, 'data': body};
        } else {
          return {'success': true};
        }
      } else {
        return {'success': false, 'message': body['message'] ?? 'فشل الحذف'};
      }
    } catch (e) {
      return {'success': false, 'message': 'خطأ في الاتصال بالخادم'};
    }
  }
}
