import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class FridgeService {
  static const String baseUrl = 'http://localhost:8000/api';

  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<List<dynamic>?> getAllFridgeItems() async {
    final token = await _getToken();
    final url = Uri.parse('$baseUrl/fridge/ing-frid-all');
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
          print('fridge/ing-frid-all: data is not List, value:');
          print(body['data']);
          return [];
        }
      } else if (response.statusCode == 404) {
        // لا يوجد ملف عائلة
        return null;
      } else {
        return [];
      }
    } catch (e) {
      print('fridge/ing-frid-all error: $e');
      return [];
    }
  }

  static Future<Map<String, dynamic>> addItemsToFridge(
    List<Map<String, dynamic>> items,
  ) async {
    final token = await _getToken();
    final url = Uri.parse('$baseUrl/fridge/add-ing-to-frid');
    try {
      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({'items': items}),
      );
      final body = json.decode(response.body);
      if (response.statusCode == 200) {
        if (body['data'] is List || body['data'] is Map<String, dynamic>) {
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

  static Future<Map<String, dynamic>> updateFridgeItem(
    int id,
    String quantity,
  ) async {
    final token = await _getToken();
    final url = Uri.parse('$baseUrl/fridge/update-frid/$id');
    try {
      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({'quantity': quantity}),
      );
      final body = json.decode(response.body);
      if (response.statusCode == 200) {
        if (body['data'] is List || body['data'] is Map<String, dynamic>) {
          return {'success': true, 'data': body['data']};
        } else {
          return {'success': true};
        }
      } else {
        return {'success': false, 'message': body['message'] ?? 'فشل التحديث'};
      }
    } catch (e) {
      return {'success': false, 'message': 'خطأ في الاتصال بالخادم'};
    }
  }

  static Future<Map<String, dynamic>> deleteFridgeItem(int id) async {
    final token = await _getToken();
    final url = Uri.parse('$baseUrl/fridge/destroy-ing-for-frid/$id');
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

  static Future<List<dynamic>> checkExpirationsForUser() async {
    final token = await _getToken();
    final url = Uri.parse('$baseUrl/fridge/check-expirations-for-user');
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

  static Future<List<dynamic>> checkExpirationsForAll() async {
    final token = await _getToken();
    final url = Uri.parse('$baseUrl/fridge/check-expirations-for-all');
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
}
