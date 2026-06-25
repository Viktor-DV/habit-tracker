import 'package:flutter/material.dart';
import 'package:habit_tracker/app/app_theme.dart';

/// Animated shimmer-style skeleton placeholder.
///
/// Use for lists / cards while async data loads.
/// ponytail: single AnimationController shared by all children via
/// InheritedWidget would be ideal for large lists, but here each
/// instance runs its own tween — acceptable for ≤ 10 placeholders.
class SkeletonBox extends StatefulWidget {
  const SkeletonBox({
    super.key,
    this.width,
    this.height = 16,
    this.radius = 8,
  });

  final double? width;
  final double height;
  final double radius;

  @override
  State<SkeletonBox> createState() => _SkeletonBoxState();
}

class _SkeletonBoxState extends State<SkeletonBox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, _) => Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: Color.lerp(
            AppTheme.cardBackground,
            AppTheme.dividerColor,
            _anim.value,
          ),
          borderRadius: BorderRadius.circular(widget.radius),
        ),
      ),
    );
  }
}

/// A typical habit-card skeleton (one row with emoji + text blocks).
class HabitCardSkeleton extends StatelessWidget {
  const HabitCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: AppTheme.cardRadius,
        border: Border.all(color: AppTheme.dividerColor),
      ),
      child: Row(
        children: [
          SkeletonBox(width: 36, height: 36, radius: 10),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonBox(height: 14, width: double.infinity),
                const SizedBox(height: 8),
                SkeletonBox(height: 11, width: 100),
              ],
            ),
          ),
          const SizedBox(width: 12),
          SkeletonBox(width: 44, height: 32, radius: 8),
        ],
      ),
    );
  }
}

/// Sliver list of [count] skeletons.
class SliverSkeletonList extends StatelessWidget {
  const SliverSkeletonList({super.key, this.count = 5});
  final int count;

  @override
  Widget build(BuildContext context) {
    return SliverList.builder(
      itemCount: count,
      itemBuilder: (_, _) => const HabitCardSkeleton(),
    );
  }
}
