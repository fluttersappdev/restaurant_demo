// lib/widgets/common/custom_button.dart
import 'package:flutter/material.dart';
import '../../core/utils/app_theme.dart';

class CustomButton extends StatelessWidget {
  final String text;
  // FIX: Changed VoidCallback to VoidCallback? to allow null (for disabled state)
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double? height;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final TextStyle? textStyle;
  final Widget? icon;
  final bool isOutlined;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed, // No change needed here
    this.isLoading = false,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height,
    this.borderRadius = 12.0,
    this.padding,
    this.textStyle,
    this.icon,
    this.isOutlined = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final buttonColor = backgroundColor ?? AppTheme.primaryColor;
    final buttonTextColor = textColor ?? Colors.white;

    return SizedBox(
      width: width,
      height: height ?? 50,
      child: Material(
        color: isOutlined ? Colors.transparent : buttonColor,
        borderRadius: BorderRadius.circular(borderRadius),
        child: InkWell(
          // The logic here already handles the null case correctly
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Container(
            padding: padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: isOutlined
                ? BoxDecoration(
              border: Border.all(color: buttonColor, width: 1.5),
              borderRadius: BorderRadius.circular(borderRadius),
            )
                : null,
            child: Center(
              child: isLoading
                  ? SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: isOutlined ? buttonColor : buttonTextColor,
                  strokeWidth: 2,
                ),
              )
                  : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    icon!,
                    const SizedBox(width: 8),
                  ],
                  Text(
                    text,
                    style: textStyle ??
                        Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: isOutlined ? buttonColor : buttonTextColor,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}