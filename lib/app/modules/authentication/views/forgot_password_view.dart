import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sakola/app/modules/authentication/controllers/forgot_password_controller.dart';
import 'package:sakola/app/widgets/custom_textfield_widget.dart';

import '../../../widgets/custom_elevationbuttom_widget.dart';

class ForgotPasswordView extends GetView<ForgotPasswordController> {
  const ForgotPasswordView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Memastikan controller di-load jika tidak menggunakan binding khusus
    Get.put(ForgotPasswordController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        // HAPUS Obx di sini, langsung pakai IconButton saja
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF31313E)),
          onPressed: () {
            // Logika tombol back tetap berjalan normal meski tanpa Obx
            if (controller.isEmailSent.value) {
              controller.isEmailSent.value = false;
            } else {
              Get.back();
            }
          },
        ),
        titleSpacing: 0,
      ),
      body: SafeArea(
        // Obx akan otomatis mengganti layar saat isEmailSent berubah jadi true
        child: Obx(() {
          return controller.isEmailSent.value
              ? _buildSuccessState()
              : _buildInputState();
        }),
      ),
    );
  }

  // --- TAMPILAN 1: FORM INPUT EMAIL ---
  Widget _buildInputState() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          const SizedBox(height: 40),
          const Text(
            'Lupa kata sandi',
            style: TextStyle(
              fontFamily: 'Alexandria',
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Color(0xFF31313E),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Masukkan alamat email untuk menerima link reset kata sandi.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Alexandria',
              fontSize: 14,
              color: Colors.grey,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 32),
          // Input Email — sekarang pakai CustomTextfieldWidget
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Email',
                style: TextStyle(
                  fontFamily: 'Alexandria',
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              CustomTextfieldWidget(
                hint: 'ex: budi@sakola.com',
                controller: controller.emailController,
                keyboardType: TextInputType.emailAddress,
                prefixIcon: const Icon(Icons.email_outlined, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 32),
          // Tombol Kirim — pakai CustomElevatedbuttonWidget, loading state
          // (spinner + auto-disable) udah ke-handle otomatis di dalamnya.
          // Catatan: `controller.isLoading.value` di sini tetap reaktif
          // karena _buildInputState() dipanggil di dalam Obx() milik
          // build() di atas.
          SizedBox(
            width: double.infinity,
            height: 52,
            child: CustomElevatedbuttonWidget(
              isLoading: controller.isLoading.value,
              onPressed: controller.sendResetLink,
              backgroundColor: const Color(0xFF31313E),
              borderSideColor: const Color(0xFF31313E),
              borderRadiusGeometry: BorderRadius.circular(9999),
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              child: const Text(
                'Kirim',
                style: TextStyle(
                  fontFamily: 'Alexandria',
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- TAMPILAN 2: EMAIL TERKIRIM ---
  Widget _buildSuccessState() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          // Icon Illustration (Amplop Ungu)
          Center(
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFFFBF9FF),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFF3E8FF), width: 2),
              ),
              child: const Icon(
                Icons.mark_email_read_outlined,
                size: 64,
                color: Color(0xFF9155DF),
              ),
            ),
          ),
          const SizedBox(height: 32),
          const Text(
            'Email Terkirim!',
            style: TextStyle(
              fontFamily: 'Alexandria',
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF31313E),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Link reset password sudah terkirim ke email Anda. Periksa email dan ikuti langkah-langkah untuk mengubah password.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Alexandria',
              fontSize: 14,
              color: Colors.grey,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 32),
          // Tombol Cek Email — sama, pakai CustomElevatedbuttonWidget
          // (gak ada loading state di tombol ini, jadi isLoading default
          // false aja).
          SizedBox(
            width: double.infinity,
            height: 52,
            child: CustomElevatedbuttonWidget(
              onPressed: () {
                // Nantinya bisa ditambahkan logika untuk membuka aplikasi Gmail/Email bawaan HP
                Get.snackbar(
                  'Info',
                  'Fitur buka aplikasi email belum diaktifkan',
                  snackPosition: SnackPosition.BOTTOM,
                );
              },
              backgroundColor: const Color(0xFF31313E),
              borderSideColor: const Color(0xFF31313E),
              borderRadiusGeometry: BorderRadius.circular(9999),
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              child: const Text(
                'Cek Email',
                style: TextStyle(
                  fontFamily: 'Alexandria',
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
