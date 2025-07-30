import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MealService {
  static const String baseUrl = 'http://localhost:8000/api';

  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<List<dynamic>> getAllMeals() async {
    final token = await _getToken();
    final url = Uri.parse('$baseUrl/meal/show-all-meal');
    try {
      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        if (body['data'] is List) {
          return body['data'];
        } else {
          return [];
        }
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  static Future<Map<String, dynamic>> addMeal(
    Map<String, dynamic> mealData,
  ) async {
    final token = await _getToken();
    final url = Uri.parse('$baseUrl/meal/add-meal');
    try {
      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(mealData),
      );
      final body = json.decode(response.body);
      if (response.statusCode == 200) {
        if (body['data'] is Map<String, dynamic> || body['data'] is List) {
          return {'success': true, 'data': body['data']};
        } else {
          return {'success': true};
        }
      } else {
        return {'success': false, 'message': body['message'] ?? 'فشل الإضافة'};
      }
    } catch (e) {
      return {'success': false, 'message': 'خطأ في الاتصال بالخادم'};
    }
  }

  static Future<Map<String, dynamic>?> getMeal(int id) async {
    final token = await _getToken();
    final url = Uri.parse('$baseUrl/meal/show-meal/$id');
    try {
      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        if (body['data'] is Map<String, dynamic>) {
          return body['data'];
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<Map<String, dynamic>> deleteMeal(int id) async {
    final token = await _getToken();
    final url = Uri.parse('$baseUrl/meal/destroy-meal/$id');
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
        return {'success': true};
      } else {
        return {'success': false, 'message': body['message'] ?? 'فشل الحذف'};
      }
    } catch (e) {
      return {'success': false, 'message': 'خطأ في الاتصال بالخادم'};
    }
  }
}
