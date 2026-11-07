import 'package:flutter/material.dart';

/// Helper warna terpusat buat seluruh app.
///
/// Kalau nanti ada warna tema lain yang dipakai berulang, taruh di sini
/// juga (misal: `static const primary = Color(0xFF347AE2);`) biar gak
/// nulis hex code manual di banyak file.
class Palette {
  Palette._();

  /// Konversi hex string ("#RRGGBB" atau "#AARRGGBB") jadi [Color].
  ///
  /// Contoh:
  /// ```dart
  /// Palette.hexToColor('#347AE2')       // opaque
  /// Palette.hexToColor('#80347AE2')     // dengan alpha channel
  /// ```
  static Color hexToColor(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
