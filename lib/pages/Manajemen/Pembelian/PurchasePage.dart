import 'package:flutter/material.dart';
import 'AddPurchasePage.dart';

class Purchase {
  final String kode;
  final String supplier;
  final DateTime tanggal;
  final int totalHarga;

  Purchase({
    required this.kode,
    required this.supplier,
    required this.tanggal,
    required this.totalHarga,
  });
}

class PurchasePage extends StatefulWidget {
  const PurchasePage({super.key});

  @override
  State<PurchasePage> createState() => _PurchasePageState();
}

class _PurchasePageState extends State<PurchasePage> {
  final Color primaryColor = const Color(0xFFE76F51);

  List<Purchase> allPurchases = List.generate(30, (index) {
    return Purchase(
      kode: 'P${1000 + index}',
      supplier: 'Supplier ${index + 1}',
      tanggal: DateTime.now().subtract(Duration(days: index * 2)),
      totalHarga: 500000 + (index * 100000),
    );
  });

  List<Purchase> displayedPurchases = [];
  String searchQuery = '';
  final Set<Purchase> selectedPurchases = {};
  bool isSelecting = false;

  @override
  void initState() {
    super.initState();
    _searchPurchase('');
  }

  void _searchPurchase(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
      if (query.isEmpty) {
        displayedPurchases = List.from(allPurchases);
      } else {
        displayedPurchases =
            allPurchases.where((p) {
              return p.kode.toLowerCase().contains(searchQuery) ||
                  p.supplier.toLowerCase().contains(searchQuery);
            }).toList();
      }
    });
  }

  void _startSelectMode(Purchase purchase) {
    setState(() {
      isSelecting = true;
      selectedPurchases.add(purchase);
    });
  }

  void _toggleSelect(Purchase purchase) {
    if (isSelecting) {
      setState(() {
        if (selectedPurchases.contains(purchase)) {
          selectedPurchases.remove(purchase);
        } else {
          selectedPurchases.add(purchase);
        }
      });
    }
  }

  void _cancelSelectMode() {
    setState(() {
      isSelecting = false;
      selectedPurchases.clear();
    });
  }

  void _hapusPurchaseYangDipilih() {
    setState(() {
      allPurchases.removeWhere((p) => selectedPurchases.contains(p));
      _searchPurchase(searchQuery);
      selectedPurchases.clear();
      isSelecting = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Data pembelian yang dipilih telah dihapus'),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isSelecting
              ? '${selectedPurchases.length} dipilih'
              : 'Daftar Pembelian',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        actions: [
          if (isSelecting)
            IconButton(
              icon: const Icon(Icons.check, color: Colors.white),
              onPressed: _cancelSelectMode,
              tooltip: 'Selesai',
            ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              onChanged: _searchPurchase,
              decoration: InputDecoration(
                labelText: 'Cari Pembelian...',
                labelStyle: TextStyle(color: primaryColor),
                prefixIcon: Icon(Icons.search, color: primaryColor),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: primaryColor),
                  borderRadius: BorderRadius.circular(30),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: primaryColor),
                  borderRadius: BorderRadius.circular(30),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: primaryColor),
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ),
          Expanded(
            child:
                displayedPurchases.isEmpty
                    ? const Center(child: Text('Belum ada pembelian'))
                    : ListView.builder(
                      itemCount: displayedPurchases.length,
                      itemBuilder: (context, index) {
                        final purchase = displayedPurchases[index];
                        final isSelected = selectedPurchases.contains(purchase);

                        return GestureDetector(
                          onLongPress: () => _startSelectMode(purchase),
                          onTap:
                              () =>
                                  isSelecting
                                      ? _toggleSelect(purchase)
                                      : null, // Optional: Navigate to detail page
                          child: Card(
                            color: isSelected ? Colors.orange.shade100 : null,
                            margin: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          purchase.supplier,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          purchase.kode,
                                          style: const TextStyle(
                                            color: Colors.grey,
                                          ),
                                        ),
                                        Text(
                                          _formatDate(purchase.tanggal),
                                          style: const TextStyle(
                                            color: Colors.grey,
                                          ),
                                        ),
                                        Text(
                                          'Rp${purchase.totalHarga}',
                                          style: const TextStyle(
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  CircleAvatar(
                                    backgroundColor: primaryColor,
                                    child: const Icon(
                                      Icons.receipt_long,
                                      color: Colors.white,
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
      floatingActionButton:
          isSelecting && selectedPurchases.isNotEmpty
              ? FloatingActionButton(
                onPressed: _hapusPurchaseYangDipilih,
                backgroundColor: Colors.red,
                child: const Icon(Icons.delete, color: Colors.white),
              )
              : FloatingActionButton(
                onPressed: () async {
                  final newPurchase = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddPurchasePage(),
                    ),
                  );
                  if (newPurchase != null && newPurchase is Purchase) {
                    setState(() {
                      allPurchases.add(newPurchase);
                      _searchPurchase(searchQuery);
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Pembelian ditambahkan!')),
                    );
                  }
                },
                backgroundColor: primaryColor,
                child: const Icon(Icons.add, color: Colors.white),
              ),
    );
  }
}
