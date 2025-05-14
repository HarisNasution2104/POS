import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ReportTab extends StatelessWidget {
  const ReportTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Laporan',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFFE76F51),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildMenuItem(
            icon: FontAwesomeIcons.receipt,
            title: 'Laporan Penjualan',
            subtitle: 'Kelola data barang',
            onTap: () {
              // Navigasi ke halaman Barang
            },
          ),
          _buildMenuItem(
            icon: FontAwesomeIcons.truckFast,
            title: 'Laporan Pembelian',
            subtitle: 'Kelola kategori produk',
            onTap: () {
              // Navigasi ke halaman Kategori
            },
          ),
          _buildMenuItem(
            icon: FontAwesomeIcons.dollarSign,
            title: 'Laporan Laba/Rugi (Profit & Loss)',
            subtitle: 'Pantau dan kelola stok',
            onTap: () {
              // Navigasi ke halaman Stok
            },
          ),
          _buildMenuItem(
            icon: FontAwesomeIcons.boxesStacked,
            title: 'Laporan Stok Barang',
            subtitle: 'Lihat riwayat penjualan',
            onTap: () {
              // Navigasi ke halaman Penjualan
            },
          ),
          _buildMenuItem(
            icon: FontAwesomeIcons.calculator,
            title: 'Laporan Arus Kas',
            subtitle: 'Lihat riwayat penjualan',
            onTap: () {
              // Navigasi ke halaman Penjualan
            },
          ),
          _buildMenuItem(
            icon: FontAwesomeIcons.fileInvoice,
            title: 'Laporan Pengeluaran',
            subtitle: 'Lihat riwayat penjualan',
            onTap: () {
              // Navigasi ke halaman Penjualan
            },
          ),
          _buildMenuItem(
            icon: FontAwesomeIcons.retweet,
            title: 'Laporan Return',
            subtitle: 'Lihat riwayat penjualan',
            onTap: () {
              // Navigasi ke halaman Penjualan
            },
          ),
          _buildMenuItem(
            icon: FontAwesomeIcons.userTie,
            title: 'Laporan Kinerja Kasir / Pegawai',
            subtitle: 'Lihat riwayat penjualan',
            onTap: () {
              // Navigasi ke halaman Penjualan
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFFE76F51)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
