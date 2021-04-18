import 'package:flutter/material.dart';

class SlidingAppBar extends PreferredSize {
  SlidingAppBar({
    @required this.child,
    @required this.controller,
    @required this.visible,
  });

  @override
  final PreferredSizeWidget child;

  @override
  Size get preferredSize => child.preferredSize;

  final AnimationController controller;
  final bool visible;

  @override
  Widget build(BuildContext context) {
    visible ? controller.reverse() : controller.forward();
    return SlideTransition(
      position: Tween<Offset>(begin: Offset.zero, end: Offset(0, -1)).animate(
        CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn),
      ),
      child: child,
    );
  }
}