import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart' as fmd;
import 'package:naples/view_models/properties/properties.dart';
import 'package:provider/provider.dart';
import 'package:markdown/markdown.dart' as md;

class SizedMarkdownWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final property = context.watch<MarkdownProperty>();
    return SizedBox(
        height: property.height,
        width: property.width,
        child: fmd.Markdown(
          data: property.markdown(),
          extensionSet: md.ExtensionSet.gitHubWeb,
        ));
  }
}
