import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'CheckoutPage.dart';
import 'package:intl/intl.dart';
import 'BarcodeScannerPage.dart'; // Scanner fullscreen yang kita buat

class SalesPage extends StatefulWidget {
  const SalesPage({super.key});

  @override
  State<SalesPage> createState() => _SalesPageState();
}

class _SalesPageState extends State<SalesPage> {
  final List<Map<String, dynamic>> barangList = [];
  int totalBarangDitambahkan = 0;
  List<Map<String, dynamic>> barangDitambahkan = [];

  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _generateDummyBarang();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _generateDummyBarang() {
    barangList.clear();
    for (int i = 1; i <= 20; i++) {
      barangList.add({
        'id': '$i',
        'shop_id': '1',
        'name': 'Barang $i',
        'code': 'BRG$i',
        'quantity': i * 5,
        'price_buy': 10000,
        'price_sell': 15000 + (i * 1000),
        'price': 15000 + (i * 1000),
        'image_path': '',
      });
    }
  }

  List<Map<String, dynamic>> get filteredBarangList {
    if (_searchQuery.isEmpty) return barangList;
    return barangList.where((item) {
      final nameLower = (item['name'] ?? '').toString().toLowerCase();
      final codeLower = (item['code'] ?? '').toString().toLowerCase();
      final queryLower = _searchQuery.toLowerCase();
      return nameLower.contains(queryLower) || codeLower.contains(queryLower);
    }).toList();
  }

  int _getBarangCount(String code) {
    final item = barangDitambahkan.firstWhere(
      (b) => b['code'] == code,
      orElse: () => {'code': code, 'quantity': 0},
    );
    return item['quantity'] ?? 0;
  }

  void _tambahBarangKePesanan(Map<String, dynamic> data) {
    setState(() {
      final index = barangDitambahkan.indexWhere((b) => b['code'] == data['code']);
      if (index != -1) {
        barangDitambahkan[index]['quantity'] += 1;
      } else {
        barangDitambahkan.add({...data, 'quantity': 1});
      }
      totalBarangDitambahkan = barangDitambahkan.fold(
        0,
        (sum, item) => sum + (item['quantity'] as int),
      );
    });
  }

  Future<void> _openScanner() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const BarcodeScannerPage()),
    );

    if (result != null && result is String && result.isNotEmpty) {
      setState(() {
        _searchQuery = result;
        _searchController.text = result;  // update textfield biar keliatan hasil scan
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    final mainColor = const Color(0xFFE76F51); // warna utama

    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        title: const Text(
          'Penjualan',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
          tooltip: 'Kembali',
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  flex: 5,
                  child: TextField(
                    controller: _searchController,
                    style: const TextStyle(fontSize: 14),
                    decoration: InputDecoration(
                      isDense: true,
                      labelText: 'Cari Barang...',
                      labelStyle: TextStyle(color: mainColor),
                      prefixIcon: Icon(
                        Icons.search,
                        color: mainColor,
                      ),
                      suffixIcon: IconButton(
                        icon: FaIcon(
                          FontAwesomeIcons.barcode,
                          color: mainColor,
                        ),
                        onPressed: _openScanner,
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: mainColor),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: mainColor),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: mainColor),
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: Icon(
                    FontAwesomeIcons.bell,
                    color: mainColor,
                  ),
                  onPressed: () {
                    // Fungsi notifikasi stok bisa ditambah di sini
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredBarangList.length,
              itemBuilder: (context, index) {
                final data = filteredBarangList[index];
                final stockQuantity = data['quantity'] ?? 0;
                final price = double.parse(data['price_sell'].toString());

                final isSelected = _getBarangCount(data['code']) > 0;

                return GestureDetector(
                  onTap: () => _tambahBarangKePesanan(data),
                  child: Card(
                    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    color: isSelected ? Colors.orange.shade100 : null,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                data['name'],
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Container(
                                width: 45,
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: mainColor,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  stockQuantity > 99 ? '99+' : '$stockQuantity',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                data['code'],
                                style: const TextStyle(color: Colors.grey),
                              ),
                              Text(
                                '${stockQuantity} x ${currencyFormat.format(price)}',
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                          if (isSelected)
                            Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                margin: const EdgeInsets.only(top: 6),
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: mainColor,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  'Jumlah: ${_getBarangCount(data['code'])}',
                                  style: const TextStyle(color: Colors.white, fontSize: 12),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Stack(
        children: [
          FloatingActionButton(
            backgroundColor: mainColor,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Checkoutpage(
                    barangDitambahkan: List.from(barangDitambahkan),
                  ),
                ),
              );
            },
            child: const Icon(FontAwesomeIcons.bagShopping, color: Colors.white),
          ),
          if (totalBarangDitambahkan > 0)
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10),
                ),
                constraints: const BoxConstraints(minWidth: 20),
                child: Text(
                  totalBarangDitambahkan.toString(),
                  style: const TextStyle(
                      color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
