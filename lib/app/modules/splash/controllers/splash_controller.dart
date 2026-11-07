import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sakola/app/routes/app_pages.dart';

import '../../../../services/storage_service.dart';

class SplashController extends GetxController {
  // Variabel reaktif untuk menampilkan versi di layar (dibaca oleh Obx di View)
  RxString version = 'Memuat...'.obs;

  @override
  void onInit() {
    super.onInit();
    getConfig();
  }

  void getConfig() async {
    try {
      // Mengambil versi asli dari sistem aplikasi
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      version.value = packageInfo.version;
      print('Versi Aplikasi Sakola: ${version.value}');
    } catch (e) {
      print('Gagal mengambil info versi: $e');
      version.value = '1.0.2'; // Fallback jika gagal
    }

    // Karena belum menggunakan API, kita langsung eksekusi fungsi pindah halaman
    toPage();
  }

  void toPage() async {
    await Future.delayed(const Duration(seconds: 3));

    if (StorageService.isLoggedIn && StorageService.isCompanySelected) {
      // Sudah login DAN sudah pilih company -> langsung dashboard
      Get.offAllNamed(Routes.NAVBAR); // Diarahkan ke halaman utama Sakola
    } else if (StorageService.isLoggedIn) {
      // Sudah login TAPI belum pilih company -> balik ke choose company
      Get.offAllNamed(Routes.CHOOSE_COMPANY);
    } else {
      // Belum login sama sekali
      Get.offAllNamed(Routes.WELCOME);
    }
  }
}
