import 'package:flutter/material.dart';

class KategoriPage extends StatefulWidget {
  const KategoriPage({super.key});

  @override
  State<KategoriPage> createState() => _KategoriPageState();
}

class _KategoriPageState extends State<KategoriPage> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _kategoriList = [];
  List<String> _filteredKategori = [];
  Set<String> _selectedKategori = {};
  bool _isSelecting = false;

  @override
  void initState() {
    super.initState();
    _filteredKategori = List.from(_kategoriList);
  }

  void _filterKategori(String query) {
    setState(() {
      _filteredKategori = _kategoriList
          .where((kategori) =>
              kategori.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _tambahKategori() {
    final newKategori = _searchController.text.trim();
    if (newKategori.isEmpty) return;

    if (_kategoriList.any(
        (item) => item.toLowerCase() == newKategori.toLowerCase())) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Kategori sudah ada')));
      return;
    }

    setState(() {
      _kategoriList.add(newKategori);
      _searchController.clear();
      _filteredKategori = List.from(_kategoriList);
    });

    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Kategori "$newKategori" ditambahkan')));
  }

  void _hapusKategori(String kategori) {
    setState(() {
      _kategoriList.remove(kategori);
      _filteredKategori.remove(kategori);
      _selectedKategori.remove(kategori);
    });
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Kategori "$kategori" dihapus')));
  }

  void _hapusKategoriYangDipilih() {
    setState(() {
      for (var kategori in _selectedKategori) {
        _kategoriList.remove(kategori);
        _filteredKategori.remove(kategori);
      }
      _selectedKategori.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kategori yang dipilih telah dihapus')));
  }

  void _toggleSelect(String kategori) {
    setState(() {
      if (_isSelecting) {
        if (_selectedKategori.contains(kategori)) {
          _selectedKategori.remove(kategori);
        } else {
          _selectedKategori.add(kategori);
        }
      }
    });
  }

  void _startSelectMode(String kategori) {
    setState(() {
      _isSelecting = true;
      _selectedKategori.add(kategori);
    });
  }

  void _cancelSelectMode() {
    setState(() {
      _isSelecting = false;
      _selectedKategori.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text(
            _isSelecting ? '${_selectedKategori.length} dipilih' : 'Kategori',style: TextStyle(color: Colors.white),),
        actions: [
          if (_isSelecting)
            IconButton(
              icon: const Icon(Icons.check, color: Colors.white),
              onPressed: _cancelSelectMode,
              tooltip: 'Selesai',
            ),
        ],
        backgroundColor: const Color(0xFFE76F51),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // TextField + Tambah
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: _filterKategori,
                    decoration: InputDecoration(
                      labelText: 'Cari / Tambah Kategori',
                      labelStyle: const TextStyle(color: Color(0xFFE76F51)),
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(
                          color: Color(0xFFE76F51),
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.add, color: Color(0xFFE76F51)),
                  onPressed: _tambahKategori,
                ),
              ],
            ),
            const SizedBox(height: 20),

            // List Kategori
            Expanded(
              child: _filteredKategori.isEmpty
                  ? const Center(child: Text('Belum ada kategori'))
                  : ListView.builder(
                      itemCount: _filteredKategori.length,
                      itemBuilder: (context, index) {
                        final kategori = _filteredKategori[index];
                        final isSelected =
                            _selectedKategori.contains(kategori);

                        return GestureDetector(
                          onLongPress: () => _startSelectMode(kategori),
                          onTap: () => _toggleSelect(kategori),
                          child: ListTile(
                            title: Text(kategori),
                            tileColor: isSelected
                                ? Colors.orange.shade100
                                : null,
                            trailing: !_isSelecting
                                ? IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red),
                                    onPressed: () =>
                                        _hapusKategori(kategori),
                                  )
                                : null,
                          ),
                        );
                      },
                    ),
            ),

            // Tombol Hapus Bulat (jika ada yang dipilih)
            if (_isSelecting && _selectedKategori.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: _hapusKategoriYangDipilih,
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(16),
                    backgroundColor: Colors.orange,
                  ),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
