import 'package:doplsnew/helpers/context_util.dart';
import 'package:doplsnew/helpers/routes.dart';
import 'package:doplsnew/helpers/uni_services.dart';
import 'package:doplsnew/screens/login.dart';
import 'package:doplsnew/screens/onboarding.dart';
import 'package:doplsnew/screens/rootpage.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:doplsnew/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await UniServices.init();

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

  const MyApp({super.key, required this.initialPage});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      navigatorKey: ContextUtility.navigatorKey,
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      theme: AppTheme.lightTheme,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en'), Locale('id')],
      home: initialPage,
      getPages: AppRoutes.routes(),
    );
  }
}
