import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'Manajemen/Barang/Barang.dart';
import 'Manajemen/Kategori/Kategori.dart';
class ServiceTab extends StatefulWidget {
  const ServiceTab({super.key});

  @override
  State<ServiceTab> createState() => _ServiceTabState();
}

class _ServiceTabState extends State<ServiceTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Manajemen',
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
            icon: FontAwesomeIcons.boxesPacking,
            title: 'Barang',
            subtitle: 'Kelola data barang',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Barang_page()),
              );
            },
          ),
          _buildMenuItem(
            icon: FontAwesomeIcons.sliders,
            title: 'Kategori',
            subtitle: 'Kelola kategori produk',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => KategoriPage()),
              );
            },
          ),
          _buildMenuItem(
            icon: FontAwesomeIcons.clipboard,
            title: 'Stok',
            subtitle: 'Pantau dan kelola stok',
            onTap: () {
              // Navigasi ke halaman Stok
            },
          ),
          _buildMenuItem(
            icon: FontAwesomeIcons.cartShopping,
            title: 'Penjualan',
            subtitle: 'Transaksi Penjualan',
            onTap: () {
              // Navigasi ke halaman Penjualan
            },
          ),
          _buildMenuItem(
            icon: FontAwesomeIcons.cartArrowDown,
            title: 'Pembelian',
            subtitle: 'Transaksi Pembelian',
            onTap: () {
              // Navigasi ke halaman Barang
            },
          ),
          _buildMenuItem(
            icon: FontAwesomeIcons.truck,
            title: 'Supplier',
            subtitle: 'Kelola Supplier',
            onTap: () {
              // Navigasi ke halaman Kategori
            },
          ),
          _buildMenuItem(
            icon: FontAwesomeIcons.userGroup,
            title: 'Customer',
            subtitle: 'Kelola Pelanggan',
            onTap: () {
              // Navigasi ke halaman Stok
            },
          ),
          _buildMenuItem(
            icon: FontAwesomeIcons.receipt,
            title: 'Pengeluaran',
            subtitle: 'Data Dana Pengeluaran',
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
