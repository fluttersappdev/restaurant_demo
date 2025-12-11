import 'package:flutter/material.dart';

class GlassMorphismCard extends StatelessWidget {
  final Widget child;
  final double width;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final Color backgroundColor;
  final double blur;
  final List<BoxShadow> boxShadow;
  final Border? border;
  final VoidCallback? onTap;

  const GlassMorphismCard({
    Key? key,
    required this.child,
    this.width = double.infinity,
    this.borderRadius = 16.0,
    this.padding = const EdgeInsets.all(16.0),
    this.margin = const EdgeInsets.all(0),
    this.backgroundColor = const Color(0xFFFFFFFF),
    this.blur = 10.0,
    this.boxShadow = const [
      BoxShadow(
        color: Color(0x0F000000),
        blurRadius: 10.0,
        spreadRadius: 0.0,
        offset: Offset(0, 4),
      ),
    ],
    this.border,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      margin: margin,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: backgroundColor.withOpacity(0.8),
              borderRadius: BorderRadius.circular(borderRadius),
              border: border,
              boxShadow: boxShadow,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(borderRadius),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
