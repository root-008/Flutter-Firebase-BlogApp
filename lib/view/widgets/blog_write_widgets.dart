import 'package:blog_app/utils/themes/colors.dart';
import 'package:flutter/material.dart';

class BlogAddTextField extends StatelessWidget {
  const BlogAddTextField({
    super.key,
    required this.controller,
    required this.label,
    this.maxLines = 1,
    this.validator,
  });

  final TextEditingController controller;
  final String label;
  final int maxLines;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextFormField(
        controller: controller,
        style: const TextStyle(color: Colors.white, fontSize: 15),
        maxLines: maxLines,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          alignLabelWithHint: true,
          labelStyle: const TextStyle(
            color: UIColor.thirdColor,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: const BorderSide(
              color: UIColor.fourthColor,
            ),
          ),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide:
                  const BorderSide(color: UIColor.secondaryColor, width: 2)),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(color: Colors.red, width: 2)),
        ),
      ),
    );
  }
}
