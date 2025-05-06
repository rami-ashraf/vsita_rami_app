import 'package:flutter/material.dart';

class RoundedBackButton extends StatelessWidget {
  final Color backgroundColor;
  final Color iconColor;
  final Color borderColor;
  final double borderRadius;
  final double iconSize;
  final VoidCallback? onPressed;
  final EdgeInsetsGeometry padding;

  const RoundedBackButton({
    super.key,
    this.backgroundColor = Colors.white,
    this.iconColor = Colors.black,
    this.borderColor = const Color(0xFFE0E0E0),
    this.borderRadius = 12.0,
    this.iconSize = 20.0,
    this.onPressed,
    this.padding = const EdgeInsets.all( 5.0),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: borderColor,
          width: 1,
        ),
      ),
      child: IconButton(
        icon: Icon(Icons.arrow_back_ios,
            color: iconColor,
            size: iconSize),
        onPressed: onPressed ?? () {
          Navigator.maybePop(context);
        },
        //padding: padding,
        constraints: const BoxConstraints(),
      ),
    );
  }
}