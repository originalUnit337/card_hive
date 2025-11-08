import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

class AppTransitions {
  static CustomTransitionPage<void> getTransitionPage(Widget child) {
    return CustomTransitionPage<void>(
      child: child,
      transitionDuration: const Duration(milliseconds: 200),
      reverseTransitionDuration: const Duration(milliseconds: 200),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1, 0);
        const end = Offset.zero;
        const curve = Curves.easeInOutCubic;
        final tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));

        final opacityTween = Tween<double>(
          begin: 0,
          end: 1,
        ).chain(CurveTween(curve: curve));
        final positionAnim = animation.drive(tween);
        final opacityAnim = animation.drive(opacityTween);
        return FadeTransition(
          opacity: opacityAnim,
          child: SlideTransition(position: positionAnim, child: child),
        );
      },
    );
  }
}
