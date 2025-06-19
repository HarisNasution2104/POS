import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:pos4/Constans.dart';
import 'Add_barang.dart';
import 'package:pos4/pages/Manajemen/BarcodeScannerPage.dart';

class BarangPage extends StatefulWidget {
  const BarangPage({super.key});

  @override
  State<BarangPage> createState() => _BarangPageState();
}

class _BarangPageState extends State<BarangPage> {
  final List<Map<String, dynamic>> barangList = [];
  List<Map<String, dynamic>> displayedBarang = [];

  final List<Map<String, dynamic>> _selectedBarang = [];

  String _searchQuery = '';
  String sortBy = 'nama';
  bool _isSelecting = false;

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

  void _generateDummyBarang() {
    barangList.clear();
    for (int i = 1; i <= 20; i++) {
      final data = {
        'id': '$i',
        'shop_id': '1',
        'name': 'Barang $i',
        'code': 'BRG$i',
        'quantity': i * 5,
        'price_buy': 10000,
        'price_sell': 15000 + (i * 1000),
        'price': 15000 + (i * 1000),
      };
      barangList.add(data);
    }
    displayedBarang = List<Map<String, dynamic>>.from(barangList);
  }

  List<Map<String, dynamic>> get filteredBarangList {
    List<Map<String, dynamic>> list = displayedBarang.where((item) {
      final name = item['name'].toString().toLowerCase();
      final code = item['code'].toString().toLowerCase();
      final query = _searchQuery.toLowerCase();
      return name.contains(query) || code.contains(query);
    }).toList();

    list.sort((a, b) {
      switch (sortBy) {
        case 'harga':
          return (a['price'] as int).compareTo(b['price'] as int);
        case 'stok':
          return (a['quantity'] as int).compareTo(b['quantity'] as int);
        case 'nama':
        default:
          return (a['name'] as String).compareTo(b['name'] as String);
      }
    });

    return list;
  }

  void _navigateToAddBarang() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddBarangPage()),
    );
  }

  void _startSelectMode(Map<String, dynamic> barang) {
    setState(() {
      _isSelecting = true;
      _selectedBarang.add(barang);
    });
  }

  void _toggleSelect(Map<String, dynamic> barang) {
    if (_isSelecting) {
      setState(() {
        if (_selectedBarang.contains(barang)) {
          _selectedBarang.remove(barang);
        } else {
          _selectedBarang.add(barang);
        }
      });
    }
  }

  void _cancelSelectMode() {
    setState(() {
      _isSelecting = false;
      _selectedBarang.clear();
    });
  }

  void _hapusBarangYangDipilih() {
    setState(() {
      barangList.removeWhere((barang) => _selectedBarang.contains(barang));
      displayedBarang.removeWhere((barang) => _selectedBarang.contains(barang));
      _selectedBarang.clear();
      _isSelecting = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Barang yang dipilih telah dihapus')),
    );
  }

  void _doImport() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Fungsi Import dijalankan')),
    );
  }

  void _doExport() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Fungsi Export dijalankan')),
    );
  }

  void _printStock() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Fungsi Cetak Stok dijalankan')),
    );
  }

  void _showOptionsAtPosition(BuildContext context, Offset offset) async {
    final selected = await showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(offset.dx, offset.dy, offset.dx + 1, offset.dy + 1),
      items: const [
        PopupMenuItem(
          value: 'import',
          child: Row(
            children: [
              Icon(Icons.file_upload, color: Colors.black54),
              SizedBox(width: 10),
              Text('Import'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'export',
          child: Row(
            children: [
              Icon(Icons.file_download, color: Colors.black54),
              SizedBox(width: 10),
              Text('Export'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'print',
          child: Row(
            children: [
              Icon(Icons.print, color: Colors.black54),
              SizedBox(width: 10),
              Text('Cetak Stok'),
            ],
          ),
        ),
      ],
    );

    switch (selected) {
      case 'import':
        _doImport();
        break;
      case 'export':
        _doExport();
        break;
      case 'print':
        _printStock();
        break;
    }
  }

  void _showSortFilterOptions(BuildContext context, Offset offset) async {
    final selected = await showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(offset.dx, offset.dy, offset.dx + 1, offset.dy + 1),
      items: const [
        PopupMenuItem(value: 'nama', child: Text('Sort by Nama')),
        PopupMenuItem(value: 'harga', child: Text('Sort by Harga')),
        PopupMenuItem(value: 'stok', child: Text('Sort by Stok')),
      ],
    );

    if (selected != null) {
      setState(() {
        sortBy = selected;
      });
    }
  }

  void _filterStokHabis() {
    setState(() {
      displayedBarang = barangList.where((b) => b['quantity'] == 0).toList();
      _isSelecting = false;
      _selectedBarang.clear();
    });
  }

  void _filterStokMenipis() {
    setState(() {
      displayedBarang = barangList.where((b) => b['quantity'] > 0 && b['quantity'] < 10).toList();
      _isSelecting = false;
      _selectedBarang.clear();
    });
  }

  void _showStokNotifications(BuildContext context) {
    final habis = barangList.where((b) => b['quantity'] == 0).toList();
    final menipis = barangList.where((b) => b['quantity'] > 0 && b['quantity'] < 10).toList();

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: 320,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('NOTIFIKASI', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 20),
                  _stokButton(
                    context,
                    title: 'Stok Habis: ${habis.length} Barang',
                    color: Colors.red,
                    enabled: habis.isNotEmpty,
                    onPressed: () {
                      Navigator.pop(context);
                      _filterStokHabis();
                    },
                  ),
                  const SizedBox(height: 16),
                  _stokButton(
                    context,
                    title: 'Stok Menipis: ${menipis.length} Barang',
                    color: Colors.orange.shade700,
                    enabled: menipis.isNotEmpty,
                    onPressed: () {
                      Navigator.pop(context);
                      _filterStokMenipis();
                    },
                  ),
                  const SizedBox(height: 24),
                  const Divider(height: 1, color: Colors.grey),
                  Align(
                    alignment: Alignment.center,
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('OK', style: TextStyle(fontSize: 15)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _stokButton(BuildContext context, {
    required String title,
    required Color color,
    required bool enabled,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: color, width: 2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        ),
        onPressed: enabled ? onPressed : null,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 16, height: 16, decoration: BoxDecoration(shape: BoxShape.circle, color: enabled ? color : Colors.grey)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(fontSize: 16, color: enabled ? Colors.black87 : Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    const mainColor = Color(0xFFE76F51);

    return Scaffold(
      appBar: customAppBar('Barang',      
        actions: [
          if (_isSelecting)
            IconButton(icon: const Icon(Icons.check, color: Colors.white), onPressed: _cancelSelectMode)
          else
            IconButton(
              icon: const Icon(Icons.more_vert_outlined, color: Colors.white),
              onPressed: () {
                RenderBox renderBox = context.findRenderObject() as RenderBox;
                Offset offset = renderBox.localToGlobal(Offset.zero);
                _showOptionsAtPosition(context, Offset(offset.dx + 300, offset.dy + 65));
              },
            ),
        ],
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(FontAwesomeIcons.arrowUpShortWide, color: mainColor),
                  onPressed: () {
                    RenderBox renderBox = context.findRenderObject() as RenderBox;
                    Offset offset = renderBox.localToGlobal(Offset.zero);
                    _showSortFilterOptions(context, Offset(offset.dx + 35, offset.dy + 125));
                  },
                ),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: 'Cari Barang...',
                      prefixIcon: const Icon(Icons.search, color: mainColor),
                      suffixIcon: IconButton(
                        icon: const FaIcon(FontAwesomeIcons.barcode, color: mainColor),
                        onPressed: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const BarcodeScannerPage()),
                          );
                          if (result != null) {
                            _searchController.text = result;
                          }
                        },
                      ),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: mainColor),
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(FontAwesomeIcons.bell, color: mainColor),
                  onPressed: () => _showStokNotifications(context),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredBarangList.length,
              itemBuilder: (context, index) {
                final barang = filteredBarangList[index];
                final isSelected = _selectedBarang.contains(barang);

                return GestureDetector(
                  onLongPress: () => _startSelectMode(barang),
                  onTap: () => _toggleSelect(barang),
                  child: Card(
                    color: isSelected ? Colors.orange.shade100 : null,
                    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            Text(barang['name'], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            Container(
                              width: 45,
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(color: mainColor, borderRadius: BorderRadius.circular(8)),
                              child: Text(
                                barang['quantity'] > 99 ? '99+' : '${barang['quantity']}',
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ]),
                          const SizedBox(height: 4),
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            Text(barang['code'], style: const TextStyle(color: Colors.grey)),
                            Text(currencyFormat.format(barang['price']), style: const TextStyle(color: Colors.grey)),
                          ]),
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
      floatingActionButton: _isSelecting && _selectedBarang.isNotEmpty
          ? FloatingActionButton(
              onPressed: _hapusBarangYangDipilih,
              backgroundColor: Colors.red,
              shape: const CircleBorder(),
              child: const Icon(Icons.delete, color: Colors.white),
            )
          : FloatingActionButton(
              onPressed: _navigateToAddBarang,
              backgroundColor: mainColor,
              shape: const CircleBorder(),
              child: const Icon(Icons.add, color: Colors.white),
            ),
    );
  }
}
