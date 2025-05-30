import 'package:flutter/material.dart';

class SalesPage extends StatelessWidget {
  const SalesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaksi Penjualan'),
        backgroundColor: const Color(0xFFE76F51),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Navigasi ke halaman detail penjualan
          },
          child: const Text('Tambah Penjualan'),
        ),
      ),
    );
  }
}
