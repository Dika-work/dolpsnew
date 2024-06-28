import 'package:doplsnew/utils/theme/app_colors.dart';
import 'package:doplsnew/utils/theme/appbar_theme.dart';
import 'package:doplsnew/utils/theme/bottom_sheet_theme.dart';
import 'package:doplsnew/utils/theme/checkbox_theme.dart';
import 'package:doplsnew/utils/theme/elevated_btn_theme.dart';
import 'package:doplsnew/utils/theme/outlined_btn_theme.dart';
import 'package:doplsnew/utils/theme/text_field_theme.dart';
import 'package:doplsnew/utils/theme/text_theme.dart';
import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Urbanist',
    disabledColor: AppColors.grey,
    brightness: Brightness.light,
    primaryColor: AppColors.primary,
    textTheme: CustomTextTheme.lightTextTheme,
    appBarTheme: CustomAppBarTheme.lightAppBarTheme,
    checkboxTheme: CustomCheckboxTheme.lightCheckboxTheme,
    scaffoldBackgroundColor: AppColors.primaryBackground,
    bottomSheetTheme: CustomBottomSheetTheme.lightBottomSheetTheme,
    elevatedButtonTheme: CustomElevatedButtonTheme.lightElevatedButtonTheme,
    outlinedButtonTheme: CustomOutlinedButtonTheme.lightOutlinedButtonTheme,
    inputDecorationTheme: CustomTextFormFieldTheme.lightInputDecorationTheme,
  );

  // static ThemeData darkTheme = ThemeData(
  //   useMaterial3: true,
  //   fontFamily: 'Urbanist',
  //   disabledColor: AppColors.grey,
  //   brightness: Brightness.dark,
  //   primaryColor: AppColors.primary,
  //   textTheme: CustomTextTheme.darkTextTheme,
  //   appBarTheme: CustomAppBarTheme.darkAppBarTheme,
  //   checkboxTheme: CustomCheckboxTheme.darkCheckboxTheme,
  //   scaffoldBackgroundColor: AppColors.primary.withOpacity(0.1),
  //   bottomSheetTheme: CustomBottomSheetTheme.darkBottomSheetTheme,
  //   elevatedButtonTheme: CustomElevatedButtonTheme.darkElevatedButtonTheme,
  //   outlinedButtonTheme: CustomOutlinedButtonTheme.darkOutlinedButtonTheme,
  //   inputDecorationTheme: CustomTextFormFieldTheme.darkInputDecorationTheme,
  // );
}
