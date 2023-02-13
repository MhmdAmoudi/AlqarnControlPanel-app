import 'package:flutter/material.dart';

import 'style.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    colorScheme: const ColorScheme.light(),
    primarySwatch: AppColors.primarySwatch,
    brightness: Brightness.light,
    fontFamily: 'Hacen',
  );

  static final darkTheme = ThemeData(
    scaffoldBackgroundColor: AppColors.darkMainColor,
    appBarTheme: const AppBarTheme().copyWith(
      backgroundColor: AppColors.darkSubColor,
      elevation: 0,
      centerTitle: true,
    ),
    canvasColor: AppColors.darkSubColor, // drop down background color
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        fixedSize: const Size(double.infinity, 45),
        foregroundColor: Colors.white,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        fixedSize: const Size(double.infinity, 45),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
          side: const BorderSide(color: AppColors.mainColor),
        ),
      ),
    ),
    switchTheme: SwitchThemeData(
      trackColor: MaterialStateProperty.resolveWith(
            (Set states) {
          if (states.contains(MaterialState.selected)) {
            return AppColors.mainColor.withOpacity(.48);
          }
          return null;
        },
      ),
      thumbColor: MaterialStateProperty.resolveWith(
            (Set states) {
          if (states.contains(MaterialState.selected)) {
            return AppColors.mainColor;
          }
          return null;
        },
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        textStyle:
        const TextStyle(fontFamily: 'Hacen', fontWeight: FontWeight.normal),
      ),
    ),
    dialogBackgroundColor: AppColors.darkSubColor,
    bottomAppBarColor: AppColors.darkMainColor,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.mainColor,
      secondary: AppColors.subColor,
    ),
    brightness: Brightness.dark,
    primarySwatch: AppColors.primarySwatch,
    splashColor: AppColors.mainColor.withOpacity(0.1),
    highlightColor: Colors.black12,
    fontFamily: 'Hacen',
    cardColor: AppColors.darkSubColor,
  );
}