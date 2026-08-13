import 'package:flutter/material.dart';

// One icon per route, kept separate from nav_items.dart so that file stays
// plain data — same split as navIcons.tsx / navItems.ts on the web.
const _iconsByPath = <String, IconData>{
  '/': Icons.dashboard_outlined,
  '/employees': Icons.person_outline,
  '/departments': Icons.apartment_outlined,
  '/attendance': Icons.schedule_outlined,
  '/attendance/team': Icons.groups_outlined,
  '/leave': Icons.calendar_month_outlined,
  '/leave/approvals': Icons.fact_check_outlined,
};

IconData navIconFor(String path) => _iconsByPath[path] ?? Icons.circle_outlined;
