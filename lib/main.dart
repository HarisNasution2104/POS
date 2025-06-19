import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'Register.dart';
import 'login.dart';
import 'home.dart';
import 'IntroScreen.dart'; // <- Tambahkan file ini
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Pastikan ini ada
  await initializeDateFormatting('id_ID', null);
  Intl.defaultLocale = 'id_ID'; // tambahkan ini
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'POS System',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder<Map<String, bool>>(
        future: _checkAppStatus(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (snapshot.hasData) {
            final seenIntro = snapshot.data!['seenIntro'] ?? false;
            final isLoggedIn = snapshot.data!['isLoggedIn'] ?? false;

            if (!seenIntro) {
              return const IntroScreen(); // Muncul hanya pertama kali
            } else if (isLoggedIn) {
              return const HomePage();
            } else {
              return const LoginPage();
            }
          } else {
            return const Scaffold(
              body: Center(child: Text('Error loading app status')),
            );
          }
        },
      ),
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/home': (context) => const HomePage(),
      },
    );
  }

  // Cek apakah intro sudah dilihat & user sudah login
  Future<Map<String, bool>> _checkAppStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final seenIntro = prefs.getBool('seenIntro') ?? false;
    final isLoggedIn = prefs.getBool('is_logged_in') ?? false;
    return {
      'seenIntro': seenIntro,
      'isLoggedIn': isLoggedIn,
    };
  }
}
