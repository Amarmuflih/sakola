import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/splash_controller.dart';

class SplashView extends StatelessWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Memasukkan controller langsung di dalam build sesuai referensi Anda
    SplashController controller = Get.put(SplashController());

    return Scaffold(
      backgroundColor: Colors.white, // Latar belakang putih bersih
      body: SizedBox(
        width: Get.width,
        height: Get.height,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Logo Sakola diletakkan persis di tengah layar
            Container(
              constraints: const BoxConstraints(maxWidth: 200, maxHeight: 200),
              child: Image.asset(
                'lib/assets/images/logo.png', // Path asset logo Anda
                width: Get.width,
                height: Get.height,
                fit: BoxFit.contain,
              ),
            ),

            // Teks Versi diletakkan di bagian bawah layar secara reaktif
            Positioned(
              bottom: 32,
              child: Obx(() {
                return Text(
                  'version ${controller.version.value}',
                  style: const TextStyle(
                    color: Colors
                        .grey, // Warna abu-abu agar kontras dengan warna putih
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
