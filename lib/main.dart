import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ipadresto/shared/network/urls.dart';
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Indian Curry',
      theme: ThemeData(
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
      home: const SplashScreen(),
    );
  }
}
