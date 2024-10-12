// import 'package:doplsnew/helpers/helper_function.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:lottie/lottie.dart';

// import '../utils/constant/custom_size.dart';

// class OnBoardingPage extends StatelessWidget {
//   const OnBoardingPage(
//       {super.key,
//       required this.image,
//       required this.title,
//       required this.subtitle,
//       this.titleTextStyle,
//       this.bodyTextStyle,
//       this.language});

//   final String image, title, subtitle;
//   final TextStyle? titleTextStyle;
//   final TextStyle? bodyTextStyle;
//   final Widget? language;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(CustomSize.lg),
//       child: Column(
//         children: [
//           Lottie.asset(
//             image,
//             width: CustomHelperFunctions.screenWidth() * .8,
//             height: CustomHelperFunctions.screenHeight() * .6,
//           ),
//           Text(
//             title,
//             textAlign: TextAlign.center,
//             style: titleTextStyle,
//           ),
//           const SizedBox(height: 16.0),
//           Text(
//             subtitle,
//             textAlign: TextAlign.center,
//             style: bodyTextStyle,
//           ),
//           language ?? const SizedBox.shrink()
//         ],
//       ),
//     );
//   }
// }

// // onboarding controllernya disini
// class OnBoardingController extends GetxController {
//   static OnBoardingController get instance => Get.find();

//   final pageController = PageController();
//   Rx<int> currentPageIndex = 0.obs;

//   void updatePageIndicator(index) {
//     currentPageIndex.value = index;
//   }

//   void dotNavigationClick(index) {
//     currentPageIndex.value = index;
//     pageController.jumpTo(index);
//   }

//   void nextPage() {
//     if (currentPageIndex.value == 2) {
//       final storage = GetStorage();
//       storage.write('IsFirstTime', false);
//       Get.offAllNamed('/login');
//     } else {
//       int page = currentPageIndex.value + 1;
//       pageController.jumpToPage(page);
//     }
//   }

//   void skipPage() {
//     currentPageIndex.value = 2;
//     pageController.jumpToPage(2);
//   }
// }
