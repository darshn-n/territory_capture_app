import 'package:flutter/material.dart';

class ControlButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onPressed;

  const ControlButton({
    super.key,
    required this.label,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: color),
      onPressed: onPressed,
      child: Text(label),
    );
  }
}
