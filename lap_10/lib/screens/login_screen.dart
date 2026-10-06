import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/auth_service.dart';
import '../services/notification_service.dart';
import 'home_screen.dart';
import 'independent_labs_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();
  final NotificationService _notificationService = NotificationService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _usernameController = TextEditingController(text: 'emilys');
  final TextEditingController _passwordController = TextEditingController(text: 'emilyspass');

  bool _obscurePassword = true;
  bool _rememberMe = true;
  bool _isLoading = false;
  String _selectedMode = 'dummyjson'; // 'dummyjson', 'mock', 'google'

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      User user;
      if (_selectedMode == 'dummyjson') {
        // Lab 10.2: Real REST API Login
        user = await _authService.realApiLogin(
          _usernameController.text.trim(),
          _passwordController.text.trim(),
        );
      } else {
        // Lab 10.1: Mock Login
        user = await _authService.mockLogin(
          _usernameController.text.trim(),
          _passwordController.text.trim(),
        );
      }

      // Lab 10.3: Session Management
      if (_rememberMe) {
        await _authService.saveSession(user);
      }

      if (!mounted) return;

      // Lab 10.5: Trigger Local Notification on successful login (LO7)
      _notificationService.showNotification(
        context,
        title: 'Login Successful! 🎉',
        body: 'Welcome back, ${user.fullName} (${user.username}).',
        icon: Icons.verified_user,
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen(user: user)),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$e'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _handleGoogleSignIn() async {
    setState(() => _isLoading = true);

    try {
      // Lab 10.4: Google Sign-In
      final user = await _authService.googleSignIn();

      if (_rememberMe) {
        await _authService.saveSession(user);
      }

      if (!mounted) return;

      // Lab 10.5: Trigger Notification
      _notificationService.showNotification(
        context,
        title: 'Google Sign-In Successful! 🚀',
        body: 'Authenticated as ${user.email}.',
        icon: Icons.g_mobiledata,
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen(user: user)),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Google Sign-In Failed: $e'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: AppBar(
        title: const Text('Authentication & Session'),
        backgroundColor: Colors.teal.shade700,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          TextButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const IndependentLabsScreen()),
              );
            },
            icon: const Icon(Icons.list_alt, color: Colors.white),
            label: const Text('Labs 10.1-5', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 450),
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Header
                      Center(
                        child: CircleAvatar(
                          radius: 32,
                          backgroundColor: Colors.teal.shade50,
                          child: Icon(Icons.lock_outline, size: 36, color: Colors.teal.shade700),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Welcome Back',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Select authentication provider to sign in',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                      ),
                      const SizedBox(height: 20),

                      // Provider Switcher
                      SegmentedButton<String>(
                        segments: const [
                          ButtonSegment(
                            value: 'dummyjson',
                            label: Text('10.2 Real API'),
                            icon: Icon(Icons.api),
                          ),
                          ButtonSegment(
                            value: 'mock',
                            label: Text('10.1 Mock'),
                            icon: Icon(Icons.code),
                          ),
                        ],
                        selected: {_selectedMode},
                        onSelectionChanged: (newSelection) {
                          setState(() {
                            _selectedMode = newSelection.first;
                            if (_selectedMode == 'dummyjson') {
                              _usernameController.text = 'emilys';
                              _passwordController.text = 'emilyspass';
                            } else {
                              _usernameController.text = 'student';
                              _passwordController.text = '123456';
                            }
                          });
                        },
                      ),

                      const SizedBox(height: 20),

                      // Username field
                      TextFormField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          labelText: 'Username',
                          prefixIcon: const Icon(Icons.person_outline),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          helperText: _selectedMode == 'dummyjson'
                              ? 'DummyJSON demo account: emilys'
                              : null,
                        ),
                        validator: (val) =>
                            (val == null || val.trim().isEmpty) ? 'Username is required' : null,
                      ),

                      const SizedBox(height: 16),

                      // Password field
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword ? Icons.visibility_off : Icons.visibility,
                            ),
                            onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                          ),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          helperText: _selectedMode == 'dummyjson'
                              ? 'Password: emilyspass'
                              : null,
                        ),
                        validator: (val) =>
                            (val == null || val.trim().isEmpty) ? 'Password is required' : null,
                      ),

                      const SizedBox(height: 12),

                      // Remember Me / Session persistence toggle (Lab 10.3)
                      Row(
                        children: [
                          Checkbox(
                            value: _rememberMe,
                            activeColor: Colors.teal.shade700,
                            onChanged: (val) => setState(() => _rememberMe = val ?? false),
                          ),
                          const Text('Keep me signed in (Auto-login)'),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Submit button
                      ElevatedButton(
                        onPressed: _isLoading ? null : _handleLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal.shade700,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                              )
                            : Text(
                                _selectedMode == 'dummyjson'
                                    ? 'Sign In via REST API'
                                    : 'Sign In (Mock)',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                      ),

                      const SizedBox(height: 16),

                      // Divider
                      const Row(
                        children: [
                          Expanded(child: Divider()),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text('OR', style: TextStyle(color: Colors.grey, fontSize: 12)),
                          ),
                          Expanded(child: Divider()),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Google Sign-In Button (Lab 10.4)
                      OutlinedButton.icon(
                        onPressed: _isLoading ? null : _handleGoogleSignIn,
                        icon: const Icon(Icons.g_mobiledata, size: 28, color: Colors.red),
                        label: const Text(
                          'Sign In with Google (Lab 10.4)',
                          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black87),
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
