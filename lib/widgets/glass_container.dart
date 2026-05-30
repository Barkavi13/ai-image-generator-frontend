import 'dart:ui';

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class GlassContainer extends StatelessWidget {
  final Widget child;

  final double height;

  GlassContainer({required this.child, required this.height});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),

      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),

        child: Container(
          height: height,

          padding: EdgeInsets.all(20),

          decoration: BoxDecoration(
            color: AppColors.glassWhite,

            borderRadius: BorderRadius.circular(25),

            border: Border.all(color: AppColors.borderWhite),
          ),

          child: child,
        ),
      ),
    );
  }
}
