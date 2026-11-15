import 'package:aivsol_solo_travel/core/extensions/theme_extensions.dart';
import 'package:aivsol_solo_travel/core/theme/app_theme.dart';
import 'package:aivsol_solo_travel/feature/detail/domain/entities/budget_entity.dart';
import 'package:aivsol_solo_travel/feature/detail/presentation/bloc/estimate_budget_bloc.dart';
import 'package:aivsol_solo_travel/feature/detail/presentation/bloc/estimate_budget_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DetailBudgetSectionWidget extends StatelessWidget {
  final VoidCallback? onRetry;

  const DetailBudgetSectionWidget({super.key, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EstimateBudgetBloc, EstimateBudgetState>(
      builder: (context, state) {
        return switch (state) {
          EstimateBudgetInitial() => const _InitialBudgetWidget(),
          EstimateBudgetLoading() => const _LoadingBudgetWidget(),
          EstimateBudgetFailure() => _FailureBudgetWidget(
            message: state.errorMessage,
            onRetry: onRetry,
          ),
          EstimateBudgetSuccess() => _SucessBudgetWidget(budget: state.budget),
        };
      },
    );
  }
}

class _InitialBudgetWidget extends StatelessWidget {
  const _InitialBudgetWidget();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(24),
      child: Center(child: Text('Budget ready to estimate.')),
    );
  }
}

class _LoadingBudgetWidget extends StatelessWidget {
  const _LoadingBudgetWidget();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 36),
      child: Center(
        child: Column(
          children: [
            SizedBox(
              height: 28,
              width: 28,
              child: CircularProgressIndicator(strokeWidth: 2.5),
            ),
            SizedBox(height: 12),
            Text('Calculating route distance & budget...'),
          ],
        ),
      ),
    );
  }
}

class _FailureBudgetWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const _FailureBudgetWidget({required this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(
            Icons.error_outline_rounded,
            color: Colors.red.shade400,
            size: 36,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Budget estimation failed',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(message, maxLines: 2, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          if (onRetry != null)
            IconButton(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
            ),
        ],
      ),
    );
  }
}

class _SucessBudgetWidget extends StatelessWidget {
  final BudgetEntity budget;
  const _SucessBudgetWidget({required this.budget});

  String formatCurrency(double amount) {
    return '₹${amount.round()}';
  }

  @override
  Widget build(BuildContext context) {
    final items = [
      _BudgetItem(
        title: 'Travel (Road / Flight)',
        subtitle: 'Round-trip: ${budget.distanceInKm.toStringAsFixed(0)} km',
        amount: formatCurrency(budget.travelCost),
        icon: Icons.train_outlined,
      ),
      _BudgetItem(
        title: 'Stay (Hostel/Hotel)',
        subtitle: '${budget.hotelNights} nights accommodation',
        amount: formatCurrency(budget.hotelCost),
        icon: Icons.bed_outlined,
      ),
      _BudgetItem(
        title: 'Food & Dining',
        subtitle: '${budget.tripDays} days meal allowance',
        amount: formatCurrency(budget.foodCost),
        icon: Icons.restaurant_outlined,
      ),
      _BudgetItem(
        title: 'Local Transport',
        subtitle: '${budget.tripDays} days local commuting',
        amount: formatCurrency(budget.localTransportCost),
        icon: Icons.two_wheeler_outlined,
      ),
    ];

    return Padding(
      padding: const .only(top: 20),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Row(
            crossAxisAlignment: .center,
            children: [
              Text(
                'Estimate Budget',
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.0,
                ),
              ),
              const Spacer(),
              Tooltip(
                decoration: BoxDecoration(
                  color: AppColors.textPrimary.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(8),
                ),
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.sizeOf(context).width - 20,
                ),
                textStyle: context.textTheme.bodyMedium?.copyWith(
                  color: AppColors.background,
                ),
                message: 'Prices are calculated based on round-trip distance, hotel nights, and daily allowances.',
                child: const Icon(
                  Icons.info_outline,
                  size: 18,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                formatCurrency(budget.totalCost),
                style: context.textTheme.headlineMedium?.copyWith(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(width: 6),
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  'INR',
                  style: context.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            decoration: BoxDecoration(
              color: context.themeData.scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: context.themeData.disabledColor.withAlpha(12),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: context.themeData.shadowColor.withAlpha(16),
                  blurRadius: 12,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: items.asMap().entries.map((entry) {
                final isLast = entry.key == items.length - 1;
                return Column(
                  children: [
                    _BudgetRow(item: entry.value),
                    if (!isLast)
                      Divider(
                        height: 1,
                        indent: 56,
                        color: context.themeData.dividerColor.withAlpha(60),
                      ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _BudgetItem {
  final String title;
  final String subtitle;
  final String amount;
  final IconData icon;

  const _BudgetItem({
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.icon,
  });
}

class _BudgetRow extends StatelessWidget {
  final _BudgetItem item;

  const _BudgetRow({required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.primary.withAlpha(18),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(item.icon, size: 18, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: context.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  item.subtitle,
                  style: context.textTheme.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Text(
            item.amount,
            style: context.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
