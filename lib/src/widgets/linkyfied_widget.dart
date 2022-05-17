import 'package:flutter/material.dart';
//import 'package:flutter_linkify/flutter_linkify.dart';
//import 'package:url_launcher/url_launcher.dart';

class LinkyfiedWidget extends StatelessWidget {
  final String text;
  final TextStyle? textStyle;
  final TextStyle? linkStyle;
  final TextAlign? textAlign;

  const LinkyfiedWidget({
    Key? key,
    required this.text,
    this.textStyle,
    this.linkStyle,
    this.textAlign,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //TODO: Temporary removed, while Linkify is not null-safe
    return Text(text);
    // return Linkify(
    //   onOpen: (link) async {
    //     if (await canLaunch(link.url)) {
    //       await launch(link.url);
    //     } else {
    //       throw 'Could not launch $link';
    //     }
    //   },
    //   text: text,
    //   style: textStyle,
    //   linkStyle: linkStyle,
    //   textAlign: textAlign,
    // );
  }
}
