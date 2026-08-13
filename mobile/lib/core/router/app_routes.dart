/// Every location in the app, in one place.
///
/// The nav catalogue and the router both build on these constants, so a route
/// can't drift from the drawer entry that points at it.
class AppRoutes {
  const AppRoutes._();

  static const splash = '/splash';
  static const login = '/login';

  static const dashboard = '/';
  static const employees = '/employees';
  static const departments = '/departments';
  static const attendance = '/attendance';
  static const teamAttendance = '/attendance/team';
  static const leave = '/leave';
  static const leaveApprovals = '/leave/approvals';
}
