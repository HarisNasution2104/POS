import 'package:flutter/material.dart';

class StockItem {
  final String kode;
  final String nama;
  final int harga;
  final int stok;

  StockItem({
    required this.kode,
    required this.nama,
    required this.harga,
    required this.stok,
  });
}

class StockPage extends StatefulWidget {
  const StockPage({super.key});

  @override
  State<StockPage> createState() => _StockPageState();
}

class _StockPageState extends State<StockPage> {
  final Color primaryColor = const Color(0xFFE76F51);

  List<StockItem> allStocks = List.generate(50, (index) {
    return StockItem(
      kode: 'S${index + 1}',
      nama: 'Stock ${index + 1}',
      harga: 50000 + (index * 5000),
      stok: (index + 1) % 10 == 0
          ? 100
          : (index + 1) % 5 == 0
              ? 50
              : (index + 1) % 3 == 0
                  ? 30
                  : 10,
    );
  });

  List<StockItem> displayedStocks = [];
  String searchQuery = '';
  String sortBy = 'nama';

  final Set<StockItem> _selectedStocks = {};
  bool _isSelecting = false;

  @override
  void initState() {
    super.initState();
    _searchStock('');
  }

  void _searchStock(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
      if (searchQuery.isEmpty) {
        displayedStocks = List.from(allStocks);
      } else {
        displayedStocks = allStocks.where((stock) {
          return stock.nama.toLowerCase().contains(searchQuery) ||
              stock.kode.toLowerCase().contains(searchQuery);
        }).toList();
      }
    });
  }

  void _sortStock(String field) {
    setState(() {
      sortBy = field;
      if (field == 'harga') {
        displayedStocks.sort((a, b) => a.harga.compareTo(b.harga));
      } else if (field == 'stok') {
        displayedStocks.sort((a, b) => a.stok.compareTo(b.stok));
      } else {
        displayedStocks.sort((a, b) => a.nama.compareTo(b.nama));
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
              title: const Text('Sort by Nama'),
              onTap: () {
                _sortStock('nama');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Sort by Harga'),
              onTap: () {
                _sortStock('harga');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Sort by Stok'),
              onTap: () {
                _sortStock('stok');
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _navigateToAddStock() {
    // Navigasi ke halaman tambah stok
    // Contoh placeholder
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddStockPage(),
      ),
    );
  }

  void _startSelectMode(StockItem stock) {
    setState(() {
      _isSelecting = true;
      _selectedStocks.add(stock);
    });
  }

  void _toggleSelect(StockItem stock) {
    if (_isSelecting) {
      setState(() {
        if (_selectedStocks.contains(stock)) {
          _selectedStocks.remove(stock);
        } else {
          _selectedStocks.add(stock);
        }
      });
    }
  }

  void _cancelSelectMode() {
    setState(() {
      _isSelecting = false;
      _selectedStocks.clear();
    });
  }

  void _hapusStockYangDipilih() {
    setState(() {
      allStocks.removeWhere((stock) => _selectedStocks.contains(stock));
      displayedStocks.removeWhere((stock) => _selectedStocks.contains(stock));
      _selectedStocks.clear();
      _isSelecting = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Stock yang dipilih telah dihapus')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text(
          _isSelecting
              ? '${_selectedStocks.length} dipilih'
              : 'Data Stok',
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
                  icon: Icon(
                    Icons.filter_list,
                    color: primaryColor,
                  ),
                  onPressed: _showSortFilterOptions,
                ),
                Expanded(
                  child: TextField(
                    onChanged: _searchStock,
                    decoration: InputDecoration(
                      labelText: 'Cari Stock...',
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
              itemCount: displayedStocks.length,
              itemBuilder: (context, index) {
                final stock = displayedStocks[index];
                final isSelected = _selectedStocks.contains(stock);
                return GestureDetector(
                  onLongPress: () => _startSelectMode(stock),
                  onTap: () => _toggleSelect(stock),
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
                                stock.nama,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Container(
                                width: 45,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: primaryColor,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  stock.stok > 99 ? '99+' : '${stock.stok}',
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
                              Text(stock.kode, style: const TextStyle(color: Colors.grey)),
                              Text('Rp${stock.harga}', style: const TextStyle(color: Colors.grey)),
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
      floatingActionButton: _isSelecting && _selectedStocks.isNotEmpty
          ? FloatingActionButton(
              onPressed: _hapusStockYangDipilih,
              backgroundColor: Colors.red,
              child: const Icon(Icons.delete, color: Colors.white),
            )
          : FloatingActionButton(
              onPressed: _navigateToAddStock,
              backgroundColor: primaryColor,
              child: const Icon(Icons.add, color: Colors.white),
            ),
    );
  }
}

class AddStockPage extends StatelessWidget {
  const AddStockPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Stock'),
        backgroundColor: const Color(0xFFE76F51),
      ),
      body: const Center(
        child: Text('Halaman tambah stock masih dalam pengembangan'),
      ),
    );
  }
}
