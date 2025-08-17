import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
        primaryColor: const Color(0xC09A5D),
        scaffoldBackgroundColor: Colors.white,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Color(0x9C7147)),
          bodyMedium: TextStyle(color: Color(0x9C7147)),
        ),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: const Color(0xC09A5D),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
