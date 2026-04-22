import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:super_market/app/data/models/purchase.dart';
import 'package:super_market/app/data/models/purchase_item.dart';
import 'package:super_market/app/data/models/company_settings.dart';
import 'package:super_market/app/core/utils/currency_formatter.dart';
import 'package:super_market/app/core/utils/date_utils.dart';

class PurchasePdfBuilder {
  static Future<pw.Document> build({
    required Purchase purchase,
    required List<PurchaseItem> items,
    required CompanySettings company,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header
              _buildHeader(company),
              pw.SizedBox(height: 20),

              // Title
              pw.Center(
                child: pw.Text(
                  'PURCHASE BILL',
                  style: pw.TextStyle(
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.SizedBox(height: 20),

              // Bill Info
              _buildBillInfo(purchase, company),
              pw.SizedBox(height: 16),

              // Supplier Info
              _buildSupplierInfo(purchase),
              pw.SizedBox(height: 20),

              // Items Table
              _buildItemsTable(items),
              pw.SizedBox(height: 20),

              // Totals
              _buildTotals(purchase),
              pw.SizedBox(height: 20),

              // Terms
              if (company.termsAndConditions?.isNotEmpty ?? false)
                _buildTerms(company),

              pw.Spacer(),

              // Footer
              _buildFooter(company),
            ],
          );
        },
      ),
    );

    return pdf;
  }

  static pw.Widget _buildHeader(CompanySettings company) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              company.companyName,
              style: pw.TextStyle(
                fontSize: 20,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            if (company.address != null)
              pw.Text(company.address!, style: const pw.TextStyle(fontSize: 10)),
            if (company.city != null)
              pw.Text('${company.city}, ${company.state ?? ''} ${company.pincode ?? ''}',
                  style: const pw.TextStyle(fontSize: 10)),
            pw.SizedBox(height: 4),
            pw.Text('Phone: ${company.phone ?? company.mobile ?? '-'}',
                style: const pw.TextStyle(fontSize: 10)),
            pw.Text('Email: ${company.email ?? '-'}',
                style: const pw.TextStyle(fontSize: 10)),
            pw.Text('GSTIN: ${company.gstin ?? '-'}',
                style: const pw.TextStyle(fontSize: 10)),
          ],
        ),
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.end,
          children: [
            if (company.logoPath != null)
              pw.Container(
                width: 60,
                height: 60,
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(),
                ),
                child: pw.Center(child: pw.Text('LOGO')),
              ),
          ],
        ),
      ],
    );
  }

  static pw.Widget _buildBillInfo(Purchase purchase, CompanySettings company) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(8),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Bill No: ${purchase.purchaseNumber}',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              pw.Text('Date: ${AppDateUtils.formatDate(purchase.purchaseDate)}'),
              if (purchase.invoiceNumber != null)
                pw.Text('Invoice No: ${purchase.invoiceNumber}'),
              if (purchase.invoiceDate != null)
                pw.Text('Invoice Date: ${AppDateUtils.formatDate(purchase.invoiceDate)}'),
            ],
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildSupplierInfo(Purchase purchase) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(8),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey100,
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('Supplier Details',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 4),
          pw.Text(purchase.supplierName ?? 'Unknown Supplier'),
          if (purchase.supplierPartyLocalId != null)
            pw.Text('Party ID: ${purchase.supplierPartyLocalId}'),
        ],
      ),
    );
  }

  static pw.Widget _buildItemsTable(List<PurchaseItem> items) {
    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey400),
      columnWidths: {
        0: const pw.FlexColumnWidth(4),
        1: const pw.FlexColumnWidth(1),
        2: const pw.FlexColumnWidth(1.5),
        3: const pw.FlexColumnWidth(1.5),
        4: const pw.FlexColumnWidth(1.5),
      },
      children: [
        // Header Row
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.grey300),
          children: [
            _tableHeader('Description'),
            _tableHeader('Qty'),
            _tableHeader('Rate'),
            _tableHeader('GST %'),
            _tableHeader('Amount'),
          ],
        ),
        // Data Rows
        ...items.map((item) => pw.TableRow(
          children: [
            _tableCell(item.materialName),
            _tableCell('${item.quantity} ${item.unitSymbol}'),
            _tableCell(CurrencyFormatter.format(item.rate)),
            _tableCell('${item.gstRate}%'),
            _tableCell(CurrencyFormatter.format(item.amount)),
          ],
        )),
      ],
    );
  }

  static pw.Widget _tableHeader(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(6),
      child: pw.Text(
        text,
        style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10),
      ),
    );
  }

  static pw.Widget _tableCell(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(6),
      child: pw.Text(text, style: const pw.TextStyle(fontSize: 10)),
    );
  }

  static pw.Widget _buildTotals(Purchase purchase) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.end,
      children: [
        pw.Container(
          width: 200,
          child: pw.Column(
            children: [
              _totalRow('Subtotal', CurrencyFormatter.format(purchase.subtotal)),
              _totalRow('CGST', CurrencyFormatter.format(purchase.cgstAmount)),
              _totalRow('SGST', CurrencyFormatter.format(purchase.sgstAmount)),
              _totalRow('IGST', CurrencyFormatter.format(purchase.igstAmount)),
              pw.Divider(),
              _totalRow('Total', CurrencyFormatter.format(purchase.totalAmount),
                  bold: true),
            ],
          ),
        ),
      ],
    );
  }

  static pw.Widget _totalRow(String label, String value, {bool bold = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            label,
            style: bold
                ? pw.TextStyle(fontWeight: pw.FontWeight.bold)
                : const pw.TextStyle(),
          ),
          pw.Text(
            value,
            style: bold
                ? pw.TextStyle(fontWeight: pw.FontWeight.bold)
                : const pw.TextStyle(),
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

  static pw.Widget _buildFooter(CompanySettings company) {
    return pw.Column(
      children: [
        pw.Divider(),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('Bank Details',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
                if (company.bankName != null)
                  pw.Text('Bank: ${company.bankName}', style: const pw.TextStyle(fontSize: 9)),
                if (company.bankAccountNumber != null)
                  pw.Text('A/C No: ${company.bankAccountNumber}', style: const pw.TextStyle(fontSize: 9)),
                if (company.bankIfsc != null)
                  pw.Text('IFSC: ${company.bankIfsc}', style: const pw.TextStyle(fontSize: 9)),
              ],
            ),
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Text('For ${company.companyName}',
                    style: const pw.TextStyle(fontSize: 10)),
                pw.SizedBox(height: 30),
                pw.Text('Authorised Signatory',
                    style: const pw.TextStyle(fontSize: 9)),
              ],
            ),
          ],
        ),
      ],
    );
  }
}