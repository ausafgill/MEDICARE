import 'package:flutter/material.dart';
import 'package:medicare/shared/constants/colors.dart';

class HelperTextField extends StatelessWidget {
  final String htxt;
  final TextEditingController controller;
  final IconData iconData;
  final bool obscure;
  final Function? validator;
  final Function? onChanged;
  final TextInputType keyboardType;
  const HelperTextField({
    super.key,
    required this.htxt,
    required this.iconData,
    required this.controller,
    required this.keyboardType,
    this.onChanged,
    this.obscure = false,
    this.validator,
  });

  valid(String? value) {
    if (validator == null) {
      return null;
    } else {
      return validator!(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: TextFormField(
        validator: (val) => valid(val),
        obscureText: obscure,
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: htxt,
          fillColor: EColors.white,
          filled: true,
          prefixIcon: Icon(iconData),
        ),
      ),
    );
  }
}
