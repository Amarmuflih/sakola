import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sakola/app/routes/app_pages.dart';
// Pastikan path ke custom widget Anda benar
import '../../../widgets/custom_textfield_widget.dart';
import '../../../widgets/custom_elevationbuttom_widget.dart';
import '../controllers/sign_in_controller.dart';

class SignInView extends GetView<SignInController> {
  const SignInView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<SignInController>()) {
      Get.put(SignInController());
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 50),
                        // Logo Sakola
                        Center(
                          child: SizedBox(
                            width: 120,
                            height: 40,
                            child: Image.asset(
                              'lib/assets/images/logo.png',
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(
                                    Icons.school,
                                    size: 40,
                                    color: Color(0xFF31313E),
                                  ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 28),
                        const Center(
                          child: Text(
                            'Selamat Datang 👋',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Alexandria',
                              fontSize: 28,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF31313E),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Center(
                          child: Text(
                            'Isi email dan kata sandi untuk masuk ke aplikasi Sakola.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Alexandria',
                              fontSize: 16,
                              color: Colors.grey,
                              height: 1.4,
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),

                        // Label & CustomTextfieldWidget Email
                        const Text(
                          'Email',
                          style: TextStyle(
                            fontFamily: 'Alexandria',
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Obx(
                          () => CustomTextfieldWidget(
                            hint: 'ex: ortu / admin',
                            controller: controller.emailController,
                            keyboardType: TextInputType.emailAddress,
                            prefixIcon: const Icon(
                              Icons.email_outlined,
                              size: 20,
                            ),
                            errorText: controller.emailError.value,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Label & CustomTextfieldWidget Password
                        const Text(
                          'Kata sandi',
                          style: TextStyle(
                            fontFamily: 'Alexandria',
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Obx(
                          () => CustomTextfieldWidget(
                            hint: 'Ketik apa saja bebas',
                            controller: controller.passwordController,
                            obscureText: controller.isPasswordHidden.value,
                            prefixIcon: const Icon(
                              Icons.lock_outline,
                              size: 20,
                            ),
                            errorText: controller.passwordError.value,
                            suffixIcon: IconButton(
                              icon: Icon(
                                controller.isPasswordHidden.value
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                size: 20,
                              ),
                              onPressed: () =>
                                  controller.isPasswordHidden.toggle(),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Remember Me & Lupa Kata Sandi Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: Obx(
                                    () => Checkbox(
                                      value: controller.rememberMe.value,
                                      activeColor: const Color(0xFF9155DF),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      onChanged: (val) =>
                                          controller.rememberMe.value =
                                              val ?? false,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'Ingat saya',
                                  style: TextStyle(
                                    fontFamily: 'Alexandria',
                                    fontSize: 14,
                                    color: Color(0xFF31313E),
                                  ),
                                ),
                              ],
                            ),
                            TextButton(
                              onPressed: () {
                                Get.toNamed(Routes.FORGOT_PASSWORD);
                              },
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: const Size(0, 0),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: const Text(
                                'Lupa kata sandi',
                                style: TextStyle(
                                  fontFamily: 'Alexandria',
                                  color: Color(0xFF9155DF),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 32),

                        // Button Masuk
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: Obx(
                            () => CustomElevatedbuttonWidget(
                              isLoading: controller.isLoading.value,
                              onPressed: controller.loginProses,
                              backgroundColor: const Color(0xFF31313E),
                              borderSideColor: const Color(0xFF31313E),
                              borderRadiusGeometry: BorderRadius.circular(100),
                              padding: const EdgeInsets.symmetric(
                                vertical: 14,
                                horizontal: 16,
                              ),
                              child: const Text(
                                'Masuk',
                                style: TextStyle(
                                  fontFamily: 'Alexandria',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Belum punya akun? Daftar
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Belum punya akun? ',
                              style: TextStyle(
                                fontFamily: 'Alexandria',
                                fontSize: 14,
                                color: Color(0xFF31313E),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                // Arahkan ke menu daftar (Pastikan Routes.REGISTER sudah Anda buat)
                                // Get.toNamed(Routes.REGISTER);
                              },
                              child: const Text(
                                'Daftar',
                                style: TextStyle(
                                  fontFamily: 'Alexandria',
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Color(
                                    0xFF9155DF,
                                  ), // Warna ungu agar seragam
                                ),
                              ),
                            ),
                          ],
                        ),

                        const Spacer(),
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 24.0),
                            child: Text(
                              'versi 1.0.2-2024',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                                fontFamily: 'Alexandria',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
