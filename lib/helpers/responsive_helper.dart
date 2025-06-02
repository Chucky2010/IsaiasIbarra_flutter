import 'package:flutter/material.dart';
import 'package:mi_proyecto/constants/responsive_breakpoints.dart';

class ResponsiveHelper {
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width > ResponsiveBreakpoints.desktop;
  }

  static bool isTablet(BuildContext context) {
    return MediaQuery.of(context).size.width > ResponsiveBreakpoints.tablet &&
           MediaQuery.of(context).size.width <= ResponsiveBreakpoints.desktop;
  }

  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width <= ResponsiveBreakpoints.tablet;
  }

  static double getContentPadding(BuildContext context) {
    if (isDesktop(context)) return 48;
    if (isTablet(context)) return 32;
    return 16;
  }

  static Widget withResponsiveWidth({
    required Widget child,
    required BuildContext context,
    double maxWidth = ResponsiveBreakpoints.maxContentWidth,
  }) {
    return Center(
      child: Container(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}