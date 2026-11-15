import 'package:aivsol_solo_travel/core/enums/share_option.dart';
import 'package:aivsol_solo_travel/core/extensions/theme_extensions.dart';
import 'package:aivsol_solo_travel/core/theme/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

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

  Future<void> launchOption(ShareOption option) async {
    if (option == ShareOption.shareTrip) {
      SharePlus.instance.share(
        ShareParams(
          text:
              'Check out my solo trip plan from $from to $to ($dateRange, $days Days) - Style: $travelStyle!',
        ),
      );
    } else {
      //// need to add the from date and to date to autofill
      final url = option.buildUrl(from: 'Chennai', destination: 'Bengaluru');
      if (url == null) return;
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoActionSheet(
      title: Text(
        'Explore & Share Options',
        style: context.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w700,
        ),
      ),
      message: Text(
        'Choose an option to explore or share your itinerary.',
        style: context.textTheme.bodySmall,
      ),
      actions: ShareOption.values.map((option) {
        return CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(context);
            launchOption(option);
          },
          child: Row(
            spacing: 12,
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

              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  mainAxisSize: .min,
                  children: [
                    Text(
                      option.title,
                      style: context.textTheme.bodyLarge?.copyWith(
                        fontWeight: .w600,
                      )
                    ),
                    Text(
                      option.subtitle,
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
