import '../../../../core/router/app_routes.dart';
import '../../../auth/domain/entities/role.dart';

// Port of frontend/src/layout/navItems.ts — one source of truth for the nav,
// so exposing a route to a role means adding it to that item's list rather
// than duplicating menu entries per role.

enum NavGroup {
  overview('Overview'),
  people('People'),
  timeAndLeave('Time & Leave');

  const NavGroup(this.label);

  final String label;
}

class NavItem {
  const NavItem({
    required this.label,
    required this.path,
    required this.group,
    required this.roles,
  });

  final String label;
  final String path;
  final NavGroup group;
  final List<Role> roles;

  bool isVisibleTo(Role role) => roles.contains(role);
}

const _everyone = [Role.admin, Role.manager, Role.employee];

/// Section order in the drawer. Sections whose links are all hidden for the
/// current role are dropped rather than rendered empty.
const navGroupOrder = <NavGroup>[
  NavGroup.overview,
  NavGroup.people,
  NavGroup.timeAndLeave,
];

const navItems = <NavItem>[
  NavItem(
    label: 'Dashboard',
    path: AppRoutes.dashboard,
    group: NavGroup.overview,
    roles: _everyone,
  ),
  NavItem(
    label: 'Employees',
    path: AppRoutes.employees,
    group: NavGroup.people,
    roles: [Role.admin],
  ),
  NavItem(
    label: 'Departments',
    path: AppRoutes.departments,
    group: NavGroup.people,
    roles: [Role.admin],
  ),
  NavItem(
    label: 'Attendance',
    path: AppRoutes.attendance,
    group: NavGroup.timeAndLeave,
    roles: _everyone,
  ),
  NavItem(
    label: 'Team Attendance',
    path: AppRoutes.teamAttendance,
    group: NavGroup.timeAndLeave,
    roles: [Role.admin, Role.manager],
  ),
  NavItem(
    label: 'Leave',
    path: AppRoutes.leave,
    group: NavGroup.timeAndLeave,
    roles: _everyone,
  ),
  NavItem(
    label: 'Leave Approvals',
    path: AppRoutes.leaveApprovals,
    group: NavGroup.timeAndLeave,
    roles: [Role.admin, Role.manager],
  ),
];
