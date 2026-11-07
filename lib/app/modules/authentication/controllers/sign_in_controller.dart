import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:sakola/app/routes/app_pages.dart';
import 'package:sakola/repository/auntetication_repository.dart';
import 'package:sakola/services/storage_service.dart';

class SignInController extends GetxController {
  final AuthenticationRepository _authRepo = AuthenticationRepository();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  RxBool isPasswordHidden = true.obs;
  RxBool rememberMe = false.obs;
  RxBool isLoading = false.obs;

  // State untuk notifikasi error di textfield
  RxString emailError = ''.obs;
  RxString passwordError = ''.obs;

  bool _isClosed = false;

  @override
  void onInit() {
    super.onInit();
    _loadSavedCredentials();
  }

  @override
  void onClose() {
    _isClosed = true;
    emailController.dispose();
    passwordController.dispose();
    _authRepo.dispose();
    super.onClose();
  }

  Future<void> _loadSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    if (_isClosed) return;

    emailController.text = prefs.getString('saved_email') ?? '';
    passwordController.text = prefs.getString('saved_password') ?? '';
    rememberMe.value = prefs.getBool('remember_me') ?? false;
  }

  Future<void> _handleSaveCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    if (_isClosed) return;

    if (rememberMe.value) {
      await prefs.setString('saved_email', emailController.text.trim());
      await prefs.setString('saved_password', passwordController.text.trim());
      await prefs.setBool('remember_me', true);
    } else {
      await prefs.remove('saved_email');
      await prefs.remove('saved_password');
      await prefs.setBool('remember_me', false);
    }
  }

  Future<void> loginProses() async {
    // 1. Reset error state setiap kali tombol ditekan
    emailError.value = '';
    passwordError.value = '';

    // 2. Validasi Input lokal
    bool isValid = true;
    String emailText = emailController.text.trim();

    // Cek Email Kosong & Validasi Format
    if (emailText.isEmpty) {
      emailError.value = 'Email tidak boleh kosong';
      isValid = false;
    } else if (!GetUtils.isEmail(emailText)) {
      emailError.value = 'Email tidak valid';
      isValid = false;
    }

    // Cek Password Kosong
    if (passwordController.text.trim().isEmpty) {
      passwordError.value = 'Kata sandi tidak boleh kosong';
      isValid = false;
    }

    if (!isValid) return; // Hentikan proses jika validasi gagal

    isLoading.value = true;
    await _handleSaveCredentials();
    if (_isClosed) return;

    try {
      final response = await _authRepo.login(
        emailText,
        passwordController.text.trim(),
      );

      if (_isClosed) return;

      // 3. JIKA LOGIN GAGAL DARI SERVER
      if (response.error != null) {
        // Kosongkan password agar tidak di-spam
        passwordController.clear();

        // Tampilkan notifikasi error dari atas kanan
        _showError('Username dan password tidak sesuai');
        return;
      }

      // Login berhasil
      if (response.accessToken != null &&
          response.accessToken!.isNotEmpty &&
          response.data != null) {
        await StorageService.saveLogin(
          token: response.accessToken!,
          user: jsonEncode(response.data!.toJson()),
        );

        Get.snackbar(
          "Login Berhasil",
          "Selamat datang ${response.data!.name}",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          margin: const EdgeInsets.only(top: 16, left: 16, right: 16),
          icon: const Icon(Icons.check_circle_outline, color: Colors.white),
        );

        Get.offAllNamed(Routes.CHOOSE_COMPANY);
      } else {
        passwordController.clear();
        _showError("Token tidak ditemukan.");
      }
    } catch (e) {
      debugPrint("LOGIN ERROR : $e");

      // Kosongkan password juga jika terjadi error sistem/jaringan
      passwordController.clear();

      _showError("Terjadi kesalahan sistem.");
    } finally {
      if (!_isClosed) {
        isLoading.value = false;
      }
    }
  }

  void _showError(String message) {
    // Menampilkan notifikasi popup (snackbar) dari atas kanan
    Get.snackbar(
      "Gagal",
      message,
      backgroundColor: Colors.red.shade600,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      maxWidth: 350,
      margin: const EdgeInsets.only(top: 24, right: 24),
      icon: const Icon(Icons.error_outline, color: Colors.white),
      duration: const Duration(seconds: 2),
      animationDuration: const Duration(milliseconds: 600),
      forwardAnimationCurve: Curves.easeOutBack,
    );
  }
}
