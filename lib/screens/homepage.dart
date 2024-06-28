import 'package:doplsnew/utils/constant/storage_util.dart';
import 'package:flutter/material.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    final storage = StorageUtil();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('Welcome ${storage.getUsername()}'),
        Text('Username: ${storage.getName()}'),
      ],
    );
  }
}
