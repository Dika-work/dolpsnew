import 'package:doplsnew/utils/theme/app_colors.dart';
import 'package:doplsnew/widgets/onboarding_page.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:get/get.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnBoardingController());

    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: controller.pageController,
            onPageChanged: controller.updatePageIndicator,
            children: [
              OnBoardingPage(
                image: 'assets/animations/onboarding1.json',
                title: 'PT LANGGENG PRANAMAS SENTOSA',
                titleTextStyle: Theme.of(context).textTheme.headlineMedium,
                subtitle:
                    'Kami adalah perusahaan yang bergerak di bidang pengelolaan dan pengembangan properti di Indonesia. Fokus kami adalah membangun hunian berkualitas yang memenuhi kebutuhan masyarakat.',
                bodyTextStyle: Theme.of(context).textTheme.bodyMedium,
              ),
              OnBoardingPage(
                  image: 'assets/animations/onboarding2.json',
                  title: 'Inovatif dan Berkesan',
                  titleTextStyle: Theme.of(context).textTheme.headlineMedium,
                  subtitle:
                      "Kami telah menghasilkan berbagai proyek properti inovatif yang berkesan. Dengan tim terampil dan berpengalaman, kami terus menghadirkan hunian modern yang sesuai dengan harapan konsumen.",
                  bodyTextStyle: Theme.of(context).textTheme.bodyMedium),
              OnBoardingPage(
                  image: 'assets/animations/onboarding3.json',
                  title: 'Standar Kualitas dan Integritas',
                  titleTextStyle: Theme.of(context).textTheme.headlineMedium,
                  subtitle:
                      "Kami berkomitmen untuk menjaga standar kualitas dan integritas di setiap proyek. Dengan memberikan nilai tambah bagi pemangku kepentingan, kami berkontribusi positif terhadap pembangunan properti di Indonesia.",
                  bodyTextStyle: Theme.of(context).textTheme.bodyMedium)
            ],
          ),
          Positioned(
              top: kToolbarHeight,
              right: 24.0,
              child: TextButton(
                onPressed: () => controller.skipPage(),
                child: const Text('Lewati'),
              )),
          Positioned(
              bottom: kBottomNavigationBarHeight - 20,
              left: 24.0,
              child: SmoothPageIndicator(
                  controller: controller.pageController,
                  onDotClicked: controller.dotNavigationClick,
                  effect: const ExpandingDotsEffect(
                      activeDotColor: AppColors.dark, dotHeight: 6),
                  count: 3)),
          Positioned(
              right: 24.0,
              bottom: kBottomNavigationBarHeight - 40,
              child: ElevatedButton(
                  onPressed: controller.nextPage,
                  style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      backgroundColor: AppColors.dark),
                  child: const Icon(
                    Iconsax.next,
                    color: Colors.white,
                  )))
        ],
      ),
    );
  }
}
