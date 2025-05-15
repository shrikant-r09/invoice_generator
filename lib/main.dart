import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Invoice Generator',
      home: InvoicePage(),
    );
  }
}

class InvoiceItem {
  final String name;
  final int quantity;
  final double price;

  InvoiceItem({required this.name, required this.quantity, required this.price});

  double get total => quantity * price;
}

class InvoicePage extends StatefulWidget {
  @override
  _InvoicePageState createState() => _InvoicePageState();
}

class _InvoicePageState extends State<InvoicePage> {
  final List<InvoiceItem> _items = [];

  final TextEditingController _businessTitleController = TextEditingController();
  final TextEditingController _gstinController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  DateTime currentDate = DateTime.now();

  double get _total => _items.fold(0, (sum, item) => sum + item.total);

  void _addItem() {
    final name = _nameController.text;
    final quantity = int.tryParse(_quantityController.text) ?? 0;
    final price = double.tryParse(_priceController.text) ?? 0.0;

    if (name.isEmpty || quantity <= 0 || price <= 0) return;

    setState(() {
      _items.add(InvoiceItem(name: name, quantity: quantity, price: price));
      _nameController.clear();
      _quantityController.clear();
      _priceController.clear();
    });
  }

  void _resetCartOnly() {
    setState(() {
      _items.clear();
      _nameController.clear();
      _quantityController.clear();
      _priceController.clear();
    });
  }

  void _editItem(int index) {
    final item = _items[index];

    final nameController = TextEditingController(text: item.name);
    final quantityController = TextEditingController(text: item.quantity.toString());
    final priceController = TextEditingController(text: item.price.toStringAsFixed(2));

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Item Name'),
              ),
              TextField(
                controller: quantityController,
                decoration: InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: priceController,
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                final newName = nameController.text;
                final newQty = int.tryParse(quantityController.text) ?? item.quantity;
                final newPrice = double.tryParse(priceController.text) ?? item.price;

                setState(() {
                  _items[index] = InvoiceItem(name: newName, quantity: newQty, price: newPrice);
                });

                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _deleteItem(int index) {
    setState(() {
      _items.removeAt(index);
    });
  }

  void _openPdfPreview() {
    currentDate = DateTime.now(); // Refresh date
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PdfPreviewPage(
          businessTitle: _businessTitleController.text,
          gstin: _gstinController.text,
          items: _items,
          total: _total,
          dateTime: currentDate,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String formattedDateTime = DateFormat('yyyy-MM-dd – kk:mm').format(currentDate);

    return Scaffold(
      appBar: AppBar(
        title: Text('Invoice Generator'),
        actions: [
          IconButton(icon: Icon(Icons.refresh), onPressed: _resetCartOnly),
          IconButton(icon: Icon(Icons.picture_as_pdf), onPressed: _openPdfPreview),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _businessTitleController,
                decoration: InputDecoration(labelText: 'Business Title'),
              ),
              TextField(
                controller: _gstinController,
                decoration: InputDecoration(labelText: 'GSTIN / STIN Number'),
              ),
              SizedBox(height: 10),
              Text('Date & Time: $formattedDateTime'),
              SizedBox(height: 10),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Item Name'),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _quantityController,
                      decoration: InputDecoration(labelText: 'Quantity'),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _priceController,
                      decoration: InputDecoration(labelText: 'Price'),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: _addItem,
                child: Text('Add Item'),
              ),
              SizedBox(
                height: 250,
                child: ListView.builder(
                  itemCount: _items.length,
                  itemBuilder: (_, index) {
                    final item = _items[index];
                    return ListTile(
                      title: Text('${item.name} (x${item.quantity})'),
                      subtitle: Text('₹${item.total.toStringAsFixed(2)}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _editItem(index),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteItem(index),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Text(
                'Total: ₹${_total.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PdfPreviewPage extends StatelessWidget {
  final String businessTitle;
  final String gstin;
  final List<InvoiceItem> items;
  final double total;
  final DateTime dateTime;

  PdfPreviewPage({
    required this.businessTitle,
    required this.gstin,
    required this.items,
    required this.total,
    required this.dateTime,
  });

  Future<Uint8List> _buildPdf(PdfPageFormat format) async {
    final pdf = pw.Document();
    final formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(dateTime);

    pdf.addPage(
      pw.Page(
        pageFormat: format,
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                businessTitle.isNotEmpty ? businessTitle : 'Business Title',
                style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
              ),
              pw.Text(
                gstin.isNotEmpty ? 'GSTIN: $gstin' : 'GSTIN: __________',
                style: pw.TextStyle(fontSize: 14),
              ),
              pw.Text(
                'Date: $formattedDate',
                style: pw.TextStyle(fontSize: 12),
              ),
              pw.SizedBox(height: 20),
              pw.Table.fromTextArray(
                headers: ['Item', 'Qty', 'Price', 'Total'],
                data: items.map((item) => [
                  item.name,
                  item.quantity.toString(),
                  item.price.toStringAsFixed(2),
                  item.total.toStringAsFixed(2)
                ]).toList(),
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                'Total: ₹${total.toStringAsFixed(2)}',
                style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
              ),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Preview Invoice'),
        leading: BackButton(),
      ),
      body: PdfPreview(
        build: (format) => _buildPdf(format),
      ),
    );
  }
}
