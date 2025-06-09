import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'Add_barang.dart';

class Barang {
  final String kode;
  final String nama;
  final int harga;
  final int stok;

  Barang({
    required this.kode,
    required this.nama,
    required this.harga,
    required this.stok,
  });
}

class Barang_page extends StatefulWidget {
  const Barang_page({super.key});

  @override
  State<Barang_page> createState() => _Barang_pageState();
}

class _Barang_pageState extends State<Barang_page> {
  List<Barang> allBarang = List.generate(50, (index) {
    return Barang(
      kode: 'B${index + 1}',
      nama: 'Barang ${index + 1}',
      harga: 100000 + (index * 10000),
      stok:
          (index + 1) % 10 == 0
              ? 100
              : (index + 1) % 5 == 0
              ? 50
              : (index + 1) % 3 == 0
              ? 30
              : 10,
    );
  });

  List<Barang> displayedBarang = [];
  String searchQuery = '';
  String sortBy = 'nama';

  final Set<Barang> _selectedBarang = {};
  bool _isSelecting = false;

  @override
  void initState() {
    super.initState();
    _searchBarang('');
  }

  void _searchBarang(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
      if (searchQuery.isEmpty) {
        displayedBarang = List.from(allBarang);
      } else {
        displayedBarang =
            allBarang.where((barang) {
              return barang.nama.toLowerCase().contains(searchQuery) ||
                  barang.kode.toLowerCase().contains(searchQuery);
            }).toList();
      }
    });
  }

  void _sortBarang(String field) {
    setState(() {
      sortBy = field;
      if (field == 'harga') {
        displayedBarang.sort((a, b) => a.harga.compareTo(b.harga));
      } else if (field == 'stok') {
        displayedBarang.sort((a, b) => a.stok.compareTo(b.stok));
      } else {
        displayedBarang.sort((a, b) => a.nama.compareTo(b.nama));
      }
    });
  }

  void _showSortFilterOptions(BuildContext context, Offset offset) async {
    final selected = await showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(
        offset.dx,
        offset.dy,
        offset.dx + 1,
        offset.dy + 1,
      ),
      items: [
        const PopupMenuItem(value: 'nama', child: Text('Sort by Nama')),
        const PopupMenuItem(value: 'harga', child: Text('Sort by Harga')),
        const PopupMenuItem(value: 'stok', child: Text('Sort by Stok')),
      ],
    );

    if (selected != null) {
      _sortBarang(selected);
    }
  }

  void _navigateToAddBarang() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddBarangPage()),
    );
  }

  void _startSelectMode(Barang barang) {
    setState(() {
      _isSelecting = true;
      _selectedBarang.add(barang);
    });
  }

  void _toggleSelect(Barang barang) {
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

  void _showStokNotifications(BuildContext context) {
    final habis = allBarang.where((b) => b.stok == 0).toList();
    final menipis = allBarang.where((b) => b.stok > 0 && b.stok < 10).toList();

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: 320,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'NOTIFIKASI',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 20),

                  // Tombol Stok Habis
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                          color: Color(0xFFE76F51),
                          width: 2,
                        ),
                        backgroundColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed:
                          habis.isEmpty
                              ? null
                              : () {
                                Navigator.pop(context);
                                _filterStokHabis();
                              },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color:
                                  habis.isEmpty ? Colors.grey : Colors.red,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Stok Habis: ${habis.length} Barang',
                              style: TextStyle(
                                fontSize: 16,
                                color:
                                    habis.isEmpty
                                        ? Colors.grey
                                        : Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Tombol Stok Menipis
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                          color: Color(0xFFE76F51),
                          width: 2,
                        ),
                        backgroundColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed:
                          menipis.isEmpty
                              ? null
                              : () {
                                Navigator.pop(context);
                                _filterStokMenipis();
                              },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color:
                                  menipis.isEmpty
                                      ? Colors.grey
                                      : Colors.orange.shade700,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Stok Menipis: ${menipis.length} Barang',
                              style: TextStyle(
                                fontSize: 16,
                                color:
                                    menipis.isEmpty
                                        ? Colors.grey
                                        : Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  const Divider(height: 1, color: Colors.grey),
                  Align(
                    alignment: Alignment.center,
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'OK',
                        style: TextStyle(fontSize: 15, color: Colors.black),
                      ),
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

  void _filterStokHabis() {
    setState(() {
      displayedBarang = allBarang.where((b) => b.stok == 0).toList();
      _isSelecting = false;
      _selectedBarang.clear();
    });
  }

  void _filterStokMenipis() {
    setState(() {
      displayedBarang =
          allBarang.where((b) => b.stok > 0 && b.stok < 10).toList();
      _isSelecting = false;
      _selectedBarang.clear();
    });
  }

  void _cancelSelectMode() {
    setState(() {
      _isSelecting = false;
      _selectedBarang.clear();
    });
  }

  void _hapusBarangYangDipilih() {
    setState(() {
      allBarang.removeWhere((barang) => _selectedBarang.contains(barang));
      displayedBarang.removeWhere((barang) => _selectedBarang.contains(barang));
      _selectedBarang.clear();
      _isSelecting = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Barang yang dipilih telah dihapus')),
    );
  }

 void _showOptionsAtPosition(BuildContext context, Offset offset) async {
    // ignore: unused_local_variable
    final selected = await showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(
        offset.dx,
        offset.dy,
        offset.dx + 1,
        offset.dy + 1,
      ),
    items: [
      const PopupMenuItem(
        value: 'import',
        child: Row(
          children: [
            Icon(Icons.file_upload, color: Colors.black54),
            SizedBox(width: 10),
            Text('Import'),
          ],
        ),
      ),
      const PopupMenuItem(
        value: 'export',
        child: Row(
          children: [
            Icon(Icons.file_download, color: Colors.black54),
            SizedBox(width: 10),
            Text('Export'),
          ],
        ),
      ),
      const PopupMenuItem(
        value: 'settings',
        child: Row(
          children: [
            Icon(Icons.settings, color: Colors.black54),
            SizedBox(width: 10),
            Text('Pengaturan'),
          ],
        ),
      ),
      const PopupMenuItem(
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
  ).then((value) {
    if (value == null) return;

    switch (value) {
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
  });
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text(
          _isSelecting ? '${_selectedBarang.length} dipilih' : 'Data Barang',
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
                  onPressed: () async {
                    final RenderBox button =
                        context.findRenderObject() as RenderBox;
                    final Offset offset = button.localToGlobal(Offset.zero);
                    _showOptionsAtPosition(
                      context,
                      Offset(offset.dx + 300, offset.dy + 65),
                    );
                  },
            ),
        ],
        backgroundColor: const Color(0xFFE76F51),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(
                    FontAwesomeIcons.arrowUpShortWide,
                    color: Color(0xFFE76F51),
                  ),
                  onPressed: () async {
                    final RenderBox button =
                        context.findRenderObject() as RenderBox;
                    final Offset offset = button.localToGlobal(Offset.zero);
                    _showSortFilterOptions(
                      context,
                      Offset(offset.dx + 35, offset.dy + 125),
                    );
                  },
                ),
                Expanded(
                  flex: 5,
                  child: TextField(
                    style: const TextStyle(fontSize: 10),
                    onChanged: _searchBarang,
                    decoration: InputDecoration(
                      isDense: true,
                      labelText: 'Cari Barang...',
                      labelStyle: const TextStyle(color: Color(0xFFE76F51)),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Color(0xFFE76F51),
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(
                          FontAwesomeIcons.barcode,
                          color: Color(0xFFE76F51),
                        ),
                        onPressed: () {
                          // Tambahkan aksi scan barcode di sini
                        },
                      ),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color(0xFFE76F51)),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color(0xFFE76F51)),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color(0xFFE76F51)),
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(
                    FontAwesomeIcons.bell,
                    color: Color(0xFFE76F51),
                  ),
                  onPressed: () => _showStokNotifications(context),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: displayedBarang.length,
              itemBuilder: (context, index) {
                final barang = displayedBarang[index];
                final isSelected = _selectedBarang.contains(barang);
                return GestureDetector(
                  onLongPress: () => _startSelectMode(barang),
                  onTap: () => _toggleSelect(barang),
                  child: Card(
                    color: isSelected ? Colors.orange.shade100 : null,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                barang.nama,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Container(
                                width: 45,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE76F51),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  barang.stok > 99 ? '99+' : '${barang.stok}',
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
                                barang.kode,
                                style: const TextStyle(color: Colors.grey),
                              ),
                              Text(
                                'Rp${barang.harga}',
                                style: const TextStyle(color: Colors.grey),
                              ),
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
      floatingActionButton:
          _isSelecting && _selectedBarang.isNotEmpty
              ? FloatingActionButton(
                onPressed: _hapusBarangYangDipilih,
                backgroundColor: Colors.red,
                shape: const CircleBorder(), // memastikan bentuk bulat
                child: const Icon(Icons.delete, color: Colors.white),
              )
              : FloatingActionButton(
                onPressed: _navigateToAddBarang,
                backgroundColor: const Color(0xFFE76F51),
                shape: const CircleBorder(), // memastikan bentuk bulat
                child: const Icon(Icons.add, color: Colors.white),
              ),
    );
  }
}
