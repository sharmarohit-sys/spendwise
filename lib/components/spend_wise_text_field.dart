import 'package:flutter/material.dart';
import 'package:spendwise/constants/dimensions.dart';

class SpendWiseTextField extends StatelessWidget {
  const SpendWiseTextField({
    super.key,
    this.hintText,
    this.prefixIcon,
    this.controller,
  });
  final String? hintText;
  final Widget? prefixIcon;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimensions.borderRadius),
        ),
      ),
    );
  }
}
