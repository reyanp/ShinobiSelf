import 'dart:math';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

/// A widget that shows a confetti animation when triggered
class ConfettiOverlay extends StatefulWidget {
  final Widget child;
  final bool showConfetti;
  final Duration duration;
  final VoidCallback? onComplete;
  final double blastDirection;
  final BlastDirectionality blastDirectionality;

  const ConfettiOverlay({
    Key? key,
    required this.child,
    this.showConfetti = false,
    this.duration = const Duration(seconds: 2),
    this.onComplete,
    this.blastDirection = pi / 2, // upward
    this.blastDirectionality = BlastDirectionality.explosive,
  }) : super(key: key);

  @override
  State<ConfettiOverlay> createState() => _ConfettiOverlayState();
}

class _ConfettiOverlayState extends State<ConfettiOverlay> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: widget.duration,
    );

    if (widget.showConfetti) {
      _playConfetti();
    }
  }

  @override
  void didUpdateWidget(ConfettiOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.showConfetti && !oldWidget.showConfetti) {
      _playConfetti();
    }
  }

  void _playConfetti() {
    _confettiController.play();
    Future.delayed(widget.duration, () {
      if (widget.onComplete != null) {
        widget.onComplete!();
      }
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirection: widget.blastDirection,
            blastDirectionality: widget.blastDirectionality,
            particleDrag: 0.05,
            emissionFrequency: 0.05,
            numberOfParticles: 20,
            gravity: 0.2,
            shouldLoop: false,
            colors: const [
              Colors.green,
              Colors.blue,
              Colors.pink,
              Colors.orange,
              Colors.purple,
              Colors.red,
              Colors.yellow,
            ],
          ),
        ),
      ],
    );
  }
}
