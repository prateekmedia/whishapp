import 'dart:math';
import 'package:flutter/material.dart';

/// Build Context Extensions
extension ContextExtensions on BuildContext {
  TextTheme get textTheme => Theme.of(this).textTheme;
  ThemeData get theme => Theme.of(this);
  Brightness get brightness => Theme.of(this).brightness;
  bool get isDark => Theme.of(this).brightness == Brightness.dark;
  back([VoidCallback? after]) {
    if (after != null) after();
    Navigator.of(this).pop();
  }

  pushPage(Widget page) => Navigator.of(this).push(MaterialPageRoute(builder: (ctx) => page));

  MediaQueryData get queryData => MediaQuery.of(this);
  get isLandscape => queryData.orientation == Orientation.landscape;
  get width => queryData.size.width;
  get height => queryData.size.height;
}

/// Int Extensions
extension GetHumanizedFileSizeExtension on int {
  String getFileSize({int decimals = 1}) {
    if (this <= 0) return "0.0 KB";
    final suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
    var i = (log(this) / log(1024)).floor();
    return ((this / pow(1024, i)).toStringAsFixed(decimals)) + ' ' + suffixes[i];
  }
}
