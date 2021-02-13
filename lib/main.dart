import 'package:flutter/material.dart';

import 'src/card.dart';
import 'src/card_grid.dart';
import 'src/calculate.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NiuNiu',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<CardValue> _selectedCardList;
  List<CardValue> _resolve;

  @override
  Widget build(BuildContext context) {
    Widget child = Scaffold(
        body: SafeArea(
      child: Column(
        children: [
          _CardResolve(
            cardList:
                _resolve?.isNotEmpty == true ? _resolve : _selectedCardList,
            hasResult: _resolve?.isNotEmpty == true,
            noResult: _resolve?.isEmpty == true,
          ),
          Spacer(),
          Container(
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FlatButton(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.blue, width: 1),
                    borderRadius: BorderRadius.all(Radius.circular(4.0)),
                  ),
                  child: Text(
                    '计算',
                    style: TextStyle(color: Colors.blue),
                  ),
                  onPressed: () {
                    _startCompute();
                  },
                ),
                SizedBox(
                  width: 10,
                ),
                FlatButton(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.red, width: 1),
                    borderRadius: BorderRadius.all(Radius.circular(4.0)),
                  ),
                  child: Text(
                    '清空',
                    style: TextStyle(color: Colors.red),
                  ),
                  onPressed: () {
                    setState(() {
                      _resolve = null;
                      _selectedCardList = null;
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: NiuCardGrid(
              onCardSelected: _onCardListSelected,
            ),
          ),
        ],
      ),
    ));
    return child;
  }

  void _startCompute() {
    if (_selectedCardList.length == 5) {
      setState(() {
        _resolve = sortByNiu(_selectedCardList) ?? [];
      });
    }
  }

  void _onCardListSelected(CardValue cardValue) {
    _selectedCardList ??= [];
    if (_selectedCardList.length < 5) {
      setState(() {
        _selectedCardList.add(cardValue);
      });
    }
  }
}

class _CardResolve extends StatelessWidget {
  final List<CardValue> cardList;

  final bool hasResult;

  final bool noResult;

  const _CardResolve({
    Key key,
    this.cardList,
    this.hasResult = false,
    this.noResult = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> cards = [];
    for (int i = 0; i < (cardList?.length ?? 0); ++i) {
      final value = cardList[i];
      Widget child = NiuCard(
        fontSize: 15,
        value: value,
      );
      if (hasResult) {
        if (i < 3) {
          child = Transform.translate(
            offset: Offset(-10.0 * i, 0),
            child: child,
          );
        } else {
          child = Transform.translate(
            offset: Offset(10.0 * (cardList.length - i - 1), 0),
            child: child,
          );
        }
      }
      child = Expanded(
        child: child,
      );
      cards.add(child);
    }

    int empty = 5 - cards.length;
    for (int i = 0; i < empty; ++i) {
      cards.add(Expanded(
        child: AspectRatio(
          aspectRatio: 0.65,
        ),
      ));
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(10, 40, 10, 60),
      margin: const EdgeInsets.fromLTRB(5, 16, 5, 0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
          color: Colors.black12,
          border: Border.all(
              color: hasResult
                  ? Colors.green
                  : noResult
                      ? Colors.red
                      : Colors.transparent,
              width: 2)),
      child: Row(
        children: cards,
      ),
    );
  }
}
