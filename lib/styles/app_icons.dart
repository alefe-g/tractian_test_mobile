import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AppIcons {
  static final bold = SvgPicture.asset('assets/icons/bold.svg');

  static final codepen = Image.asset('assets/icons/Codepen.png');

  static final ellipse = SvgPicture.asset('assets/icons/Ellipse.svg');

  static final goLocation = SvgPicture.asset('assets/icons/GoLocation.svg');

  static final greenBold = SvgPicture.asset('assets/icons/GreenBold.svg');

  static final whiteBold = SvgPicture.asset('assets/icons/WhiteBold.svg');

  static final icon = SvgPicture.asset('assets/icons/icon.svg');

  static final info = SvgPicture.asset('assets/icons/info.svg');

  static final whiteInfo = SvgPicture.asset(
    'assets/icons/info.svg',
    colorFilter: const ColorFilter.mode(
      Colors.white,
      BlendMode.srcATop,
    ),
  );

  static final ioCubeOutline = SvgPicture.asset(
    'assets/icons/IoCubeOutline.svg',
  );
}
