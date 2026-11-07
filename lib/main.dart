import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:toastification/toastification.dart';
import 'app/routes/app_pages.dart'; // Pastikan import rute ini ditambahkan

void main() async {
  // Pastikan binding Flutter terinisialisasi sebelum menjalankan Firebase
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Firebase
  await Firebase.initializeApp();
  await GetStorage.init();
  await dotenv.load(fileName: ".env");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      child: GetMaterialApp(
        title: 'Sakola',
        debugShowCheckedModeBanner: false,

        // Tambahkan konfigurasi rute GetX di bawah ini
        initialRoute: AppPages.INITIAL, // Ini akan memanggil Routes.SPLASH
        getPages: AppPages.routes, // Mengambil daftar rute yang digenerate CLI
      ),
    );
  }
}
