import 'package:flutter/material.dart';

class CustomCheckBox extends StatelessWidget {
  const CustomCheckBox({
    super.key,
    required this.onTap,
    required this.selected,
    required this.title,
  });

  final VoidCallback onTap;
  final bool selected;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            decoration: TextDecoration.none,
            color: Colors.black,
          ),
        ),
        GestureDetector(
          onTap: onTap,
          child: Icon(
            selected ? Icons.check_box : Icons.check_box_outline_blank,
            color: Colors.black,
            size: 26,
          ),
        ),
      ],
    );
  }
}
