import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter_bluetooth_printer/flutter_bluetooth_printer_library.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'SalesPage.dart';

class ReceiptPage extends StatefulWidget {
  final int total;
  final int bayar;
  final List<Map<String, dynamic>> barangDitambahkan;
final String status;
  const ReceiptPage({
    super.key,
    required this.total,
    required this.bayar,
    required this.barangDitambahkan, required this.status,
  });

  @override
  State<ReceiptPage> createState() => _ReceiptPageState();
}

class _ReceiptPageState extends State<ReceiptPage> {
  String _shopName = '';
  String _shopAddress = '';
  String _shopPhone = '';
  bool _isLoading = true;
  String? _databaseName;
  ReceiptController? controller;
  
  final currencyFormat = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp',
    decimalDigits: 0,
  );

  final String baseUrl = const String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://seputar-it.eu.org/POS/Shop',
  );

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    final prefs = await SharedPreferences.getInstance();
    _databaseName = prefs.getString('user_db_name');

    if (_databaseName == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Database belum ditemukan. Silakan login ulang.'),
        ),
      );
      setState(() => _isLoading = false);
      return;
    }

    await _loadShopData();
  }

  Future<void> _loadShopData() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/get_shop.php?user_db_name=$_databaseName'),
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
        final res = json.decode(response.body);
        final data = res['toko'];
        if (data != null) {
          setState(() {
            _shopName = data['nama'] ?? '';
            _shopAddress = data['alamat'] ?? '';
            _shopPhone = data['telepon'] ?? '';
          });
        }
      }
    } catch (e) {
      debugPrint('Gagal ambil data toko: $e');
    }

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  Widget _buildRow(String label, String value, {Color? color}) {
    return Row(
      children: [
        Expanded(
          flex: 5,
          child: Text(label, style: const TextStyle(fontSize: 18)),
        ),
        Expanded(
          flex: 2,
          child: Text(value, style: TextStyle(fontSize: 18, color: color)),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final subtotal = widget.barangDitambahkan.fold<int>(0, (sum, item) {
      final int qty = item['quantity'] ?? 0;
      final int harga = item['price_temp'] ?? item['price_sell'] ?? 0;
      return sum + (qty * harga);
    });

    final totalDiskon = widget.barangDitambahkan.fold<int>(
      0,
      (sum, item) => sum + ((item['discount_price'] ?? 0) as num).toInt(),
    );

    final kembalian = widget.bayar - widget.total;

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xFFE76F51),
        title: const Text(
          'Struk Pembayaran',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Receipt(
                onInitialized: (ctrl) => controller = ctrl,
                builder:
                    (context) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            _shopName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Center(
                          child: Text(
                            _shopAddress,
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                        Center(
                          child: Text(
                            _shopPhone,
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                        const Divider(),
                        Text(
                          'Tanggal: ${DateFormat('dd-MM-yyyy HH:mm').format(DateTime.now())}',
                          style: const TextStyle(fontSize: 18),
                        ),
                                                Text(
                          'Status : ${widget.status}',
                          style: const TextStyle(fontSize: 18),
                        ),
                        const Divider(),

                        // Header tabel
                        Row(
                          children: const [
                            Expanded(
                              flex: 2,
                              child: Text(
                                'Qty',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: Text(
                                'Item',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: Text(
                                'Diskon',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: Text(
                                'Harga',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),

                        // Isi daftar barang
                        ...widget.barangDitambahkan.map((item) {
                          final name = item['name'] ?? '';
                          final qty = item['quantity'] ?? 0;
                          final harga =
                              item['price_temp'] ?? item['price_sell'] ?? 0;
                          final diskon = item['discount_price'] ?? 0;

                          return Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(
                                  '$qty',
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ),
                              Expanded(
                                flex: 4,
                                child: Text(
                                  name,
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ),
                              Expanded(
                                flex: 4,
                                child: Text(
                                  currencyFormat.format(diskon),
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ),
                              Expanded(
                                flex: 4,
                                child: Text(
                                  currencyFormat.format(harga),
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ),
                            ],
                          );
                        }).toList(),

                        const Divider(),
                        _buildRow(
                          'Subtotal : ',
                          currencyFormat.format(subtotal),
                        ),
                        _buildRow(
                          'Diskon : ',
                          currencyFormat.format(totalDiskon),
                          color: Colors.red,
                        ),
                        _buildRow(
                          'Kembalian : ',
                          currencyFormat.format(kembalian),
                        ),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              currencyFormat.format(widget.total),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
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
          onPressed: () async {
            final address = await FlutterBluetoothPrinter.selectDevice(context);
            if (!mounted) return;
            if (address != null) {
              await controller?.print(
                address: address.address,
                keepConnected: true,
                addFeeds: 4,
              );
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Berhasil mencetak!')),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Printer tidak dipilih')),
              );
              // ✅ Kembali ke halaman awal (SalesPage)
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const SalesPage()),
                (route) => false,
              );
            }
          },
          icon: const Icon(Icons.print, color: Colors.white),
          label: const Text(
            'Pilih & Cetak',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
