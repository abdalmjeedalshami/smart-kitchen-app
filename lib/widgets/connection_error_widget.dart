import 'package:flutter/material.dart';
import 'package:meal_app_planner/utils/network_utils.dart';

class ConnectionErrorWidget extends StatelessWidget {
  final VoidCallback? onRetry;
  final String? customMessage;

  const ConnectionErrorWidget({super.key, this.onRetry, this.customMessage});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wifi_off, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              customMessage ?? NetworkUtils.getConnectionErrorMessage(),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            if (onRetry != null)
              ElevatedButton(
                onPressed: onRetry,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                ),
                child: const Text('إعادة المحاولة'),
              ),
          ],
        ),
      ),
    );
  }
}

class SlowConnectionWidget extends StatelessWidget {
  const SlowConnectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.orange.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_amber, color: Colors.orange, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              NetworkUtils.getSlowConnectionWarning(),
              style: const TextStyle(fontSize: 14, color: Colors.orange),
            ),
          ),
        ],
      ),
    );
  }
}
