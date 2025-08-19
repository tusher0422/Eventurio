import 'package:flutter/material.dart';

class EventurioIcon extends StatelessWidget {
  final double size;
  final Color color;

  const EventurioIcon({
    this.size = 100,
    this.color = Colors.white,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.event_available,
      size: size,
      color: color,
    );
  }
}
