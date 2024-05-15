import 'package:flutter/material.dart';

class SharedAnimatedWrapper extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Axis direction;
  final bool isExpanded;

  const SharedAnimatedWrapper({
    required this.child,
    required this.duration,
    this.direction = Axis.horizontal,
    this.isExpanded = false,
    super.key,
  });

  @override
  State<SharedAnimatedWrapper> createState() => _AnimatedWrapperState();
}

class _AnimatedWrapperState extends State<SharedAnimatedWrapper>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _sizeAnimation;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _sizeAnimation =
        Tween<double>(begin: 0, end: 200).animate(_animationController);
    _fadeAnimation =
        Tween<double>(begin: 0, end: 1).animate(_animationController);

    if (widget.isExpanded) {
      _animationController.forward();
    }
  }

  @override
  void didUpdateWidget(SharedAnimatedWrapper oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isExpanded) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: AnimatedBuilder(
        animation: _sizeAnimation,
        builder: (context, child) {
          return SizedBox(
            width: widget.direction == Axis.horizontal
                ? _sizeAnimation.value
                : null,
            height:
                widget.direction == Axis.vertical ? _sizeAnimation.value : null,
            child: child,
          );
        },
        child: widget.child,
      ),
    );
  }
}
