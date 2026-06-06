import 'package:flutter/material.dart';

/// Visual tokens for naples form fields (label/help/box/focus/switch).
///
/// naples ships sensible defaults derived from the ambient [ColorScheme] via
/// [NaplesFieldTokens.fromColorScheme], so fields look reasonable in any app
/// without configuration. Host apps that want a specific look register their
/// own instance as a [ThemeExtension] on `ThemeData.extensions`, and the field
/// widgets pick it up through [NaplesFieldTokens.of].
@immutable
class NaplesFieldTokens extends ThemeExtension<NaplesFieldTokens> {
  /// Control fill (editable state).
  final Color fieldBg;

  /// Control border (editable, unfocused).
  final Color fieldBorder;

  /// Border colour when the field has focus.
  final Color focus;

  /// Soft focus halo painted around the control.
  final Color focusRing;

  /// Field label colour.
  final Color label;

  /// Inline help / description colour.
  final Color help;

  /// Primary input text colour.
  final Color text;

  /// Muted foreground (placeholder, lock icon, secondary text).
  final Color muted;

  /// Accent — switch "on" track, etc.
  final Color accent;

  /// Foreground drawn on [accent].
  final Color onAccent;

  /// Switch "off" track colour.
  final Color switchTrackOff;

  /// Control corner radius.
  final double radius;

  const NaplesFieldTokens({
    required this.fieldBg,
    required this.fieldBorder,
    required this.focus,
    required this.focusRing,
    required this.label,
    required this.help,
    required this.text,
    required this.muted,
    required this.accent,
    required this.onAccent,
    required this.switchTrackOff,
    this.radius = 8,
  });

  /// Defaults built from a [ColorScheme] — keeps naples self-contained.
  factory NaplesFieldTokens.fromColorScheme(ColorScheme s) {
    return NaplesFieldTokens(
      fieldBg: s.surfaceContainerHighest,
      fieldBorder: s.outlineVariant,
      focus: s.primary,
      focusRing: s.primary.withValues(alpha: 0.28),
      label: s.onSurfaceVariant,
      help: s.onSurfaceVariant,
      text: s.onSurface,
      muted: s.onSurfaceVariant,
      accent: s.primary,
      onAccent: s.onPrimary,
      switchTrackOff: s.outline,
    );
  }

  /// The registered tokens, or [ColorScheme]-derived defaults when none is set.
  static NaplesFieldTokens of(BuildContext context) {
    final theme = Theme.of(context);
    return theme.extension<NaplesFieldTokens>() ??
        NaplesFieldTokens.fromColorScheme(theme.colorScheme);
  }

  @override
  NaplesFieldTokens copyWith({
    Color? fieldBg,
    Color? fieldBorder,
    Color? focus,
    Color? focusRing,
    Color? label,
    Color? help,
    Color? text,
    Color? muted,
    Color? accent,
    Color? onAccent,
    Color? switchTrackOff,
    double? radius,
  }) {
    return NaplesFieldTokens(
      fieldBg: fieldBg ?? this.fieldBg,
      fieldBorder: fieldBorder ?? this.fieldBorder,
      focus: focus ?? this.focus,
      focusRing: focusRing ?? this.focusRing,
      label: label ?? this.label,
      help: help ?? this.help,
      text: text ?? this.text,
      muted: muted ?? this.muted,
      accent: accent ?? this.accent,
      onAccent: onAccent ?? this.onAccent,
      switchTrackOff: switchTrackOff ?? this.switchTrackOff,
      radius: radius ?? this.radius,
    );
  }

  @override
  NaplesFieldTokens lerp(ThemeExtension<NaplesFieldTokens>? other, double t) {
    if (other is! NaplesFieldTokens) return this;
    return NaplesFieldTokens(
      fieldBg: Color.lerp(fieldBg, other.fieldBg, t)!,
      fieldBorder: Color.lerp(fieldBorder, other.fieldBorder, t)!,
      focus: Color.lerp(focus, other.focus, t)!,
      focusRing: Color.lerp(focusRing, other.focusRing, t)!,
      label: Color.lerp(label, other.label, t)!,
      help: Color.lerp(help, other.help, t)!,
      text: Color.lerp(text, other.text, t)!,
      muted: Color.lerp(muted, other.muted, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      onAccent: Color.lerp(onAccent, other.onAccent, t)!,
      switchTrackOff: Color.lerp(switchTrackOff, other.switchTrackOff, t)!,
      radius: lerpDouble(radius, other.radius, t),
    );
  }

  static double lerpDouble(double a, double b, double t) => a + (b - a) * t;
}
