import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final Function(String)? onChanged;
  final TextEditingController? controller;
  final TextInputType? textType;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final String? label;
  final int maxLines;

  const CustomTextField({
    super.key,
    this.onChanged,
    this.controller,
    this.textType,
    this.inputFormatters,
    this.validator,
    this.label,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if ((label ?? '').isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(
              label!,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                decoration: TextDecoration.none,
                color: Colors.black,
              ),
            ),
          ),
        TextFormField(
          keyboardType: textType ?? TextInputType.text,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          autocorrect: false,
          cursorColor: Colors.black,
          maxLines: maxLines,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            decoration: TextDecoration.none,
            color: Colors.black,
          ),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            filled: true,
            fillColor: Colors.white,
            border: outlineBorder,
            focusedBorder: outlineBorder,
            enabledBorder: outlineBorder,
            disabledBorder: outlineBorder,
          ),
          validator: validator,
          inputFormatters: inputFormatters,
          controller: controller,
          onChanged: onChanged,
        ),
      ],
    );
  }
}

final outlineBorder = OutlineInputBorder(
  borderSide: BorderSide(color: Colors.black.withValues(alpha: 0.3)),
  borderRadius: BorderRadius.circular(2),
);
