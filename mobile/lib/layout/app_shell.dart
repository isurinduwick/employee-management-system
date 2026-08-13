import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/auth.dart';
import '../screens/login_screen.dart';
import '../screens/placeholder_page.dart';
import '../state/auth_state.dart';
import '../theme/app_colors.dart';
import 'nav_icons.dart';
import 'nav_items.dart';

// Mobile counterpart of the web Layout: the sidebar becomes a drawer (same
// grouped, role-filtered items), and the top bar's user chip and logout move
// into the app bar and drawer footer.
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  String _currentPath = '/';

  String _initials(String fullName) {
    final parts = fullName.trim().split(RegExp(r'\s+'));
    final first = parts.first.isNotEmpty ? parts.first[0] : '';
    final last = parts.length > 1 && parts.last.isNotEmpty ? parts.last[0] : '';
    return (first + last).toUpperCase();
  }

  Future<void> _logout() async {
    await context.read<AuthState>().logout();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final session = context.watch<AuthState>().session!;
    final items = visibleNavItems(session.role);

    // A role can lose access to the selected route only if the session
    // changes underneath us; falling back to the first visible item keeps the
    // shell from rendering a page the role can't see.
    final current = items.firstWhere(
      (item) => item.path == _currentPath,
      orElse: () => items.first,
    );

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: Text(current.label),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.text,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        shape: const Border(bottom: BorderSide(color: AppColors.border)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.accentSoft,
              child: Text(
                _initials(session.fullName),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.accent,
                ),
              ),
            ),
          ),
        ],
      ),
      drawer: _buildDrawer(session, items, current),
      body: PlaceholderPage(title: current.label, path: current.path),
    );
  }

  Widget _buildDrawer(LoginResponse session, List<NavItem> items, NavItem current) {
    // Only sections that still have a link for this role get a heading.
    final sections = navGroups
        .map((group) => (group: group, items: items.where((i) => i.group == group).toList()))
        .where((section) => section.items.isNotEmpty);

    return Drawer(
      backgroundColor: AppColors.surface,
      child: SafeArea(
        child: Column(
          children: [
            _buildBrandHeader(session),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  for (final section in sections) ...[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 14, 20, 6),
                      child: Text(
                        navGroupLabel(section.group).toUpperCase(),
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.06,
                          color: AppColors.textSubtle,
                        ),
                      ),
                    ),
                    for (final item in section.items)
                      _buildNavTile(item, isActive: item.path == current.path),
                  ],
                ],
              ),
            ),
            const Divider(height: 1, color: AppColors.border),
            ListTile(
              leading: const Icon(Icons.logout, size: 20, color: AppColors.textMuted),
              title: const Text(
                'Log out',
                style: TextStyle(fontSize: 14, color: AppColors.textMuted),
              ),
              onTap: _logout,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBrandHeader(LoginResponse session) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.md),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.accent, Color(0xFF0B3F5F)],
              ),
            ),
            child: const Icon(Icons.business_center_rounded, size: 19, color: AppColors.accentContrast),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  session.fullName,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.text,
                  ),
                ),
                Text(
                  roleToString(session.role),
                  style: const TextStyle(fontSize: 12.5, color: AppColors.textMuted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavTile(NavItem item, {required bool isActive}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 1),
      child: Material(
        color: isActive ? AppColors.accentSoft : Colors.transparent,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          onTap: () {
            setState(() => _currentPath = item.path);
            Navigator.of(context).pop();
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
            child: Row(
              children: [
                Icon(
                  navIconFor(item.path),
                  size: 19,
                  color: isActive ? AppColors.accent : AppColors.textMuted,
                ),
                const SizedBox(width: 12),
                Text(
                  item.label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                    color: isActive ? AppColors.accent : AppColors.text,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
