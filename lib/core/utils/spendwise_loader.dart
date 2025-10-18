import 'package:flutter/material.dart';
import 'package:spendwise/core/constants/image_constant.dart';

class SpendwiseLoader extends StatelessWidget {
  const SpendwiseLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      width: 100,
      child: Stack(
        fit: StackFit.expand,
        alignment: Alignment.center,
        children: [
          UnconstrainedBox(
            child: ClipRRect(
              borderRadius: BorderRadiusGeometry.circular(100),
              child: Image.asset(ImageConstant.logo, height: 80),
            ),
          ),
          const CircularProgressIndicator(),
        ],
      ),
    );
  }
}
