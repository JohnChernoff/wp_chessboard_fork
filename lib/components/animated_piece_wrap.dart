library wp_chessboard;

import 'package:flutter/material.dart';
import 'package:wp_chessboard/models/chess_state.dart';

class AnimatedPieceWrap extends StatefulWidget {
  final Widget child;
  final StateEntry stateEntry;
  final double squareSize;
  final bool animated;
  final int aniMillis;

  const AnimatedPieceWrap({Key? key, required this.child, required this.stateEntry, required this.squareSize, required this.animated, this.aniMillis = 200}) : super(key: key);

  @override
  State<AnimatedPieceWrap> createState() => _AnimatedPieceWrapState();
}

class _AnimatedPieceWrapState extends State<AnimatedPieceWrap> {
  int rank = 0;
  int file = 0;

  @override
  void initState() {
    if (widget.animated) {
      SquarePosition? pos = widget.stateEntry.lastPosition();
      if (pos != null) {
        rank = pos.rank;
        file = pos.file;
      } else {
        rank = widget.stateEntry.position.rank;
        file = widget.stateEntry.position.file;
      }
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        setState(() {
          rank = widget.stateEntry.position.rank;
          file = widget.stateEntry.position.file;
        });
      });
    } else {
      rank = widget.stateEntry.position.rank;
      file = widget.stateEntry.position.file;
    }
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double left = (file) * widget.squareSize;
    double bottom = (rank) * widget.squareSize;

    return AnimatedPositioned(
      key: Key(widget.stateEntry.getKey() + "_a"),
      curve: Curves.easeInOut,
      duration: Duration(milliseconds: widget.aniMillis),
      bottom: bottom,
      left: left,
      child: widget.child
    );
  }
}

class CapturedPieceWrap extends StatefulWidget {
  final Widget child;
  final int aniMillis;
  final int rank;
  final int file;

  const CapturedPieceWrap({
    super.key,
    required this.child,
    required this.aniMillis,
    required this.rank,
    required this.file,
  });

  @override
  State<CapturedPieceWrap> createState() => _CapturedPieceWrapState();
}

class _CapturedPieceWrapState extends State<CapturedPieceWrap>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.aniMillis),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.file * widget.aniMillis.toDouble() * 0, // placeholder
      bottom: 0,
      child: FadeTransition(
        opacity: ReverseAnimation(_controller),
        child: widget.child,
      ),
    );
  }
}