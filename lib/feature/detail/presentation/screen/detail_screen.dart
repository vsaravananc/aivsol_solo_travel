import 'package:aivsol_solo_travel/core/extensions/theme_extensions.dart';
import 'package:aivsol_solo_travel/core/theme/app_theme.dart';
import 'package:aivsol_solo_travel/feature/detail/presentation/widgets/detail_budget_section_widget.dart';
import 'package:aivsol_solo_travel/feature/detail/presentation/widgets/detail_header_widget.dart';
import 'package:aivsol_solo_travel/feature/detail/presentation/widgets/detail_share_sheet_widget.dart';
import 'package:aivsol_solo_travel/feature/detail/presentation/widgets/detail_weather_section_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {
  final String from;
  final String to;
  final String fromCode;
  final String toPlace;
  final String dateRange;
  final int days;
  final String travelStyle;

  const DetailScreen({
    super.key,
    required this.from,
    required this.to,
    required this.fromCode,
    required this.toPlace,
    required this.dateRange,
    required this.days,
    required this.travelStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Trip Detail'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () => DetailShareSheetWidget.show(
                context,
                from: from,
                to: to,
                dateRange: dateRange,
                days: days,
                travelStyle: travelStyle,
              ),
              child: Container(
                width: 38,
                height: 38,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  CupertinoIcons.share,
                  color: context.themeData.scaffoldBackgroundColor,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DetailHeaderWidget(
              from: from,
              to: to,
              dateRange: dateRange,
              days: days,
              travelStyle: travelStyle,
            ),

            DetailBudgetSectionWidget.dummy(),

            const DetailWeatherSectionWidget(),

          ],
        ),
      ),
    );
  }
}
