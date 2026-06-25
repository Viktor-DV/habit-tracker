import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:habit_tracker/features/monetization/data/monetization_providers.dart';
import 'package:habit_tracker/features/monetization/domain/premium_repository.dart';

class PaywallScreen extends ConsumerStatefulWidget {
  const PaywallScreen({super.key});

  @override
  ConsumerState<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends ConsumerState<PaywallScreen> {
  bool _loading = false;
  String? _error;

  @override
  Widget build(BuildContext context) {
    final status = ref.watch(premiumProvider);
    final theme = Theme.of(context);

    if (status == PremiumStatus.premium) {
      // Already purchased — dismiss.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) context.pop();
      });
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F7),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 8),
            // ── Hero ──────────────────────────────────────────────────────
            Center(
              child: Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.star_rounded,
                    size: 40, color: Color(0xFF2E7D32)),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Habit Tracker Premium',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1A1A1A),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              'Один раз — навсегда',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF888888),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // ── Comparison table ─────────────────────────────────────────
            _ComparisonTable(),
            const SizedBox(height: 32),

            // ── Price block ──────────────────────────────────────────────
            Center(
              child: Column(
                children: [
                  Text(
                    '150 ₽',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: const Color(0xFFBBBBBB),
                      decoration: TextDecoration.lineThrough,
                      decorationColor: const Color(0xFFBBBBBB),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '100 ₽',
                    style: theme.textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF2E7D32),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Разовая покупка без подписки',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: const Color(0xFF888888),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ── CTA button ───────────────────────────────────────────────
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  _error!,
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: theme.colorScheme.error),
                  textAlign: TextAlign.center,
                ),
              ),
            FilledButton(
              onPressed:
                  (status == PremiumStatus.pending || _loading) ? null : _buy,
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF2E7D32),
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(52),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              child: _loading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white),
                    )
                  : const Text('Получить Premium',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                'Покупка осуществляется через RuStore',
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: const Color(0xFFAAAAAA)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _buy() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await ref.read(premiumProvider.notifier).purchase();
      if (mounted) context.pop();
    } catch (e) {
      setState(() => _error = 'Не удалось совершить покупку. Попробуйте ещё раз.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }
}

// ---------------------------------------------------------------------------

class _ComparisonTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _TableHeader(),
          const Divider(height: 1),
          _Row('Привычек', 'до 5', 'Безлимит', highlight: true),
          _Row('Реклама', 'Есть', 'Нет', highlight: false),
          _Row('Статистика и графики', '✓', '✓', highlight: false),
          _Row('Таймер', '✓', '✓', highlight: false),
          _Row('Уведомления', '✓', '✓', highlight: false),
          _Row('Все типы привычек', '✓', '✓', highlight: false),
        ],
      ),
    );
  }
}

class _TableHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Row(
        children: [
          Expanded(
              flex: 3,
              child: Text('',
                  style: theme.textTheme.labelSmall
                      ?.copyWith(color: const Color(0xFF888888)))),
          Expanded(
            flex: 2,
            child: Text('Free',
                textAlign: TextAlign.center,
                style: theme.textTheme.labelMedium
                    ?.copyWith(fontWeight: FontWeight.w600)),
          ),
          Expanded(
            flex: 2,
            child: Text('Premium',
                textAlign: TextAlign.center,
                style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF2E7D32))),
          ),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row(this.feature, this.free, this.premium,
      {required this.highlight});
  final String feature;
  final String free;
  final String premium;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      color: highlight ? const Color(0xFFF1F8E9) : null,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(feature,
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: const Color(0xFF444444))),
          ),
          Expanded(
            flex: 2,
            child: Text(free,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: const Color(0xFF888888))),
          ),
          Expanded(
            flex: 2,
            child: Text(premium,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                    color: const Color(0xFF2E7D32),
                    fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}
