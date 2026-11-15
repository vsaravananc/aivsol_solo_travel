import 'package:aivsol_solo_travel/core/extensions/theme_extensions.dart';
import 'package:aivsol_solo_travel/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class _ExploreItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback? onTap;

  const _ExploreItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    this.onTap,
  });
}

class DetailExploreSectionWidget extends StatelessWidget {
  final VoidCallback? onOpenMaps;
  final VoidCallback? onFindFlightsTrains;
  final VoidCallback? onFindHotels;
  final VoidCallback? onShareTripPlan;

  const DetailExploreSectionWidget({
    super.key,
    this.onOpenMaps,
    this.onFindFlightsTrains,
    this.onFindHotels,
    this.onShareTripPlan,
  });

  List<_ExploreItem> _buildItems() {
    return [
      _ExploreItem(
        title: 'Open in Google Maps',
        subtitle: 'Explore your destination',
        icon: Icons.map_outlined,
        onTap: onOpenMaps,
      ),
      _ExploreItem(
        title: 'Find Flights / Trains',
        subtitle: 'Compare travel options',
        icon: Icons.flight_takeoff_outlined,
        onTap: onFindFlightsTrains,
      ),
      _ExploreItem(
        title: 'Find Hotels',
        subtitle: 'Find accommodation for your dates',
        icon: Icons.hotel_outlined,
        onTap: onFindHotels,
      ),
      _ExploreItem(
        title: 'Share Trip Plan',
        subtitle: 'Share your itinerary with friends',
        icon: Icons.share_outlined,
        onTap: onShareTripPlan,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final items = _buildItems();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'EXPLORE YOUR JOURNEY',
              style: context.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: 1.0,
                color: AppColors.textSecondary,
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () {},
              child: Text(
                'Quick Launch',
                style: context.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
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
                    _ExploreRow(item: entry.value),
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
    );
  }
}

class _ExploreRow extends StatelessWidget {
  final _ExploreItem item;

  const _ExploreRow({required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: item.onTap ?? () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.bgGrey,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(item.icon, size: 18, color: AppColors.textPrimary),
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
            Icon(
              Icons.chevron_right_rounded,
              color: context.themeData.disabledColor,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
