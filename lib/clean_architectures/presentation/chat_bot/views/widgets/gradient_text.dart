import 'package:flutter/material.dart';

class GradientText extends StatelessWidget {
  final String text;
  final TextStyle style;

  const GradientText({
    Key? key,
    required this.text,
    required this.style,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        transform: GradientRotation(136.1 * 3.1416 / 180), // chuyển deg -> rad
        colors: [
          Color(0xFF36DFF1),
          Color(0xFF2764E7),
        ],
        stops: [0.1131, 0.8169],
      ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
      child: Text(
        text,
        style:
            style.copyWith(color: Colors.white), // color sẽ bị che bởi Shader
      ),
    );
  }
}
