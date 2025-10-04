import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../core/config/export.dart';

class SecureStorageService {
  factory SecureStorageService() => _instance;
  SecureStorageService._internal();
  static final SecureStorageService _instance =
      SecureStorageService._internal();

  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  Future<void> write(String key, String value) =>
      _storage.write(key: key, value: value);
  Future<String?> read(String key) => _storage.read(key: key);
  Future<void> delete(String key) => _storage.delete(key: key);
  Future<void> deleteAll() => _storage.deleteAll();

  Future<bool> isLoggedIn() async {
    final String? token = await _storage.read(key: AppConfigs.tokenKey);
    return token != null && token.isNotEmpty;
  }
}
