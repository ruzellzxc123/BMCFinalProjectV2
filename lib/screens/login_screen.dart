// ...existing code...
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final userCred = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      debugPrint('LOGIN success -> uid: ${userCred.user?.uid ?? "null"}');
      debugPrint('CURRENT USER after login -> ${FirebaseAuth.instance.currentUser?.uid ?? "null"}');

      // NAVIGATE DIRECTLY as a reliable fallback so the app shows Home immediately
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/home');
      }

    } on FirebaseAuthException catch (e) {
      debugPrint('LOGIN FirebaseAuthException: code=${e.code} message=${e.message}');
      String message = e.message ?? 'An error occurred';
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), backgroundColor: Colors.red),
        );
      }
    } catch (e, st) {
      debugPrint('LOGIN error: $e\n$st');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('An error occurred'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
// ...existing code...

  static const Color _bgDark = Color(0xFF111111);
  static const Color _panel = Color(0xFFF7F3F2);
  static const Color _gold = Color(0xFFD4AF37);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 0,
      ),
      body: Stack(
        children: [
          // subtle background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0B0B0B), Color(0xFF221F20)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: Card(
                  color: _panel,
                  elevation: 12,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 28.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Logo / Title
                          SizedBox(
                            height: 64,
                            child: Row(
                              children: [
                                // if you have a logo: Image.asset('assets/images/logo.png', height: 48),
                                const Text(
                                  'ZellLux',
                                  style: TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1.2,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 18),
                          // Email
                          TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              labelStyle: const TextStyle(color: Colors.black54),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: _gold.withOpacity(0.12)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: _gold),
                              ),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) return 'Please enter your email';
                              if (!value.contains('@')) return 'Please enter a valid email';
                              return null;
                            },
                          ),
                          const SizedBox(height: 14),
                          // Password
                          TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              labelStyle: const TextStyle(color: Colors.black54),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: _gold.withOpacity(0.12)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: _gold),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) return 'Please enter your password';
                              if (value.length < 6) return 'Password must be at least 6 characters';
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _gold,
                                foregroundColor: Colors.black,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                elevation: 6,
                              ),
                              onPressed: _isLoading ? null : _login,
                              child: _isLoading
                                  ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2))
                                  : const Text('Login', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pushReplacementNamed('/signup');
                            },
                            child: Text(
                              "Don't have an account? Sign Up",
                              style: TextStyle(color: _gold.withOpacity(0.95)),
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
        ],
      ),
    );
  }
}
// ...existing code...