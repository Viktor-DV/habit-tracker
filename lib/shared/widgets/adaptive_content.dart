import 'package:flutter/material.dart';

/// Max content width for tablet / large-screen layouts.
/// ponytail: one breakpoint covers phones and tablets cleanly.
const double kContentMaxWidth = 680.0;

/// Centers and constrains content width on screens wider than [kContentMaxWidth].
///
/// Wrap any `body` or list padding widget that would look stretched on tablets:
///   AdaptiveContent(child: ListView(...))
class AdaptiveContent extends StatelessWidget {
  const AdaptiveContent({super.key, required this.child, this.padding});

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.sizeOf(context).width;
    if (screen <= kContentMaxWidth) return _padded(child);
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: kContentMaxWidth),
        child: _padded(child),
      ),
    );
  }

  Widget _padded(Widget w) =>
      padding != null ? Padding(padding: padding!, child: w) : w;
}

/// Sliver-compatible version.
class SliverAdaptiveContent extends StatelessWidget {
  const SliverAdaptiveContent({super.key, required this.sliver});
  final Widget sliver;

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.sizeOf(context).width;
    if (screen <= kContentMaxWidth) return sliver;

    final sidepad = (screen - kContentMaxWidth) / 2;
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: sidepad),
      sliver: sliver,
    );
  }
}
