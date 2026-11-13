import 'dart:async';
import 'package:flutter/material.dart';
import '../services/prefs_service.dart';
import 'login_screen.dart';
import 'main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();
    
    _timer = Timer(const Duration(seconds: 2), _navigateNext);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _navigateNext() async {
    if (_hasNavigated) return;
    _hasNavigated = true;
    _timer?.cancel();

    final isLoggedIn = await PrefsService.isLoggedIn();
    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => isLoggedIn ? const MainScreen() : const LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const purplePrimary = Color(0xFF8B6CE8);
    const purpleDark = Color(0xFF2A2142);
    const lavenderBg = Color(0xFFE8E0FA);

    return Scaffold(
      backgroundColor: lavenderBg,
      body: Center(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: _navigateNext, 
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: purplePrimary.withValues(alpha: 0.18),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.science_rounded, 
                  size: 76,
                  color: purplePrimary,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'Rick & Morty Explorer',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: purpleDark.withValues(alpha: 0.75),
                  letterSpacing: 0.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}