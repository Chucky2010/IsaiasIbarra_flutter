import 'package:flutter/material.dart';
import 'package:mi_proyecto/constants/responsive_breakpoints.dart';
import 'package:mi_proyecto/helpers/responsive_helper.dart';


class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final double? maxWidth;
  final EdgeInsetsGeometry? padding;

  const ResponsiveContainer({
    super.key,
    required this.child,
    this.maxWidth,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveHelper.withResponsiveWidth(
      context: context,
      maxWidth: maxWidth ?? ResponsiveBreakpoints.maxContentWidth,
      child: Padding(
        padding: padding ?? EdgeInsets.all(ResponsiveHelper.getContentPadding(context)),
        child: child,
      ),
    );
  }
}