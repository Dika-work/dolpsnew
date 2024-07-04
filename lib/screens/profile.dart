import 'package:cached_network_image/cached_network_image.dart';
import 'package:doplsnew/helpers/helper_function.dart';
import 'package:doplsnew/utils/constant/custom_size.dart';
import 'package:doplsnew/utils/constant/storage_util.dart';
import 'package:doplsnew/utils/loader/shimmer.dart';
import 'package:doplsnew/utils/theme/app_colors.dart';
import 'package:doplsnew/widgets/search_textfield.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../widgets/curved_edges.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    final storageUtil = StorageUtil();
    final user = storageUtil.getUserDetails();
    final usernameController = TextEditingController();
    final passwordController = TextEditingController();
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            ClipPath(
              clipper: TCustomCurvedEdges(),
              child: Container(
                color: Colors.blueAccent,
                width: double.infinity,
                padding: const EdgeInsets.only(bottom: CustomSize.lg),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: CustomSize.lg, vertical: CustomSize.md),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(70),
                        child: CachedNetworkImage(
                          width: CustomSize.profileImageSize,
                          height: CustomSize.profileImageSize,
                          imageUrl: '${storageUtil.baseURL}/do/${user!.gambar}',
                          fit: BoxFit.cover,
                          progressIndicatorBuilder: (_, __, ___) =>
                              const CustomShimmerEffect(
                            width: 55,
                            height: 55,
                            radius: 55,
                          ),
                          errorWidget: (_, __, ___) =>
                              Image.asset('assets/icons/person.png'),
                        ),
                      ),
                      Text(
                        user.nama.toUpperCase(),
                        style: Theme.of(context)
                            .textTheme
                            .headlineLarge
                            ?.copyWith(color: AppColors.white),
                      ),
                      Text(
                        user.tipe,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  'Nama Lengkap :',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(CustomHelperFunctions.toTitleCase(user.nama),
                    style: Theme.of(context).textTheme.bodyLarge)
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  'Petugas :',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(CustomHelperFunctions.toTitleCase(user.tipe),
                    style: Theme.of(context).textTheme.bodyLarge)
              ],
            ),
            CustomSearchTextFormField(
              offset: 0.0,
              name: 'Edit Nama',
              textEditingController: usernameController,
              function: (p0) {},
              nameTextField: 'Ubah username',
              clearFunction: () {
                usernameController.clear();
              },
              icon: Iconsax.user_edit,
            ),
            CustomSearchTextFormField(
              offset: 0.0,
              name: 'Ubah Password',
              textEditingController: passwordController,
              function: (p0) {},
              nameTextField: 'Ubah password',
              clearFunction: () {
                passwordController.clear();
              },
              icon: Iconsax.edit,
            ),
            ElevatedButton(onPressed: () {}, child: const Text('Ubah Gambar')),
            Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: CustomSize.md),
                  child: Text(
                    'Data User',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                )),
            Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: CustomSize.md),
                  child: Text(
                    'Alamat',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                )),
          ],
        ),
      )),
    );
  }
}
