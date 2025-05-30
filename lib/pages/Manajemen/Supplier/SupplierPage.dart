import 'package:flutter/material.dart';

class SupplierPage extends StatelessWidget {
  const SupplierPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kelola Supplier'),
        backgroundColor: const Color(0xFFE76F51),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Navigasi ke halaman detail supplier
          },
          child: const Text('Tambah Supplier'),
        ),
      ),
    );
  }
}
