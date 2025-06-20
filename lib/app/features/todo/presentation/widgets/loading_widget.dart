import 'package:flutter/material.dart';

class CircularLoadingWidget extends StatelessWidget {
  final double? size;
  final Color? color;
  final double? value;

  const CircularLoadingWidget({
    super.key,
    this.size = 30,
    this.color = Colors.white,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: size,
        width: size,
        child: CircularProgressIndicator(
          value: value,
          backgroundColor: color ?? Colors.black,
          valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      ),
    );
  }
}
