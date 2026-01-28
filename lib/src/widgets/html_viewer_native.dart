import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// Native implementation using webview_flutter
Widget buildHtmlViewer({
  required String html,
  String? baseUrl,
}) {
  return _HtmlViewerNative(html: html, baseUrl: baseUrl);
}

class _HtmlViewerNative extends StatefulWidget {
  final String html;
  final String? baseUrl;

  const _HtmlViewerNative({
    required this.html,
    this.baseUrl,
  });

  @override
  State<_HtmlViewerNative> createState() => _HtmlViewerNativeState();
}

class _HtmlViewerNativeState extends State<_HtmlViewerNative> {
  late final WebViewController _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initController();
  }

  void _initController() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted);

    _loadContent();
    _isInitialized = true;
  }

  void _loadContent() {
    final content = '''
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  ${widget.baseUrl != null ? '<base href="${widget.baseUrl}">' : ''}
  <style>
    body {
      margin: 8px;
      font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
    }
  </style>
</head>
<body>
${widget.html}
</body>
</html>
''';

    _controller.loadHtmlString(
      content,
      baseUrl: widget.baseUrl,
    );
  }

  @override
  void didUpdateWidget(covariant _HtmlViewerNative oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.html != widget.html || oldWidget.baseUrl != widget.baseUrl) {
      _loadContent();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return WebViewWidget(controller: _controller);
  }
}
