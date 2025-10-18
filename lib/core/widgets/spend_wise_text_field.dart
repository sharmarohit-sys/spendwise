import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spendwise/core/constants/dimensions.dart';

class SpendWiseTextField extends StatelessWidget {
  const SpendWiseTextField({
    super.key,
    this.hintText,
    this.labelText,
    this.maxLength,
    this.prefixIcon,
    this.controller,
    this.keyboardType,
    this.validator,
    this.inputFormatters,
  });
  final String? hintText;
  final int? maxLength;
  final Widget? prefixIcon;
  final String? labelText;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      maxLength: maxLength,
      inputFormatters: inputFormatters,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        counterText: '',
        labelText: labelText,
        prefixIcon: prefixIcon,
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimensions.borderRadius),
        ),
      ),
    );
  }
}
