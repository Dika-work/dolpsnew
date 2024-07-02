import 'package:cached_network_image/cached_network_image.dart';
import 'package:doplsnew/screens/homepage.dart';
import 'package:doplsnew/utils/constant/custom_size.dart';
import 'package:doplsnew/utils/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../controllers/login_controller.dart';
import '../utils/constant/storage_util.dart';
import '../utils/loader/shimmer.dart';
import '../widgets/expandable_container.dart';

class Rootpage extends StatefulWidget {
  const Rootpage({super.key});

  @override
  State<Rootpage> createState() => _RootpageState();
}

class _RootpageState extends State<Rootpage> {
  final loginController = Get.put(LoginController());

  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  static const List<Widget> _widgetOptions = <Widget>[
    Homepage(),
  ];

  _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final storageUtil = StorageUtil();
    final user = storageUtil.getUserDetails();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Homepage'),
        leading: IconButton(
          icon: const Icon(Iconsax.firstline),
          onPressed: () {
            scaffoldKey.currentState!.openDrawer();
          },
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: CustomSize.sm),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: AppColors.dark,
            ),
            child: IconButton(
                onPressed: () => storageUtil.logout(),
                icon: const Icon(
                  Iconsax.logout_1,
                  color: AppColors.white,
                  size: CustomSize.iconMd,
                )),
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: AppColors.lightExpandable,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: CustomSize.imageCarouselHeight,
                padding: const EdgeInsets.only(top: 20.0),
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
                        imageUrl:
                            'https://tse3.mm.bing.net/th?id=OIP.d7Yh1Ur0vyGpFrhMYsNZIAHaGs&pid=Api&P=0&h=180',
                        fit: BoxFit.cover,
                        progressIndicatorBuilder: (context, url, progress) =>
                            const CustomShimmerEffect(
                          width: 55,
                          height: 55,
                          radius: 55,
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ),
                    Text(
                      user!.nama.toUpperCase(),
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
                              borderRadius:
                                  BorderRadius.circular(CustomSize.sm),
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
                              borderRadius:
                                  BorderRadius.circular(CustomSize.sm),
                              color: AppColors.dark,
                            ),
                            child: IconButton(
                                onPressed: () =>
                                    scaffoldKey.currentState!.closeDrawer(),
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
                icon: Iconsax.book,
                textTitle: 'Home',
                onTap: _onItemTapped(0),
              ),
              user.menu1 == 1
                  ? ExpandableContainer(
                      icon: Iconsax.folder_2,
                      textTitle: 'Master Data',
                      content: Column(
                        children: [
                          ListTile(
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
                          ListTile(
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
                        ],
                      ))
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
                              ListTile(
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
                              ),
                              ListTile(
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
                              ),
                              ListTile(
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
                              ),
                              ListTile(
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
                              ),
                              ListTile(
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
                              ),
                              ListTile(
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
                              ),
                              ListTile(
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
                              ),
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
                              ListTile(
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
                              ListTile(
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
                              ),
                              ListTile(
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
                              ),
                              ListTile(
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
                              ),
                              ListTile(
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
                              ),
                            ],
                          )),
                    )
                  : const SizedBox.shrink(),
              user.menu4 == 1
                  ? ExpandableContainer(
                      icon: Iconsax.add,
                      textTitle: 'Input Data Realisasi',
                      content: ExpandableContainer(
                          icon: FontAwesomeIcons.motorcycle,
                          textTitle: 'Honda',
                          content: Column(
                            children: [
                              ListTile(
                                leading: const Icon(
                                  Iconsax.record,
                                  color: AppColors.darkExpandableContent,
                                ),
                                title: Text(
                                  'Request Mobile',
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
                                  'DO Reguler',
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
                                  'DO Mutasi',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall
                                      ?.copyWith(color: AppColors.light),
                                ),
                              ),
                            ],
                          )),
                    )
                  : const SizedBox.shrink(),
              user.menu9 == 1
                  ? ExpandableContainer(
                      icon: Iconsax.calendar,
                      textTitle: 'Laporan Honda',
                      content: Column(
                        children: [
                          ExpandableContainer(
                            icon: Iconsax.book,
                            textTitle: 'DO Harian',
                            onTap: () {},
                          ),
                          ExpandableContainer(
                              icon: Iconsax.receipt,
                              textTitle: 'DO Bulanan',
                              content: Column(
                                children: [
                                  ListTile(
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
                                  ExpandableContainer(
                                      icon: Iconsax.box,
                                      textTitle: 'Plant',
                                      content: Column(
                                        children: [
                                          ListTile(
                                            leading: const Icon(
                                              Iconsax.record,
                                              color: AppColors
                                                  .darkExpandableContent,
                                            ),
                                            title: Text(
                                              '',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleSmall
                                                  ?.copyWith(
                                                      color: AppColors.light),
                                            ),
                                          ),
                                          ListTile(
                                            leading: const Icon(
                                              Iconsax.record,
                                              color: AppColors
                                                  .darkExpandableContent,
                                            ),
                                            title: Text(
                                              '',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleSmall
                                                  ?.copyWith(
                                                      color: AppColors.light),
                                            ),
                                          ),
                                        ],
                                      )),
                                  ExpandableContainer(
                                      icon: Iconsax.box,
                                      textTitle: 'Total DO Harian',
                                      content: Column(
                                        children: [
                                          ListTile(
                                            leading: const Icon(
                                              Iconsax.record,
                                              color: AppColors
                                                  .darkExpandableContent,
                                            ),
                                            title: Text(
                                              '',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleSmall
                                                  ?.copyWith(
                                                      color: AppColors.light),
                                            ),
                                          ),
                                          ListTile(
                                            leading: const Icon(
                                              Iconsax.record,
                                              color: AppColors
                                                  .darkExpandableContent,
                                            ),
                                            title: Text(
                                              '',
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
                                  ListTile(
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
                                ],
                              )),
                          ExpandableContainer(
                            icon: Iconsax.diagram,
                            textTitle: 'Grafik',
                            onTap: () {},
                          ),
                        ],
                      ),
                    )
                  : const SizedBox.shrink(),
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
      ),
      key: scaffoldKey,
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
    );
  }
}
