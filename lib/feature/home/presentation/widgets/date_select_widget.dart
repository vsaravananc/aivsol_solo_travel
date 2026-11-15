import 'package:aivsol_solo_travel/core/extensions/theme_extensions.dart';
import 'package:aivsol_solo_travel/core/theme/app_theme.dart';
import 'package:aivsol_solo_travel/feature/home/presentation/bloc/home_bloc.dart';
import 'package:aivsol_solo_travel/feature/home/presentation/bloc/home_event.dart';
import 'package:aivsol_solo_travel/feature/home/presentation/bloc/home_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class DateSelectWidget extends StatelessWidget {
  const DateSelectWidget({super.key});

  Future<void> _handleEdit(
    BuildContext context,
    DateTime currentStart,
    DateTime currentEnd,
  ) async {
    final now = DateTime.now();
    final firstSelectableDate = DateTime(now.year, now.month, now.day + 1);
    final lastSelectableDate = DateTime(now.year + 5, 12, 31);

    final picked = await showDateRangePicker(
      context: context,
      firstDate: firstSelectableDate,
      lastDate: lastSelectableDate,
      initialDateRange: DateTimeRange(start: currentStart, end: currentEnd),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      builder: (context, child) {
        return SafeArea(
          bottom: false,
          child: Theme(
            data: context.themeData.copyWith(
              colorScheme: context.themeData.colorScheme.copyWith(
                primary: AppColors.primary,
                onPrimary: Colors.white,
              ),
            ),
            child: child!,
          ),
        ).animate().slideY(
          begin: 0.5,
          end: 0,
          duration: const Duration(milliseconds: 300),
        );
      },
    );

    if (picked == null || !context.mounted) return;

    context.read<HomeBloc>().add(
      DateRangeChangedEvent(startDate: picked.start, endDate: picked.end),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      buildWhen: (previous, current) =>
          previous.startDate != current.startDate ||
          previous.endDate != current.endDate,
      builder: (context, state) {
        final startDate = state.startDate!;
        final endDate = state.endDate!;
        final totalDays = endDate.difference(startDate).inDays;

        return Container(
          margin: const .only(top: 12),
          padding: const .symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            color: context.themeData.scaffoldBackgroundColor,
            borderRadius: .circular(18),
            border: .all(
              color: context.themeData.disabledColor.withAlpha(12),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: context.themeData.shadowColor.withAlpha(20),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            spacing: 12,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  color: AppColors.bgGrey,
                  shape: .circle,
                ),
                child: const Icon(
                  Icons.calendar_today,
                  size: 20,
                  color: Color(0xFF1E242B),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text.rich(
                      TextSpan(
                        style: context.textTheme.titleMedium?.copyWith(
                          fontWeight: .w700,
                        ),
                        children: [
                          TextSpan(text: DateFormat('d MMM').format(startDate)),
                          TextSpan(
                            text: '  →  ',
                            style: context.textTheme.bodyMedium?.copyWith(
                              fontSize: 13,
                            ),
                          ),
                          TextSpan(
                            text: DateFormat('d MMM yyyy').format(endDate),
                          ),
                        ],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '$totalDays Days Solo Itinerary',
                      style: context.textTheme.bodyMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => _handleEdit(context, startDate, endDate),
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: context.themeData.primaryColor.withAlpha(15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'Edit',
                      style: context.textTheme.bodyMedium?.copyWith(
                        fontWeight: .w600,
                        color: context.themeData.primaryColor,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
