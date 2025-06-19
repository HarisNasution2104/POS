import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pos4/pages/Report/Penjualan/PenjualanPerBulan.dart';
import 'package:pos4/pages/Report/Penjualan/PenjualanPerHari.dart';
import 'package:pos4/pages/Report/Penjualan/PenjualanPerMinggu.dart';
import 'package:pos4/pages/Report/Penjualan/PenjualanPerTahun.dart';
import '../../Constans.dart';

class LaporanPenjualan extends StatefulWidget {
  const LaporanPenjualan({super.key});

  @override
  State<LaporanPenjualan> createState() => _LaporanPenjualanState();
}

class _LaporanPenjualanState extends State<LaporanPenjualan> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar('Report', centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildMenuItem(
            icon: FontAwesomeIcons.receipt,
            title: 'Penjualan Hari Ini',
            subtitle: 'Transaksi Hari Ini',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PenjualanPerHari()),
              );
            },
          ),
          _buildMenuItem(
            icon: FontAwesomeIcons.receipt,
            title: 'Penjualan Perminggu',
            subtitle: 'Transaksi Minggu Ini',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PenjualanPerMinggu()),
              );
            },
          ),
          _buildMenuItem(
            icon: FontAwesomeIcons.receipt,
            title: 'Penjualan Perbulan',
            subtitle: 'Transaksi Perbulan',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PenjualanPerBulan()),
              );
            },
          ),
          _buildMenuItem(
            icon: FontAwesomeIcons.receipt,
            title: 'Penjualan Pertahun',
            subtitle: 'Seluruh Transaksi',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PenjualanPertahun()),
              );
            },
          ),
                    _buildMenuItem(
            icon: FontAwesomeIcons.receipt,
            title: 'Penjualan Semua Transaksi',
            subtitle: 'Seluruh Transaksi',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PenjualanPerBulan()),
              );
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
