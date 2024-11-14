import 'package:flutter/material.dart';

class CardDividedContainer extends StatelessWidget {
  final Widget headerChild;
  final Widget bodyChild;
  const CardDividedContainer({
    Key? key,
    required this.headerChild,
    required this.bodyChild,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
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
    Key? key,
    required this.headerChild,
    required this.bodyChild,
    this.indentDivider = true,
    this.showDivider = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        headerChild,
        if (showDivider)
          Divider(
            height: 1,
            indent: indentDivider ? 5 : 0,
            endIndent: indentDivider ? 5 : 0,
          ),
        Expanded(child: bodyChild),
      ],
    );
  }
}
