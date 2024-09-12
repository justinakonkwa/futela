// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';

class NextButton extends StatelessWidget {
  NextButton({
    super.key,
    required this.onTap,
    required this.child,
    this.color,
    this.width,
  });

  final void Function()? onTap;
  final Widget child;
  Color? color;
  double? width;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        width: width,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: Theme.of(context).colorScheme.secondary,
          ),
          color: color ?? Theme.of(context).colorScheme.primary,
        ),
        // padding: const EdgeInsets.all(10),
        child: child,
      ),
    );
  }
}
