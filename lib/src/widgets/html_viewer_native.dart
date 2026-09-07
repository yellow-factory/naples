import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'html_viewer_controller.dart';

/// Native implementation using webview_flutter
Widget buildHtmlViewer({
  required String html,
  String? baseUrl,
  String? url,
  Map<String, String>? headers,
  void Function(String url)? onUrlChanged,
  HtmlViewerController? controller,
}) {
  return _HtmlViewerNative(
    html: html,
    baseUrl: baseUrl,
    url: url,
    headers: headers,
    onUrlChanged: onUrlChanged,
    controller: controller,
  );
}

class _HtmlViewerNative extends StatefulWidget {
  final String html;
  final String? baseUrl;
  final String? url;
  final Map<String, String>? headers;
  final void Function(String url)? onUrlChanged;
  final HtmlViewerController? controller;

  const _HtmlViewerNative({
    required this.html,
    this.baseUrl,
    this.url,
    this.headers,
    this.onUrlChanged,
    this.controller,
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
    widget.controller?.attach(_runScript);
  }

  Future<String?> _runScript(String javaScript) async {
    final result = await _controller.runJavaScriptReturningResult(javaScript);
    return result.toString();
  }

  @override
  void dispose() {
    widget.controller?.detach(_runScript);
    super.dispose();
  }

  void _initController() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onPageStarted: (url) => debugPrint('[HtmlViewer] onPageStarted: $url'),
        onPageFinished: (url) {
          debugPrint('[HtmlViewer] onPageFinished: $url');
          widget.onUrlChanged?.call(url);
        },
        onWebResourceError: (error) => debugPrint(
          '[HtmlViewer] onWebResourceError: code=${error.errorCode} type=${error.errorType} desc=${error.description} url=${error.url}',
        ),
        onHttpError: (error) => debugPrint(
          '[HtmlViewer] onHttpError: status=${error.response?.statusCode} url=${error.request?.uri}',
        ),
      ));

    _loadContent();
    _isInitialized = true;
  }

  void _loadContent() {
    if (widget.url != null) {
      _controller.loadRequest(Uri.parse(widget.url!), headers: widget.headers ?? {});
      return;
    }

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
    if (!identical(oldWidget.controller, widget.controller)) {
      oldWidget.controller?.detach(_runScript);
      widget.controller?.attach(_runScript);
    }
    if (oldWidget.url != widget.url ||
        oldWidget.html != widget.html ||
        oldWidget.baseUrl != widget.baseUrl) {
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
