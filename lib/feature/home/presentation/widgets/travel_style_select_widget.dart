import 'package:aivsol_solo_travel/core/enums/travel_style.dart';
import 'package:aivsol_solo_travel/core/extensions/theme_extensions.dart';
import 'package:aivsol_solo_travel/core/theme/app_theme.dart';
import 'package:aivsol_solo_travel/feature/home/presentation/bloc/home_bloc.dart';
import 'package:aivsol_solo_travel/feature/home/presentation/bloc/home_event.dart';
import 'package:aivsol_solo_travel/feature/home/presentation/bloc/home_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TravelStyleSelectWidget extends StatelessWidget {
  const TravelStyleSelectWidget({super.key});

  void _showPicker(BuildContext context, TravelStyle currentStyle) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (modalContext) {
        return CupertinoActionSheet(
          title: Text(
            'Select Travel Style',
            style: context.textTheme.titleMedium,
          ),
          message: const Text(
            'Choose a budget tier that best fits your travel plan.',
            style: TextStyle(fontSize: 13),
          ),
          actions: TravelStyle.values.map((style) {
            final isSelected = style == currentStyle;
            return CupertinoActionSheetAction(
              onPressed: () {
                context.read<HomeBloc>().add(TravelStyleChangedEvent(style));
                Navigator.pop(modalContext);
              },
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? context.themeData.primaryColor.withAlpha(20)
                          : AppColors.bgGrey,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      style.icon,
                      size: 18,
                      color: isSelected
                          ? context.themeData.primaryColor
                          : const Color(0xFF1E242B),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          style.label,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: isSelected
                                ? FontWeight.w700
                                : FontWeight.w500,
                            color: const Color(0xFF1E242B),
                          ),
                        ),
                        Text(
                          style.description,
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
                  if (isSelected)
                    Icon(
                      CupertinoIcons.checkmark_alt,
                      color: context.themeData.primaryColor,
                      size: 20,
                    ),
                ],
              ),
            );
          }).toList(),
          cancelButton: CupertinoActionSheetAction(
            isDefaultAction: true,
            onPressed: () => Navigator.pop(modalContext),
            child: const Text('Cancel'),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      buildWhen: (previous, current) =>
          previous.travelStyle != current.travelStyle,
      builder: (context, state) {
        final style = state.travelStyle ?? TravelStyle.standard;

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
                child: Icon(
                  style.icon,
                  size: 20,
                  color: const Color(0xFF1E242B),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      style.label,
                      style: context.textTheme.titleMedium?.copyWith(
                        fontWeight: .w700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      style.description,
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
                  onTap: () => _showPicker(context, style),
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
                      'Select',
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
