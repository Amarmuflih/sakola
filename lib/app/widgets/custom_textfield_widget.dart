import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/palette.dart';

/// Text field custom dengan styling Sakola (border abu-abu, fokus ungu,
/// error merah) — biar semua form di app konsisten tanpa perlu nulis
/// `InputDecoration` panjang lebar tiap kali butuh text field.
///
/// Contoh pakai:
/// ```dart
/// CustomTextfieldWidget(
///   hint: 'Masukkan email',
///   controller: emailController,
///   keyboardType: TextInputType.emailAddress,
///   prefixIcon: const Icon(Icons.email_outlined, size: 20),
///   errorText: controller.emailError.value, // kosongin '' kalau gak error
/// )
/// ```
class CustomTextfieldWidget extends StatelessWidget {
  final String hint;
  final String errorText;
  final TextEditingController controller;
  final FocusNode? focus;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool obscureText;
  final bool? isReadOnly;
  final bool? enabled;
  final VoidCallback? onTap;
  final Function(String)? onSubmitted;
  final Function(String)? onChange;
  final Function(String)? validator;
  final int? maxLines;
  final EdgeInsets? scrollPadding;
  final Color? fillColor;
  final Color? disabledBorderColor;
  final double? maxWidthPrefixIcon;
  final double? maxWidthSuffixIcon;
  final double? maxHeightPrefixIcon;
  final double? maxHeightSuffixIcon;

  const CustomTextfieldWidget({
    super.key,
    required this.hint,
    this.errorText = '',
    this.suffixIcon,
    this.prefixIcon,
    required this.controller,
    this.focus,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatters,
    this.isReadOnly,
    this.enabled,
    this.onTap,
    this.onSubmitted,
    this.validator,
    this.onChange,
    this.maxLines = 1,
    this.scrollPadding,
    this.fillColor,
    this.disabledBorderColor,
    this.maxWidthPrefixIcon,
    this.maxWidthSuffixIcon,
    this.maxHeightPrefixIcon,
    this.maxHeightSuffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    // 1. Buat pengecekan: Jika errorText tidak kosong (termasuk spasi), berarti error.
    bool hasError = errorText.isNotEmpty;

    return TextFormField(
      obscureText: obscureText,
      readOnly: isReadOnly ?? false,
      controller: controller,
      focusNode: focus,
      keyboardType: keyboardType ?? TextInputType.text,
      textInputAction: textInputAction,
      textCapitalization: textCapitalization,
      inputFormatters: inputFormatters,
      maxLines: maxLines,
      onFieldSubmitted: onSubmitted != null ? (val) => onSubmitted!(val) : null,
      onChanged: onChange != null ? (val) => onChange!(val) : null,
      validator: validator != null ? (val) => validator!(val!) : null,
      scrollPadding: scrollPadding ?? const EdgeInsets.all(20),
      onTap: onTap,
      enabled: enabled ?? true,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: Palette.hexToColor('#182230'),
      ),
      decoration: InputDecoration(
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 0),

        // 2. MATIKAN errorText bawaan agar TIDAK ADA ruang tambahan di bawah
        // dan ikon/hint TIDAK ikut jadi merah
        errorText: null,

        hintText: hint,
        hintStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: Palette.hexToColor('#98A2B3'),
        ),
        fillColor:
            fillColor ??
            (enabled ?? true ? Colors.white : Palette.hexToColor('#D0D5DD')),
        filled: true,

        // 3. ATUR WARNA BORDER MANUAL:
        // Jika hasError = true, kasih warna merah (#FDA29B).
        // Jika false, kasih warna abu biasa (#D0D5DD).
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: hasError
                ? Palette.hexToColor('#FDA29B')
                : Palette.hexToColor('#D0D5DD'),
            width: 1,
          ),
        ),

        // Jika sedang di-klik (fokus) tapi posisinya error, tetap merah.
        // Jika tidak error, kasih warna ungu (#B692F6).
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: hasError
                ? Palette.hexToColor('#FDA29B')
                : ((isReadOnly ?? false)
                      ? Palette.hexToColor('#D0D5DD')
                      : Palette.hexToColor('#B692F6')),
            width: 1,
          ),
        ),

        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: disabledBorderColor ?? Palette.hexToColor('#D0D5DD'),
            width: 1,
          ),
        ),
        suffixIcon: suffixIcon == null
            ? null
            : Padding(
                padding: const EdgeInsets.only(right: 10, left: 8),
                child: suffixIcon,
              ),
        prefixIcon: prefixIcon == null
            ? null
            : Padding(
                padding: const EdgeInsets.only(left: 10, right: 8),
                child: prefixIcon,
              ),
        prefixIconConstraints: BoxConstraints(
          maxWidth: maxWidthPrefixIcon ?? 70,
          maxHeight: maxHeightPrefixIcon ?? 70,
        ),
        suffixIconConstraints: BoxConstraints(
          maxWidth: maxWidthSuffixIcon ?? 70,
          maxHeight: maxHeightSuffixIcon ?? 70,
        ),
      ),
    );
  }
}
