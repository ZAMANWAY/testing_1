import 'package:flutter/material.dart';

class AppSizer extends InheritedWidget {
  final double screenWidth;
  final double screenHeight;
  final double scaleWidth;
  final double scaleHeight;
  final double designWidth;
  final double designHeight;

  final bool isTablet;
  final bool isPortrait;
  final bool isLandscape;

  const AppSizer({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
    required this.scaleWidth,
    required this.scaleHeight,
    required this.designWidth,
    required this.designHeight,
    required this.isTablet,
    required this.isPortrait,
    required this.isLandscape,
    required super.child,
  });

  static AppSizer of(BuildContext context) {
    final AppSizer? result =
        context.dependOnInheritedWidgetOfExactType<AppSizer>();
    assert(result != null, 'No AppSizer found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(AppSizer oldWidget) =>
      screenWidth != oldWidget.screenWidth ||
      screenHeight != oldWidget.screenHeight ||
      isTablet != oldWidget.isTablet ||
      isPortrait != oldWidget.isPortrait ||
      isLandscape != oldWidget.isLandscape;
}

class SizerBuilder extends StatelessWidget {
  final Widget child;
  const SizerBuilder({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final Orientation orientation = MediaQuery.of(context).orientation;

    double designWidth = 439;
    double designHeight = 956;

    final bool isTablet = size.shortestSide >= 600;
    final bool isPortrait = orientation == Orientation.portrait;
    final bool isLandscape = orientation == Orientation.landscape;

    if (isTablet) {
      designWidth = 800;
      designHeight = 1280;
    }

    if (isLandscape) {
      final double temp = designWidth;
      designWidth = designHeight;
      designHeight = temp;
    }

    final double scaleWidth = size.width / designWidth;
    final double scaleHeight = size.height / designHeight;

    return AppSizer(
      screenWidth: size.width,
      screenHeight: size.height,
      scaleWidth: scaleWidth,
      scaleHeight: scaleHeight,
      designWidth: designWidth,
      designHeight: designHeight,
      isTablet: isTablet,
      isPortrait: isPortrait,
      isLandscape: isLandscape,
      child: child,
    );
  }
}

extension SizerExtensions on num {
  double w(BuildContext context) => this * AppSizer.of(context).scaleWidth;
  double h(BuildContext context) => this * AppSizer.of(context).scaleHeight;
  double sp(BuildContext context) => this * AppSizer.of(context).scaleWidth;
}
