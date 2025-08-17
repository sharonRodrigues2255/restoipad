import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// {@template splash_screen}
/// SplashScreen widget.
/// {@endtemplate}
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({
    super.key, 
  });

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      body: Center(
        child: Image.asset(
          'assets/images/splash.png',
          width: MediaQuery.of(context).size.width * .8,
          height: MediaQuery.of(context).size.height * .8,
        ),
      ),
    );
  }
}
