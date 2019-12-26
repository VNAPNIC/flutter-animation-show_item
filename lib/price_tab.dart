import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animation_show_item/animated_dot.dart';

class PriceTab extends StatefulWidget {
  final double height;
  final VoidCallback onPlaneFlightStart;

  const PriceTab({Key key, this.height, this.onPlaneFlightStart})
      : super(key: key);

  @override
  _PriceTabState createState() => _PriceTabState();
}

class _PriceTabState extends State<PriceTab> with TickerProviderStateMixin {
  final double _initialPlanePaddingBottom = 16.0;
  final double _minPlanePaddingTop = 16.0;
  final List<int> _flightStops = [1, 2, 3, 4];
  final double _cardHeight = 100.0 + 20;

  AnimationController _planeTravelController;
  AnimationController _dotsAnimationController;
  Animation _planeTravelAnimation;

  List<Animation<double>> _dotPositions = [];

  double get _planeTopPadding =>
      _minPlanePaddingTop +
      (1 - _planeTravelAnimation.value) * _maxPlaneTopPadding;

  double get _maxPlaneTopPadding =>
      widget.height - _minPlanePaddingTop - _initialPlanePaddingBottom;

  @override
  void initState() {
    super.initState();
    _initPlaneTravelAnimations();
    _initDotAnimationController();
    _initDotAnimations();

    Future.delayed(Duration(milliseconds: 500), () {
      widget?.onPlaneFlightStart();
      _planeTravelController.forward();
    });
    Future.delayed(Duration(milliseconds: 700), () {
      _dotsAnimationController.forward();
    });
  }

  @override
  void dispose() {
    _planeTravelController.dispose();
    _dotsAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[_buildPlane()]
          ..addAll(_flightStops.map(_mapFlightStopToDot)),
      ),
    );
  }

  var colors = [Colors.red, Colors.amber, Colors.lightGreen, Colors.blue];

  Widget _mapFlightStopToDot(stop) {
    int index = _flightStops.indexOf(stop);
    return AnimatedDot(
      animation: _dotPositions[index],
      color: colors[index],
    );
  }

  Widget _buildPlane() {
    return AnimatedBuilder(
      animation: _planeTravelAnimation,
      child: Container(
          margin: EdgeInsets.all(20),
          height: 100.0,
          width: 100.0,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: DecoratedBox(
              decoration: BoxDecoration(color: Colors.black45),
            ),
          )),
      builder: (context, child) => Positioned(
        top: _planeTopPadding,
        child: child,
      ),
    );
  }

  _initPlaneTravelAnimations() {
    _planeTravelController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _planeTravelAnimation = CurvedAnimation(
      parent: _planeTravelController,
      curve: Curves.fastOutSlowIn,
    );
  }

  void _initDotAnimations() {
    //what part of whole animation takes one dot travel
    final double slideDurationInterval = 0.4;
    //what are delays between dot animations
    final double slideDelayInterval = 0.2;
    //at the bottom of the screen
    double startingMarginTop = widget.height;
    //minimal margin from the top (where first dot will be placed)
    double minMarginTop = _minPlanePaddingTop + 0.5 * (0.8 * _cardHeight);

    for (int i = 0; i < _flightStops.length; i++) {
      final start = slideDelayInterval * i;
      final end = start + slideDurationInterval;

      double finalMarginTop = minMarginTop + i * (0.8 * _cardHeight);
      Animation<double> animation = new Tween(
        begin: startingMarginTop,
        end: finalMarginTop,
      ).animate(
        new CurvedAnimation(
          parent: _dotsAnimationController,
          curve: new Interval(start, end, curve: Curves.easeOut),
        ),
      );
      _dotPositions.add(animation);
    }
  }

  void _initDotAnimationController() {
    _dotsAnimationController = new AnimationController(
        vsync: this, duration: Duration(milliseconds: 500));
  }
}
