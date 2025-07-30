import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meal_app_planner/utils/network_utils.dart';

class AppUtils {
  /// عرض رسالة نجاح
  static void showSuccessMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// عرض رسالة خطأ
  static void showErrorMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// عرض رسالة تحذير
  static void showWarningMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.orange,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// عرض رسالة معلومات
  static void showInfoMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.blue,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// نسخ النص إلى الحافظة
  static Future<void> copyToClipboard(BuildContext context, String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    showSuccessMessage(context, 'تم نسخ النص إلى الحافظة');
  }

  /// التحقق من الاتصال وعرض رسالة مناسبة
  static Future<bool> checkConnectionAndShowMessage(
    BuildContext context,
  ) async {
    final hasConnection = await NetworkUtils.hasInternetConnection();

    if (!hasConnection) {
      showWarningMessage(context, NetworkUtils.getConnectionErrorMessage());
    }

    return hasConnection;
  }

  /// تنسيق التاريخ
  static String formatDate(DateTime date) {
    return '${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}';
  }

  /// تنسيق الوقت
  static String formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  /// التحقق من صحة البريد الإلكتروني
  static bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  /// التحقق من صحة كلمة المرور
  static bool isValidPassword(String password) {
    return password.length >= 6;
  }

  /// إنشاء لون عشوائي
  static Color getRandomColor() {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.red,
      Colors.teal,
      Colors.indigo,
      Colors.pink,
    ];
    return colors[DateTime.now().millisecond % colors.length];
  }
}
