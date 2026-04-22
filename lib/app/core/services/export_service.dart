import 'dart:io';
import 'package:csv/csv.dart';

import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';


class ExportService {
  /// Export list of maps to CSV file
  static Future<File?> exportToCsv({
    required List<Map<String, dynamic>> data,
    required List<String> columns,
    required String fileName,
    List<String>? headers,
  }) async {
    try {
      // Convert headers
      final headerRow = headers ?? columns;

      // Build rows
      final rows = <List<dynamic>>[headerRow];
      for (final item in data) {
        final row = columns.map((col) => item[col] ?? '').toList();
        rows.add(row);
      }

      // Convert to CSV
      final csv = const ListToCsvConverter().convert(rows);

      // Get documents directory
      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
      final file = File('${directory.path}/$fileName\_$timestamp.csv');

      // Write file
      await file.writeAsString(csv);

      return file;
    } catch (e) {
      return null;
    }
  }

  /// Export purchases to CSV
  static Future<File?> exportPurchases(
      List<Map<String, dynamic>> purchases,
      ) async {
    return exportToCsv(
      data: purchases,
      columns: [
        'purchaseNumber',
        'purchaseDate',
        'supplierName',
        'invoiceNumber',
        'subtotal',
        'gstAmount',
        'totalAmount',
      ],
      headers: [
        'Bill No',
        'Date',
        'Supplier',
        'Invoice No',
        'Subtotal',
        'GST',
        'Total',
      ],
      fileName: 'purchases',
    );
  }

  /// Export bills to CSV
  static Future<File?> exportBills(
      List<Map<String, dynamic>> bills,
      ) async {
    return exportToCsv(
      data: bills,
      columns: [
        'billNumber',
        'billDate',
        'siteName',
        'clientName',
        'status',
        'totalAmount',
      ],
      headers: [
        'Bill No',
        'Date',
        'Site',
        'Client',
        'Status',
        'Amount',
      ],
      fileName: 'bills',
    );
  }

  /// Export party ledger to CSV
  static Future<File?> exportLedger(
      List<Map<String, dynamic>> entries,
      String partyName,
      ) async {
    return exportToCsv(
      data: entries,
      columns: [
        'date',
        'reference',
        'description',
        'debit',
        'credit',
        'balance',
      ],
      headers: [
        'Date',
        'Reference',
        'Description',
        'Debit',
        'Credit',
        'Balance',
      ],
      fileName: 'ledger_${partyName.replaceAll(' ', '_')}',
    );
  }

  /// Export stock report to CSV
  static Future<File?> exportStockReport(
      List<Map<String, dynamic>> materials,
      ) async {
    return exportToCsv(
      data: materials,
      columns: [
        'name',
        'unitSymbol',
        'currentStock',
        'rate',
        'alertQuantity',
        'stockValue',
      ],
      headers: [
        'Material',
        'Unit',
        'Stock',
        'Rate',
        'Alert At',
        'Value',
      ],
      fileName: 'stock_report',
    );
  }

  /// Export worker attendance to CSV
  static Future<File?> exportAttendance(
      List<Map<String, dynamic>> attendance,
      String month,
      ) async {
    return exportToCsv(
      data: attendance,
      columns: [
        'workerName',
        'category',
        'daysPresent',
        'daysAbsent',
        'totalWages',
      ],
      headers: [
        'Worker Name',
        'Category',
        'Days Present',
        'Days Absent',
        'Total Wages',
      ],
      fileName: 'attendance_$month',
    );
  }

  /// Export worker payment report to CSV
  static Future<File?> exportWorkerPayments(
      List<Map<String, dynamic>> payments,
      ) async {
    return exportToCsv(
      data: payments,
      columns: [
        'paymentNumber',
        'paymentDate',
        'workerName',
        'siteName',
        'paymentType',
        'amount',
      ],
      headers: [
        'Payment No',
        'Date',
        'Worker',
        'Site',
        'Type',
        'Amount',
      ],
      fileName: 'worker_payments',
    );
  }
}