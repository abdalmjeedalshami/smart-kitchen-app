import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HealthConditionService {
  static const String baseUrl = 'http://localhost:8000/api';

  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<List<dynamic>> getAllConditions() async {
    final token = await _getToken();
    final url = Uri.parse('$baseUrl/health-conditions/view-all');
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
        if (body is List) {
          return body;
        } else if (body['data'] is List) {
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

  static Future<Map<String, dynamic>> addCondition(String name) async {
    final token = await _getToken();
    final url = Uri.parse('$baseUrl/health-conditions/add');
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
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (body['data'] is Map<String, dynamic> || body['data'] is List) {
          return {'success': true, 'data': body['data']};
        } else {
          return {'success': true};
        }
      } else if (response.statusCode == 422 &&
          body['message']?.contains('unique') == true) {
        return {
          'success': false,
          'message': 'هذا المرض موجود بالفعل أو بانتظار موافقة الأدمن.',
        };
      } else {
        return {'success': false, 'message': body['message'] ?? 'فشل الإضافة'};
      }
    } catch (e) {
      return {'success': false, 'message': 'خطأ في الاتصال بالخادم'};
    }
  }

  static Future<Map<String, dynamic>> attachConditions(
    List<int> conditionIds,
  ) async {
    final token = await _getToken();
    final url = Uri.parse('$baseUrl/family-profile/attach-conditions');
    try {
      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({'health_condition_ids': conditionIds}),
      );
      final body = json.decode(response.body);
      if (response.statusCode == 200) {
        if (body['data'] is Map<String, dynamic> || body['data'] is List) {
          return {'success': true, 'data': body['data']};
        } else {
          return {'success': true};
        }
      } else {
        return {'success': false, 'message': body['message'] ?? 'فشل الربط'};
      }
    } catch (e) {
      return {'success': false, 'message': 'خطأ في الاتصال بالخادم'};
    }
  }

  static Future<Map<String, dynamic>> detachConditions(
    List<int> conditionIds,
  ) async {
    final token = await _getToken();
    final url = Uri.parse('$baseUrl/family-profile/detach-conditions');
    try {
      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({'health_condition_ids': conditionIds}),
      );
      final body = json.decode(response.body);
      if (response.statusCode == 200) {
        if (body['data'] is Map<String, dynamic> || body['data'] is List) {
          return {'success': true, 'data': body['data']};
        } else {
          return {'success': true};
        }
      } else {
        return {'success': false, 'message': body['message'] ?? 'فشل الإزالة'};
      }
    } catch (e) {
      return {'success': false, 'message': 'خطأ في الاتصال بالخادم'};
    }
  }

  static Future<List<dynamic>> getFamilyConditions() async {
    final token = await _getToken();
    final url = Uri.parse('$baseUrl/family-profile/view-my-condition');
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
        if (body is List) {
          return body;
        } else if (body['data'] is List) {
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
