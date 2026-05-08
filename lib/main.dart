import 'package:flutter/material.dart';
import 'package:sakola/loginpage/login.dart';
import 'package:sakola/loginpage/lupakatasandi.dart';
import 'package:sakola/main%20page/absensi.dart';
import 'package:sakola/main%20page/home%20page/cctv.dart';
import 'package:sakola/main%20page/home.dart';
import 'package:sakola/main%20page/lainnya.dart';
import 'package:sakola/main%20page/tagihan%20page/metodepembayaran.dart';
import 'package:sakola/main%20page/tagihan.dart';
import 'package:sakola/navigationpage/navigation.dart';
import 'package:sakola/start.dart';

void main() {
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

        //main page
        '/home': (context) => const HomePage(),
        '/tagihan': (context) => const Tagihan(),
        '/absensi': (context) => const Absensi(),
        '/lainnya': (context) => const MenuLainnya(),

        //metode pembayaran
        '/metode-pembayaran': (context) => const PaymentMethod(),

        //homepage
        '/cctv': (context) => const Cctv(), // Ganti dengan halaman CCTV,
      }, // Ganti dengan halaman Tagihan},
    );
  }
}
