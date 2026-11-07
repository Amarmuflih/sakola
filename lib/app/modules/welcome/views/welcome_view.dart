import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../widgets/custom_elevationbuttom_widget.dart';
import '../controllers/welcome_controller.dart';
import '../../../routes/app_pages.dart'; // Pastikan path ini sesuai untuk memanggil Routes.SIGN_IN

class WelcomeView extends GetView<WelcomeController> {
  const WelcomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // 1. LOGO SAKOLA
            Padding(
              padding: const EdgeInsets.only(left: 24.0),
              child: SizedBox(
                width: 121,
                height: 28,
                child: Image.asset(
                  'lib/assets/images/logo.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // 2. TEXT HEADING
            Padding(
              padding: const EdgeInsets.only(left: 24.0),
              child: SizedBox(
                width: 364,
                child: RichText(
                  text: const TextSpan(
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF31313E),
                      height: 1.2,
                      fontFamily: 'Poppins',
                    ),
                    children: [
                      TextSpan(text: 'Solusi Cerdas untuk\n'),
                      TextSpan(
                        text: 'Manajemen Sekolah\n',
                        style: TextStyle(color: Color(0xFF9155DF)),
                      ),
                      TextSpan(text: 'di Era Digital'),
                    ],
                  ),
                ),
              ),
            ),

            // 3. GAMBAR TENGAH (FULL WIDTH)
            Expanded(
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(vertical: 20.0),
                child: Image.asset(
                  'lib/assets/images/welcome.png',

                  fit: BoxFit.fitWidth,
                  alignment: Alignment.center,
                ),
              ),
            ),

            // 4. TOMBOL MULAI SEKARANG — diganti pakai
            // CustomElevatedbuttonWidget biar konsisten sama tombol lain.
            // Gak ada state loading di tombol ini (langsung navigasi),
            // jadi `isLoading` dibiarin default false.
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Container(
                  width: double.infinity,
                  constraints: const BoxConstraints(maxWidth: 364),
                  height: 60,
                  child: CustomElevatedbuttonWidget(
                    onPressed: () {
                      // Menggunakan routing GetX ke halaman Login
                      Get.offNamed(Routes.SIGN_IN);
                    },
                    backgroundColor: const Color(0xFF31313E),
                    borderSideColor: const Color(0xFF31313E),
                    borderRadiusGeometry: BorderRadius.circular(9999),
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 16,
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Mulai Sekarang',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(
                          Icons.chevron_right,
                          color: Colors.white,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // 5. FOOTER VERSI
            const SizedBox(height: 16),
            const Center(
              child: Text(
                'versi 1.0.2-2024',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}