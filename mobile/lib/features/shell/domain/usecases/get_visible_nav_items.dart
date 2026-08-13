import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../auth/domain/entities/role.dart';
import '../entities/nav_item.dart';

/// The destinations a role may open. The drawer renders exactly this list, so
/// a route is never merely hidden — it is absent.
class GetVisibleNavItems implements SyncUseCase<List<NavItem>, Role> {
  const GetVisibleNavItems();

  @override
  Either<Failure, List<NavItem>> call(Role role) {
    final visible = navItems.where((item) => item.isVisibleTo(role)).toList();
    return visible.isEmpty
        ? const Left(ForbiddenFailure('This account has no available screens.'))
        : Right(visible);
  }
}
