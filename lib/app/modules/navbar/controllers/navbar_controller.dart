import 'package:get/get.dart';

/// Controller buat bottom navigation, cuma handle 1 hal: index tab yang
/// lagi aktif dari 4 tab (Home / Persetujuan / Laporan / Lainnya).
///
/// Sengaja dibikin RINGAN — kalau tiap tab butuh data sendiri (misal
/// Persetujuan butuh fetch list approval), taruh logic itu di controller
/// masing-masing halaman (mis. `ApprovalController`), BUKAN di sini.
/// `NavbarController` cuma tukang atur "lagi di tab yang mana".
class NavbarController extends GetxController {
  /// 0 = Home, 1 = Persetujuan, 2 = Laporan, 3 = Lainnya
  final RxInt indexPage = 0.obs;

  void changePage(int index) {
    if (indexPage.value == index) return;
    indexPage.value = index;
  }
}
