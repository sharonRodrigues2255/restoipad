import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NetworkService {
  static final NetworkService _instance = NetworkService._internal();
  factory NetworkService() => _instance;
  NetworkService._internal() {}

  Future<void> setAuthToken(
    String token,
    String name,
    String email,
    String type,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
    await prefs.setString('username', name);
    await prefs.setString('email', email);
    await prefs.setString('type', type);
  }

  void showToast(BuildContext? ctx, String msg, Color color) {
    if (ctx == null) return;
    final overlay = Overlay.maybeOf(ctx);
    if (overlay == null) return;

    final entry = OverlayEntry(
      builder:
          (context) => Positioned(
            top: 30,
            right: 30,
            child: Material(
              color: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  msg,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
            ),
          ),
    );

    overlay.insert(entry);
    Future.delayed(const Duration(seconds: 2), () => entry.remove());
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('loggedIn') ?? false;
  }
}
