import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class IngredientService {
  static const String baseUrl = 'http://localhost:8000/api';

  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    print('TOKEN (IngredientService): ' + (token ?? 'NULL'));
    return token;
  }

  static Future<List<dynamic>> getAllIngredients() async {
    final token = await _getToken();
    final url = Uri.parse('$baseUrl/ingredients/showallIng');
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
        print(
          'DEBUG: getAllIngredients data type: ${data.runtimeType}, value: $data',
        );
        if (data is List) {
          return data;
        } else if (data is Map<String, dynamic>) {
          return [data];
        } else {
          print(
            'ERROR: getAllIngredients unexpected data type: ${data.runtimeType}, value: $data',
          );
          return [];
        }
      } else {
        return [];
      }
    } catch (e) {
      print('خطأ في الاتصال بالسيرفر: $e');
      return [];
    }
  }

  static Future<List<dynamic>> getPreferredIngredients() async {
    final token = await _getToken();
    final url = Uri.parse('$baseUrl/ingredients/show-preferred-ing');
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
        print(
          'DEBUG: getPreferredIngredients data type: ${data.runtimeType}, value: $data',
        );
        if (data is List) {
          return data;
        } else if (data is Map<String, dynamic>) {
          return [data];
        } else {
          print(
            'ERROR: getPreferredIngredients unexpected data type: ${data.runtimeType}, value: $data',
          );
          return [];
        }
      } else {
        return [];
      }
    } catch (e) {
      print('خطأ في الاتصال بالسيرفر: $e');
      return [];
    }
  }

  static Future<List<dynamic>> searchIngredients(String query) async {
    final token = await _getToken();
    final url = Uri.parse('$baseUrl/ingredients/searchIng?q=$query');
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
        print(
          'DEBUG: searchIngredients data type: ${data.runtimeType}, value: $data',
        );
        if (data is List) {
          return data;
        } else if (data is Map<String, dynamic>) {
          return [data];
        } else {
          print(
            'ERROR: searchIngredients unexpected data type: ${data.runtimeType}, value: $data',
          );
          return [];
        }
      } else {
        return [];
      }
    } catch (e) {
      print('خطأ في الاتصال بالسيرفر: $e');
      return [];
    }
  }

  static Future<Map<String, dynamic>?> getIngredient(int id) async {
    final token = await _getToken();
    final url = Uri.parse('$baseUrl/ingredients/showIng/$id');
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
        print(
          'DEBUG: getIngredient data type: ${data.runtimeType}, value: $data',
        );
        if (data is Map<String, dynamic>) {
          return data;
        } else {
          print(
            'ERROR: getIngredient unexpected data type: ${data.runtimeType}, value: $data',
          );
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<Map<String, dynamic>> addIngredient(
    String name,
    String unit,
  ) async {
    final token = await _getToken();
    final url = Uri.parse('$baseUrl/ingredients/addIng');
    try {
      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({'name': name, 'unit': unit}),
      );
      final body = json.decode(response.body);
      if (response.statusCode == 200) {
        return {'success': true, 'data': body['data']};
      } else {
        return {'success': false, 'message': body['message'] ?? 'فشل الإضافة'};
      }
    } catch (e) {
      return {'success': false, 'message': 'خطأ في الاتصال بالخادم'};
    }
  }

  static Future<Map<String, dynamic>> updateIngredient(
    int id,
    String name,
  ) async {
    final token = await _getToken();
    final url = Uri.parse('$baseUrl/ingredients/updateIng/$id');
    try {
      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({'name': name}),
      );
      final body = json.decode(response.body);
      if (response.statusCode == 200) {
        return {'success': true, 'data': body['data']};
      } else {
        return {'success': false, 'message': body['message'] ?? 'فشل التحديث'};
      }
    } catch (e) {
      return {'success': false, 'message': 'خطأ في الاتصال بالخادم'};
    }
  }

  static Future<Map<String, dynamic>> deleteIngredient(int id) async {
    final token = await _getToken();
    final url = Uri.parse('$baseUrl/ingredients/destroyIng/$id');
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

  static Future<Map<String, dynamic>> addAlias(
    int ingredientId,
    String aliasName,
  ) async {
    final token = await _getToken();
    final url = Uri.parse('$baseUrl/ingredient-aliases/addAlias');
    try {
      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'ingredient_id': ingredientId,
          'alias_name': aliasName,
        }),
      );
      final body = json.decode(response.body);
      if (response.statusCode == 200) {
        return {'success': true, 'data': body['data']};
      } else {
        return {
          'success': false,
          'message': body['message'] ?? 'فشل إضافة الاسم البديل',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'خطأ في الاتصال بالخادم'};
    }
  }
}
