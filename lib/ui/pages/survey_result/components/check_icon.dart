import 'package:flutter/material.dart';

class CheckIcon extends StatelessWidget {
  final bool active;

  const CheckIcon({required this.active});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Icon(
        Icons.check_circle,
        color: active
            ? Theme.of(context).highlightColor
            : Theme.of(context).disabledColor,
      ),
    );
  }
}