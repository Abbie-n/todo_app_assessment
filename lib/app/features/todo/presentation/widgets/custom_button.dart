import 'package:flutter/material.dart';
import 'package:todo_app_assessment/app/features/todo/presentation/widgets/loading_widget.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.loading = false,
  });

  final String text;
  final void Function()? onPressed;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: MaterialButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.transparent),
        ),
        elevation: 0,
        height: 48,
        minWidth: double.infinity,
        color: Colors.black,
        disabledColor: Colors.black.withValues(alpha: 0.5),
        onPressed: loading ? null : onPressed,
        child: Center(
          child:
              loading
                  ? const CircularLoadingWidget(size: 36)
                  : Text(
                    text,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      decoration: TextDecoration.none,
                      color: Colors.white,
                    ),
                  ),
        ),
      ),
    );
  }
}
