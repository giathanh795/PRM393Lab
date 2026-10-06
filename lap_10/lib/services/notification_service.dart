import 'package:flutter/material.dart';

class NotificationItem {
  final String title;
  final String body;
  final DateTime timestamp;
  final IconData icon;

  const NotificationItem({
    required this.title,
    required this.body,
    required this.timestamp,
    this.icon = Icons.notifications_active,
  });
}

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final List<NotificationItem> _history = [];

  List<NotificationItem> get history => List.unmodifiable(_history);

  /// Lab 10.5: Trigger notification on key user action (e.g., Login success)
  void showNotification(
    BuildContext context, {
    required String title,
    required String body,
    IconData icon = Icons.check_circle_outline,
  }) {
    final item = NotificationItem(
      title: title,
      body: body,
      timestamp: DateTime.now(),
      icon: icon,
    );
    _history.insert(0, item);

    // Show floating top banner / SnackBar
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        backgroundColor: Colors.teal.shade800,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        content: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.white, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    body,
                    style: const TextStyle(fontSize: 12, color: Colors.white70),
                  ),
                ],
              ),
            ),
          ],
        ),
        duration: const Duration(seconds: 4),
      ),
    );
  }
}
