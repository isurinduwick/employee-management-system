import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// A skeleton block with a sweeping highlight, for screens that know the shape
/// of what they are loading. Prefer this over a spinner for list/detail
/// screens — the layout stops jumping when the data lands.
class ShimmerBox extends StatefulWidget {
  const ShimmerBox({
    super.key,
    this.width = double.infinity,
    this.height = 14,
    this.radius = AppRadius.xs,
  });

  final double width;
  final double height;
  final double radius;

  @override
  State<ShimmerBox> createState() => _ShimmerBoxState();
}

class _ShimmerBoxState extends State<ShimmerBox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        // Sweeps the highlight from off-screen left to off-screen right.
        final position = _controller.value * 2 - 1;
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.radius),
            gradient: LinearGradient(
              begin: Alignment(position - 1, 0),
              end: Alignment(position + 1, 0),
              colors: const [
                AppColors.surface3,
                AppColors.surface2,
                AppColors.surface3,
              ],
              stops: const [0.1, 0.5, 0.9],
            ),
          ),
        );
      },
    );
  }
}

/// A few stacked [ShimmerBox] rows — the default placeholder for list screens.
class ShimmerList extends StatelessWidget {
  const ShimmerList({super.key, this.rows = 6, this.rowHeight = 64});

  final int rows;
  final double rowHeight;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.lg),
      itemCount: rows,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
      itemBuilder: (_, _) =>
          ShimmerBox(height: rowHeight, radius: AppRadius.lg),
    );
  }
}
