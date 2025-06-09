import 'package:flutter/material.dart';
import 'ReceiptPreviewPage.dart';

class Settingspage extends StatefulWidget {
  const Settingspage({super.key});

  @override
  State<Settingspage> createState() => _SettingspageState();
}

class _SettingspageState extends State<Settingspage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: const Text(
          'Pengaturan',
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
            icon: Icons.print,
            title: 'Printer & Struk',
            subtitle: 'Pengaturan cetakan struk',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ReceiptPreviewPage()),
              );
            },
          ),
          _buildMenuItem(
            icon: Icons.storage,
            title: 'Database',
            subtitle: 'Backup & restore data',
            onTap: () => _showComingSoon('Pengaturan Database'),
          ),
          _buildMenuItem(
            icon: Icons.account_balance_wallet,
            title: 'E-Wallet',
            subtitle: 'Kelola integrasi e-wallet',
            onTap: () => _showComingSoon('Pengaturan E-Wallet'),
          ),
          _buildMenuItem(
            icon: Icons.sync,
            title: 'Sinkronisasi',
            subtitle: 'Sinkronisasi data ke cloud',
            onTap: () => _showComingSoon('Sinkronisasi Data'),
          ),
          _buildMenuItem(
            icon: Icons.people,
            title: 'Manajemen Staff',
            subtitle: 'Kelola akses dan peran staff',
            onTap: () => _showComingSoon('Manajemen Staff'),
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

  void _showComingSoon(String title) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(title),
            content: const Text('Fitur ini akan segera tersedia.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }
}
