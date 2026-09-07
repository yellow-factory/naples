import 'package:flutter/material.dart';

import 'html_viewer_controller.dart';

/// Stub implementation - should never be used at runtime
Widget buildHtmlViewer({
  required String html,
  String? baseUrl,
  String? url,
  Map<String, String>? headers,
  void Function(String url)? onUrlChanged,
  HtmlViewerController? controller,
}) {
  throw UnsupportedError(
    'Cannot build HTML viewer without platform implementation',
  );
}
