import 'package:aivsol_solo_travel/core/extensions/theme_extensions.dart';
import 'package:aivsol_solo_travel/core/theme/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class ShareOptionItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const ShareOptionItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });
}

class DetailShareSheetWidget extends StatelessWidget {
  final String from;
  final String to;
  final String dateRange;
  final int days;
  final String travelStyle;

  const DetailShareSheetWidget({
    super.key,
    required this.from,
    required this.to,
    required this.dateRange,
    required this.days,
    required this.travelStyle,
  });

  static Future<void> show(
    BuildContext context, {
    required String from,
    required String to,
    required String dateRange,
    required int days,
    required String travelStyle,
  }) {
    return showCupertinoModalPopup<void>(
      context: context,
      builder: (modalContext) => DetailShareSheetWidget(
        from: from,
        to: to,
        dateRange: dateRange,
        days: days,
        travelStyle: travelStyle,
      ),
    );
  }

  List<ShareOptionItem> _buildOptions(BuildContext context) {
    return [
      ShareOptionItem(
        title: 'Open in Google Maps',
        subtitle: 'Explore your destination',
        icon: Icons.map_outlined,
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Opening Google Maps for $to...'),
              duration: const Duration(seconds: 2),
            ),
          );
        },
      ),
      ShareOptionItem(
        title: 'Find Flights / Trains',
        subtitle: 'Compare travel options',
        icon: Icons.flight_takeoff_outlined,
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Searching flights & trains from $from to $to...'),
              duration: const Duration(seconds: 2),
            ),
          );
        },
      ),
      ShareOptionItem(
        title: 'Find Hotels',
        subtitle: 'Find accommodation for your dates',
        icon: Icons.hotel_outlined,
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Finding hotels in $to for $dateRange...'),
              duration: const Duration(seconds: 2),
            ),
          );
        },
      ),
      ShareOptionItem(
        title: 'Share Trip Plan',
        subtitle: 'Share your itinerary with friends',
        icon: Icons.share_outlined,
        onTap: () {
          SharePlus.instance.share(
            ShareParams(
              text:
                  'Check out my solo trip plan from $from to $to ($dateRange, $days Days) - Style: $travelStyle!',
            ),
          );
        },
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final options = _buildOptions(context);

    return CupertinoActionSheet(
      title: Text(
        'Explore & Share Options',
        style: context.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w700,
        ),
      ),
      message: const Text(
        'Choose an option to explore or share your itinerary.',
        style: TextStyle(fontSize: 13),
      ),
      actions: options.map((option) {
        return CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(context);
            option.onTap();
          },
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.primary.withAlpha(20),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  option.icon,
                  size: 18,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      option.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1E242B),
                      ),
                    ),
                    Text(
                      option.subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF8E8E93),
                      ),
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
        );
      }).toList(),
      cancelButton: CupertinoActionSheetAction(
        isDefaultAction: true,
        onPressed: () => Navigator.pop(context),
        child: const Text('Cancel'),
      ),
    );
  }
}
