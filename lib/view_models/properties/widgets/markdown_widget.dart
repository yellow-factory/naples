import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart' as fmd;
import 'package:naples/view_models/properties/properties.dart';
import 'package:provider/provider.dart';
import 'package:markdown/markdown.dart' as md;

class MarkdownWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final property = context.watch<MarkdownLayoutMember>();
    return fmd.MarkdownBody(
      data: property.markdown,
      extensionSet: md.ExtensionSet.gitHubWeb,
    );
  }
}
