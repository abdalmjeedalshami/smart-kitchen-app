import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  //  Android Emulator localhost ـ 10.0.2.2
  static const String baseUrl = 'http://localhost:8000/api';

  static Future<Map<String, dynamic>> loginUser(
    String email,
    String password,
  ) async {
    final url = Uri.parse('$baseUrl/login');

    try {
      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: json.encode({'email': email, 'password': password}),
      );

      final body = json.decode(response.body);

      // Laravel returns 'Token' or 'Token:'
      final token = body['Token'] ?? body['Token:'] ?? body['token'];
      if (response.statusCode == 200 && token != null) {
        body['token'] = token; // add normalized key for frontend
        return {'success': true, 'data': body};
      } else {
        return {
          'success': false,
          'message': body['message'] ?? 'فشل تسجيل الدخول',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'خطأ في الاتصال بالخادم'};
    }
  }

  static Future<Map<String, dynamic>> registerUser(
    Map<String, String> data,
  ) async {
    final url = Uri.parse('$baseUrl/register');

    try {
      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: json.encode(data),
      );

      final body = json.decode(response.body);

      final token = body['Token'] ?? body['Token:'] ?? body['token'];
      if (response.statusCode == 200 && token != null) {
        body['token'] = token;
        return {'success': true, 'data': body};
      } else {
        return {
          'success': false,
          'message': body['message'] ?? 'فشل إنشاء الحساب',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'خطأ في الاتصال بالخادم'};
    }
  }

  static Future<Map<String, dynamic>> logoutUser(String token) async {
    final url = Uri.parse('$baseUrl/logout');
    try {
      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        return {'success': true};
      } else {
        return {'success': false, 'message': 'فشل تسجيل الخروج'};
      }
    } catch (e) {
      return {'success': false, 'message': 'خطأ في الاتصال بالخادم'};
    }
  }

  static Future<Map<String, dynamic>> forgotPassword(String email) async {
    final url = Uri.parse('$baseUrl/forgot-password');
    try {
      final response = await http.post(
        url,
        headers: {'Accept': 'application/json'},
        body: {'email': email},
      );
      if (response.statusCode == 200) {
        return {'success': true};
      } else {
        return {'success': false, 'message': 'فشل إرسال البريد'};
      }
    } catch (e) {
      return {'success': false, 'message': 'خطأ في الاتصال بالخادم'};
    }
  }

  static Future<Map<String, dynamic>> resetPassword(
    String email,
    String password,
    String passwordConfirmation,
  ) async {
    final url = Uri.parse('$baseUrl/reset-password');
    try {
      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'email': email,
          'password': password,
          'password_confirmation': passwordConfirmation,
        }),
      );
      if (response.statusCode == 200) {
        return {'success': true};
      } else {
        return {'success': false, 'message': 'فشل إعادة تعيين كلمة المرور'};
      }
    } catch (e) {
      return {'success': false, 'message': 'خطأ في الاتصال بالخادم'};
    }
  }

  static Future<Map<String, dynamic>> checkNumber(String number) async {
    final url = Uri.parse('$baseUrl/checkNumber');
    try {
      final response = await http.post(url, body: {'number': number});
      if (response.statusCode == 200) {
        return {'success': true};
      } else {
        return {'success': false, 'message': 'فشل التحقق من الرقم'};
      }
    } catch (e) {
      return {'success': false, 'message': 'خطأ في الاتصال بالخادم'};
    }
  }
}
