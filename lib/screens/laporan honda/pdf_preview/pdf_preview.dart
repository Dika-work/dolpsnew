import 'dart:io';
import 'dart:typed_data';
import 'package:doplsnew/utils/popups/full_screen_loader.dart';
import 'package:doplsnew/utils/popups/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../../utils/constant/custom_size.dart';

class PdfPreviewScreen extends StatefulWidget {
  final Uint8List pdfBytes;
  final String fileName;

  const PdfPreviewScreen(
      {super.key, required this.pdfBytes, required this.fileName});

  @override
  State<PdfPreviewScreen> createState() => _PdfPreviewScreenState();
}

class _PdfPreviewScreenState extends State<PdfPreviewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Preview'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: _downloadPDF, // Download the PDF
          )
        ],
      ),
      body: SfPdfViewer.memory(widget.pdfBytes),
    );
  }

  Future<void> _downloadPDF() async {
    try {
      // Tentukan lokasi folder
      Directory downloadDir =
          Directory('/storage/emulated/0/Download/LaporanPDF');
      if (!await downloadDir.exists()) {
        await downloadDir.create(recursive: true); // Buat folder jika belum ada
      }

      // Simpan PDF ke dalam folder
      final file = File('${downloadDir.path}/${widget.fileName}');
      await file.writeAsBytes(widget.pdfBytes);

      // Periksa apakah widget masih ter-mount sebelum menampilkan dialog
      if (mounted) {
        // Tampilkan notifikasi keberhasilan
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset(
                    height: 110,
                    'assets/animations/success.json',
                  ),
                  const SizedBox(height: CustomSize.defaultSpace),
                  Text(
                    "File telah berhasil diunduh. Silakan periksa folder 'LaporanPDF' di dalam folder 'Download'",
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    CustomFullScreenLoader.stopLoading();
                    CustomFullScreenLoader.stopLoading();
                  },
                  child: const Text('Oke!'),
                ),
              ],
            );
          },
        );
      }

      // Log file path untuk debugging
      print('PDF saved at: ${file.path}');
    } catch (e) {
      if (mounted) {
        // Tampilkan notifikasi jika terjadi error
        SnackbarLoader.errorSnackBar(
          title: 'Gagal menyimpan',
          message: 'Terjadi kesalahan saat menyimpan file: $e',
        );
      }
      print('Error saving PDF: $e');
    }
  }
}
