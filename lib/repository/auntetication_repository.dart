import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:sakola/data/models/auntetication_model.dart';
import 'package:sakola/repository/api_respository.dart'; // Pastikan path ini sesuai

class AuthenticationRepository extends ApiRepository {
  // Method Login dihubungkan dengan model SignIn
  // Method Login dihubungkan dengan model SignIn
  Future<SignIn> login(String email, String password) async {
    try {
      // UBAH BARIS INI: dari 'api/login' menjadi 'login' saja
      final response = await postData(
        'login', // <--- Cukup tulis 'login'
        {'email': email, 'password': password},
        null,
        null,
        'req_login',
      );

      // MENGHUBUNGKAN KE MODEL:
      // Mengubah respons JSON mentah menjadi Objek SignIn yang rapi
      return signInFromJson(jsonEncode(response.data));
    } on DioException catch (e) {
      // Jika terjadi error dari server (misal password salah/email tidak ada)
      // Kita ambil pesan error-nya dan masukkan ke cetakan withError
      String errorMessage =
          e.response?.data?['message'] ?? 'Gagal menghubungi server';
      return SignIn.withError(errorMessage);
    } catch (e) {
      // Jika terjadi error sistem di HP
      return SignIn.withError('Error aplikasi: $e');
    }
  }

  // Method forgot password (sementara dibiarkan dynamic karena belum ada modelnya)
  Future<dynamic> forgotPassword(String email) async {
    try {
      final response = await postData('api/forgot-password', {'email': email});
      return response.data;
    } on DioException catch (e) {
      return e.response?.data;
    }
  }
}
