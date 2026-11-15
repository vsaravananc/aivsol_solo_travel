import 'package:aivsol_solo_travel/core/extensions/theme_extensions.dart';
import 'package:aivsol_solo_travel/feature/home/presentation/bloc/home_bloc.dart';
import 'package:aivsol_solo_travel/feature/home/presentation/bloc/home_event.dart';
import 'package:aivsol_solo_travel/feature/home/presentation/bloc/home_state.dart';
import 'package:aivsol_solo_travel/feature/home/presentation/widgets/custom_filed_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FromToInputWidget extends StatefulWidget {
  const FromToInputWidget({super.key});

  @override
  State<FromToInputWidget> createState() => _FromToInputWidgetState();
}

class _FromToInputWidgetState extends State<FromToInputWidget> {
  late TextEditingController fromController;
  late TextEditingController toController;
  late FocusNode fromFocusNode;
  late FocusNode toFocusNode;
  ValueNotifier<double> rotationTurns = ValueNotifier(0.0);

  @override
  void initState() {
    fromController = TextEditingController();
    toController = TextEditingController();
    fromFocusNode = FocusNode();
    toFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    fromController.dispose();
    toController.dispose();
    fromFocusNode.dispose();
    toFocusNode.dispose();
    rotationTurns.dispose();
    super.dispose();
  }

  void _handleSwap() {
    rotationTurns.value += 0.5;
    final temp = fromController.text;
    fromController.text = toController.text;
    toController.text = temp;
    context.read<HomeBloc>().add(const LocationsSwappedEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeBloc, HomeState>(
      listenWhen: (previous, current) =>
          previous.from != current.from || previous.to != current.to,
      listener: (context, state) {
        if (state.from != null && state.from != fromController.text) {
          fromController.text = state.from!;
        }
        if (state.to != null && state.to != toController.text) {
          toController.text = state.to!;
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 12.0),
        child: Stack(
          alignment: .centerRight,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              decoration: BoxDecoration(
                color: context.themeData.scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
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
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 12,
                children: [
                  Column(
                    mainAxisSize: .min,
                    children: [
                      Container(
                        padding: const .all(8),
                        decoration: BoxDecoration(
                          color: context.themeData.primaryColor.withAlpha(30),
                          shape: .circle,
                        ),
                        child: Center(
                          child: Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: context.themeData.primaryColor,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 1.2,
                        height: 35,
                        color: context.themeData.primaryColor.withAlpha(30),
                      ),
                      Container(
                        padding: const .all(6),
                        decoration: BoxDecoration(
                          color: context.themeData.primaryColor.withAlpha(30),
                          shape: .circle,
                        ),
                        child: Center(
                          child: Icon(
                            Icons.location_on_rounded,
                            color: context.themeData.primaryColor,
                            size: 17,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      spacing: 16,
                      children: [
                        CustomFieldWidget(
                          label: 'From',
                          controller: fromController,
                          focusNode: fromFocusNode,
                          hintText: 'Bengaluru (BLR)',
                          textInputAction: TextInputAction.next,
                          onChanged: (value) {
                            context.read<HomeBloc>().add(
                                  FromLocationChangedEvent(value),
                                );
                          },
                        ),
                        CustomFieldWidget(
                          label: 'To',
                          controller: toController,
                          focusNode: toFocusNode,
                          hintText: 'Varkala, Kerala',
                          textInputAction: TextInputAction.done,
                          onChanged: (value) {
                            context.read<HomeBloc>().add(
                                  ToLocationChangedEvent(value),
                                );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Focus(
                canRequestFocus: false,
                autofocus: false,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _handleSwap,
                    borderRadius: BorderRadius.circular(22),
                    child: Ink(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: context.themeData.colorScheme.surface,
                        shape: .circle,
                        border: Border.all(
                          color: context.themeData.dividerColor.withAlpha(20),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: context.themeData.shadowColor.withAlpha(18),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Center(
                        child: AnimatedBuilder(
                          animation: Listenable.merge([rotationTurns]),
                          builder: (context, value) {
                            return AnimatedRotation(
                              turns: rotationTurns.value,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                              child: Icon(
                                Icons.swap_vert_rounded,
                                color: context.themeData.primaryColor,
                                size: 22,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
