import 'package:flutter/material.dart';

class CustomDialogs {
  static defaultDialog({
    required BuildContext context,
    String title = 'Konfirmasi Penghapusan',
    String content =
        'Menghapus data ini akan menghapus semua data terkait. Apakah Anda yakin?',
    String cancelText = 'Batal',
    String confirmText = 'Hapus',
    Function()? onCancel,
    Function()? onConfirm,
  }) {
    // Show a confirmation dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              onPressed: onCancel ?? () => Navigator.of(context).pop(),
              child: Text(cancelText),
            ),
            TextButton(
              onPressed: onConfirm,
              child: Text(confirmText),
            ),
          ],
        );
      },
    );
  }
}
