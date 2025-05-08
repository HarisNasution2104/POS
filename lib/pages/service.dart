import 'package:flutter/material.dart';

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
        title: const Text('Manajemen Layanan'),
        backgroundColor: const Color(0xFFE76F51),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildMenuItem(
            icon: Icons.inventory_2_outlined,
            title: 'Barang',
            subtitle: 'Kelola data barang',
            onTap: () {
              // Navigasi ke halaman Barang
            },
          ),
          _buildMenuItem(
            icon: Icons.category_outlined,
            title: 'Kategori',
            subtitle: 'Kelola kategori produk',
            onTap: () {
              // Navigasi ke halaman Kategori
            },
          ),
          _buildMenuItem(
            icon: Icons.point_of_sale_outlined,
            title: 'Stok',
            subtitle: 'Pantau dan kelola stok',
            onTap: () {
              // Navigasi ke halaman Stok
            },
          ),
          _buildMenuItem(
            icon: Icons.shopping_cart_outlined,
            title: 'Penjualan',
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
