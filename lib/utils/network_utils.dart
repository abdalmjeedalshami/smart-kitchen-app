import 'dart:io';
import 'package:flutter/foundation.dart';

class NetworkUtils {
  /// التحقق من الاتصال بالإنترنت
  static Future<bool> hasInternetConnection() async {
    try {
      if (kIsWeb) {
        // في الويب، نفترض وجود اتصال
        return true;
      }

      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  /// التحقق من اتصال الشبكة مع إعادة المحاولة
  static Future<bool> checkConnectionWithRetry({int maxRetries = 3}) async {
    for (int i = 0; i < maxRetries; i++) {
      if (await hasInternetConnection()) {
        return true;
      }

      // انتظار قبل إعادة المحاولة
      await Future.delayed(Duration(seconds: 1 + i));
    }
    return false;
  }

  /// رسالة خطأ الاتصال
  static String getConnectionErrorMessage() {
    return 'لا يوجد اتصال بالإنترنت. يرجى التحقق من اتصالك والمحاولة مرة أخرى.';
  }

  /// رسالة تحذير الاتصال البطيء
  static String getSlowConnectionWarning() {
    return 'الاتصال بطيء. قد يستغرق تحميل التطبيق وقتاً أطول.';
  }
}
