import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sakola/loginpage/login.dart';
import 'package:sakola/loginpage/lupakatasandi.dart';
import 'package:sakola/main%20page%20manajeman/homepage.dart';
import 'package:sakola/main%20page%20manajeman/laporan.dart';
import 'package:sakola/main%20page%20manajeman/persetujuan.dart';
import 'package:sakola/main%20page%20orangtua/absensi.dart';
import 'package:sakola/main%20page%20orangtua/home%20page/cctv.dart';
import 'package:sakola/main%20page%20orangtua/home%20page/jadwal.dart';
import 'package:sakola/main%20page%20orangtua/home%20page/notifikasi.dart';
import 'package:sakola/main%20page%20orangtua/home%20page/recapnilai.dart';
import 'package:sakola/main%20page%20orangtua/home%20page/tugas.dart';
import 'package:sakola/main%20page%20orangtua/home.dart';
import 'package:sakola/main%20page%20orangtua/lainnya%20page/keamanan.dart';
import 'package:sakola/main%20page%20orangtua/lainnya%20page/pengaturan.dart';
import 'package:sakola/main%20page%20orangtua/lainnya.dart';
import 'package:sakola/main%20page%20orangtua/lainnya%20page/akunsaya.dart';
import 'package:sakola/main%20page%20orangtua/tagihan%20page/metodepembayaran.dart';
import 'package:sakola/main%20page%20orangtua/tagihan.dart';
import 'package:sakola/navigationpage/navigation.dart';
import 'package:sakola/start%20page/start.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: OnboardingScreen(),
      debugShowCheckedModeBanner: false,
      routes: {
        //navigation
        '/navigation': (context) => const MainNavigation(),

        //login
        '/login': (context) => const LoginScreen(),
        '/forgot-password': (context) => const ForgotPasswordScreen(),

        //start
        '/start': (context) => const OnboardingScreen(),

        //main page manajemen
        '/home_manajemen': (context) => const HomeManajemen(),
        '/persetujuan_manajemen': (context) => const Persetujuan(),
        '/laporan_manajemen': (context) => const Laporan(),

        //main page orangtua
        '/home': (context) => const HomePage(),
        '/tagihan': (context) => const Tagihan(),
        '/absensi': (context) => const Absensi(),
        '/lainnya': (context) => const MenuLainnya(),

        //metode pembayaran
        '/metode-pembayaran': (context) => const PaymentMethod(),

        //homepage
        '/cctv': (context) => const Cctv(),
        '/rekap-nilai': (context) => const RekapNilai(),
        '/jadwal': (context) => const JadwalPelajaran(),
        '/tugas': (context) => const Tugas(),
        '/notifikasi': (context) => const Notifikasi(),

        //pengaturan
        '/akun-saya': (context) => const AkunSaya(),
        '/keamanan': (context) => const Keamanan(),
        '/pengaturan': (context) => const Pengaturan(),
      },
    );
  }
}
