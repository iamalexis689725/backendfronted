import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SecureStorage {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  static Future<void> saveSession({
    required String token,
    required String role,
    required String name,
    required String email,
  }) async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
      await prefs.setString('role', role);
      await prefs.setString('name', name);
      await prefs.setString('email', email);
    } else {
      await Future.wait([
        _storage.write(key: 'token', value: token),
        _storage.write(key: 'role', value: role),
        _storage.write(key: 'name', value: name),
        _storage.write(key: 'email', value: email),
      ]);
    }
  }

  static Future<Map<String, String?>> getSession() async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      return {
        'token': prefs.getString('token'),
        'role': prefs.getString('role'),
        'name': prefs.getString('name'),
        'email': prefs.getString('email'),
      };
    }
    final results = await Future.wait([
      _storage.read(key: 'token'),
      _storage.read(key: 'role'),
      _storage.read(key: 'name'),
      _storage.read(key: 'email'),  
    ]);
    return {
      'token': results[0],
      'role': results[1],
      'name': results[2],
      'email': results[3],
    };
  }

  static Future<String?> getToken() async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('token');
    }
    return _storage.read(key: 'token');
  }

  static Future<void> clear() async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      await Future.wait([
        prefs.remove('token'),
        prefs.remove('role'),
        prefs.remove('name'),
        prefs.remove('email'),
      ]);
    } else {
      await _storage.deleteAll();
    }
  }
}