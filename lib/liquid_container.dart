library liquid_container;

import 'dart:math';
import 'package:flutter/material.dart';

class ContainerLiquidFill extends StatefulWidget {
  final Duration loadDuration;
  final Duration waveDuration;

  final double boxHeight;

  final double boxWidth;

  final Color boxBackgroundColor;

  final Color waveColor;

  final double loadUntil;
  final String image;

  ContainerLiquidFill({
    Key? key,
    this.loadDuration = const Duration(seconds: 6),
    this.waveDuration = const Duration(seconds: 4),
    required this.boxHeight,
    required this.boxWidth,
    required this.boxBackgroundColor,
    required this.waveColor,
    required this.image,
    this.loadUntil = 1.0,
  })  : assert(loadUntil > 0 && loadUntil <= 1.0),
        super(key: key);

  @override
  _ContainerLiquidFillState createState() => _ContainerLiquidFillState();
}

class _ContainerLiquidFillState extends State<ContainerLiquidFill>
    with TickerProviderStateMixin {
  final _containerKey = GlobalKey();

  late AnimationController _waveController, _loadController;

  late Animation<double> _loadValue;

  @override
  void initState() {
    super.initState();

    _waveController = AnimationController(
      vsync: this,
      duration: widget.waveDuration,
    );

    _loadController = AnimationController(
      vsync: this,
      duration: widget.loadDuration,
    );
    _loadValue = Tween<double>(
      begin: 0.0,
      end: widget.loadUntil,
    ).animate(_loadController);
    if (1.0 == widget.loadUntil) {
      _loadValue.addStatusListener((status) {
        if (AnimationStatus.completed == status) {
          // Stop the repeating wave when the load has completed to 100%
          _waveController.stop();
        }
      });
    }

    _waveController.repeat();
    _loadController.forward();
  }

  @override
  void dispose() {
    _waveController.dispose();
    _loadController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        SizedBox(
          height: widget.boxHeight,
          width: widget.boxWidth,
          child: AnimatedBuilder(
            animation: _waveController,
            builder: (BuildContext context, Widget? child) {
              return CustomPaint(
                painter: _WavePainter(
                  containerKey: _containerKey,
                  waveValue: _waveController.value,
                  loadValue: _loadValue.value,
                  boxHeight: widget.boxHeight,
                  waveColor: widget.waveColor,
                ),
              );
            },
          ),
        ),
        SizedBox(
          height: widget.boxHeight,
          width: widget.boxWidth,
          child: ShaderMask(
            blendMode: BlendMode.srcOut,
            shaderCallback: (bounds) => LinearGradient(
              colors: [widget.boxBackgroundColor],
              stops: [0.0],
            ).createShader(bounds),
            child: Stack(
              children: [
                Container(
                  width: widget.boxWidth,
                  height: widget.boxHeight,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(widget.image), fit: BoxFit.cover)),
                ),
                Container(
                  margin: EdgeInsets.only(top: 30),
                  key: _containerKey,
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}

class _WavePainter extends CustomPainter {
  static const _pi2 = 2 * pi;
  final GlobalKey containerKey;
  final double waveValue;
  final double loadValue;
  final double boxHeight;
  final Color waveColor;

  _WavePainter({
    required this.containerKey,
    required this.waveValue,
    required this.loadValue,
    required this.boxHeight,
    required this.waveColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final RenderBox? textBox =
        containerKey.currentContext!.findRenderObject() as RenderBox;
    if (textBox == null) return;
    final textHeight = textBox.size.height;
    final baseHeight =
        (boxHeight / 2) + (textHeight / 2) - (loadValue * textHeight);

    final width = size.width;
    final height = size.height;
    final path = Path();
    path.moveTo(0.0, baseHeight);
    for (var i = 0.0; i < width; i++) {
      path.lineTo(i, baseHeight + sin(_pi2 * (i / width + waveValue)) * 8);
    }

    path.lineTo(width, height);
    path.lineTo(0.0, height);
    path.close();
    final wavePaint = Paint()..color = waveColor;
    canvas.drawPath(path, wavePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
