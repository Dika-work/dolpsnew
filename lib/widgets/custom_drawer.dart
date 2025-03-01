import 'package:cached_network_image/cached_network_image.dart';
import 'package:doplsnew/utils/constant/custom_size.dart';
import 'package:doplsnew/utils/constant/storage_util.dart';
import 'package:doplsnew/utils/loader/shimmer.dart';
import 'package:doplsnew/utils/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import 'expandable_container.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({
    super.key,
    required this.onItemTapped,
    required this.selectedIndex,
    required this.logout,
    required this.closeDrawer,
  });

  final Function(int) onItemTapped;
  final int selectedIndex;
  final Function logout;
  final void Function()? closeDrawer;

  @override
  Widget build(BuildContext context) {
    final storageUtil = StorageUtil();
    final user = storageUtil.getUserDetails();
    return Drawer(
      backgroundColor: AppColors.lightExpandable,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: CustomSize.imageCarouselHeight,
              padding: const EdgeInsets.only(top: CustomSize.lg),
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/login_bg.jpg'),
                    fit: BoxFit.cover),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(CustomSize.xl),
                    child: CachedNetworkImage(
                      width: 70,
                      height: 70,
                      imageUrl: user!.gambar,
                      fit: BoxFit.cover,
                      progressIndicatorBuilder: (_, __, ___) =>
                          const CustomShimmerEffect(
                        width: 55,
                        height: 55,
                        radius: 55,
                      ),
                      errorWidget: (_, ___, __) =>
                          Image.asset('assets/icons/person.png'),
                    ),
                  ),
                  Text(
                    user.nama.toUpperCase(),
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium
                        ?.copyWith(color: AppColors.white),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: CustomSize.sm),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(CustomSize.sm),
                            color: AppColors.dark,
                          ),
                          child: IconButton(
                              onPressed: () => Get.toNamed('/profile'),
                              icon: const Icon(
                                Iconsax.user,
                                color: AppColors.white,
                              )),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(CustomSize.sm),
                            color: AppColors.dark,
                          ),
                          child: IconButton(
                              onPressed: closeDrawer,
                              icon: const Icon(
                                Iconsax.back_square,
                                color: AppColors.white,
                              )),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            ExpandableContainer(
                icon: Iconsax.book, textTitle: 'Home', onTap: closeDrawer),
            user.menu1 == 1
                ? ExpandableContainer(
                    icon: Iconsax.folder_2,
                    textTitle: 'Master Data',
                    content: ListTile(
                      onTap: () => Get.toNamed('/type-motor'),
                      leading: const Icon(
                        Iconsax.record,
                        color: AppColors.darkExpandableContent,
                      ),
                      title: Text(
                        'Type Motor',
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall
                            ?.copyWith(color: AppColors.light),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
            user.menu2 == 1
                ? ExpandableContainer(
                    icon: Iconsax.box,
                    textTitle: 'Tampil Seluruh Data',
                    content: ExpandableContainer(
                        icon: FontAwesomeIcons.motorcycle,
                        textTitle: 'Honda',
                        content: Column(
                          children: [
                            ListTile(
                              onTap: () => Get.toNamed('/all-do-global'),
                              leading: const Icon(
                                Iconsax.record,
                                color: AppColors.darkExpandableContent,
                              ),
                              title: Text(
                                'DO Global',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(color: AppColors.light),
                              ),
                            ),
                            user.tipe == 'admin'
                                ? ListTile(
                                    onTap: () => Get.toNamed('/all-do-harian'),
                                    leading: const Icon(
                                      Iconsax.record,
                                      color: AppColors.darkExpandableContent,
                                    ),
                                    title: Text(
                                      'DO Harian LPS',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall
                                          ?.copyWith(color: AppColors.light),
                                    ),
                                  )
                                : const SizedBox.shrink(),
                            user.tipe == 'admin'
                                ? ListTile(
                                    onTap: () => Get.toNamed('/all-do-tambah'),
                                    leading: const Icon(
                                      Iconsax.record,
                                      color: AppColors.darkExpandableContent,
                                    ),
                                    title: Text(
                                      'DO Tambahan',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall
                                          ?.copyWith(color: AppColors.light),
                                    ),
                                  )
                                : const SizedBox.shrink(),
                            user.tipe == 'admin'
                                ? ListTile(
                                    onTap: () => Get.toNamed('/all-do-kurang'),
                                    leading: const Icon(
                                      Iconsax.record,
                                      color: AppColors.darkExpandableContent,
                                    ),
                                    title: Text(
                                      'DO Pengurangan',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall
                                          ?.copyWith(color: AppColors.light),
                                    ),
                                  )
                                : const SizedBox.shrink(),
                            user.tipe == 'admin'
                                ? ListTile(
                                    onTap: () =>
                                        Get.toNamed('/all-do-estimasi'),
                                    leading: const Icon(
                                      Iconsax.record,
                                      color: AppColors.darkExpandableContent,
                                    ),
                                    title: Text(
                                      'DO Estimasi (Tentative)',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall
                                          ?.copyWith(color: AppColors.light),
                                    ),
                                  )
                                : const SizedBox.shrink(),
                            user.tipe == 'admin'
                                ? ListTile(
                                    leading: const Icon(
                                      Iconsax.record,
                                      color: AppColors.darkExpandableContent,
                                    ),
                                    title: Text(
                                      'Request Kendaraan',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall
                                          ?.copyWith(color: AppColors.light),
                                    ),
                                  )
                                : const SizedBox.shrink(),
                            user.cekReguler == 1
                                ? ListTile(
                                    onTap: () => Get.toNamed('/all-do-reguler'),
                                    leading: const Icon(
                                      Iconsax.record,
                                      color: AppColors.darkExpandableContent,
                                    ),
                                    title: Text(
                                      'DO Reguler',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall
                                          ?.copyWith(color: AppColors.light),
                                    ),
                                  )
                                : const SizedBox.shrink(),
                            user.cekReguler == 1
                                ? ListTile(
                                    onTap: () => Get.toNamed('/all-do-mutasi'),
                                    leading: const Icon(
                                      Iconsax.record,
                                      color: AppColors.darkExpandableContent,
                                    ),
                                    title: Text(
                                      'DO Mutasi',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall
                                          ?.copyWith(color: AppColors.light),
                                    ),
                                  )
                                : const SizedBox.shrink(),
                          ],
                        )),
                  )
                : const SizedBox.shrink(),
            user.menu3 == 1
                ? ExpandableContainer(
                    icon: Iconsax.add,
                    textTitle: 'Input Data DO',
                    content: ExpandableContainer(
                        icon: FontAwesomeIcons.motorcycle,
                        textTitle: 'Honda',
                        content: Column(
                          children: [
                            user.tipe == 'Pengurus Pabrik' &&
                                        user.dealer == 'honda' ||
                                    user.tipe == 'admin'
                                ? ListTile(
                                    onTap: () => Get.toNamed('/data-do-global'),
                                    leading: const Icon(
                                      Iconsax.record,
                                      color: AppColors.darkExpandableContent,
                                    ),
                                    title: Text(
                                      'DO Global',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall
                                          ?.copyWith(color: AppColors.light),
                                    ),
                                  )
                                : const SizedBox.shrink(),
                            user.tipe == 'admin'
                                ? ListTile(
                                    onTap: () => Get.toNamed('/data-do-harian'),
                                    leading: const Icon(
                                      Iconsax.record,
                                      color: AppColors.darkExpandableContent,
                                    ),
                                    title: Text(
                                      'DO Harian',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall
                                          ?.copyWith(color: AppColors.light),
                                    ),
                                  )
                                : const SizedBox.shrink(),
                            user.tipe == 'Pengurus Pabrik' &&
                                        user.dealer == 'honda' ||
                                    user.tipe == 'admin'
                                ? ListTile(
                                    onTap: () =>
                                        Get.toNamed('/data-do-tambahan'),
                                    leading: const Icon(
                                      Iconsax.record,
                                      color: AppColors.darkExpandableContent,
                                    ),
                                    title: Text(
                                      'DO Tambahan',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall
                                          ?.copyWith(color: AppColors.light),
                                    ),
                                  )
                                : const SizedBox.shrink(),
                            user.tipe == 'Pengurus Pabrik' &&
                                        user.dealer == 'honda' ||
                                    user.tipe == 'admin'
                                ? ListTile(
                                    onTap: () =>
                                        Get.toNamed('/data-do-pengurangan'),
                                    leading: const Icon(
                                      Iconsax.record,
                                      color: AppColors.darkExpandableContent,
                                    ),
                                    title: Text(
                                      'DO Pengurangan',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall
                                          ?.copyWith(color: AppColors.light),
                                    ),
                                  )
                                : const SizedBox.shrink(),
                          ],
                        )),
                  )
                : const SizedBox.shrink(),
            user.menu4 == 1
                ? ExpandableContainer(
                    icon: Iconsax.add,
                    textTitle: 'Input Data Realisasi',
                    content: Column(
                      children: [
                        ExpandableContainer(
                            icon: FontAwesomeIcons.motorcycle,
                            textTitle: 'Honda',
                            content: Column(
                              children: [
                                user.tipe == 'k.pool' ||
                                        user.tipe == 'admin' ||
                                        user.tipe == 'Pengurus Pabrik'
                                    ? ListTile(
                                        onTap: () =>
                                            Get.toNamed('/request-mobil'),
                                        leading: const Icon(
                                          Iconsax.record,
                                          color:
                                              AppColors.darkExpandableContent,
                                        ),
                                        title: Text(
                                          'Request Mobil',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall
                                              ?.copyWith(
                                                  color: AppColors.light),
                                        ),
                                      )
                                    : const SizedBox.shrink(),
                                user.cekReguler == 1
                                    ? ListTile(
                                        onTap: () => Get.toNamed('/do-reguler'),
                                        leading: const Icon(
                                          Iconsax.record,
                                          color:
                                              AppColors.darkExpandableContent,
                                        ),
                                        title: Text(
                                          'DO Reguler',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall
                                              ?.copyWith(
                                                  color: AppColors.light),
                                        ),
                                      )
                                    : const SizedBox.shrink(),
                                user.cekMutasi == 1
                                    ? ListTile(
                                        onTap: () => Get.toNamed('/do-mutasi'),
                                        leading: const Icon(
                                          Iconsax.record,
                                          color:
                                              AppColors.darkExpandableContent,
                                        ),
                                        title: Text(
                                          'DO Mutasi',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall
                                              ?.copyWith(
                                                  color: AppColors.light),
                                        ),
                                      )
                                    : const SizedBox.shrink(),
                              ],
                            )),
                        if (user.tipe == 'k.pool' || user.tipe == 'admin')
                          ListTile(
                            onTap: () => Get.toNamed('/estimasi-pm'),
                            leading: const Icon(
                              Iconsax.record,
                              color: AppColors.darkExpandableContent,
                            ),
                            title: Text(
                              'Estimasi P M',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(color: AppColors.light),
                            ),
                          ),
                        if (user.tipe == 'k.pool' || user.tipe == 'admin')
                          ListTile(
                            leading: const Icon(
                              Iconsax.record,
                              color: AppColors.darkExpandableContent,
                            ),
                            title: Text(
                              'Total Estimasi P M',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(color: AppColors.light),
                            ),
                          ),
                        if (user.tipe == 'k.pool' || user.tipe == 'admin')
                          ListTile(
                            onTap: () => Get.toNamed('/table-estimasi'),
                            leading: const Icon(
                              Iconsax.record,
                              color: AppColors.darkExpandableContent,
                            ),
                            title: Text(
                              'Table Estimasi P M',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(color: AppColors.light),
                            ),
                          ),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
            user.menu6 == 1
                ? ExpandableContainer(
                    icon: Iconsax.calendar,
                    textTitle: 'Laporan Honda',
                    content: Column(
                      children: [
                        user.tipe == 'Pengurus Stuffing' ||
                                user.tipe == 'admin' ||
                                user.tipe == 'Pengurus Pabrik'
                            ? ListTile(
                                leading: const Icon(
                                  Iconsax.record,
                                  color: AppColors.darkExpandableContent,
                                ),
                                title: Text(
                                  'DO Harian',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall
                                      ?.copyWith(color: AppColors.light),
                                ),
                              )
                            : const SizedBox.shrink(),
                        user.tipe == 'admin' || user.tipe == 'Pengurus Pabrik'
                            ? ExpandableContainer(
                                icon: Iconsax.receipt,
                                textTitle: 'DO Bulanan',
                                content: Column(
                                  children: [
                                    ListTile(
                                      onTap: () =>
                                          Get.toNamed('/laporan-samarinda'),
                                      leading: const Icon(
                                        Iconsax.record,
                                        color: AppColors.darkExpandableContent,
                                      ),
                                      title: Text(
                                        'Samarinda',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall
                                            ?.copyWith(color: AppColors.light),
                                      ),
                                    ),
                                    ListTile(
                                      leading: const Icon(
                                        Iconsax.record,
                                        color: AppColors.darkExpandableContent,
                                      ),
                                      title: Text(
                                        'Jenis Motor',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall
                                            ?.copyWith(color: AppColors.light),
                                      ),
                                    ),
                                    ListTile(
                                      onTap: () =>
                                          Get.toNamed('/laporan-realisasi'),
                                      leading: const Icon(
                                        Iconsax.record,
                                        color: AppColors.darkExpandableContent,
                                      ),
                                      title: Text(
                                        'Realisasi',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall
                                            ?.copyWith(color: AppColors.light),
                                      ),
                                    ),
                                    ListTile(
                                      leading: const Icon(
                                        Iconsax.record,
                                        color: AppColors.darkExpandableContent,
                                      ),
                                      title: Text(
                                        'Mutasi',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall
                                            ?.copyWith(color: AppColors.light),
                                      ),
                                    ),
                                    if (user.tipe == 'Pengurus Pabrik' ||
                                        user.tipe == 'admin')
                                      ExpandableContainer(
                                        icon: Iconsax.box,
                                        textTitle: 'Plant',
                                        content: Column(
                                          children: [
                                            ...(user.plant == '0'
                                                    ? [
                                                        '1100',
                                                        '1200',
                                                        '1300',
                                                        '1350',
                                                        '1700',
                                                        '1800',
                                                        '1900'
                                                      ] // Semua plant untuk admin
                                                    : [
                                                        '1100',
                                                        '1200',
                                                        '1300',
                                                        '1350',
                                                        '1700',
                                                        '1800',
                                                        '1900'
                                                      ]
                                                        .where((plant) =>
                                                            user.plant ==
                                                                plant ||
                                                            (user.plant ==
                                                                    '1300' &&
                                                                plant ==
                                                                    '1350') ||
                                                            (user.plant ==
                                                                    '1350' &&
                                                                plant ==
                                                                    '1300'))
                                                        .toList() // Tampilkan plant sesuai user, dan tambahkan plant yang saling berhubungan untuk 1300 dan 1350
                                                )
                                                .map(
                                              (plant) => ListTile(
                                                onTap: () => Get.toNamed(
                                                    '/laporan-plant',
                                                    arguments: plant),
                                                leading: const Icon(
                                                  Iconsax.record,
                                                  color: AppColors
                                                      .darkExpandableContent,
                                                ),
                                                title: Text(
                                                  'Plant $plant',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleSmall
                                                      ?.copyWith(
                                                          color:
                                                              AppColors.light),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ExpandableContainer(
                                        icon: Iconsax.box,
                                        textTitle: 'Total DO Harian',
                                        content: Column(
                                          children: [
                                            ListTile(
                                              // onTap: () => Get.toNamed(
                                              //     '/laporan-plant',
                                              //     arguments: 'PLANT 1100'),
                                              leading: const Icon(
                                                Iconsax.record,
                                                color: AppColors
                                                    .darkExpandableContent,
                                              ),
                                              title: Text(
                                                'Plant 1100',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleSmall
                                                    ?.copyWith(
                                                        color: AppColors.light),
                                              ),
                                            ),
                                            ListTile(
                                              // onTap: () => Get.toNamed(
                                              //     '/laporan-plant',
                                              //     arguments: 'PLANT 1200'),
                                              leading: const Icon(
                                                Iconsax.record,
                                                color: AppColors
                                                    .darkExpandableContent,
                                              ),
                                              title: Text(
                                                'Plant 1200',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleSmall
                                                    ?.copyWith(
                                                        color: AppColors.light),
                                              ),
                                            ),
                                            ListTile(
                                              // onTap: () => Get.toNamed(
                                              //     '/laporan-plant',
                                              //     arguments: 'PLANT 1300'),
                                              leading: const Icon(
                                                Iconsax.record,
                                                color: AppColors
                                                    .darkExpandableContent,
                                              ),
                                              title: Text(
                                                'Plant 1300',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleSmall
                                                    ?.copyWith(
                                                        color: AppColors.light),
                                              ),
                                            ),
                                            ListTile(
                                              // onTap: () => Get.toNamed(
                                              //     '/laporan-plant',
                                              //     arguments: 'PLANT 1350'),
                                              leading: const Icon(
                                                Iconsax.record,
                                                color: AppColors
                                                    .darkExpandableContent,
                                              ),
                                              title: Text(
                                                'Plant 1350',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleSmall
                                                    ?.copyWith(
                                                        color: AppColors.light),
                                              ),
                                            ),
                                            ListTile(
                                              // onTap: () => Get.toNamed(
                                              //     '/laporan-plant',
                                              //     arguments: 'PLANT 1700'),
                                              leading: const Icon(
                                                Iconsax.record,
                                                color: AppColors
                                                    .darkExpandableContent,
                                              ),
                                              title: Text(
                                                'Plant 1700',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleSmall
                                                    ?.copyWith(
                                                        color: AppColors.light),
                                              ),
                                            ),
                                            ListTile(
                                              // onTap: () => Get.toNamed(
                                              //     '/laporan-plant',
                                              //     arguments: 'PLANT 1800'),
                                              leading: const Icon(
                                                Iconsax.record,
                                                color: AppColors
                                                    .darkExpandableContent,
                                              ),
                                              title: Text(
                                                'Plant 1800',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleSmall
                                                    ?.copyWith(
                                                        color: AppColors.light),
                                              ),
                                            ),
                                            ListTile(
                                              // onTap: () => Get.toNamed(
                                              //     '/laporan-plant',
                                              //     arguments: 'PLANT 1900'),
                                              leading: const Icon(
                                                Iconsax.record,
                                                color: AppColors
                                                    .darkExpandableContent,
                                              ),
                                              title: Text(
                                                'Plant 1900',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleSmall
                                                    ?.copyWith(
                                                        color: AppColors.light),
                                              ),
                                            ),
                                          ],
                                        )),
                                    ListTile(
                                      onTap: () =>
                                          Get.toNamed('/laporan-dealer'),
                                      leading: const Icon(
                                        Iconsax.record,
                                        color: AppColors.darkExpandableContent,
                                      ),
                                      title: Text(
                                        'Dealer',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall
                                            ?.copyWith(color: AppColors.light),
                                      ),
                                    ),
                                  ],
                                ))
                            : const SizedBox.shrink(),
                        ListTile(
                          onTap: () => Get.toNamed('/laporan-estimasi'),
                          leading: const Icon(
                            Iconsax.record,
                            color: AppColors.darkExpandableContent,
                          ),
                          title: Text(
                            'Estimasi',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(color: AppColors.light),
                          ),
                        ),
                        user.tipe == 'admin'
                            ? ExpandableContainer(
                                icon: Iconsax.diagram,
                                textTitle: 'Grafik',
                                onTap: () {},
                              )
                            : const SizedBox.shrink(),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
            // user.menu9 == 1
            //     ? ExpandableContainer(
            //         icon: Iconsax.add,
            //         textTitle: 'Laporan YMH & Suzuki',
            //         content: ExpandableContainer(
            //           icon: Iconsax.record,
            //           textTitle: 'Yamaha & Suzuki',
            //           content: Column(
            //             children: [
            //               user.tipe == 'Pengurus Stuffing' ||
            //                       user.tipe == 'admin'
            //                   ? ListTile(
            //                       leading: const Icon(
            //                         Iconsax.record,
            //                         color: AppColors.darkExpandableContent,
            //                       ),
            //                       title: Text(
            //                         'DO Harian',
            //                         style: Theme.of(context)
            //                             .textTheme
            //                             .titleSmall
            //                             ?.copyWith(color: AppColors.light),
            //                       ),
            //                     )
            //                   : const SizedBox.shrink(),
            //               ExpandableContainer(
            //                 icon: Iconsax.record,
            //                 textTitle: 'DO Bulanan',
            //                 content: Column(
            //                   children: [
            //                     ListTile(
            //                       leading: const Icon(
            //                         Iconsax.record,
            //                         color: AppColors.darkExpandableContent,
            //                       ),
            //                       title: Text(
            //                         'Global',
            //                         style: Theme.of(context)
            //                             .textTheme
            //                             .titleSmall
            //                             ?.copyWith(color: AppColors.light),
            //                       ),
            //                     ),
            //                     ListTile(
            //                       leading: const Icon(
            //                         Iconsax.record,
            //                         color: AppColors.darkExpandableContent,
            //                       ),
            //                       title: Text(
            //                         'Daerah',
            //                         style: Theme.of(context)
            //                             .textTheme
            //                             .titleSmall
            //                             ?.copyWith(color: AppColors.light),
            //                       ),
            //                     ),
            //                   ],
            //                 ),
            //               ),
            //               ListTile(
            //                 leading: const Icon(
            //                   Iconsax.record,
            //                   color: AppColors.darkExpandableContent,
            //                 ),
            //                 title: Text(
            //                   'DO Tahunan',
            //                   style: Theme.of(context)
            //                       .textTheme
            //                       .titleSmall
            //                       ?.copyWith(color: AppColors.light),
            //                 ),
            //               ),
            //             ],
            //           ),
            //         ),
            //       )
            //     : const SizedBox.shrink(),
            user.menu10 == 1
                ? ExpandableContainer(
                    icon: Iconsax.setting,
                    textTitle: 'Manajemen User',
                    content: Column(
                      children: [
                        ListTile(
                          onTap: () => Get.toNamed('data-user'),
                          leading: const Icon(
                            Iconsax.user,
                            color: AppColors.darkExpandableContent,
                          ),
                          title: Text(
                            'DATA USER',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(color: AppColors.light),
                          ),
                        ),
                        ListTile(
                          leading: const Icon(
                            Iconsax.user_octagon,
                            color: AppColors.darkExpandableContent,
                          ),
                          title: Text(
                            'GROUP USER',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(color: AppColors.light),
                          ),
                        ),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
