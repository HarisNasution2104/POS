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
  String sortBy = 'tanggal'; // tanggal, supplier, totalHarga

  final Set<Purchase> _selectedPurchases = {};
  bool _isSelecting = false;

  @override
  void initState() {
    super.initState();
    _searchPurchase('');
  }

  void _searchPurchase(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
      if (searchQuery.isEmpty) {
        displayedPurchases = List.from(allPurchases);
      } else {
        displayedPurchases = allPurchases.where((purchase) {
          return purchase.kode.toLowerCase().contains(searchQuery) ||
              purchase.supplier.toLowerCase().contains(searchQuery);
        }).toList();
      }
    });
  }

  void _sortPurchase(String field) {
    setState(() {
      sortBy = field;
      if (field == 'supplier') {
        displayedPurchases.sort((a, b) => a.supplier.compareTo(b.supplier));
      } else if (field == 'totalHarga') {
        displayedPurchases.sort((a, b) => a.totalHarga.compareTo(b.totalHarga));
      } else {
        // default tanggal descending (latest first)
        displayedPurchases.sort((a, b) => b.tanggal.compareTo(a.tanggal));
      }
    });
  }

  void _showSortFilterOptions() {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Sort by Tanggal (Terbaru)'),
              onTap: () {
                _sortPurchase('tanggal');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Sort by Supplier'),
              onTap: () {
                _sortPurchase('supplier');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Sort by Total Harga'),
              onTap: () {
                _sortPurchase('totalHarga');
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _startSelectMode(Purchase purchase) {
    setState(() {
      _isSelecting = true;
      _selectedPurchases.add(purchase);
    });
  }

  void _toggleSelect(Purchase purchase) {
    if (_isSelecting) {
      setState(() {
        if (_selectedPurchases.contains(purchase)) {
          _selectedPurchases.remove(purchase);
        } else {
          _selectedPurchases.add(purchase);
        }
      });
    }
  }

  void _cancelSelectMode() {
    setState(() {
      _isSelecting = false;
      _selectedPurchases.clear();
    });
  }

  void _hapusPurchaseYangDipilih() {
    setState(() {
      allPurchases.removeWhere((p) => _selectedPurchases.contains(p));
      displayedPurchases.removeWhere((p) => _selectedPurchases.contains(p));
      _selectedPurchases.clear();
      _isSelecting = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Data pembelian yang dipilih telah dihapus')),
    );
  }

  void _navigateToAddPurchase() {
    // Navigasi ke halaman tambah pembelian
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddPurchasePage()),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text(
          _isSelecting
              ? '${_selectedPurchases.length} dipilih'
              : 'Transaksi Pembelian',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          if (_isSelecting)
            IconButton(
              icon: const Icon(Icons.check, color: Colors.white),
              onPressed: _cancelSelectMode,
              tooltip: 'Selesai',
            )
          else
            IconButton(
              icon: const Icon(Icons.more_vert_outlined, color: Colors.white),
              onPressed: _showSortFilterOptions,
            ),
        ],
        backgroundColor: primaryColor,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.filter_list, color: primaryColor),
                  onPressed: _showSortFilterOptions,
                ),
                Expanded(
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
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: displayedPurchases.length,
              itemBuilder: (context, index) {
                final purchase = displayedPurchases[index];
                final isSelected = _selectedPurchases.contains(purchase);

                return GestureDetector(
                  onLongPress: () => _startSelectMode(purchase),
                  onTap: () => _toggleSelect(purchase),
                  child: Card(
                    color: isSelected ? Colors.orange.shade100 : null,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                purchase.supplier,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                _formatDate(purchase.tanggal),
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(purchase.kode, style: const TextStyle(color: Colors.grey)),
                              Text('Rp${purchase.totalHarga}', style: const TextStyle(color: Colors.grey)),
                            ],
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
      floatingActionButton: _isSelecting && _selectedPurchases.isNotEmpty
          ? FloatingActionButton(
              onPressed: _hapusPurchaseYangDipilih,
              backgroundColor: Colors.red,
              child: const Icon(Icons.delete, color: Colors.white),
            )
          : FloatingActionButton(
              onPressed: _navigateToAddPurchase,
              backgroundColor: primaryColor,
              child: const Icon(Icons.add, color: Colors.white),
            ),
    );
  }
}

