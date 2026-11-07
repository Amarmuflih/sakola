import 'dart:convert';

import 'package:dio/dio.dart' as dio;
// import 'package:firebase_messaging/firebase_messaging.dart'; // Buka komen jika Firebase sudah disetup
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sakola/app/utils/global_fungtions.dart';

// PASTIKAN PATH IMPORT INI SESUAI DENGAN FOLDER ANDA

import '../../../../services/storage_service.dart';
import '../../../routes/app_pages.dart'; // Menggunakan route Sakola
import 'package:sakola/data/models/auntetication_model.dart';
import 'package:sakola/repository/auntetication_repository.dart';

import '../../../utils/storage_keys.dart';

class ChooseCompanyController extends GetxController {
  Rx<AuthenticationRepository> authenticationRepository =
      AuthenticationRepository().obs;

  Rx<ScrollController> chooseCompanySC = ScrollController().obs;

  // Menggunakan UserCompany sesuai model Sakola
  RxList<UserCompany> companies = <UserCompany>[].obs;

  RxBool isLoading = false.obs;

  RxString email = ''.obs;
  RxString name = ''.obs;

  RxMap argument = <String, dynamic>{}.obs;

  @override
  void onInit() {
    // Menangkap argumen jika ada (dari halaman sebelumnya)
    if (Get.arguments != null) {
      argument.value = Get.arguments;
      email.value = argument['email'] ?? '';
      name.value = argument['name'] ?? '';
    } else {
      // Fallback: Ambil dari GetStorage jika argumen kosong
      final box = GetStorage();
      var userStr = box.read('user');
      if (userStr != null) {
        var userData = jsonDecode(userStr);
        email.value = userData['email'] ?? '';
        name.value = userData['name'] ?? '';
      }
    }

    getList();
    super.onInit();
  }

  void getBack() async {
    var arg = Get.arguments;

    if (arg != null && arg['nav'] == 'from_register') {
      Get.offAllNamed(Routes.SIGN_IN);
    } else {
      final box = GetStorage();
      box.remove(StorageKeys.userCompany); // sebelumnya: 'user_company'
      Get.back();
    }
  }

  void getList() async {
    isLoading.value = true;

    try {
      // =======================================================
      // KODE API ASLI (Sesuai Referensi)
      // var res = await authenticationRepository.value.getCompany({});
      // companies.value = res;
      // =======================================================

      // KODE SAKOLA (Karena data perusahaan sudah ada saat login)
      final box = GetStorage();
      String? userDataString = box.read('user');
      if (userDataString != null) {
        Map<String, dynamic> userMap = jsonDecode(userDataString);
        if (userMap['user_companies'] != null) {
          var list = userMap['user_companies'] as List;
          companies.assignAll(
            list.map((e) => UserCompany.fromJson(e)).toList(),
          );
        }
      }

      isLoading.value = false;
    } on dio.DioException catch (e) {
      isLoading.value = false;
      GlobalFunctions.showToast(
        'Gagal',
        e.response?.statusMessage ?? 'Tidak bisa mengambil data',
        'error',
      );
    }
  }

  // Fungsi ini otomatis terpanggil dari View setelah user memilih company (menyimpan ID ke storage)
  void getDataUser() async {
    GlobalFunctions.globalLoading(isBack: false);

    // ==========================================================
    // KODE FIREBASE FCM (Dimatikan sementara agar tidak error)
    // ==========================================================
    /*
    if (Platform.isIOS) {
      NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(...);
      await FirebaseMessaging.instance.getAPNSToken();
    }
    String? fcmToken = await FirebaseMessaging.instance.getToken();
    */

    // ==========================================================
    // PROSES API MIGRATION & UPDATE USER (Sesuai Referensi)
    // ==========================================================
    /*
    try {
      var res = await authenticationRepository.value.getUserSetting();
      if (res.id != null) {
        await authenticationRepository.value.getMigrations();
        await authenticationRepository.value.updateUser({...});
        final box = GetStorage();
        box.write('user', jsonEncode(res));
      }
    } on dio.DioException catch (e) { ... }
    */

    // Pura-pura proses API sebentar
    await Future.delayed(const Duration(milliseconds: 500));
    Get.back(); // Tutup global loading

    // ==========================================================
    // KODE NAVIGASI DIMATIKAN SEMENTARA
    Get.offAllNamed(Routes.NAVBAR); // Diarahkan ke halaman utama Sakola

    // ==========================================================
  }

  // Helper untuk warna status (Sesuai referensi)
  Color statusBGColor(String status) {
    switch (status.toLowerCase()) {
      case 'trial':
        return Colors.yellow[700]!.withValues(alpha: 0.2);
      case 'awaiting payment':
        return Colors.grey[700]!.withValues(alpha: 0.2);
      case 'subscribe':
        return Colors.green[700]!.withValues(alpha: 0.2);
      case 'suspend':
        return Colors.red[700]!.withValues(alpha: 0.2);
      default:
        return Colors.white;
    }
  }

  Color statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'trial':
        return Colors.yellow[700]!;
      case 'awaiting payment':
        return Colors.grey[700]!;
      case 'subscribe':
        return Colors.green[700]!;
      case 'suspend':
        return Colors.red[700]!;
      default:
        return Colors.white;
    }
  }
}

logout() async {
  await StorageService.logout();
  Get.offAllNamed(Routes.SIGN_IN);
}
