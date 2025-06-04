import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_printer/flutter_bluetooth_printer_library.dart';

class ReceiptPreviewPage extends StatefulWidget {
  const ReceiptPreviewPage({super.key});


  @override
  State<ReceiptPreviewPage> createState() => _ReceiptPreviewPageState();
}

class _ReceiptPreviewPageState extends State<ReceiptPreviewPage> {
  ReceiptController? controller;
    String ? address;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preview Struk'),
        backgroundColor: const Color(0xFFE76F51),
        actions: [
          IconButton(
            onPressed: () async {
              final selected = await FlutterBluetoothPrinter.selectDevice(context);
            if (selected != null) {
              setState((){
                address = selected.address;
              },
              );
            }
            },
            icon: Icon(Icons.print),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Center(
                child: Text(
                  'TOKO SEPUTAR IT',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Center(child: Text('Jl. Teknologi No. 123')),
              SizedBox(height: 16),
              Text('Tanggal : 02-06-2025'),
              Text('Kasir   : Admin'),
              Divider(),
              Text('1x Indomie Goreng         Rp3.500'),
              Text('2x Teh Botol Sosro        Rp8.000'),
              Divider(),
              Text('Total    : Rp11.500'),
              SizedBox(height: 8),
              Center(child: Text('Terima kasih atas kunjungannya!')),

            ],
          ),
        ),
        
      ),
    );
  }
}