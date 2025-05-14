import 'package:flutter/material.dart';
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
      kode: 'B${index + 1}', // Kode barang mulai dari B001 hingga B050
      nama: 'Barang ${index + 1}', // Nama barang seperti "Barang 1", "Barang 2", ...
      harga: 100000 + (index * 10000), // Harga mulai dari 100000, bertambah 10000 setiap barang
      stok: (index + 1) % 10 == 0 ? 100 : (index + 1) % 5 == 0 ? 50 : (index + 1) % 3 == 0 ? 30 : 10, // Stok bervariasi
    );
  });

  List<Barang> displayedBarang = [];
  String searchQuery = '';
  String sortBy = 'nama';

  @override
  void initState() {
    super.initState();
    // Tampilkan semua barang saat pertama kali
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
                _sortBarang('nama');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Sort by Harga'),
              onTap: () {
                _sortBarang('harga');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Sort by Stok'),
              onTap: () {
                _sortBarang('stok');
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _navigateToAddBarang() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddBarangPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white, // Ubah warna ikon back dan teks judul
        title: const Text(
          'Data Barang',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert_outlined, color: Colors.white),
            onPressed: _showSortFilterOptions,
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
                // Tombol filter di sebelah kiri
                IconButton(
                  icon: const Icon(
                    Icons.filter_list,
                    color: Color(0xFFE76F51), // Warna oranye sesuai tema
                  ),
                  onPressed: _showSortFilterOptions, // Menampilkan filter
                ),
                // Kolom pencarian
                Expanded(
                  child: TextField(
                    onChanged: _searchBarang,
                    decoration: InputDecoration(
                      labelText: 'Cari Barang...',
                      labelStyle: const TextStyle(
                        color: Color(0xFFE76F51),
                      ), // Ubah warna label ke oranye
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Color(0xFFE76F51),
                      ),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Color(0xFFE76F51),
                        ), // Garis oranye
                        borderRadius: BorderRadius.circular(30), // Rounded corner
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Color(0xFFE76F51),
                        ), // Garis oranye saat fokus
                        borderRadius: BorderRadius.circular(30),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Color(0xFFE76F51),
                        ), // Garis oranye saat enabled
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
              itemCount: displayedBarang.length,
              itemBuilder: (context, index) {
                final barang = displayedBarang[index];
                return Card(
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
                              width: 45, // Tetapkan lebar tetap
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: const Color(0xFFE76F51), // Warna oranye sesuai AppBar
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
                              '${barang.kode}',
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
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddBarang,
        child: const Icon(Icons.add, color: Colors.white),
        backgroundColor: const Color(0xFFE76F51), // Ubah warna background jika perlu
        shape: const CircleBorder(), // Pastikan bentuknya bulat
      ),
    );
  }
}

