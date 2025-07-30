import 'package:flutter/material.dart';
import 'package:meal_app_planner/widgets/connection_error_widget.dart';
import 'package:meal_app_planner/utils/network_utils.dart';

class ErrorScreen extends StatefulWidget {
  final String? errorMessage;
  final VoidCallback? onRetry;

  const ErrorScreen({super.key, this.errorMessage, this.onRetry});

  @override
  State<ErrorScreen> createState() => _ErrorScreenState();
}

class _ErrorScreenState extends State<ErrorScreen> {
  bool _isCheckingConnection = false;

  Future<void> _checkConnection() async {
    setState(() {
      _isCheckingConnection = true;
    });

    try {
      final hasConnection = await NetworkUtils.checkConnectionWithRetry();

      if (hasConnection && widget.onRetry != null) {
        widget.onRetry!();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(NetworkUtils.getConnectionErrorMessage()),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        _isCheckingConnection = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 250, 240),
      appBar: AppBar(
        title: const Text(
          'خطأ في الاتصال',
          style: TextStyle(fontSize: 24, color: Colors.orange),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body:
          _isCheckingConnection
              ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'جاري التحقق من الاتصال...',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              )
              : ConnectionErrorWidget(
                onRetry: _checkConnection,
                customMessage: widget.errorMessage,
              ),
    );
  }
}
