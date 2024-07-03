import 'package:doplsnew/helpers/helper_function.dart';
import 'package:doplsnew/utils/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../loader/animation_loader.dart';
import '../loader/circular_loader.dart';

class CustomFullScreenLoader {
  static void openLoadingDialog(String text, String animation) {
    showDialog(
      context: Get.overlayContext!,
      barrierDismissible: false,
      builder: (_) => PopScope(
        canPop: false,
        child: Container(
          color: AppColors.white,
          width: CustomHelperFunctions.screenWidth(),
          height: CustomHelperFunctions.screenHeight(),
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 250),
                CustomAnimationLoaderWidget(text: text, animation: animation),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static void popUpCircular() {
    Get.defaultDialog(
      title: '',
      onWillPop: () async => false,
      content: const CustomCircularLoader(),
      backgroundColor: Colors.transparent,
    );
  }

  static stopLoading() {
    Navigator.of(Get.overlayContext!).pop();
  }
}
