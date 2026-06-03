/// Returns a date inside `[first, last]` that satisfies `predicate`. Tries
/// `preferred` first (clamped into the range), then walks forward up to a
/// year for a selectable day, then backward. Returns the clamped preferred
/// date when nothing matches — at that point the constraint is effectively
/// unsatisfiable and the picker's own assertion is the correct signal.
///
/// Shared by [DateTimeField] and [DateTimeFormField] so the clamp-and-walk
/// logic lives in one place.
DateTime safeInitialDate({
  required DateTime preferred,
  required DateTime first,
  required DateTime last,
  required bool Function(DateTime)? predicate,
}) {
  final clamped = preferred.isBefore(first)
      ? first
      : (preferred.isAfter(last) ? last : preferred);
  if (predicate == null || predicate(clamped)) return clamped;
  var d = clamped;
  for (var i = 0; i < 366; i++) {
    d = d.add(const Duration(days: 1));
    if (d.isAfter(last)) break;
    if (predicate(d)) return d;
  }
  d = clamped;
  for (var i = 0; i < 366; i++) {
    d = d.subtract(const Duration(days: 1));
    if (d.isBefore(first)) break;
    if (predicate(d)) return d;
  }
  return clamped;
}
