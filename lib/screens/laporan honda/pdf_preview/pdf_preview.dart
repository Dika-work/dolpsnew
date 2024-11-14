import 'dart:io';
import 'dart:typed_data';
import 'package:doplsnew/utils/popups/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

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

      // Tampilkan notifikasi keberhasilan
      SnackbarLoader.successSnackBar(
        title: 'Berhasil menyimpan',
        message: 'PDF tersimpan di folder ./Download/LaporanPDF',
      );

      // Log file path untuk debugging
      print('PDF saved at: ${file.path}');
    } catch (e) {
      // Tampilkan notifikasi jika terjadi error
      SnackbarLoader.errorSnackBar(
        title: 'Gagal menyimpan',
        message: 'Terjadi kesalahan saat menyimpan file: $e',
      );
      print('Error saving PDF: $e');
    }
  }
}
