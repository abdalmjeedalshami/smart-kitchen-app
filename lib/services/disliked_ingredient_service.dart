import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DislikedIngredientService {
  static const String baseUrl = 'http://localhost:8000/api';

  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<List<dynamic>> getAllDislikedForFamily(int familyId) async {
    final token = await _getToken();
    final url = Uri.parse(
      '$baseUrl/disliked-ingredients/show-all-dis-for-family/$familyId',
    );
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
        final data = body['data'];
        if (data is List) {
          return data;
        } else if (data is Map<String, dynamic>) {
          return [data];
        } else {
          print('getAllDislikedForFamily: data is not List or Map, value:');
          print(data);
          return [];
        }
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  static Future<List<dynamic>> getAllDislikedForMe() async {
    final token = await _getToken();
    final url = Uri.parse('$baseUrl/disliked-ingredients/show-all-dis-for-me');
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
        final data = body['data'];
        if (data is List) {
          return data;
        } else if (data is Map<String, dynamic>) {
          return [data];
        } else {
          print('getAllDislikedForMe: data is not List or Map, value:');
          print(data);
          return [];
        }
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  static Future<Map<String, dynamic>> addDisliked(
    List<int> ingredientIds,
  ) async {
    final token = await _getToken();
    final url = Uri.parse('$baseUrl/disliked-ingredients/add-dis');
    try {
      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({'ingredient_ids': ingredientIds}),
      );
      final body = json.decode(response.body);
      if (response.statusCode == 200) {
        final data = body['data'];
        if (data is Map<String, dynamic> || data is List) {
          return {'success': true, 'data': data};
        } else {
          print('addDisliked: data is not Map or List, value:');
          print(data);
          return {'success': true, 'data': null};
        }
      } else {
        return {'success': false, 'message': body['message'] ?? 'فشل الإضافة'};
      }
    } catch (e) {
      return {'success': false, 'message': 'خطأ في الاتصال بالخادم'};
    }
  }

  static Future<Map<String, dynamic>> deleteDisliked(int id) async {
    final token = await _getToken();
    final url = Uri.parse('$baseUrl/disliked-ingredients/destroy-dis/$id');
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
