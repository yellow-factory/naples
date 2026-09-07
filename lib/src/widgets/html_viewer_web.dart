import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'dart:ui_web' as ui_web;

import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;

import 'html_viewer_controller.dart';

/// Counter to generate unique view IDs
int _viewIdCounter = 0;

/// Web implementation using iframe with HtmlElementView
Widget buildHtmlViewer({
  required String html,
  String? baseUrl,
  String? url,
  Map<String, String>? headers,
  void Function(String url)? onUrlChanged,
  HtmlViewerController? controller,
}) {
  // onUrlChanged isn't used on web: iframe navigations are visible to the
  // embedding page only via postMessage from the iframe contents. Consumers
  // that need the path should add their own `window` `message` listener.
  return _HtmlViewerWeb(html: html, baseUrl: baseUrl, url: url, controller: controller);
}

class _HtmlViewerWeb extends StatefulWidget {
  final String html;
  final String? baseUrl;
  final String? url;
  final HtmlViewerController? controller;

  const _HtmlViewerWeb({
    required this.html,
    this.baseUrl,
    this.url,
    this.controller,
  });

  @override
  State<_HtmlViewerWeb> createState() => _HtmlViewerWebState();
}

class _HtmlViewerWebState extends State<_HtmlViewerWeb> {
  late final String _viewId;
  web.HTMLIFrameElement? _iframe;

  @override
  void initState() {
    super.initState();
    _viewId = 'html-viewer-${_viewIdCounter++}';
    _registerView();
    widget.controller?.attach(_runScript);
  }

  /// The iframe is same-origin (see the sandbox below), so the page's own
  /// `eval` is reachable from here; the parent needs no bridge of its own.
  Future<String?> _runScript(String javaScript) async {
    final window = _iframe?.contentWindow;
    if (window == null) return null;
    final result = window.callMethod<JSAny?>('eval'.toJS, javaScript.toJS);
    if (result == null || result.isUndefinedOrNull) return null;
    return result.dartify()?.toString();
  }

  @override
  void dispose() {
    widget.controller?.detach(_runScript);
    super.dispose();
  }

  void _registerView() {
    ui_web.platformViewRegistry.registerViewFactory(
      _viewId,
      (int viewId) {
        _iframe = web.document.createElement('iframe') as web.HTMLIFrameElement
          ..style.border = 'none'
          ..style.width = '100%'
          ..style.height = '100%';

        _updateContent();
        return _iframe!;
      },
    );
  }

  void _updateContent() {
    if (_iframe == null) return;

    if (widget.url != null) {
      _iframe!.src = widget.url!;
      return;
    }

    // Inline HTML mode — restrict sandbox to scripts + same-origin only
    _iframe!.sandbox.add('allow-scripts');
    _iframe!.sandbox.add('allow-same-origin');

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

    _iframe!.srcdoc = content.toJS;
  }

  @override
  void didUpdateWidget(covariant _HtmlViewerWeb oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(oldWidget.controller, widget.controller)) {
      oldWidget.controller?.detach(_runScript);
      widget.controller?.attach(_runScript);
    }
    if (oldWidget.url != widget.url ||
        oldWidget.html != widget.html ||
        oldWidget.baseUrl != widget.baseUrl) {
      _updateContent();
    }
  }

  @override
  Widget build(BuildContext context) {
    return HtmlElementView(viewType: _viewId);
  }
}
