import 'package:flutter/material.dart';
import 'package:chat_bot_package/core/components/constant/image_const.dart';

class AppIconWidget extends StatelessWidget {
  final double radius;
  const AppIconWidget({
    super.key,
    required this.radius,
  });

  @override
  Widget build(BuildContext context) {
    BoxShadow shadow = BoxShadow(
        color: Theme.of(context).shadowColor.withOpacity(0.1), blurRadius: 5.0);

    return Container(
      width: radius,
      height: radius,
      decoration: BoxDecoration(
        boxShadow: [shadow],
        shape: BoxShape.circle,
        color: Theme.of(context).cardColor,
      ),
      padding: const EdgeInsets.all(3.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: Image.asset(ImageConst.appIcon,
            width: double.infinity, height: double.infinity),
      ),
    );
  }
}
