import 'package:flutter/material.dart';

class SharedResponsiveWrapper extends StatelessWidget {
  final Widget mobileView;
  final Widget tabletView;
  final Widget desktopView;

  const SharedResponsiveWrapper({
    super.key,
    required this.mobileView,
    required this.tabletView,
    required this.desktopView,
  });

  static const int mobileBreakpoint = 600;
  static const int tabletBreakpoint = 1024;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < mobileBreakpoint) {
          return mobileView;
        } else if (constraints.maxWidth < tabletBreakpoint) {
          return tabletView;
        } else {
          return desktopView;
        }
      },
    );
  }
}
