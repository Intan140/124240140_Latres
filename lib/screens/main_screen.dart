import 'package:flutter/material.dart';
import '../services/prefs_service.dart';
import 'home_screen.dart';
import 'episodes_screen.dart';
import 'favorite_screen.dart';
import 'login_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomeScreen(),
    EpisodeScreen(),
    FavoriteScreen(),
  ];

  final List<String> _titles = const [
    'Rick & Morty',
    'Episodes',
    'My Favorites',
  ];

  void _confirmLogout(BuildContext context) {
    const purpleDark = Color(0xFF2A2142);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Logout',
          style: TextStyle(fontWeight: FontWeight.bold, color: purpleDark),
        ),
        content: const Text('Yakin ingin keluar dari akun ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF8B6CE8),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () async {
              Navigator.pop(ctx);
              await PrefsService.logout();
              if (!context.mounted) return;
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
            child: const Text('Keluar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const purplePrimary = Color(0xFF8B6CE8);
    const purpleDark = Color(0xFF2A2142);
    const purpleSoft = Color(0xFFEDE8FA);
    const lavenderBg = Color(0xFFE8E0FA); 

    return Scaffold(
      backgroundColor: lavenderBg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          _titles[_currentIndex],
          style: const TextStyle(
            color: purpleDark,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        backgroundColor: Colors.white,
        indicatorColor: purpleSoft,
        elevation: 4,
        onDestinationSelected: (index) {
          if (index == 3) {
            _confirmLogout(context);
          } else {
            setState(() {
              _currentIndex = index;
            });
          }
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(Icons.home, color: purplePrimary),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.tv_outlined),
            selectedIcon: Icon(Icons.tv, color: purplePrimary),
            label: 'Episode',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_outline),
            selectedIcon: Icon(Icons.favorite, color: purplePrimary),
            label: 'Favorite',
          ),
          NavigationDestination(
            icon: Icon(Icons.logout_rounded, color: Color(0xFFD96B8A)),
            label: 'Logout',
          ),
        ],
      ),
    );
  }
}