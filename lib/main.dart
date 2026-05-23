import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/login_screen.dart';
import 'services/theme_manager.dart';

void main() {
  runApp(const StudyHubApp());
}

class StudyHubApp extends StatefulWidget {
  const StudyHubApp({super.key});

  @override
  State<StudyHubApp> createState() => _StudyHubAppState();
}

class _StudyHubAppState extends State<StudyHubApp> {
  @override
  void initState() {
    super.initState();
    themeManager.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StudyHub',
      debugShowCheckedModeBanner: false,
      themeMode: themeManager.themeMode,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        textTheme: GoogleFonts.poppinsTextTheme(),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1A237E),
          primary: const Color(0xFF1A237E),
          secondary: const Color(0xFF0D47A1),
          background: const Color(0xFFF8F9FE),
        ),
        scaffoldBackgroundColor: const Color(0xFFF8F9FE),
        appBarTheme: AppBarTheme(
          backgroundColor: const Color(0xFF1A237E),
          foregroundColor: Colors.white,
          centerTitle: true,
          titleTextStyle: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
          elevation: 0,
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.dark,
          seedColor: const Color(0xFF1A237E),
          primary: const Color(0xFF9FA8DA),
          secondary: const Color(0xFFC5CAE9),
          surface: const Color(0xFF121212),
          background: const Color(0xFF121212),
          onPrimary: Colors.black,
          onSurface: Colors.white,
          onBackground: Colors.white,
        ),
        scaffoldBackgroundColor: const Color(0xFF121212),
        appBarTheme: AppBarTheme(
          backgroundColor: const Color(0xFF1E1E1E),
          foregroundColor: Colors.white,
          centerTitle: true,
          titleTextStyle: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        cardTheme: CardThemeData(
          color: const Color(0xFF1E1E1E),
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        iconTheme: const IconThemeData(color: Colors.white70),
      ),
      home: const LoginScreen(),
    );
  }
}
