import '../../../attendance/domain/entities/attendance_record.dart';

/// Where the signed-in user stands on today's attendance.
enum TodayStatus { notCheckedIn, checkedIn, checkedOut }

/// One headline number on the dashboard, with the route it drills into.
class DashboardStat {
  const DashboardStat({
    required this.label,
    required this.value,
    required this.route,
  });

  final String label;
  final int value;
  final String route;
}

/// Everything the dashboard shows, already reduced to what the UI needs.
///
/// The dashboard owns no endpoints of its own — it composes the employees,
/// departments, leave and attendance use cases, exactly as the web page does.
class DashboardSummary {
  const DashboardSummary({required this.todayStatus, required this.stats});

  final TodayStatus todayStatus;
  final List<DashboardStat> stats;

  static TodayStatus statusFor(AttendanceRecord? today) {
    if (today == null) return TodayStatus.notCheckedIn;
    return today.hasCheckedOut ? TodayStatus.checkedOut : TodayStatus.checkedIn;
  }
}
