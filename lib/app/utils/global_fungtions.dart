import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:toastification/toastification.dart';
import 'package:path/path.dart' as path;

// Hapus import palette jika Anda belum punya filenya, kita ganti manual
// import 'palette.dart';

Color getRandomColor() {
  final random = Random();
  return Color.fromRGBO(
    random.nextInt(256),
    random.nextInt(256),
    random.nextInt(256),
    1.0,
  );
}

class GlobalFunctions {
  // --- 1. TOAST NOTIFICATION ---
  static void showToast(String title, String description, String type) {
    toastification.show(
      title: Text(title.capitalizeFirst!),
      description: Text(description),
      autoCloseDuration: const Duration(seconds: 3),
      showProgressBar: false,
      dragToClose: true,
      borderSide: const BorderSide(width: 1, color: Colors.transparent),
      style: ToastificationStyle.flat,
      type: type == 'error'
          ? ToastificationType.error
          : type == 'success'
          ? ToastificationType.success
          : ToastificationType.info,
      // Warna disesuaikan dengan hex
      backgroundColor: type == 'error'
          ? const Color(0xFFF04438)
          : type == 'success'
          ? const Color(0xFF17B26A)
          : const Color(0xFFFEF0C7),
      foregroundColor: type == 'warning'
          ? const Color(0xFF000000)
          : Colors.white,
      primaryColor: type == 'warning' ? const Color(0xFF000000) : Colors.white,
    );
  }

  // --- 2. GLOBAL LOADING ---
  static void globalLoading({
    bool isBack = true,
    String title = 'Memuat Data',
  }) {
    Get.dialog(
      PopScope(
        canPop: isBack,
        onPopInvokedWithResult: (bool didPop, result) {
          if (didPop) return;
          if (isBack) Get.back();
        },
        child: GestureDetector(
          onTap: () {
            if (isBack) Get.back();
          },
          child: Scaffold(
            backgroundColor: Colors.black.withValues(alpha: 0.3),
            body: SafeArea(
              child: Container(
                width: Get.width,
                decoration: const BoxDecoration(color: Colors.transparent),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(30),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Column(
                          children: [
                            LoadingAnimationWidget.discreteCircle(
                              color: const Color(0xFFFE3251), // Warna Sakola
                              size: Get.width * 0.1,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Text(
                                title,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // --- 3. UTILS LAINNYA ---
  static Future<File> uint8ListToFile(Uint8List uint8list) async {
    final tempDir = await getTemporaryDirectory();
    final tempPath = path.join(
      tempDir.path,
      'compressed_image_${DateTime.now().millisecondsSinceEpoch}.jpg',
    );
    File file = File(tempPath);
    await file.writeAsBytes(uint8list);
    return file;
  }

  static bool isIpad() {
    return Platform.isIOS && Get.mediaQuery.size.shortestSide > 600;
  }

  // --- 4. FORMAT WAKTU ---
  static Duration timeDifference(String startTime, String endTime) {
    final start = _parseTime(startTime);
    final end = _parseTime(endTime);
    Duration difference = end.difference(start);
    if (difference.isNegative)
      difference = difference + const Duration(hours: 24);
    return difference;
  }

  static DateTime _parseTime(String time) {
    List<String> parts = time.split(':');
    int hour = parts.isNotEmpty ? int.tryParse(parts[0]) ?? 0 : 0;
    int minute = parts.length > 1 ? int.tryParse(parts[1]) ?? 0 : 0;
    int second = parts.length > 2 ? int.tryParse(parts[2]) ?? 0 : 0;
    return DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      hour,
      minute,
      second,
    );
  }
}

// --- 5. FORMATTER UANG (RUPIAH) ---
class ThousandsSeparatorInputFormatter extends TextInputFormatter {
  static const separator = '.';

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) return newValue.copyWith(text: '');
    if (newValue.text[0] == '0') return const TextEditingValue(text: "0");

    String oldValueText = oldValue.text;
    String newValueText = newValue.text;

    if (oldValue.text.endsWith(separator) &&
        oldValue.text.length == newValue.text.length + 1) {
      newValueText = newValueText.substring(0, newValueText.length - 1);
    }

    if (oldValueText != newValueText) {
      int selectionIndex =
          newValue.text.length - newValue.selection.extentOffset;
      final chars = newValueText.split('');
      String newString = '';
      for (int i = chars.length - 1; i >= 0; i--) {
        if ((chars.length - 1 - i) % 3 == 0 && i != chars.length - 1) {
          newString = separator + newString;
        }
        newString = chars[i] + newString;
      }
      return TextEditingValue(
        text: newString,
        selection: TextSelection.collapsed(
          offset: newString.length - selectionIndex,
        ),
      );
    }
    return newValue;
  }
}
