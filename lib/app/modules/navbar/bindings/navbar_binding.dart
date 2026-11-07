import 'package:get/get.dart';
import 'package:sakola/app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:sakola/app/modules/navbar/controllers/navbar_controller.dart';

/// Binding buat route NAVBAR (shell utama app dengan bottom nav 4 tab).
///
/// PENTING: `NavbarView` pakai `IndexedStack`, yang artinya SEMUA halaman
/// tab (Home, Persetujuan, Laporan, Lainnya) langsung di-build begitu
/// `NavbarView` dibuka — bukan cuma tab yang lagi aktif. Jadi
/// `DashboardController` (dipakai tab Home) HARUS udah ke-daftar di sini,
/// bukan cuma diserahkan ke `DashboardBinding` di route terpisah — soalnya
/// route DASHBOARD yang lama itu gak lagi dilewatin begitu kamu masuk
/// lewat NAVBAR.
///
/// Kalau nanti tab Persetujuan/Laporan/Lainnya udah punya controller-nya
/// sendiri, tambahin `Get.lazyPut<...Controller>()` di sini juga.
class NavbarBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NavbarController>(() => NavbarController());
    Get.lazyPut<DashboardController>(() => DashboardController());
  }
}
