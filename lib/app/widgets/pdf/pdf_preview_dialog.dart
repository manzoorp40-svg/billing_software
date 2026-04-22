import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PdfPreviewDialog extends StatelessWidget {
  final pw.Document document;
  final String title;
  final String? fileName;

  const PdfPreviewDialog({
    super.key,
    required this.document,
    this.title = 'PDF Preview',
    this.fileName,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.9,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Header
            Row(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Get.back(),
                ),
              ],
            ),
            const Divider(),
            // PDF Preview
            Expanded(
              child: PdfPreview(
                build: (format) => document.save(),
                canChangeOrientation: false,
                canChangePageFormat: true,
                canDebug: false,
                pdfFileName: fileName ?? 'document.pdf',
                actions: [
                  PdfPreviewAction(
                    icon: const Icon(Icons.print),
                    onPressed: (context, build, pageFormat) async {
                      await Printing.layoutPdf(
                        onLayout: (format) => document.save(),
                        name: fileName ?? 'document',
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Future<void> show({
    required pw.Document document,
    String title = 'PDF Preview',
    String? fileName,
  }) async {
    await Get.dialog(
      PdfPreviewDialog(
        document: document,
        title: title,
        fileName: fileName,
      ),
      barrierDismissible: true,
    );
  }

  static Future<void> print({
    required pw.Document document,
    String name = 'document',
  }) async {
    await Printing.layoutPdf(
      onLayout: (format) => document.save(),
      name: name,
    );
  }

  static Future<void> share({
    required pw.Document document,
    required String fileName,
  }) async {
    await Printing.sharePdf(
      bytes: await document.save(),
      filename: '$fileName.pdf',
    );
  }
}