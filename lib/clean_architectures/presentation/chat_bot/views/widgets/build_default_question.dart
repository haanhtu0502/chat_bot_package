import 'package:chat_bot_package/core/components/extensions/context_extensions.dart';
import 'package:chat_bot_package/core/components/extensions/string_extensions.dart';
import 'package:chat_bot_package/core/design_systems/theme_colors.dart';
import 'package:flutter/material.dart';

class BuildDefaultQuestion extends StatelessWidget {
  const BuildDefaultQuestion({
    super.key,
    required this.question,
    required this.onTap,
  });

  final String question;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppColors.brightBlue.toColor(),
          ),
        ),
        child: Text(
          question,
          style: context.titleMedium,
        ),
      ),
    );
  }
}
