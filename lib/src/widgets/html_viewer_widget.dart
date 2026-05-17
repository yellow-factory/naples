import 'package:flutter/material.dart';

import 'html_viewer_stub.dart'
    if (dart.library.html) 'html_viewer_web.dart'
    if (dart.library.io) 'html_viewer_native.dart' as platform;

/// Widget for viewing HTML content with JavaScript support.
///
/// On web platforms, uses an iframe via HtmlElementView.
/// On native platforms (macOS, Windows, Linux), uses webview_flutter.
///
/// Provide either [url] to load a remote page, or [html] to render inline HTML.
/// When [url] is given it takes precedence over [html].
class HtmlViewerWidget extends StatelessWidget {
  /// Remote URL to load in the viewer (takes precedence over [html]).
  final String? url;

  /// The HTML content to display (used when [url] is null).
  final String html;

  /// Optional base URL for resolving relative URLs (used with [html] only).
  final String? baseUrl;

  /// Optional HTTP headers to include when loading [url] (native only).
  /// Ignored on web because iframes cannot send custom request headers.
  final Map<String, String>? headers;

  const HtmlViewerWidget({
    this.url,
    this.html = '',
    this.baseUrl,
    this.headers,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return platform.buildHtmlViewer(
      html: html,
      baseUrl: baseUrl,
      url: url,
      headers: headers,
    );
  }
}
