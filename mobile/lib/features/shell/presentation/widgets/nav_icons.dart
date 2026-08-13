import 'package:flutter/material.dart';

import '../../../../core/router/app_routes.dart';

// One icon per route, kept out of the nav entity so the domain layer stays
// free of Flutter types — same split as navIcons.tsx / navItems.ts on the web.
const _iconsByPath = <String, IconData>{
  AppRoutes.dashboard: Icons.dashboard_outlined,
  AppRoutes.employees: Icons.person_outline,
  AppRoutes.departments: Icons.apartment_outlined,
  AppRoutes.attendance: Icons.schedule_outlined,
  AppRoutes.teamAttendance: Icons.groups_outlined,
  AppRoutes.leave: Icons.calendar_month_outlined,
  AppRoutes.leaveApprovals: Icons.fact_check_outlined,
};

IconData navIconFor(String path) => _iconsByPath[path] ?? Icons.circle_outlined;
