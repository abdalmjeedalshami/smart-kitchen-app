import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MealRequestService {
  static const String baseUrl = 'http://localhost:8000/api';

  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<Map<String, dynamic>> addMealRequest(
    Map<String, dynamic> requestData,
  ) async {
    final token = await _getToken();
    final url = Uri.parse('$baseUrl/meal-request/add-meal-req');
    try {
      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(requestData),
      );
      final body = json.decode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (body['data'] is Map<String, dynamic> || body['data'] is List) {
          return {'success': true, 'data': body['data']};
        } else {
          return {'success': true};
        }
      } else if (response.statusCode == 404) {
        return {
          'success': false,
          'message':
              'المسار غير موجود أو السيرفر غير متصل. تأكد من صحة الرابط أو من تشغيل الباك اند.',
        };
      } else {
        return {
          'success': false,
          'message': body['message'] ?? 'فشل إرسال الطلب',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'خطأ في الاتصال بالخادم'};
    }
  }
}
