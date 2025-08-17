import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ipadresto/shared/network/urls.dart';
import 'package:ipadresto/view/splash_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  await Supabase.initialize(url: Urls.supabaseUrl, anonKey: Urls.supabaseKey);
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Restoadmin',
      debugShowCheckedModeBanner: false,
      builder: (context, child) => SplashScreen(),
    );
  }
}
