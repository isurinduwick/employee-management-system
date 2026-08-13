/// Shared date/time formatting — no `intl` dependency, since these are the
/// only shapes the app needs: a clock time and a short calendar date.
class DateFormatting {
  const DateFormatting._();

  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  /// "—" for null, otherwise "2:05 PM" in the device's local time.
  static String time(DateTime? value) {
    if (value == null) return '—';
    final local = value.toLocal();
    final hour24 = local.hour;
    final hour = hour24 % 12 == 0 ? 12 : hour24 % 12;
    final minute = local.minute.toString().padLeft(2, '0');
    final period = hour24 < 12 ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  /// "15 Aug 2026".
  static String date(DateTime value) =>
      '${value.day} ${_months[value.month - 1]} ${value.year}';

  /// "15 Aug" — for date ranges where the year is implied.
  static String dateShort(DateTime value) =>
      '${value.day} ${_months[value.month - 1]}';

  static bool isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  static DateTime today() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }
}
