import 'package:flutter/material.dart';

/// ```
class CustomInkwellWidget extends StatelessWidget {
  const CustomInkwellWidget({
    super.key,
    this.child,
    this.onTap,
    this.onLongPress,
    this.onDoubleTap,
    this.borderRadius,
  });

  final Widget? child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final VoidCallback? onDoubleTap;

  /// Opsional — kasih ini kalau child-nya punya rounded corner, biar
  /// hit-area & (kalaupun ada) efek fokusnya ngikutin bentuk yang sama,
  /// gak kotak lurus nabrak sudut card.
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap ?? () {},
      onLongPress: onLongPress,
      onDoubleTap: onDoubleTap,
      borderRadius: borderRadius,
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: child ?? const SizedBox(),
    );
  }
}
