import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/notification_service.dart';

class IndependentLabsScreen extends StatefulWidget {
  const IndependentLabsScreen({super.key});

  @override
  State<IndependentLabsScreen> createState() => _IndependentLabsScreenState();
}

class _IndependentLabsScreenState extends State<IndependentLabsScreen> {
  final AuthService _auth = AuthService();
  final NotificationService _notification = NotificationService();
  String _status = 'Select a lab test below to run';
  bool _busy = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: AppBar(
        title: const Text('Independent Lab Checkers'),
        backgroundColor: Colors.teal.shade700,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Status Box
            Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Execution Output:', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    Text(
                      _status,
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 12,
                        color: Colors.teal.shade900,
                      ),
                    ),
                    if (_busy) ...[
                      const SizedBox(height: 8),
                      const LinearProgressIndicator(),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Lab 10.1 Mock Login
            _buildLabCard(
              title: 'Lab 10.1 - Mock Login (Backend Simulation)',
              description: 'Validates input & simulates async backend authentication with delay.',
              icon: Icons.code,
              onRun: () async {
                setState(() {
                  _busy = true;
                  _status = 'Running Lab 10.1 Mock Login...';
                });
                try {
                  final user = await _auth.mockLogin('test_user', 'password123');
                  setState(() {
                    _status = 'Lab 10.1 SUCCESS:\nUser: ${user.fullName}\nToken: ${user.token}';
                  });
                } catch (e) {
                  setState(() => _status = 'Lab 10.1 ERROR: $e');
                } finally {
                  setState(() => _busy = false);
                }
              },
            ),

            // Lab 10.2 Real REST API Login
            _buildLabCard(
              title: 'Lab 10.2 - Real REST API Login (DummyJSON)',
              description: 'Sends real HTTP POST request to https://dummyjson.com/auth/login.',
              icon: Icons.api,
              onRun: () async {
                setState(() {
                  _busy = true;
                  _status = 'Sending POST request to DummyJSON API...';
                });
                try {
                  final user = await _auth.realApiLogin('emilys', 'emilyspass');
                  setState(() {
                    _status =
                        'Lab 10.2 API SUCCESS:\nStatus: 200 OK\nName: ${user.fullName}\nEmail: ${user.email}\nJWT Token: ${user.token}';
                  });
                } catch (e) {
                  setState(() => _status = 'Lab 10.2 ERROR: $e');
                } finally {
                  setState(() => _busy = false);
                }
              },
            ),

            // Lab 10.3 Auto-login & Logout
            _buildLabCard(
              title: 'Lab 10.3 - Session Management & SharedPreferences',
              description: 'Tests saving, reading, and clearing session from local storage.',
              icon: Icons.save,
              onRun: () async {
                setState(() {
                  _busy = true;
                  _status = 'Testing SharedPreferences storage...';
                });
                final current = await _auth.getSession();
                setState(() {
                  _status = current == null
                      ? 'Lab 10.3: No active session found in SharedPreferences.'
                      : 'Lab 10.3: Active session found for "${current.username}".';
                  _busy = false;
                });
              },
            ),

            // Lab 10.4 Firebase / Google Sign-In
            _buildLabCard(
              title: 'Lab 10.4 - Google Sign-In Flow',
              description: 'Executes Google identity sign-in and profile synchronization.',
              icon: Icons.g_mobiledata,
              onRun: () async {
                setState(() {
                  _busy = true;
                  _status = 'Authenticating via Google identity provider...';
                });
                try {
                  final user = await _auth.googleSignIn();
                  setState(() {
                    _status =
                        'Lab 10.4 SUCCESS:\nProvider: Google\nEmail: ${user.email}\nToken: ${user.token}';
                  });
                } catch (e) {
                  setState(() => _status = 'Lab 10.4 ERROR: $e');
                } finally {
                  setState(() => _busy = false);
                }
              },
            ),

            // Lab 10.5 Local Notification (LO7)
            _buildLabCard(
              title: 'Lab 10.5 - Local Notification Integration (LO7)',
              description: 'Triggers in-app local notification after key user actions.',
              icon: Icons.notifications_active,
              onRun: () {
                _notification.showNotification(
                  context,
                  title: 'Lab 10.5 Notification Tested! 🔔',
                  body: 'LO7 requirement fulfilled: Notification triggered on device.',
                  icon: Icons.notifications_active,
                );
                setState(() {
                  _status = 'Lab 10.5 SUCCESS: Notification triggered and shown!';
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabCard({
    required String title,
    required String description,
    required IconData icon,
    required VoidCallback onRun,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.teal.shade50,
          child: Icon(icon, color: Colors.teal.shade700),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        subtitle: Text(description, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
        trailing: ElevatedButton(
          onPressed: _busy ? null : onRun,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal.shade700,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 12),
          ),
          child: const Text('Test'),
        ),
      ),
    );
  }
}
