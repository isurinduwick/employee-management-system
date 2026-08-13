import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_providers.dart';
import '../../domain/entities/nav_item.dart';
import '../../domain/usecases/get_visible_nav_items.dart';

final getVisibleNavItemsProvider = Provider<GetVisibleNavItems>(
  (ref) => const GetVisibleNavItems(),
);

/// Destinations for the signed-in role — empty while signed out.
final visibleNavItemsProvider = Provider<List<NavItem>>((ref) {
  final session = ref.watch(sessionProvider);
  if (session == null) return const [];

  final result = ref.watch(getVisibleNavItemsProvider)(session.role);
  return result.getOrElse((_) => const []);
});

/// The nav entry matching a location, or null for routes that aren't in the
/// drawer.
final navItemForLocationProvider = Provider.family<NavItem?, String>((
  ref,
  location,
) {
  final items = ref.watch(visibleNavItemsProvider);
  for (final item in items) {
    if (item.path == location) return item;
  }
  return null;
});
