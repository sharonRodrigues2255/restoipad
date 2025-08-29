import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ipadresto/shared/network/urls.dart';
import 'package:ipadresto/shared/providers/theme_providers.dart';
import 'package:ipadresto/view/splash_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  await Supabase.initialize(url: Urls.supabaseUrl, anonKey: Urls.supabaseKey);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the theme provider
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Indian kitchen (Curry island)',

      theme: ThemeData(
        brightness: Brightness.light,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black, // icons & text
          elevation: 0,
        ),
        textTheme: TextTheme(
          headlineLarge: GoogleFonts.anton(
            fontSize: 60,
            color: Colors.red,
            letterSpacing: 2,
          ),
          titleMedium: GoogleFonts.montserrat(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: const Color(0xFFC5A25D),
            letterSpacing: 2,
          ),
        ),
      ),

      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        textTheme: TextTheme(
          headlineLarge: GoogleFonts.anton(
            fontSize: 60,
            color: Colors.white,
            letterSpacing: 2,
          ),
          titleMedium: GoogleFonts.montserrat(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: const Color(0xFFE0C97A),
            letterSpacing: 2,
          ),
        ),
        colorScheme: const ColorScheme.dark(
          primary: Colors.red,
          secondary: Colors.amber,
        ),
      ),

      themeMode: themeMode, // controlled by Riverpod
      home: const SplashScreen(),
    );
  }
}
