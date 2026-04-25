import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:intl/intl.dart';

class PDFGenerator {
  /// Generate application form PDF
  static Future<pw.Document> generateApplicationForm({
    required String schemeName,
    required Map<String, String> formData,
    required List<String> documents,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header
              pw.Center(
                child: pw.Column(
                  children: [
                    pw.Text(
                      'GOVERNMENT OF INDIA',
                      style: pw.TextStyle(
                        fontSize: 18,
                        fontWeight: pw.FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                    pw.SizedBox(height: 8),
                    pw.Text(
                      'OFFICIAL APPLICATION FORM',
                      style: pw.TextStyle(
                        fontSize: 14,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 20),
                    pw.Container(
                      width: double.infinity,
                      height: 2,
                      color: PdfColors.grey800,
                    ),
                  ],
                ),
              ),

              pw.SizedBox(height: 30),

              // Scheme Name
              pw.Container(
                padding: const pw.EdgeInsets.all(15),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.grey400),
                  borderRadius: pw.BorderRadius.circular(8),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'Scheme Applied For:',
                      style: pw.TextStyle(
                        fontSize: 12,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.grey700,
                      ),
                    ),
                    pw.SizedBox(height: 8),
                    pw.Text(
                      schemeName,
                      style: pw.TextStyle(
                        fontSize: 16,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              pw.SizedBox(height: 30),

              // Application Details
              pw.Text(
                'APPLICANT DETAILS',
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                  decoration: pw.TextDecoration.underline,
                ),
              ),

              pw.SizedBox(height: 20),

              // Form Fields
              ...formData.entries.map((entry) {
                return pw.Padding(
                  padding: const pw.EdgeInsets.only(bottom: 15),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        _formatLabel(entry.key),
                        style: pw.TextStyle(
                          fontSize: 11,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.grey700,
                        ),
                      ),
                      pw.SizedBox(height: 5),
                      pw.Container(
                        width: double.infinity,
                        padding: const pw.EdgeInsets.all(10),
                        decoration: pw.BoxDecoration(
                          border: pw.Border.all(color: PdfColors.grey400),
                          borderRadius: pw.BorderRadius.circular(4),
                        ),
                        child: pw.Text(
                          entry.value,
                          style: const pw.TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),

              pw.SizedBox(height: 30),

              // Documents Required
              pw.Text(
                'DOCUMENTS REQUIRED',
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                  decoration: pw.TextDecoration.underline,
                ),
              ),

              pw.SizedBox(height: 15),

              ...documents.map((doc) {
                return pw.Padding(
                  padding: const pw.EdgeInsets.only(bottom: 8),
                  child: pw.Row(
                    children: [
                      pw.Container(
                        width: 8,
                        height: 8,
                        decoration: const pw.BoxDecoration(
                          shape: pw.BoxShape.circle,
                          color: PdfColors.grey800,
                        ),
                      ),
                      pw.SizedBox(width: 10),
                      pw.Text(
                        doc,
                        style: const pw.TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                );
              }).toList(),

              pw.SizedBox(height: 40),

              // Declaration
              pw.Container(
                padding: const pw.EdgeInsets.all(15),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.grey400),
                  borderRadius: pw.BorderRadius.circular(8),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'DECLARATION',
                      style: pw.TextStyle(
                        fontSize: 12,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 10),
                    pw.Text(
                      'I hereby declare that the information provided above is true and correct to the best of my knowledge and belief. I understand that any false information may result in rejection of my application and legal action.',
                      style: const pw.TextStyle(fontSize: 10),
                    ),
                  ],
                ),
              ),

              pw.Spacer(),

              // Footer
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Container(
                        width: 150,
                        height: 50,
                        decoration: pw.BoxDecoration(
                          border: pw.Border.all(color: PdfColors.grey400),
                        ),
                      ),
                      pw.SizedBox(height: 5),
                      pw.Text(
                        'Applicant Signature',
                        style: pw.TextStyle(fontSize: 10, color: PdfColors.grey600),
                      ),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text(
                        'Date: ${DateFormat('dd/MM/yyyy').format(DateTime.now())}',
                        style: pw.TextStyle(fontSize: 10, color: PdfColors.grey600),
                      ),
                    ],
                  ),
                ],
              ),

              pw.SizedBox(height: 20),

              pw.Center(
                child: pw.Text(
                  'Generated by ADHIKAR - Your Right. Delivered.',
                  style: pw.TextStyle(
                    fontSize: 8,
                    color: PdfColors.grey600,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );

    return pdf;
  }

  /// Format field key to readable label
  static String _formatLabel(String key) {
    return key
        .split('_')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  /// Generate benefit summary PDF
  static Future<pw.Document> generateBenefitSummary({
    required String userName,
    required int schemeCount,
    required double totalBenefit,
    required List<Map<String, String>> schemes,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header
              pw.Center(
                child: pw.Column(
                  children: [
                    pw.Text(
                      'ADHIKAR - BENEFIT SUMMARY',
                      style: pw.TextStyle(
                        fontSize: 20,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.blue800,
                      ),
                    ),
                    pw.SizedBox(height: 8),
                    pw.Text(
                      'Your Right. Delivered.',
                      style: pw.TextStyle(
                        fontSize: 12,
                        fontStyle: pw.FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),

              pw.SizedBox(height: 30),

              // User Info
              pw.Text(
                'Name: $userName',
                style: const pw.TextStyle(fontSize: 14),
              ),
              pw.Text(
                'Date: ${DateFormat('dd/MM/yyyy').format(DateTime.now())}',
                style: pw.TextStyle(fontSize: 12, color: PdfColors.grey600),
              ),

              pw.SizedBox(height: 30),

              // Summary Card
              pw.Container(
                padding: const pw.EdgeInsets.all(20),
                decoration: pw.BoxDecoration(
                  color: PdfColors.blue100,
                  borderRadius: pw.BorderRadius.circular(12),
                ),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                  children: [
                    pw.Column(
                      children: [
                        pw.Text(
                          '$schemeCount',
                          style: pw.TextStyle(
                            fontSize: 32,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.blue800,
                          ),
                        ),
                        pw.Text(
                          'Schemes',
                          style: const pw.TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    pw.Container(
                      width: 1,
                      height: 50,
                      color: PdfColors.blue300,
                    ),
                    pw.Column(
                      children: [
                        pw.Text(
                          '₹${totalBenefit.toInt()}',
                          style: pw.TextStyle(
                            fontSize: 32,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.blue800,
                          ),
                        ),
                        pw.Text(
                          'Total Benefit/Year',
                          style: const pw.TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              pw.SizedBox(height: 30),

              // Schemes List
              pw.Text(
                'ELIGIBLE SCHEMES',
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                  decoration: pw.TextDecoration.underline,
                ),
              ),

              pw.SizedBox(height: 15),

              ...schemes.asMap().entries.map((entry) {
                final index = entry.key + 1;
                final scheme = entry.value;
                return pw.Container(
                  margin: const pw.EdgeInsets.only(bottom: 12),
                  padding: const pw.EdgeInsets.all(12),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.grey300),
                    borderRadius: pw.BorderRadius.circular(8),
                  ),
                  child: pw.Row(
                    children: [
                      pw.Container(
                        width: 30,
                        height: 30,
                        decoration: pw.BoxDecoration(
                          color: PdfColors.blue800,
                          shape: pw.BoxShape.circle,
                        ),
                        child: pw.Center(
                          child: pw.Text(
                            '$index',
                            style: const pw.TextStyle(
                              color: PdfColors.white,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      pw.SizedBox(width: 12),
                      pw.Expanded(
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              scheme['name'] ?? '',
                              style: pw.TextStyle(
                                fontSize: 12,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                            pw.SizedBox(height: 4),
                            pw.Text(
                              scheme['benefit'] ?? '',
                              style: pw.TextStyle(
                                fontSize: 10,
                                color: PdfColors.grey700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),

              pw.Spacer(),

              // Footer
              pw.Center(
                child: pw.Text(
                  'This document was generated by ADHIKAR app.\n'
                  'Please visit the respective government offices to apply for these schemes.',
                  style: pw.TextStyle(
                    fontSize: 9,
                    color: PdfColors.grey600,
                  ),
                  textAlign: pw.TextAlign.center,
                ),
              ),
            ],
          );
        },
      ),
    );

    return pdf;
  }
}
