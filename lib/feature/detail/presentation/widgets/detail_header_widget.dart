import 'package:aivsol_solo_travel/core/extensions/theme_extensions.dart';
import 'package:aivsol_solo_travel/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class DetailHeaderWidget extends StatelessWidget {
  final String from;
  final String to;
  final String dateRange;
  final int days;
  final String travelStyle;

  const DetailHeaderWidget({
    super.key,
    required this.from,
    required this.to,
    required this.dateRange,
    required this.days,
    required this.travelStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .center,
      children: [
        const SizedBox(width: .infinity),
        Text(
          '$from  →  $to',
          style: context.textTheme.headlineMedium?.copyWith(
            fontWeight: .w700,
          ),
        ),
        Row(
          mainAxisAlignment: .center,
          children: [
            const Icon(
              Icons.calendar_today_outlined,
              size: 14,
              color: AppColors.textSecondary,
            ),
            const SizedBox(width: 6),
            Text(
              '$dateRange  •  $days Days • $travelStyle',
              style: context.textTheme.bodyMedium,
            ),
          ],
        ),
      ],
    );
  }
}
