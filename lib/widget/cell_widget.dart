import 'package:flutter/material.dart';

class CellWidget extends StatelessWidget {
  final int value;

  const CellWidget({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: _discColor,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.black26, width: 2),
          boxShadow: value == 0
              ? null
              : const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
        ),
      ),
    );
  }

  Color get _discColor {
    switch (value) {
      case 1:
        return Colors.redAccent;
      case 2:
        return Colors.yellow;
      default:
        return Colors.white;
    }
  }
}
