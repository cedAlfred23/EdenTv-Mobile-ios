import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class EdenAppSize {
  static getSize({
    required BuildContext context,
    double defaultValue = 60.0,
    double mobileValue = 40.0,
    double tabletValue = 80.0,
    double smallerThanMobileValue = 10.0,
    double largerThanTabbletValue = 80.0,
  }) {
    return ResponsiveValue(
      context,
      defaultValue: defaultValue,
      valueWhen: [
        Condition.equals(name: MOBILE, value: mobileValue),
        Condition.equals(name: TABLET, value: tabletValue),
        Condition.smallerThan(
          name: MOBILE,
          value: smallerThanMobileValue,
        ),
        Condition.largerThan(
          name: TABLET,
          value: largerThanTabbletValue,
        )
      ],
    ).value;
  }
}
