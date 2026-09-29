import 'package:flutter/material.dart';

void main() {
  runApp(const SignupApp());
}

/// Root Application
class SignupApp extends StatelessWidget {
  const SignupApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 7 - Signup Form with Validation & UX',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.light,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.indigo, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.redAccent),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.redAccent, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
      home: const SignupScreen(),
    );
  }
}

/// ============================================================================
/// Lab 7: SignupScreen (Forms, Validation, Focus, Async Check, Password Strength)
/// ============================================================================
class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // Step 2: GlobalKey for Form
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Text Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  // Step 5: FocusNodes for Keyboard Management
  final FocusNode _nameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();

  // Bonus UX State
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _agreedToTerms = false;
  bool _termsError = false;

  // Step 6: Async Email Check State
  bool _isCheckingEmail = false;

  @override
  void initState() {
    super.initState();
    // Rebuild when password changes to update strength indicator live
    _passwordController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();

    _nameFocus.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _confirmPasswordFocus.dispose();
    super.dispose();
  }

  // ===========================================================================
  // Step 3 & 4: Validation Functions (Separated for clarity)
  // ===========================================================================

  /// Validates Full Name (Required, minimum 2 characters)
  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Full Name is required';
    }
    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }

  /// Validates Email (Required, must contain '@' and '.')
  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    final email = value.trim();
    // Standard pattern requiring '@' and '.'
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    if (!emailRegex.hasMatch(email)) {
      return 'Enter a valid email address (e.g., user@example.com)';
    }
    return null;
  }

  /// Validates Password (Minimum 8 chars, at least 1 digit)
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must contain at least one digit (0-9)';
    }
    return null;
  }

  /// Validates Confirm Password (Must match password)
  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  /// Calculates Password Strength (Weak / Medium / Strong)
  int _getPasswordStrength(String password) {
    if (password.isEmpty) return 0;
    int score = 0;
    if (password.length >= 8) score++;
    if (RegExp(r'[0-9]').hasMatch(password)) score++;
    if (RegExp(r'[A-Z]').hasMatch(password)) score++;
    if (RegExp(r'[^A-Za-z0-9]').hasMatch(password)) score++;
    return score; // 0 to 4
  }

  // ===========================================================================
  // Step 6: Form Submission & Async Email Check
  // ===========================================================================
  Future<void> _submitForm() async {
    // Dismiss keyboard
    FocusScope.of(context).unfocus();

    // Check terms
    if (!_agreedToTerms) {
      setState(() {
        _termsError = true;
      });
    } else {
      setState(() {
        _termsError = false;
      });
    }

    // Run local synchronous validation
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid || !_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please correct the errors in the form before submitting.'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    // Save form state
    _formKey.currentState?.save();

    // Start Async Validation (Lab 7.4)
    setState(() {
      _isCheckingEmail = true;
    });

    final enteredEmail = _emailController.text.trim();

    // Simulate server API call (2 seconds delay)
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    // Fake condition: Emails starting with 'taken' are considered already registered
    if (enteredEmail.toLowerCase().startsWith('taken')) {
      setState(() {
        _isCheckingEmail = false;
      });

      _showErrorDialog(
        'Email Already Taken',
        'The email address "$enteredEmail" is already registered. Please use another email (Hint: don\'t start with "taken").',
      );
      return;
    }

    // Success!
    setState(() {
      _isCheckingEmail = false;
    });

    _showSuccessDialog();
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        icon: const Icon(Icons.error_outline, color: Colors.red, size: 48),
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        icon: const Icon(Icons.check_circle_outline, color: Colors.green, size: 54),
        title: const Text('Registration Successful!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Your account has been created with the following details:'),
            const SizedBox(height: 12),
            _infoRow('Name:', _nameController.text.trim()),
            _infoRow('Email:', _emailController.text.trim()),
            const SizedBox(height: 8),
            const Text(
              'A verification email has been dispatched to your inbox.',
              style: TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              _formKey.currentState?.reset();
              _nameController.clear();
              _emailController.clear();
              _passwordController.clear();
              _confirmPasswordController.clear();
              setState(() {
                _agreedToTerms = false;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigo,
              foregroundColor: Colors.white,
            ),
            child: const Text('Create Another Account'),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label ', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 13))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Step 5: Wrap screen in GestureDetector to unfocus keyboard when tapping outside
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FD),
        appBar: AppBar(
          title: const Text('Create Account', style: TextStyle(fontWeight: FontWeight.bold)),
          centerTitle: true,
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        body: SafeArea(
          // Avoid overflow when keyboard opens
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
                child: Form(
                  key: _formKey,
                  // Real-time validation feedback on user interaction
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Header card
                      _buildHeader(),

                      const SizedBox(height: 24),

                      // Field 1: Full Name
                      _buildFieldLabel('Full Name', Icons.person_outline),
                      TextFormField(
                        controller: _nameController,
                        focusNode: _nameFocus,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.name,
                        decoration: const InputDecoration(
                          hintText: 'John Doe',
                          prefixIcon: Icon(Icons.person, color: Colors.indigo),
                        ),
                        validator: _validateName,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_emailFocus);
                        },
                      ),

                      const SizedBox(height: 16),

                      // Field 2: Email
                      _buildFieldLabel('Email Address', Icons.email_outlined),
                      TextFormField(
                        controller: _emailController,
                        focusNode: _emailFocus,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          hintText: 'john.doe@example.com',
                          prefixIcon: Icon(Icons.email, color: Colors.indigo),
                          helperText: 'Tip: Emails starting with "taken" will simulate already-registered',
                        ),
                        validator: _validateEmail,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_passwordFocus);
                        },
                      ),

                      const SizedBox(height: 16),

                      // Field 3: Password
                      _buildFieldLabel('Password', Icons.lock_outline),
                      TextFormField(
                        controller: _passwordController,
                        focusNode: _passwordFocus,
                        textInputAction: TextInputAction.next,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          hintText: 'At least 8 characters & 1 digit',
                          prefixIcon: const Icon(Icons.lock, color: Colors.indigo),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword ? Icons.visibility_off : Icons.visibility,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ),
                        validator: _validatePassword,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_confirmPasswordFocus);
                        },
                      ),

                      // Password Strength Indicator Bar
                      _buildPasswordStrengthBar(),

                      const SizedBox(height: 16),

                      // Field 4: Confirm Password
                      _buildFieldLabel('Confirm Password', Icons.lock_reset),
                      TextFormField(
                        controller: _confirmPasswordController,
                        focusNode: _confirmPasswordFocus,
                        textInputAction: TextInputAction.done,
                        obscureText: _obscureConfirm,
                        decoration: InputDecoration(
                          hintText: 'Re-enter your password',
                          prefixIcon: const Icon(Icons.lock_reset, color: Colors.indigo),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureConfirm ? Icons.visibility_off : Icons.visibility,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureConfirm = !_obscureConfirm;
                              });
                            },
                          ),
                        ),
                        validator: _validateConfirmPassword,
                        onFieldSubmitted: (_) => _submitForm(),
                      ),

                      const SizedBox(height: 16),

                      // Terms and Conditions Checkbox
                      _buildTermsCheckbox(),

                      const SizedBox(height: 24),

                      // Submit Button with Loading State
                      _buildSubmitButton(),

                      const SizedBox(height: 16),

                      // Footer helper
                      Center(
                        child: Text(
                          'Lab 7 Demo: Form Validation & UX Management',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                          ),
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

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.indigo.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.indigo.withValues(alpha: 0.2)),
      ),
      child: const Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.indigo,
            radius: 24,
            child: Icon(Icons.app_registration, color: Colors.white, size: 26),
          ),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Join Us Today',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 2),
                Text(
                  'Fill in your details below to register your account.',
                  style: TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFieldLabel(String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0, left: 2.0),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.indigo),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
          const Text(' *', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildPasswordStrengthBar() {
    final password = _passwordController.text;
    if (password.isEmpty) return const SizedBox(height: 4);

    final score = _getPasswordStrength(password);
    String label = 'Weak';
    Color color = Colors.red;

    if (score == 2) {
      label = 'Fair';
      color = Colors.orange;
    } else if (score == 3) {
      label = 'Good';
      color = Colors.lightGreen;
    } else if (score >= 4) {
      label = 'Strong';
      color = Colors.green;
    }

    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 4.0, right: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Password Strength: $label',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              Text(
                '${(score / 4 * 100).toInt()}%',
                style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
              ),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: score / 4,
              minHeight: 6,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTermsCheckbox() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Checkbox(
              value: _agreedToTerms,
              activeColor: Colors.indigo,
              onChanged: (val) {
                setState(() {
                  _agreedToTerms = val ?? false;
                  if (_agreedToTerms) _termsError = false;
                });
              },
            ),
            const Expanded(
              child: Text(
                'I agree to the Terms of Service and Privacy Policy',
                style: TextStyle(fontSize: 13),
              ),
            ),
          ],
        ),
        if (_termsError)
          const Padding(
            padding: EdgeInsets.only(left: 12.0),
            child: Text(
              'You must accept the terms before proceeding',
              style: TextStyle(color: Colors.redAccent, fontSize: 12),
            ),
          ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      height: 52,
      child: ElevatedButton(
        onPressed: _isCheckingEmail ? null : _submitForm,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
          disabledBackgroundColor: Colors.indigo.withValues(alpha: 0.6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: _isCheckingEmail
            ? const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.5,
                    ),
                  ),
                  SizedBox(width: 12),
                  Text(
                    'Verifying Email...',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              )
            : const Text(
                'Sign Up',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
      ),
    );
  }
}
