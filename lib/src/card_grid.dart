import 'dart:math';

import 'package:flutter/material.dart';

import 'card.dart';

typedef OnCardSelected = Function(CardValue cardList);

class NiuCardGrid extends StatefulWidget {
  final OnCardSelected onCardSelected;

  const NiuCardGrid({
    Key key,
    this.onCardSelected,
  }) : super(key: key);

  @override
  _NiuCardGridState createState() => _NiuCardGridState();
}

class _NiuCardGridState extends State<NiuCardGrid> {
  final _cardValue = <CardValue>[];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 10; ++i) {
      _cardValue.add(CardValue(
        i + 1,
        Coppe.values[Random().nextInt(Coppe.values.length)],
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget child = GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: 0.67,
        crossAxisCount: 5,
        crossAxisSpacing: 2,
        mainAxisSpacing: 15,
      ),
      itemBuilder: (context, index) =>
          _buildCard(context, _cardValue[index]),
      itemCount: 10,
      clipBehavior: Clip.none,
    );

    child = Padding(
      padding: EdgeInsets.all(8.0),
      child: child,
    );

    return child;
  }

  Widget _buildCard(BuildContext context, CardValue value) {
    return NiuCard(
      value: value,
      fontSize: 18,
      onTap: () {
        _onCardSelected(value);
      },
    );
  }

  void _onCardSelected(CardValue value) {
    if (widget.onCardSelected != null) {
      widget.onCardSelected(value);
    }
  }
}
