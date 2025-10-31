import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:proj1/pages/authentication.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/note_model.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(NoteAdapter());

  await Hive.openBox('movies');
  await Hive.openBox('libraries');
  await Hive.openBox<Note>('notes');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212), // Bookz-style dark
        primaryColor: const Color(0xFFB71C1C), // Deep red accent
        colorScheme: ColorScheme.dark(
          primary: const Color(0xFFB71C1C),
          secondary: const Color(0xFF1C1C1E),
          background: const Color(0xFF121212),
          surface: const Color(0xFF1C1C1E),
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white70),
          titleLarge: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 28,
          ),
        ),
      ),
      home: AnimatedSplashScreen(
        splash: const SplashContent(),
        splashIconSize: double.infinity,
        nextScreen: const Authentication(),
        duration: 3000,
        backgroundColor: Colors.transparent,
      ),
    );
  }
}

class SplashContent extends StatelessWidget {
  const SplashContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF1C1C1E),
            Color(0xFF121212),
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const ReadReflectLogo(),
            const SizedBox(height: 20),
            const Text(
              "Readn'Reflect",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ReadReflectLogo extends StatelessWidget {
  const ReadReflectLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      width: 160,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const RadialGradient(
          colors: [
            Color(0xFFB71C1C),
            Color(0xFF4A0D0D),
          ],
          center: Alignment.center,
          radius: 0.85,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.redAccent.withOpacity(0.4),
            blurRadius: 25,
            spreadRadius: 3,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Center(
        child: Icon(
          Icons.menu_book_rounded,
          color: Colors.white.withOpacity(0.95),
          size: 80,
        ),
      ),
    );
  }
}

