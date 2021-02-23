import 'dart:math';

import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';

enum Coppe {
  /// 黑桃
  spade,

  /// 红桃
  heart,

  /// 方块
  diamond,

  /// 梅花
  club,
}

class CardValue {
  /// 从 1 ~ 15
  final int value;

  final Coppe coppe;

  CardValue(this.value, this.coppe) : assert(value >= 1 && value <= 13);

  String value2Text() {
    if (value == 1) {
      return "A";
    } else if (value > 1 && value < 11) {
      return "$value";
    } else {
      switch (value) {
        case 11:
          return 'J';
        case 12:
          return 'Q';
        case 13:
          return 'K';
        default:
          return '?';
      }
    }
  }

  @override
  bool operator ==(o) => o is CardValue && o.value == value && o.coppe == coppe;

  @override
  int get hashCode => hashValues(value, coppe);
}

class NiuCard extends StatefulWidget {
  final CardValue value;

  final VoidCallback onTap;

  final double width;

  final double fontSize;

  final bool selected;

  final double elevation;

  const NiuCard({
    Key key,
    @required this.value,
    this.onTap,
    this.width = 100,
    this.fontSize = 24,
    this.selected = false,
    this.elevation = 8,
  }) : super(key: key);

  @override
  _NiuCardState createState() => _NiuCardState();
}

class _NiuCardState extends State<NiuCard> with SingleTickerProviderStateMixin {
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget child;
    Color fontColor = _coppe2Color(widget.value.coppe);

    child = Stack(
      children: [
        Positioned(
          top: 5,
          left: 5,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.value.value2Text(),
                style: TextStyle(
                  color: fontColor,
                  fontSize: widget.fontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
              _buildIcon(widget.value.coppe),
            ],
          ),
        ),
        Positioned(
          bottom: 5,
          right: 5,
          child: Transform.rotate(
            angle: pi,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.value.value2Text(),
                  style: TextStyle(
                    color: fontColor,
                    fontSize: widget.fontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                _buildIcon(widget.value.coppe),
              ],
            ),
          ),
        ),
        Positioned.fill(
            child: GestureDetector(
          onTapDown: (_) {
            _animationController.stop();
            _animationController.forward();
          },
          onTapUp: (_) {
            _animationController.forward().then((_) {
              _animationController.reverse();
            });
          },
          onTapCancel: () {
            _animationController.reverse();
          },
          onTap: () {
            if (widget.onTap != null) {
              widget.onTap();
            }
          },
        )),
      ],
    );

    child = IgnorePointer(
      ignoring: widget.onTap == null,
      child: child,
    );

    child = SizedBox(
      width: widget.width,
      child: AspectRatio(
        aspectRatio: 0.65,
        child: child,
      ),
    );

    child = Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(6.0)),
        border: widget.selected
            ? Border.all(
                color: Colors.blue,
                width: 2,
              )
            : null,
      ),
      child: child,
    );

    child = AnimatedBuilder(
      animation: _animationController,
      builder: (context, c) {
        return PhysicalModel(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(6.0)),
          elevation: widget.elevation * (1 - _animationController.value),
          child: c,
        );
      },
      child: child,
    );

    return child;
  }

  Widget _buildIcon(Coppe coppe) {
    double size = widget.fontSize;
    switch (coppe) {
      case Coppe.spade:
        return SvgPicture.asset(
          'assets/images/spade.svg',
          color: Colors.black87,
          width: size,
          height: size,
        );
      case Coppe.heart:
        return SvgPicture.asset(
          'assets/images/heart.svg',
          color: Colors.red,
          width: size,
          height: size,
        );
      case Coppe.diamond:
        return SvgPicture.asset(
          'assets/images/diamond.svg',
          color: Colors.red,
          width: size,
          height: size,
        );
      case Coppe.club:
        return SvgPicture.asset(
          'assets/images/club.svg',
          color: Colors.black87,
          width: size,
          height: size,
        );
    }
    return null;
  }

  Color _coppe2Color(Coppe coppe) {
    switch (coppe) {
      case Coppe.spade:
        return Colors.black87;
      case Coppe.heart:
        return Colors.red;
      case Coppe.diamond:
        return Colors.red;
      case Coppe.club:
        return Colors.black87;
    }
    return null;
  }
}
