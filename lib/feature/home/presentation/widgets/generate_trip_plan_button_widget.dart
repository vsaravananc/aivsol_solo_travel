import 'package:aivsol_solo_travel/core/extensions/theme_extensions.dart';
import 'package:aivsol_solo_travel/feature/home/presentation/bloc/home_bloc.dart';
import 'package:aivsol_solo_travel/feature/home/presentation/bloc/home_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GenerateTripPlanButtonWidget extends StatelessWidget {
  final VoidCallback? onPressed;

  const GenerateTripPlanButtonWidget({
    super.key,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      buildWhen: (previous, current) =>
          previous.isFormValid != current.isFormValid,
      builder: (context, state) {
        final isEnabled = state.isFormValid;

        return Padding(
          padding: const EdgeInsets.only(top: 24),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: context.themeData.primaryColor,
              foregroundColor: context.themeData.scaffoldBackgroundColor,
              disabledBackgroundColor:
                  context.themeData.disabledColor.withAlpha(25),
              disabledForegroundColor: context.themeData.disabledColor,
              elevation: 0,
              minimumSize: const Size(double.infinity, 54),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            onPressed: isEnabled ? (onPressed ?? () {}) : null,
            child: const Text('Generate Trip Plan'),
          ),
        );
      },
    );
  }
}
