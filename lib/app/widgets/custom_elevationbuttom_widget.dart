import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../utils/palette.dart';

/// Elevated button custom dengan state loading bawaan (pakai
/// [LoadingAnimationWidget]) dan border yang otomatis pudar kalau disabled.
class CustomElevatedbuttonWidget extends StatelessWidget {
  final Widget? child;
  final Color? backgroundColor;
  final Color? borderSideColor;
  final Color? disabledBackgroundColor;
  final double? borderSideWidth;
  final Function()? onPressed;
  final EdgeInsetsGeometry? padding;
  final BorderRadiusGeometry? borderRadiusGeometry;
  final bool isLoading;

  const CustomElevatedbuttonWidget({
    super.key,
    this.child,
    this.backgroundColor,
    this.borderSideColor,
    this.disabledBackgroundColor,
    this.borderSideWidth,
    this.onPressed,
    this.padding,
    this.borderRadiusGeometry,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        minimumSize: const Size(0, 0),
        elevation: 0,
        backgroundColor: backgroundColor ?? Palette.hexToColor('#347AE2'),
        disabledBackgroundColor:
            disabledBackgroundColor ?? Palette.hexToColor('#D0D5DD'),
        shadowColor: Colors.transparent,
        padding:
            padding ?? const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: (isLoading || onPressed == null)
                ? (disabledBackgroundColor ?? Palette.hexToColor('#D0D5DD'))
                : (borderSideColor ?? Palette.hexToColor('#347AE2')),
            width: borderSideWidth ?? 1,
          ),
          borderRadius: borderRadiusGeometry ?? BorderRadius.circular(8),
        ),
      ),
      child: isLoading
          ? LoadingAnimationWidget.discreteCircle(
              color: Palette.hexToColor('#FCFCFD'),
              size: 22.5,
            )
          : (child ?? const SizedBox()),
    );
  }
}
