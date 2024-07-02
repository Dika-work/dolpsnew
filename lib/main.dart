import 'package:doplsnew/helpers/routes.dart';
import 'package:doplsnew/screens/login.dart';
import 'package:doplsnew/screens/onboarding.dart';
import 'package:doplsnew/screens/rootpage.dart';
import 'package:doplsnew/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  final localStorage = GetStorage();
  final bool isFirstTime = localStorage.read('IsFirstTime') ?? true;
  final bool isLoggedIn = localStorage.read('user') != null;

  Widget initialPage;

  if (isFirstTime) {
    localStorage.write('IsFirstTime', false);
    initialPage = const OnboardingScreen();
  } else {
    initialPage = isLoggedIn ? const Rootpage() : const LoginScreen();
  }

  runApp(MyApp(initialPage: initialPage));
}

class MyApp extends StatelessWidget {
  final Widget initialPage;

  const MyApp({Key? key, required this.initialPage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      theme: AppTheme.lightTheme,
      home: initialPage,
      getPages: AppRoutes.routes(),
    );
  }
}
