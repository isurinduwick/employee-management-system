import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../error/exception_mapper.dart';
import 'state_views.dart';

/// Renders an [AsyncValue] as data / loading / error without every screen
/// re-writing the same `.when(...)`.
///
/// Errors are run through `mapExceptionToFailure`, so even something thrown
/// outside a repository still reaches the user as a readable message.
class AsyncValueView<T> extends StatelessWidget {
  const AsyncValueView({
    super.key,
    required this.value,
    required this.data,
    this.loading,
    this.onRetry,
    this.errorTitle = 'Something went wrong',
  });

  final AsyncValue<T> value;
  final Widget Function(T data) data;

  /// Defaults to a centred spinner; pass a [ShimmerList] for list screens.
  final Widget? loading;
  final VoidCallback? onRetry;
  final String errorTitle;

  @override
  Widget build(BuildContext context) {
    return value.when(
      // skipLoadingOnRefresh keeps the current data on screen while a refresh
      // runs, instead of flashing the skeleton again.
      skipLoadingOnRefresh: true,
      data: data,
      loading: () => loading ?? const LoadingView(),
      error: (error, _) => ErrorView(
        title: errorTitle,
        message: mapExceptionToFailure(error).message,
        onRetry: onRetry,
      ),
    );
  }
}
