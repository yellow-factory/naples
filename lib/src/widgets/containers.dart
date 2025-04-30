import 'package:flutter/material.dart';

class CardDividedContainer extends StatelessWidget {
  final Widget headerChild;
  final Widget bodyChild;
  final bool elevatedCard;
  const CardDividedContainer({
    super.key,
    required this.headerChild,
    required this.bodyChild,
    this.elevatedCard = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: elevatedCard ? 4 : 0,
      child: DividedContainer(
        showDivider: true,
        indentDivider: true,
        headerChild: headerChild,
        bodyChild: bodyChild,
      ),
    );
  }
}

class DividedContainer extends StatelessWidget {
  final Widget headerChild;
  final Widget bodyChild;
  final bool showDivider;
  final bool indentDivider;
  const DividedContainer({
    super.key,
    required this.headerChild,
    required this.bodyChild,
    this.indentDivider = true,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        headerChild,
        if (showDivider)
          Divider(height: 1, indent: indentDivider ? 5 : 0, endIndent: indentDivider ? 5 : 0),
        Expanded(child: bodyChild),
      ],
    );
  }
}
