import 'package:get_storage/get_storage.dart';
import '../app/utils/storage_keys.dart';

class StorageService {
  StorageService._();

  static final GetStorage _box = GetStorage();

  // ======================
  // Login
  // ======================

  static Future<void> saveLogin({
    required String token,
    required String user,
  }) async {
    await _box.write(StorageKeys.isLogin, true);
    await _box.write(StorageKeys.token, token);
    await _box.write(StorageKeys.user, user);
  }

  static bool get isLoggedIn => _box.read(StorageKeys.isLogin) ?? false;

  static String get token => _box.read(StorageKeys.token) ?? '';

  static String get user => _box.read(StorageKeys.user) ?? '';

  // ======================
  // Company
  // ======================

  /// True kalau user sudah pernah validasi/pilih company sebelumnya.
  static bool get isCompanySelected =>
      _box.read(StorageKeys.userCompany) != null;

  static String get userCompany => _box.read(StorageKeys.userCompany) ?? '';

  // ======================
  // Logout
  // ======================

  static Future<void> logout() async {
    await _box.remove(StorageKeys.isLogin);
    await _box.remove(StorageKeys.token);
    await _box.remove(StorageKeys.user);
    await _box.remove(
      StorageKeys.userCompany,
    ); // BARU: reset pilihan company juga
  }
}
