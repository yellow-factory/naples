import 'package:flutter/material.dart';

import 'html_viewer_stub.dart'
    if (dart.library.html) 'html_viewer_web.dart'
    if (dart.library.io) 'html_viewer_native.dart' as platform;

/// Widget for viewing HTML content with JavaScript support.
///
/// On web platforms, uses an iframe via HtmlElementView.
/// On native platforms (macOS, Windows, Linux), uses webview_flutter.
class HtmlViewerWidget extends StatelessWidget {
  /// The HTML content to display
  final String html;

  /// Optional base URL for resolving relative URLs
  final String? baseUrl;

  const HtmlViewerWidget({
    required this.html,
    this.baseUrl,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return platform.buildHtmlViewer(
      html: html,
      baseUrl: baseUrl,
    );
  }
}
