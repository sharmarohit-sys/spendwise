import 'package:flutter/material.dart';
import 'package:spendwise/core/constants/dimensions.dart';

class SpendWiseButton extends StatelessWidget {
  const SpendWiseButton({
    super.key,
    this.onTap,
    required this.title,
    this.isLoading = false,
  });

  final void Function()? onTap;

  final String title;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        width: double.infinity,
        height: Dimensions.padding * 12,
        decoration: BoxDecoration(
          color: colorScheme.primary,
          borderRadius: BorderRadius.circular(Dimensions.borderRadius),
        ),
        child: Center(
          child: isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : Text(
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
