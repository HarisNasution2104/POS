import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'CheckoutPage.dart';
import 'package:intl/intl.dart';

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
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _generateDummyBarang(); // generate barang lokal
  }

  void _generateDummyBarang() {
    setState(() {
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
    });
  }

  List<Map<String, dynamic>> get filteredBarangList {
    return barangList
        .where((item) =>
            item['name']
                ?.toLowerCase()
                .contains(_searchQuery.toLowerCase()) ??
            false)
        .toList();
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
      final index =
          barangDitambahkan.indexWhere((b) => b['code'] == data['code']);
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

  @override
  Widget build(BuildContext context) {
    final currencyFormat =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange.shade900,
        title: const Text('Penjualan', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.search, color: Colors.orange.shade700),
                  onPressed: () {
                    setState(() {
                      _isSearching = !_isSearching;
                      if (!_isSearching) _searchQuery = '';
                    });
                  },
                ),
                const SizedBox(width: 10),
                if (_isSearching)
                  Expanded(
                    child: TextField(
                      onChanged: (value) =>
                          setState(() => _searchQuery = value),
                      decoration: InputDecoration(
                        hintText: 'Cari barang...',
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 12),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.orange.shade900),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.orange.shade900, width: 2.0),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: filteredBarangList.length,
                itemBuilder: (context, index) {
                  final data = filteredBarangList[index];
                  final stockQuantity = data['quantity'] ?? 0;
                  final price = double.parse(data['price_sell'].toString());

                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.grey.shade200,
                      child: Text(
                        data['name'].substring(0, 2).toUpperCase(),
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                    title: Text(data['name']),
                    subtitle: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(data['code'],
                            style: const TextStyle(color: Colors.grey)),
                        Text('$stockQuantity x ${currencyFormat.format(price)}',
                            style: const TextStyle(fontSize: 12)),
                      ],
                    ),
                    trailing: _getBarangCount(data['code']) > 0
                        ? Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.orange.shade900,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              _getBarangCount(data['code']).toString(),
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 12),
                            ),
                          )
                        : null,
                    onTap: () => _tambahBarangKePesanan(data),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Stack(
        children: [
          FloatingActionButton(
            backgroundColor: Colors.orange.shade900,
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
