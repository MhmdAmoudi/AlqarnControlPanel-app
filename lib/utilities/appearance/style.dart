import 'package:flutter/material.dart';

class AppColors {
  static const Color mainColor = Color(0xff0D5BE1);
  static const Color subColor = Color(0xff0F5BDF);
  static const Color darkMainColor = Color(0xff1b1925);
  static const Color darkSubColor = Color(0xff252534);
  static const Color priceColor = Colors.deepOrange;
  static const Color goldColor = Color(0xffffd52b);

  static final MaterialColor primarySwatch = MaterialColor(
    mainColor.value,
    {
      50: AppColors.mainColor.withOpacity(.1),
      100: AppColors.mainColor.withOpacity(.2),
      200: AppColors.mainColor.withOpacity(.3),
      300: AppColors.mainColor.withOpacity(.4),
      400: AppColors.mainColor.withOpacity(.5),
      500: AppColors.mainColor.withOpacity(.6),
      600: AppColors.mainColor.withOpacity(.7),
      700: AppColors.mainColor.withOpacity(.8),
      800: AppColors.mainColor.withOpacity(.9),
      900: AppColors.mainColor.withOpacity(1),
    },
  );
}