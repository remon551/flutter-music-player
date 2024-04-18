import 'package:flutter/material.dart';

class InkWellContainer extends StatelessWidget {
  const InkWellContainer(
      {super.key,
      required this.color,
      this.onTap,
      required this.child,
      this.padding = 0.0,
      this.borderRadius = 0.0});

  final Color color;
  final void Function()? onTap;
  final Widget child;
  final double padding;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: Material(
        borderRadius: BorderRadius.all(
          Radius.circular(borderRadius),
        ),
        color: color,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.all(
            Radius.circular(borderRadius),
          ),
          child: Container(
              padding: EdgeInsets.all(padding),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.all(
                  Radius.circular(borderRadius),
                ),
              ),
              width: double.infinity,
              child: child),
        ),
      ),
    );
  }
}
