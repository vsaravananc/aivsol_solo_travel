import 'package:aivsol_solo_travel/core/extensions/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomFieldWidget extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final FocusNode? focusNode;
  final String hintText;
  final FormFieldValidator<String>? validator;
  final VoidCallback? onTap;
  final TextInputAction textInputAction;

  const CustomFieldWidget({
    super.key,
    required this.label,
    required this.controller,
    required this.hintText,
    this.focusNode,
    this.validator,
    this.onTap,
    this.textInputAction = TextInputAction.next,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      mainAxisSize: .min,
      children: [
        Text(
          label,
          style: context.textTheme.bodySmall?.copyWith(
            fontWeight: .w700,
            letterSpacing: 0.4,
          ),
        ),
        TextFormField(
          controller: controller,
          focusNode: focusNode,
          onTap: onTap,
          validator: validator,
          textInputAction: textInputAction,
          onTapUpOutside: (_) {
            focusNode?.unfocus();
          },
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
            TextInputFormatter.withFunction((old, current) {
              return current.copyWith(
                text:
                    current.text[0].toUpperCase() +
                    current.text.substring(1).toLowerCase(),
                selection: current.selection,
              );
            }),
          ],
          style: context.textTheme.titleMedium?.copyWith(fontWeight: .w600),
          decoration: InputDecoration(hintText: hintText),
        ),
      ],
    );
  }
}
