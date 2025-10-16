import 'package:flutter/material.dart';
import 'package:spendwise/core/constants/dimensions.dart';

class SpendWiseTextField extends StatelessWidget {
  const SpendWiseTextField({
    super.key,
    this.hintText,
    this.prefixIcon,
    this.controller,
    this.validator,
  });
  final String? hintText;
  final Widget? prefixIcon;
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
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
