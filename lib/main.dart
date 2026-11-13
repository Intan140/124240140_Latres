import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/app_provider.dart';
import 'services/db_helper.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBHelper.initHive();

  runApp(
    ChangeNotifierProvider(
      create: (_) => AppProvider(),
      child: const RickAndMortyApp(),
    ),
  );
}

class RickAndMortyApp extends StatelessWidget {
  const RickAndMortyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const lavenderBg = Color(0xFFE8E0FA);
    const cardSurface = Color(0xFFFFFFFF);
    const purplePrimary = Color(0xFF8B6CE8);
    const purpleDark = Color(0xFF2A2142);

    return MaterialApp(
      title: 'Rick & Morty Explorer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: lavenderBg,
        colorScheme: ColorScheme.fromSeed(
          seedColor: purplePrimary,
          primary: purplePrimary,
          surface: cardSurface,
          onSurface: purpleDark,
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: lavenderBg,
          foregroundColor: purpleDark,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: purpleDark,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        cardTheme: CardThemeData(
          color: cardSurface,
          elevation: 2,
          shadowColor: purplePrimary.withValues(alpha: 0.15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: const BorderSide(color: Color(0xFFD5C8F5), width: 1),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: purplePrimary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            elevation: 0,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: cardSurface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFD5C8F5)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFD5C8F5)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: purplePrimary, width: 1.8),
          ),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}