import 'package:flutter/material.dart';
import '../services/db_helper.dart';
import '../services/prefs_service.dart';
import 'register_screen.dart';
import 'main_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _obscurePassword = true;

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      final username = _usernameController.text.trim();
      final password = _passwordController.text.trim();

      final isValid = await DBHelper.instance.loginUser(username, password);

      if (isValid) {
        await PrefsService.saveLoginSession(username);
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MainScreen()),
        );
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Username atau password salah!'),
            backgroundColor: Color(0xFFD96B8A),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const purplePrimary = Color(0xFF8B6CE8);
    const purpleDark = Color(0xFF2A2142);
    const purpleSoft = Color(0xFFEDE8FA);
    const lavenderBg = Color(0xFFE8E0FA);

    return Scaffold(
      backgroundColor: lavenderBg,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Card(
            color: Colors.white,
            elevation: 4,
            shadowColor: purplePrimary.withValues(alpha: 0.15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        color: purpleSoft,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.science_rounded,
                        size: 52,
                        color: purplePrimary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Rick & Morty Explorer',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: purpleDark,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Masuk ke portal dimensi Anda',
                      style: TextStyle(color: purpleDark.withValues(alpha: 0.6)),
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        labelText: 'Username',
                        prefixIcon: const Icon(Icons.person_outline, color: purplePrimary),
                        filled: true,
                        fillColor: const Color(0xFFF9F7FE),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(color: purplePrimary, width: 1.5),
                        ),
                      ),
                      validator: (val) => val == null || val.isEmpty ? 'Username wajib diisi' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock_outline, color: purplePrimary),
                        filled: true,
                        fillColor: const Color(0xFFF9F7FE),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(color: purplePrimary, width: 1.5),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                            color: purplePrimary,
                          ),
                          onPressed: () {
                            setState(() => _obscurePassword = !_obscurePassword);
                          },
                        ),
                      ),
                      validator: (val) => val == null || val.isEmpty ? 'Password wajib diisi' : null,
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: purplePrimary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: _isLoading ? null : _handleLogin,
                        child: _isLoading
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                              )
                            : const Text(
                                'LOGIN',
                                style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.5),
                              ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const RegisterScreen()),
                        );
                      },
                      child: const Text(
                        'Belum punya akun? Register di sini',
                        style: TextStyle(color: purplePrimary, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}