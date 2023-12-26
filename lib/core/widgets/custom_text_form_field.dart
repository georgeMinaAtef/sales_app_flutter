import 'package:flutter/material.dart';

import '../utils/styles.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    required this.controller,
    this.labelText,
    this.suffixIcon,
    this.prefixIcon,
    this.obscureText = false,
    this.border = const OutlineInputBorder(),
    this.maxLines = 1,
    this.validator,
    this.textInputType,
    this.onChange,
  });

  final TextEditingController controller;
  final TextInputType? textInputType;
  final String? labelText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool obscureText;
  final InputBorder? border;
  final int? maxLines;
  final  Function(String)? onChange;

  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: textInputType ?? TextInputType.emailAddress,
      validator: validator,
      maxLines: maxLines,
      onChanged: onChange,
      decoration: InputDecoration(
        labelText: labelText,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        border: border,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        errorStyle: Styles.textStyle16,
      ),
      style: Styles.textStyle18,
      obscureText: obscureText,
    );
  }
}
