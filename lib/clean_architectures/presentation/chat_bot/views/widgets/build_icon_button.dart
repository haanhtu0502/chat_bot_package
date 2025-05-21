import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class BuildIconButton extends StatefulWidget {
  const BuildIconButton({
    super.key,
    required this.onTap,
    required this.assetIcon,
    this.isActive = false,
    this.activeIconColor,
    this.activeBackgroundColor,
    this.inactiveIconColor = Colors.black,
  });

  final String assetIcon;
  final void Function() onTap;
  final bool isActive;
  final Color? activeIconColor;
  final Color? activeBackgroundColor;
  final Color inactiveIconColor;

  @override
  State<BuildIconButton> createState() => _BuildIconButtonState();
}

class _BuildIconButtonState extends State<BuildIconButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: widget.isActive ? widget.activeBackgroundColor : Colors.white,
          shape: BoxShape.circle,
          border: Border.all(
            color: widget.isActive ? Colors.transparent : Colors.grey[300]!,
          ),
        ),
        child: Center(
          child: SvgPicture.asset(
            widget.assetIcon,
            color: widget.isActive
                ? widget.activeIconColor
                : widget.inactiveIconColor,
            width: 20,
            height: 20,
          ),
        ),
      ),
    );
  }
}
