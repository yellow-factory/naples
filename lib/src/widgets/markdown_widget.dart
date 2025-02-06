import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart' as fmd;
import 'package:markdown/markdown.dart' as md;
import 'package:url_launcher/url_launcher.dart';

class MarkdownWidget extends StatelessWidget {
  final String template;
  final double? height;
  final WrapAlignment wrapAlignment;

  const MarkdownWidget(
      {required this.template,
      this.height,
      this.wrapAlignment = WrapAlignment.spaceBetween,
      super.key});

  void onTapLink(text, href, title) async {
    if (await canLaunchUrl(href)) {
      await launchUrl(href);
    } else {
      throw 'Could not launch $href';
    }
  }

  @override
  Widget build(BuildContext context) {
    var extensionSet = md.ExtensionSet.gitHubWeb;
    var styleSheet = fmd.MarkdownStyleSheet(
      textAlign: wrapAlignment,
      unorderedListAlign: wrapAlignment,
      orderedListAlign: wrapAlignment,
    );

    if (height != null) {
      return SizedBox(
        height: height,
        child: fmd.Markdown(
          data: template,
          extensionSet: extensionSet,
          onTapLink: onTapLink,
          styleSheet: styleSheet,
          // imageBuilder: (uri, title, alt) =>
          //   Text('image'),
          //styleSheet: fmd.MarkdownStyleSheet(textAlign: WrapAlignment.start),
        ),
      );
    }

    return fmd.MarkdownBody(
      data: template,
      extensionSet: extensionSet,
      onTapLink: onTapLink,
      styleSheet: styleSheet,
      // imageBuilder: (uri, title, alt) =>
      //   Text('image'),
      //styleSheet: fmd.MarkdownStyleSheet(textAlign: WrapAlignment.start),
    );
  }
}
