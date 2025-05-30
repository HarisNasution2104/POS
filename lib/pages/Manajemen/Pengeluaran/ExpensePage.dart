import 'package:flutter/material.dart';

class ExpensePage extends StatelessWidget {
  const ExpensePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Pengeluaran'),
        backgroundColor: const Color(0xFFE76F51),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Navigasi ke halaman detail pengeluaran
          },
          child: const Text('Tambah Pengeluaran'),
        ),
      ),
    );
  }
}
