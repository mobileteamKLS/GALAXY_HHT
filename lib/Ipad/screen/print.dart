import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:printing/printing.dart';
class PdfViewerScreen extends StatefulWidget {
  @override
  _PdfViewerScreenState createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  String? filePath;

  /// Pick a PDF from local storage
  Future<void> pickPdf() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        filePath = result.files.single.path!;
      });
    }
  }

  /// Select a printer and print the PDF over WiFi
  Future<void> selectPrinterAndPrint() async {
    if (filePath == null) return;
    var info = await Printing.info(); print(info);
    print(info);
    // Discover available printers
    final Printer? selectedPrinter = await Printing.pickPrinter(context:context);

    if (selectedPrinter != null) {
      final file = File(filePath!);

      // Send the PDF to the selected printer
      await Printing.directPrintPdf(
        printer: selectedPrinter,
        onLayout: (_) => file.readAsBytesSync(),
      );

      print("Printing started on: ${selectedPrinter.name}");
    } else {
      print("No printer selected");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("PDF Viewer & Printer")),
      body: filePath != null
          ? PDFView(filePath: filePath!)
          : Center(child: Text("Select a PDF to view & print")),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            onPressed: pickPdf,
            child: Icon(Icons.file_open),
            tooltip: "Select PDF",
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            onPressed: selectPrinterAndPrint,
            child: Icon(Icons.print),
            tooltip: "Print PDF",
          ),
        ],
      ),
    );
  }
}