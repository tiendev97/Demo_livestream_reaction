import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

enum PathType {
  one,
  two,
}

class ReactionAnimationItem extends StatefulWidget {
  final double width;
  final double height;
  final int index;
  final Function(int index) animationEnded;
  final String icon;

  const ReactionAnimationItem({
    Key key,
    this.width,
    this.height,
    this.index,
    this.animationEnded,
    this.icon,
  }) : super(key: key);

  @override
  _ReactionAnimationItemState createState() => _ReactionAnimationItemState();
}

class _ReactionAnimationItemState extends State<ReactionAnimationItem>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  Animation animation;
  Path animationPath;
  double randomValue;
  int randomDuration;

  @override
  void initState() {
    super.initState();

    randomValue = Random().nextDouble();
    animationPath = randomValue > 0.5
        ? drawPath(widget.width, widget.height, PathType.one)
        : drawPath(widget.width, widget.height, PathType.two);
    randomDuration = randomValue > 0.5 ? 3000 : 5000;

    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: randomDuration),
    );
    animation = Tween(begin: 0.0, end: 1.0).animate(animationController)
      ..addListener(() {
        setState(() {});
      });

    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed &&
          widget.animationEnded != null) {
        widget.animationEnded(widget.index);
      }
    });

    Future.delayed(Duration(milliseconds: 250), () {
      animationController.forward();
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      overflow: Overflow.visible,
      children: [
        // Positioned(
        //   top: 0,
        //   child: CustomPaint(
        //     painter: PathPainter(animationPath),
        //   ),
        // ),
        Positioned(
          top: calculate(animation.value).dy ?? 0,
          left: calculate(animation.value).dx ?? 0,
          child: Opacity(
            opacity: (1 - animation.value) > 0.2 ? (1 - animation.value) : 0.2,
            child: SizedBox(
              width: (1 - animation.value) * 40,
              height: (1 - animation.value) * 40,
              child: Image.asset(widget.icon),
            ),
          ),
        ),
      ],
    );
  }

  Offset calculate(value) {
    PathMetrics pathMetrics = animationPath.computeMetrics();
    PathMetric pathMetric = pathMetrics.elementAt(0);
    value = pathMetric.length * value;
    Tangent pos = pathMetric.getTangentForOffset(value);
    return pos.position;
  }

  Path drawPath(width, height, pathType) {
    final random = Random().nextDouble();
    final xPos1 = pathType == PathType.one
        ? random * 0.5 * width
        : 0.5 * width * (1 + random);
    final xPos2 = pathType == PathType.one
        ? 0.5 * width * (1 + random)
        : random * 0.5 * width;

    final startYPos = height - 40 + random * 40;

    Path path = Path();
    path.moveTo(width / 2 - 40, startYPos);
    path.cubicTo(xPos1, 3 * height / 4, xPos2, height / 4, width / 2, 40);

    return path;
  }
}

class PathPainter extends CustomPainter {
  Path path;

  PathPainter(this.path);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    canvas.drawPath(this.path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
