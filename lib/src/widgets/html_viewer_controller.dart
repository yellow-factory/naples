/// Runs a script in the page an [HtmlViewerWidget] shows and resolves with
/// what the script evaluated to, as a string (`null` when the page has nothing
/// to say or the viewer is not on screen).
typedef HtmlViewerScriptRunner = Future<String?> Function(String javaScript);

/// A handle on the page inside an [HtmlViewerWidget], for the host to drive it
/// from Flutter — zoom controls in the widget tree instead of on the page, say.
///
/// Give one to the widget's `controller`; the platform implementation attaches
/// itself while it is mounted, and detaches on dispose, so a script sent to a
/// controller with no page simply resolves to `null`.
class HtmlViewerController {
  HtmlViewerScriptRunner? _runner;

  /// Whether a mounted viewer is currently listening.
  bool get isAttached => _runner != null;

  /// Evaluates [javaScript] in the page and returns its result as a string.
  ///
  /// Scripts should return a primitive; objects come back as whatever the host
  /// webview stringifies them to. Errors thrown by the script resolve to `null`
  /// rather than propagating, so a page still loading is not a crash.
  Future<String?> runJavaScript(String javaScript) async {
    final runner = _runner;
    if (runner == null) return null;
    try {
      return await runner(javaScript);
    } catch (_) {
      return null;
    }
  }

  /// Called by the platform viewer when it mounts. Not for hosts.
  void attach(HtmlViewerScriptRunner runner) => _runner = runner;

  /// Called by the platform viewer when it unmounts. Not for hosts; a viewer
  /// only detaches the runner it attached, so a controller handed to a newer
  /// viewer keeps that one.
  void detach(HtmlViewerScriptRunner runner) {
    if (identical(_runner, runner)) _runner = null;
  }
}
