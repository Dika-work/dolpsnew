import 'dart:io';
import 'dart:typed_data';
import 'package:doplsnew/utils/popups/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
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
    Directory directory = await getExternalStorageDirectory() ??
        await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/${widget.fileName}');
    await file.writeAsBytes(widget.pdfBytes);

    SnackbarLoader.successSnackBar(
        title: 'Berhasil menyimpan',
        message: 'Pdf tersimpan pada folder download');
  }
}
