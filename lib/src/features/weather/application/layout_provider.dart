import 'package:flutter/material.dart';

enum DeviceType { mobile, tablet, desktop }

class LayoutProvider extends ChangeNotifier {
  DeviceType _deviceType = DeviceType.mobile;

  DeviceType get deviceType => _deviceType;

  void setDeviceType(DeviceType type) {
    if (_deviceType != type) {
      _deviceType = type;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    }
  }
}
