import 'package:flutter/material.dart';

class AnimationWrapper extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Curve curve;

  const AnimationWrapper({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeInOut,
  });

  @override
  _AnimationWrapperState createState() => _AnimationWrapperState();
}

class _AnimationWrapperState extends State<AnimationWrapper>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return FadeTransition(
          opacity: _animation,
          child: ScaleTransition(
            scale: _animation,
            child: widget.child,
          ),
        );
      },
    );
  }
}
