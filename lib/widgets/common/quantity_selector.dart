import 'package:flutter/material.dart';
import '../../core/utils/app_theme.dart';

class QuantitySelector extends StatelessWidget {
  final int quantity;
  final Function(int) onQuantityChanged;
  final double? width;
  final double? height;
  final double borderRadius;

  const QuantitySelector({
    Key? key,
    required this.quantity,
    required this.onQuantityChanged,
    this.width,
    this.height,
    this.borderRadius = 8.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height ?? 36,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: InkWell(
              onTap: () => onQuantityChanged(quantity - 1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                bottomLeft: Radius.circular(8),
              ),
              child: Container(
                height: double.infinity,
                alignment: Alignment.center,
                child: const Icon(
                  Icons.remove,
                  size: 18,
                  color: AppTheme.lightTextColor,
                ),
              ),
            ),
          ),
          Container(
            width: 1,
            height: double.infinity,
            color: const Color(0xFFE2E8F0),
          ),
          Expanded(
            child: Container(
              height: double.infinity,
              alignment: Alignment.center,
              child: Text(
                '$quantity',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ),
          Container(
            width: 1,
            height: double.infinity,
            color: const Color(0xFFE2E8F0),
          ),
          Expanded(
            child: InkWell(
              onTap: () => onQuantityChanged(quantity + 1),
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
              child: Container(
                height: double.infinity,
                alignment: Alignment.center,
                child: const Icon(
                  Icons.add,
                  size: 18,
                  color: AppTheme.lightTextColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}