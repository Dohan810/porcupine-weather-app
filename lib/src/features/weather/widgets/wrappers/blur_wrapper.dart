import 'dart:ui';

import 'package:flutter/material.dart';

class BlurWrapper extends StatelessWidget {
  final Widget child;
  final bool inverted;

  const BlurWrapper({
    super.key,
    required this.child,
    this.inverted = false,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius:
          inverted ? BorderRadius.circular(0) : BorderRadius.circular(20.0),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: inverted
                ? Colors.white.withOpacity(0.3)
                : Colors.black.withOpacity(0.3),
            borderRadius: BorderRadius.circular(20.0),
            border: Border.all(
              color: inverted
                  ? Colors.black.withOpacity(0.2)
                  : Colors.white.withOpacity(0.2),
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
