import 'package:ap_common/resources/ap_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

extension NthuApIcon on ApIcon {
  static IconData get arrowRight {
    switch (ApIcon.code) {
      case ApIcon.filled:
        return Icons.arrow_circle_right;
      case ApIcon.outlined:
      default:
        return Icons.arrow_circle_right_outlined;
    }
  }
}