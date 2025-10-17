import 'dart:convert';
import 'package:kmonie/entities/user/user.dart';
import 'package:kmonie/core/services/services.dart';
import 'package:kmonie/core/di/di.dart';

class UserService {
  static const String _userKey = 'user_data';
  static const String _isLoggedInKey = 'is_logged_in';

  Future<void> saveUser(User user) async {
    final prefs = sl<SharedPreferencesService>();
    await prefs.writeString(_userKey, json.encode(user.toJson()));
    await prefs.writeBool(_isLoggedInKey, true);
  }

  Future<User?> getUser() async {
    try {
      final prefs = sl<SharedPreferencesService>();
      final userJson = await prefs.readString(_userKey);

      if (userJson != null) {
        final userMap = json.decode(userJson) as Map<String, dynamic>;
        return User.fromJson(userMap);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<bool> isLoggedIn() async {
    final prefs = sl<SharedPreferencesService>();
    return await prefs.readBool(_isLoggedInKey) ?? false;
  }

  Future<void> clearUser() async {
    final prefs = sl<SharedPreferencesService>();
    await prefs.delete(_userKey);
    await prefs.delete(_isLoggedInKey);
  }

  Future<void> updateUser(User user) async {
    await saveUser(user);
  }
}
