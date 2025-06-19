import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_printer/flutter_bluetooth_printer_library.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReceiptPreviewPage extends StatefulWidget {
  const ReceiptPreviewPage({super.key});

  @override
  State<ReceiptPreviewPage> createState() => _ReceiptPreviewPageState();
}

class _ReceiptPreviewPageState extends State<ReceiptPreviewPage> {
  ReceiptController? controller;
  String? savedAddress;

  @override
  void initState() {
    super.initState();
    _loadSavedPrinter();
  }

  Future<void> _loadSavedPrinter() async {
    final prefs = await SharedPreferences.getInstance();
    final addr = prefs.getString('saved_printer_address');
    if (addr != null) {
      setState(() {
        savedAddress = addr;
      });
    }
  }

  Future<void> _savePrinter(String address) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('saved_printer_address', address);
    setState(() {
      savedAddress = address;
    });
  }

  Future<void> _printReceipt() async {
    if (savedAddress == null) {
      // Belum ada printer disimpan, minta pilih dulu
      final device = await FlutterBluetoothPrinter.selectDevice(context);
      if (!mounted) return;
      if (device != null) {
        await _savePrinter(device.address);
        await controller?.print(
          address: device.address,
          keepConnected: true,
          addFeeds: 4,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Berhasil mencetak!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Printer tidak dipilih')),
        );
      }
    } else {
      // Langsung cetak ke printer yang sudah disimpan
      await controller?.print(
        address: savedAddress!,
        keepConnected: true,
        addFeeds: 4,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Berhasil mencetak ke printer tersimpan!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xFFE76F51),
        title: const Text(
          'Bluetooth Printer',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Receipt(
        onInitialized: (ctrl) {
          controller = ctrl;
        },
        builder:
            (context) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    'TOKO FLUTTER',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
                const SizedBox(height: 8),
                const Center(child: Text('Jl. Contoh No. 123, Jakarta',style: TextStyle(fontSize: 20),)),
                const Center(child: Text('Telp: 0812-3456-7890',style: TextStyle(fontSize: 20),)),
                const Divider(),
                const Text('Tanggal: 03-06-2025 10:23',style: TextStyle(fontSize: 20),),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [Text('Item',style: TextStyle(fontSize: 20),), Text('Qty',style: TextStyle(fontSize: 20),), Text('Harga',style: TextStyle(fontSize: 20),)],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('Kopi Susu'),
                    Text('2'),
                    Text('10.000'),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('Roti Bakar'),
                    Text('1'),
                    Text('15.000'),
                  ],
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'Total',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '35.000',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Center(
                  child: Text(
                    'Terima kasih!',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
              ],
            ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange),
          onPressed: _printReceipt,
          icon: const Icon(Icons.print, color: Colors.white),
          label: const Text(
            'Cetak',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}