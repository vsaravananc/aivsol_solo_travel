import 'package:aivsol_solo_travel/core/extensions/theme_extensions.dart';
import 'package:aivsol_solo_travel/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

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

class DetailBudgetSectionWidget extends StatelessWidget {
  final double totalBudget;
  final List<_BudgetItem> items;

  const DetailBudgetSectionWidget({
    super.key,
    required this.totalBudget,
    required this.items,
  });

  static const _dummyItems = [
    _BudgetItem(
      title: 'Travel (Train / Flight)',
      subtitle: 'Direct trains & connector',
      amount: '₹4,000',
      icon: Icons.train_outlined,
    ),
    _BudgetItem(
      title: 'Stay (Hostel/Hotel)',
      subtitle: 'Cliff view boutique dorm/ro...',
      amount: '₹4,500',
      icon: Icons.bed_outlined,
    ),
    _BudgetItem(
      title: 'Food & Dining',
      subtitle: 'Cafes & fresh coastal catch...',
      amount: '₹2,000',
      icon: Icons.restaurant_outlined,
    ),
    _BudgetItem(
      title: 'Local Transport',
      subtitle: 'Scooter rental & local autos',
      amount: '₹2,000',
      icon: Icons.two_wheeler_outlined,
    ),
  ];

  static DetailBudgetSectionWidget dummy() {
    return const DetailBudgetSectionWidget(
      totalBudget: 12500,
      items: _dummyItems,
    );
  }

  @override
  Widget build(BuildContext context) {
    final formatted =
        '₹${totalBudget.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+$)'), (m) => '${m[1]},')}';

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
                  borderRadius: .circular(8),
                ),
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.sizeOf(context).width - 20,
                ),
                textStyle: context.textTheme.bodyMedium?.copyWith(
                  color: AppColors.background,
                ),
                message: 'Prices are approximate and may vary depending on availability and booking windows.',
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
            crossAxisAlignment: .end,
            children: [
              Text(
                formatted,
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
              children: [
                ...items.asMap().entries.map((entry) {
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
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
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
