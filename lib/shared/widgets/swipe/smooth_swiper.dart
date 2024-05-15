import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class SharedSwipingContainers extends StatefulWidget {
  final List<Widget> pages;

  const SharedSwipingContainers({super.key, required this.pages});

  @override
  _SharedSwipingContainersState createState() =>
      _SharedSwipingContainersState();
}

class _SharedSwipingContainersState extends State<SharedSwipingContainers> {
  final PageController _controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          constraints: const BoxConstraints(maxHeight: 250),
          child: PageView(
            pageSnapping: true,
            controller: _controller,
            children: widget.pages,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SmoothPageIndicator(
            controller: _controller,
            count: widget.pages.length,
            effect: const WormEffect(
              dotHeight: 12,
              dotWidth: 12,
              activeDotColor: Colors.blue,
            ),
          ),
        ),
      ],
    );
  }
}
