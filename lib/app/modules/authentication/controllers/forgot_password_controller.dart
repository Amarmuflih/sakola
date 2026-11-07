import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import '../../../../repository/authentication_repository.dart'; // Buka komen ini nanti

class ForgotPasswordController extends GetxController {
  // Panggil repository (Dimatikan sementara)
  // final AuthenticationRepository _authRepo = AuthenticationRepository();

  final TextEditingController emailController = TextEditingController();

  // Variabel reaktif untuk mengatur tampilan (pengganti setState)
  RxBool isLoading = false.obs;
  RxBool isEmailSent =
      false.obs; // Untuk switch dari halaman input ke halaman sukses

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }

  void sendResetLink() async {
    if (emailController.text.trim().isEmpty) {
      Get.snackbar(
        'Perhatian',
        'Email tidak boleh kosong.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
      return;
    }

    isLoading.value = true;

    // ==========================================
    // KODE SIMULASI (AKTIF SAAT INI)
    // ==========================================
    await Future.delayed(
      const Duration(seconds: 2),
    ); // Pura-pura loading 2 detik
    isEmailSent.value = true; // Langsung ubah layar ke halaman sukses
    isLoading.value = false;
    print("==================================================");
    print("✅ [DEBUG] SIMULASI EMAIL RESET PASSWORD TERKIRIM!");
    print("📧 Tujuan Email : ${emailController.text.trim()}");
    print("💻 Status UI    : Berhasil pindah ke halaman sukses");
    print("==================================================");
    // ==========================================
    // KODE API ASLI (BUKA KOMEN INI NANTI)
    // ==========================================
    /*
    try {
      var response = await _authRepo.forgotPassword(emailController.text.trim());
      
      if (response != null && response['status'] == 'success') {
        isEmailSent.value = true;
      } else {
        Get.snackbar(
          'Gagal',
          response['message'] ?? 'Terjadi kesalahan saat mengirim email.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
        );
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading.value = false;
    }
    */
  }
}
