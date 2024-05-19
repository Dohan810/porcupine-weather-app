import 'package:flutter/material.dart';
import 'package:open_weather_example_flutter/shared/application/layout_provider.dart';
import 'package:provider/provider.dart';

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

  static const int mobileBreakpoint = 680;
  static const int tabletBreakpoint = 1024;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final layoutProvider = Provider.of<LayoutProvider>(context);

        if (constraints.maxWidth < mobileBreakpoint) {
          layoutProvider.setDeviceType(DeviceType.mobile);
          return mobileView;
        } else if (constraints.maxWidth < tabletBreakpoint) {
          layoutProvider.setDeviceType(DeviceType.tablet);
          return tabletView;
        } else {
          layoutProvider.setDeviceType(DeviceType.desktop);
          return desktopView;
        }
      },
    );
  }
}
