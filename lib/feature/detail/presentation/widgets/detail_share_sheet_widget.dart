import 'package:aivsol_solo_travel/core/extensions/theme_extensions.dart';
import 'package:aivsol_solo_travel/core/external_apps/external_app_config.dart';
import 'package:aivsol_solo_travel/core/external_apps/external_app_launcher.dart';
import 'package:aivsol_solo_travel/core/external_apps/external_apps.dart';
import 'package:aivsol_solo_travel/core/theme/app_theme.dart';
import 'package:aivsol_solo_travel/core/utility/scaffold_messenger_key.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class _SheetItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SheetItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });
}

class DetailShareSheetWidget extends StatefulWidget {
  final String from;
  final String to;
  final String dateRange;
  final int days;
  final String travelStyle;
  final DateTime startDate;
  final DateTime endDate;

  const DetailShareSheetWidget({
    super.key,
    required this.from,
    required this.to,
    required this.dateRange,
    required this.days,
    required this.travelStyle,
    required this.startDate,
    required this.endDate,
  });

  static Future<void> show(
    BuildContext context, {
    required String from,
    required String to,
    required String dateRange,
    required int days,
    required String travelStyle,
    required DateTime startDate,
    required DateTime endDate,
  }) {
    return showCupertinoModalPopup<void>(
      context: context,
      builder: (modalContext) => DetailShareSheetWidget(
        from: from,
        to: to,
        dateRange: dateRange,
        days: days,
        travelStyle: travelStyle,
        endDate: endDate,
        startDate: startDate,
      ),
    );
  }

  @override
  State<DetailShareSheetWidget> createState() => _DetailShareSheetWidgetState();
}

class _DetailShareSheetWidgetState extends State<DetailShareSheetWidget> {
  bool _isLaunching = false;

  String get _checkin => DateFormat('yyyy-MM-dd').format(widget.startDate);
  String get _checkout => DateFormat('yyyy-MM-dd').format(widget.endDate);

  Future<void> _handleExternalApp(ExternalAppConfig config) async {
    if (_isLaunching) return;
    _isLaunching = true;

    try {
      final result = await ExternalAppLauncher.launch(
        config: config,
        destination: widget.to,
        checkin: _checkin,
        checkout: _checkout,
      );

      if (!result.didOpen) {
        _showErrorSnackbar(
          result.errorMessage ??
              'Unable to open ${config.appName}. Please try again.',
        );
      }
    } finally {
      _isLaunching = false;
    }
  }

  void _showErrorSnackbar(String message) {
    final messenger = rootScaffoldMessengerKey.currentState;
    if (messenger == null) return;

    messenger.clearSnackBars();
    messenger.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 20),
        backgroundColor: Colors.transparent,
        elevation: 0,
        duration: const Duration(seconds: 3),
        content: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF2C1517),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.error.withValues(alpha: 0.4),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.error_outline_rounded,
                  color: AppColors.error,
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    height: 1.3,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<_SheetItem> _buildItems() {
    final items = <_SheetItem>[];

    for (final config in ExternalApps.all) {
      items.add(
        _SheetItem(
          icon: config.icon,
          title: config.title,
          subtitle: config.subtitle,
          onTap: () => _handleExternalApp(config),
        ),
      );
    }

    return items;
  }

  @override
  Widget build(BuildContext context) {
    final items = _buildItems();

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
      actions: items.map((item) {
        return CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(context);
            item.onTap();
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
                child: Icon(item.icon, size: 18, color: AppColors.primary),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      item.title,
                      style: context.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
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
