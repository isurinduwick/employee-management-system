import '../models/auth.dart';

// Port of frontend/src/layout/navItems.ts — one source of truth for the nav,
// so exposing a route to a role means adding it to that item's list rather
// than duplicating menu entries per role.

enum NavGroup { overview, people, timeAndLeave }

String navGroupLabel(NavGroup group) {
  switch (group) {
    case NavGroup.overview:
      return 'Overview';
    case NavGroup.people:
      return 'People';
    case NavGroup.timeAndLeave:
      return 'Time & Leave';
  }
}

// Section order in the drawer. Sections whose links are all hidden for the
// current role are dropped rather than rendered empty.
const navGroups = <NavGroup>[NavGroup.overview, NavGroup.people, NavGroup.timeAndLeave];

class NavItem {
  final String label;
  final String path;
  final NavGroup group;
  final List<Role> roles;

  const NavItem({
    required this.label,
    required this.path,
    required this.group,
    required this.roles,
  });
}

const navItems = <NavItem>[
  NavItem(
    label: 'Dashboard',
    path: '/',
    group: NavGroup.overview,
    roles: [Role.admin, Role.manager, Role.employee],
  ),
  NavItem(
    label: 'Employees',
    path: '/employees',
    group: NavGroup.people,
    roles: [Role.admin],
  ),
  NavItem(
    label: 'Departments',
    path: '/departments',
    group: NavGroup.people,
    roles: [Role.admin],
  ),
  NavItem(
    label: 'Attendance',
    path: '/attendance',
    group: NavGroup.timeAndLeave,
    roles: [Role.admin, Role.manager, Role.employee],
  ),
  NavItem(
    label: 'Team Attendance',
    path: '/attendance/team',
    group: NavGroup.timeAndLeave,
    roles: [Role.admin, Role.manager],
  ),
  NavItem(
    label: 'Leave',
    path: '/leave',
    group: NavGroup.timeAndLeave,
    roles: [Role.admin, Role.manager, Role.employee],
  ),
  NavItem(
    label: 'Leave Approvals',
    path: '/leave/approvals',
    group: NavGroup.timeAndLeave,
    roles: [Role.admin, Role.manager],
  ),
];

List<NavItem> visibleNavItems(Role role) =>
    navItems.where((item) => item.roles.contains(role)).toList();
