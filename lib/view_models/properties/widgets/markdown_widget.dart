import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart' as fmd;
import 'package:naples/view_models/properties/properties.dart';
import 'package:provider/provider.dart';
//import 'package:markdown/markdown.dart' as md;

class MarkdownWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final property = context.watch<MarkdownLayoutMember>();
    return fmd.MarkdownBody(
      data: property.markdown,
    );

// return Markdown(
//     controller: controller,
//     selectable: true,
//     data: 'Insert emoji :smiley: here',
//     extensionSet: md.ExtensionSet(
//         [md.gitHubFlavored.blockSyntaxes],
//         [md.EmojiSyntax(), ...md.gitHubFlavored.inlineSyntaxes]),
// )

    // return Padding(
    //   padding:
    //       EdgeInsets.only(top: property.topPadding ?? 0.0, bottom: property.bottomPadding ?? 0.0),
    //   child: Text(
    //     property.comment(),
    //     style: TextStyle(fontStyle: property.fontStyle, fontWeight: property.fontWeight),
    //     textAlign: property.textAlign,
    //   ),
    // );
  }
}
