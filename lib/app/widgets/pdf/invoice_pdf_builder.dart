import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;


import '../../core/constants/enums.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/utils/date_utils.dart';
import '../../data/models/bill.dart';
import '../../data/models/bill.item.dart';
import '../../data/models/company_settings.dart';

class InvoicePdfBuilder {
  static Future<pw.Document> build({
    required Bill bill,
    required List<BillItem> items,
    required CompanySettings company,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        header: (context) => _buildPageHeader(company, bill),
        footer: (context) => _buildPageFooter(company, context),
        build: (context) => [
          pw.SizedBox(height: 10),

          // Bill To
          _buildBillTo(bill),
          pw.SizedBox(height: 20),

          // Items
          _buildItemsTable(items),
          pw.SizedBox(height: 20),

          // Totals
          _buildTotals(bill),
          pw.SizedBox(height: 30),

          // Amount in Words
          _buildAmountInWords(bill),
          pw.SizedBox(height: 20),

          // Bank Details
          _buildBankDetails(company),

          if (company.termsAndConditions?.isNotEmpty ?? false) ...[
            pw.SizedBox(height: 20),
            _buildTerms(company),
          ],
        ],
      ),
    );

    return pdf;
  }

  static pw.Widget _buildPageHeader(CompanySettings company, Bill bill) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  company.companyName.toUpperCase(),
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 2),
                if (company.address != null)
                  pw.Text(company.address!, style: const pw.TextStyle(fontSize: 9)),
                pw.Text(
                  '${company.city ?? ''}, ${company.state ?? ''} ${company.pincode ?? ''}'
                      .trim(),
                  style: const pw.TextStyle(fontSize: 9),
                ),
                pw.Text('Phone: ${company.phone ?? company.mobile ?? '-'}',
                    style: const pw.TextStyle(fontSize: 9)),
                pw.Text('Email: ${company.email ?? '-'}',
                    style: const pw.TextStyle(fontSize: 9)),
                pw.Text('GSTIN: ${company.gstin ?? '-'}',
                    style: const pw.TextStyle(fontSize: 9)),
                pw.Text('PAN: ${company.pan ?? '-'}',
                    style: const pw.TextStyle(fontSize: 9)),
              ],
            ),
            pw.Container(
              padding: const pw.EdgeInsets.all(8),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(width: 2),
              ),
              child: pw.Column(
                children: [
                  pw.Text(
                    'RA BILL',
                    style: pw.TextStyle(
                      fontSize: 14,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 4),
                  pw.Text(bill.billNumber,
                      style: const pw.TextStyle(fontSize: 10)),
                ],
              ),
            ),
          ],
        ),
        pw.SizedBox(height: 10),
        pw.Divider(thickness: 2),
      ],
    );
  }

  static pw.Widget _buildPageFooter(CompanySettings company, pw.Context context) {
    return pw.Column(
      children: [
        pw.Divider(),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text('Generated from Construction Billing Software',
                style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey)),
            pw.Text('Page ${context.pageNumber} of ${context.pagesCount}',
                style: const pw.TextStyle(fontSize: 8)),
          ],
        ),
      ],
    );
  }

  static pw.Widget _buildBillTo(Bill bill) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey100,
        border: pw.Border.all(color: PdfColors.grey400),
      ),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('Bill To:',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
                pw.SizedBox(height: 4),
                pw.Text(bill.clientName ?? bill.siteName ?? 'Unknown Client',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                if (bill.siteName != null && bill.siteName != bill.clientName)
                  pw.Text('Site: ${bill.siteName}'),
              ],
            ),
          ),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              _infoRow('Bill No:', bill.billNumber),
              _infoRow('Date:', AppDateUtils.formatDate(bill.billDate)),
              _infoRow('Status:', BillStatus.fromIndex(bill.status).displayName),
              if (bill.dueDate != null)
                _infoRow('Due Date:', AppDateUtils.formatDate(bill.dueDate)),
            ],
          ),
        ],
      ),
    );
  }

  static pw.Widget _infoRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 1),
      child: pw.Row(
        mainAxisSize: pw.MainAxisSize.min,
        children: [
          pw.Text(label, style: const pw.TextStyle(fontSize: 9)),
          pw.SizedBox(width: 8),
          pw.Text(value,
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9)),
        ],
      ),
    );
  }

  static pw.Widget _buildItemsTable(List<BillItem> items) {
    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey400),
      columnWidths: {
        0: const pw.FlexColumnWidth(0.5),
        1: const pw.FlexColumnWidth(4),
        2: const pw.FlexColumnWidth(1),
        3: const pw.FlexColumnWidth(1.5),
        4: const pw.FlexColumnWidth(1.5),
      },
      children: [
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.grey300),
          children: [
            _th('#'),
            _th('Description'),
            _th('Unit'),
            _th('Rate (₹)'),
            _th('Amount (₹)'),
          ],
        ),
        ...items.asMap().entries.map((entry) => pw.TableRow(
          children: [
            _td('${entry.key + 1}'),
            _td(entry.value.description),
            _td(entry.value.unit ?? '-'),
            _td(CurrencyFormatter.formatPlain(entry.value.rate)),
            _td(CurrencyFormatter.format(entry.value.amount)),
          ],
        )),
      ],
    );
  }

  static pw.Widget _th(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(6),
      child: pw.Text(text,
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10),
          textAlign: pw.TextAlign.center),
    );
  }

  static pw.Widget _td(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(6),
      child: pw.Text(text, style: const pw.TextStyle(fontSize: 9)),
    );
  }

  static pw.Widget _buildTotals(Bill bill) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.end,
      children: [
        pw.Container(
          width: 220,
          child: pw.Column(
            children: [
              _totalRow('Sub Total', CurrencyFormatter.format(bill.subtotal)),
              _totalRow('Add: CGST @${bill.gstRate / 2}%',
                  CurrencyFormatter.format(bill.cgstAmount)),
              _totalRow('Add: SGST @${bill.gstRate / 2}%',
                  CurrencyFormatter.format(bill.sgstAmount)),
              if (bill.igstAmount > 0)
                _totalRow('Add: IGST @${bill.gstRate}%',
                    CurrencyFormatter.format(bill.igstAmount)),
              pw.Divider(),
              _totalRow('GRAND TOTAL', CurrencyFormatter.format(bill.totalAmount),
                  bold: true, large: true),
            ],
          ),
        ),
      ],
    );
  }

  static pw.Widget _totalRow(String label, String value,
      {bool bold = false, bool large = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            label,
            style: pw.TextStyle(
              fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
              fontSize: large ? 12 : 10,
            ),
          ),
          pw.Text(
            value,
            style: pw.TextStyle(
              fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
              fontSize: large ? 12 : 10,
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildAmountInWords(Bill bill) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(8),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey100,
        border: pw.Border.all(color: PdfColors.grey400),
      ),
      child: pw.Row(
        children: [
          pw.Text('Amount in Words: ',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
          pw.Expanded(
            child: pw.Text(
              _numberToWords(bill.totalAmount),
              style: const pw.TextStyle(fontSize: 10),
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildBankDetails(CompanySettings company) {
    if (company.bankName == null) return pw.SizedBox();

    return pw.Container(
      padding: const pw.EdgeInsets.all(8),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey400),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('Bank Details',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
          pw.SizedBox(height: 4),
          pw.Row(
            children: [
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('Bank Name: ${company.bankName ?? '-'}',
                        style: const pw.TextStyle(fontSize: 9)),
                    pw.Text('A/C No: ${company.bankAccountNumber ?? '-'}',
                        style: const pw.TextStyle(fontSize: 9)),
                  ],
                ),
              ),
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('IFSC: ${company.bankIfsc ?? '-'}',
                        style: const pw.TextStyle(fontSize: 9)),
                    pw.Text('Branch: ${company.bankBranch ?? '-'}',
                        style: const pw.TextStyle(fontSize: 9)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildTerms(CompanySettings company) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(8),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey400),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('Terms & Conditions',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
          pw.SizedBox(height: 4),
          pw.Text(company.termsAndConditions!,
              style: const pw.TextStyle(fontSize: 8)),
        ],
      ),
    );
  }

  // Helper: Number to words (simplified for INR)
  static String _numberToWords(double number) {
    if (number == 0) return 'Zero Rupees Only';

    final rupees = number.floor();
    final paise = ((number - rupees) * 100).round();

    final words = _convertToWords(rupees);
    var result = '$words Rupees';

    if (paise > 0) {
      result += ' and ${_convertToWords(paise)} Paise';
    }

    return '$result Only';
  }

  static String _convertToWords(int number) {
    if (number == 0) return 'Zero';

    final units = [
      '', 'One', 'Two', 'Three', 'Four', 'Five', 'Six', 'Seven', 'Eight', 'Nine',
      'Ten', 'Eleven', 'Twelve', 'Thirteen', 'Fourteen', 'Fifteen', 'Sixteen',
      'Seventeen', 'Eighteen', 'Nineteen'
    ];
    final tens = ['', '', 'Twenty', 'Thirty', 'Forty', 'Fifty', 'Sixty', 'Seventy', 'Eighty', 'Ninety'];

    if (number < 20) return units[number];
    if (number < 100) return '${tens[number ~/ 10]} ${units[number % 10]}'.trim();
    if (number < 1000) return '${units[number ~/ 100]} Hundred ${_convertToWords(number % 100)}'.trim();
    if (number < 100000) return '${_convertToWords(number ~/ 1000)} Thousand ${_convertToWords(number % 1000)}'.trim();
    if (number < 10000000) return '${_convertToWords(number ~/ 100000)} Lakh ${_convertToWords(number % 100000)}'.trim();
    return '${_convertToWords(number ~/ 10000000)} Crore ${_convertToWords(number % 10000000)}'.trim();
  }
}