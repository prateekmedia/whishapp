import 'dart:async';
import 'package:flutter/material.dart';

class AdvancedGestureDetector extends StatelessWidget {
  final Widget child;
  final VoidCallback? onHold,
      onTap,
      onDoubleTap,
      onSwipeDown,
      onSwipeUp,
      onSwipeLeft,
      onSwipeRight;
  final Duration duration;
  final HitTestBehavior behavior;
  final double sensitivity;

  const AdvancedGestureDetector({
    Key? key,
    required this.child,
    this.duration = const Duration(milliseconds: 300),
    this.onHold,
    this.onTap,
    this.onSwipeUp,
    this.onSwipeDown,
    this.onSwipeLeft,
    this.onSwipeRight,
    this.onDoubleTap,
    this.behavior = HitTestBehavior.translucent,
    this.sensitivity = 8.0,
  })  : assert(sensitivity > 0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    late Timer timer;
    return GestureDetector(
      onLongPressStart:
          onHold != null ? (_) => timer = Timer(duration, onHold!) : null,
      onLongPressEnd: onHold != null ? (_) => timer.cancel() : null,
      onHorizontalDragUpdate: onSwipeRight != null || onSwipeLeft != null
          ? (event) {
              if (onSwipeRight != null && event.delta.dx > sensitivity) {
                onSwipeRight!();
              } else if (onSwipeLeft != null && event.delta.dx < -sensitivity) {
                onSwipeLeft!();
              }
            }
          : null,
      onVerticalDragUpdate: onSwipeUp != null || onSwipeDown != null
          ? (event) {
              if (onSwipeUp != null && event.delta.dy < -sensitivity) {
                onSwipeUp!();
              } else if (onSwipeDown != null && event.delta.dy > sensitivity) {
                onSwipeDown!();
              }
            }
          : null,
      onTap: onTap,
      onDoubleTap: onDoubleTap,
      behavior: behavior,
      child: child,
    );
  }
}
