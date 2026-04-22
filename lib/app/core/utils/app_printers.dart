import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:printing/printing.dart';

/// Utility for dot-matrix / continuous roll printers (common in India)
class DotMatrixPrint {
  static const int charactersPerLine = 80;
  static const int leftMargin = 2;

  /// Center text
  static String center(String text, [int width = charactersPerLine]) {
    final padding = (width - text.length) ~/ 2;
    return ' ' * padding + text;
  }

  /// Left-align with right padding
  static String leftPad(String text, int width) {
    return text.padRight(width);
  }

  /// Right-align with left padding
  static String rightPad(String text, int width) {
    return text.padLeft(width);
  }

  /// Create a dashed line
  static String dashedLine([int width = charactersPerLine]) {
    return '-' * width;
  }

  /// Create a double dashed line
  static String doubleLine([int width = charactersPerLine]) {
    return '=' * width;
  }

  /// Format a row with label and value
  static String formatRow(String label, String value, [int width = charactersPerLine]) {
    final labelWidth = (width * 0.3).floor();
    final valueWidth = (width * 0.7).floor();
    return leftPad(label, labelWidth) + rightPad(value, valueWidth);
  }

  /// Format a table row
  static String formatTableRow(
      List<String> columns,
      List<int> widths,
      ) {
    String result = '';
    for (int i = 0; i < columns.length; i++) {
      result += leftPad(columns[i], widths[i]);
    }
    return result;
  }

  /// Print header for dot-matrix
  static List<String> buildDotMatrixHeader({
    required String companyName,
    required String billNumber,
    required String date,
  }) {
    return [
      doubleLine(),
      center(companyName),
      dashedLine(),
      'Bill No: $billNumber${' ' * 50}Date: $date',
      doubleLine(),
    ];
  }

  /// Print footer for dot-matrix
  static List<String> buildDotMatrixFooter({
    required String amountInWords,
    String? terms,
  }) {
    return [
      dashedLine(),
      'Amount in Words: $amountInWords',
      dashedLine(),
      if (terms != null) ...[
        'Terms: $terms',
        dashedLine(),
      ],
      'Receiver Signature${' ' * 50}Authorised Signature',
      '',
      '',
    ];
  }

  /// Build a dot-matrix compatible bill for continuous paper
  static String buildDotMatrixBill({
    required List<String> headerLines,
    required String tableHeader,
    required List<String> tableRows,
    required String totalsLine,
    required List<String> footerLines,
  }) {
    return [
      ...headerLines,
      '',
      tableHeader,
      dashedLine(),
      ...tableRows,
      '',
      totalsLine,
      ...buildDotMatrixFooter(
        amountInWords: footerLines.first,
        terms: footerLines.length > 1 ? footerLines[1] : null,
      ),
    ].join('\n');
  }

  /// Print to dot-matrix printer
  static Future<void> printDotMatrix({
    required String content,
    String printerName = 'Dot Matrix',
  }) async {
    await Printing.directPrintPdf(
      printer: Printer(url: printerName),
      onLayout: (format) async {
        // Create a simple PDF with monospace font
        final doc = Document();
        doc.addPage(
          Page(
            pageFormat: PdfPageFormat(
              80 * 72 / 25.4, // 80mm width
              double.infinity,
            ),
            margin: const EdgeInsets.all(4),
            build: (context) {
              return Text(
                content,
                style: TextStyle(
                  font: Font.courier(),
                  fontSize: 8,
                ),
              );
            },
          ),
        );
        return doc.save();
      },
    );
  }
}