import 'package:doplsnew/helpers/routes.dart';
import 'package:doplsnew/screens/rootpage.dart';
import 'package:doplsnew/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  await GetStorage.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      theme: AppTheme.lightTheme,
      getPages: AppRoutes.routes(),
      // home: Rootpage(),
    );
  }
}
