import 'package:flutter/material.dart';
import 'package:spendwise/constants/dimensions.dart';

class SpendWiseButton extends StatelessWidget {
  const SpendWiseButton({super.key, this.onTap, required this.title});

  final void Function()? onTap;

  final String title;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: Dimensions.padding * 12,
        decoration: BoxDecoration(
          color: colorScheme.primary,
          borderRadius: BorderRadius.circular(Dimensions.borderRadius),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: colorScheme.onPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
