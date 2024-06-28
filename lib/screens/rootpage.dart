// import 'package:doplsnew/helpers/helper_function.dart';
import 'package:doplsnew/screens/homepage.dart';
// import 'package:doplsnew/screens/profile.dart';
import 'package:doplsnew/utils/theme/app_colors.dart';
import 'package:doplsnew/widgets/rounded_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../controllers/login_controller.dart';
import '../utils/constant/storage_util.dart';
import '../widgets/expandable_container.dart';

class Rootpage extends StatefulWidget {
  const Rootpage({super.key});

  @override
  State<Rootpage> createState() => _RootpageState();
}

class _RootpageState extends State<Rootpage> {
  final loginController = Get.put(LoginController());
  final storageUtil = StorageUtil();

  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  static const List<Widget> _widgetOptions = <Widget>[
    Homepage(),
    // Profile(),
  ];

  _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // final dark = CustomHelperFunctions.isDarkMode(context);

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
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: AppColors.dark,
            ),
            child: IconButton(
                onPressed: () {},
                icon: const Icon(
                  Iconsax.notification,
                  color: AppColors.white,
                )),
          ),
          const SizedBox(width: 5.0),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: AppColors.dark,
            ),
            child: IconButton(
                onPressed: () => storageUtil.logout(),
                icon: const Icon(
                  Iconsax.logout_1,
                  color: AppColors.white,
                )),
          ),
          const SizedBox(width: 8.0),
        ],
      ),
      drawer: Drawer(
        backgroundColor: AppColors.lightExpandable,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 200,
                padding: const EdgeInsets.only(top: 20.0),
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/login_bg.jpg'),
                      fit: BoxFit.cover),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CustomRoundedImage(
                      imageType: ImageType
                          .network, // Tentukan tipe gambar sebagai network
                      image:
                          'https://tse3.mm.bing.net/th?id=OIP.d7Yh1Ur0vyGpFrhMYsNZIAHaGs&pid=Api&P=0&h=180', // Berikan URL gambar untuk ditampilkan
                      fit: BoxFit.cover,
                    ),
                    const Text(
                      "Muhammad Dika Haryadi",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    Text(
                      "email disini",
                      style: TextStyle(
                        color: Colors.grey[200],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              ExpandableContainer(
                icon: Iconsax.book,
                textTitle: 'Home',
                onTap: _onItemTapped(0),
              ),
              ExpandableContainer(
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
                  )),
              ExpandableContainer(
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
              ),
              ExpandableContainer(
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
              ),
              ExpandableContainer(
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
              ),
              ExpandableContainer(
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
                                        color: AppColors.darkExpandableContent,
                                      ),
                                      title: Text(
                                        '',
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
                                        '',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall
                                            ?.copyWith(color: AppColors.light),
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
                                        color: AppColors.darkExpandableContent,
                                      ),
                                      title: Text(
                                        '',
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
                                        '',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall
                                            ?.copyWith(color: AppColors.light),
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
              ),
              ExpandableContainer(
                icon: Iconsax.setting,
                textTitle: 'Manajemen User',
                content: Column(
                  children: [
                    ListTile(
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
              ),
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
