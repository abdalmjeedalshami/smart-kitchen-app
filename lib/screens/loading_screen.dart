import 'package:flutter/material.dart';
import 'package:meal_app_planner/utils/network_utils.dart';

class LoadingScreen extends StatefulWidget {
  final String? message;
  final Future<void> Function()? onLoad;

  const LoadingScreen({super.key, this.message, this.onLoad});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      // التحقق من الاتصال
      final hasConnection = await NetworkUtils.checkConnectionWithRetry();

      if (!hasConnection) {
        setState(() {
          _isLoading = false;
          _errorMessage = NetworkUtils.getConnectionErrorMessage();
        });
        return;
      }

      // تنفيذ العملية المطلوبة
      if (widget.onLoad != null) {
        await widget.onLoad!();
      }

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'حدث خطأ أثناء تحميل التطبيق: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 250, 240),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isLoading) ...[
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
              ),
              const SizedBox(height: 24),
              Text(
                widget.message ?? 'جاري تحميل التطبيق...',
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ] else if (_errorMessage != null) ...[
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                _errorMessage!,
                style: const TextStyle(fontSize: 16, color: Colors.red),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isLoading = true;
                    _errorMessage = null;
                  });
                  _initializeApp();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                ),
                child: const Text('إعادة المحاولة'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
