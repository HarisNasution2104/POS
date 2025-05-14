import 'package:flutter/material.dart';

class AddBarangPage extends StatefulWidget {
  const AddBarangPage({super.key});

  @override
  State<AddBarangPage> createState() => _AddBarangPageState();
}

class _AddBarangPageState extends State<AddBarangPage> {
  final TextEditingController _kodeController = TextEditingController(
    text: '00001',
  );
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _stokController = TextEditingController();
  final TextEditingController _kategoriController = TextEditingController();
  final TextEditingController _hargaBeliController = TextEditingController();
  final TextEditingController _hargaJualController = TextEditingController();
  final TextEditingController _stokMinController = TextEditingController();
  final TextEditingController _stokMaxController = TextEditingController();
  final TextEditingController _supplierController = TextEditingController();

  void _scanBarcode() {
    print("Scan barcode diklik");
  }

  void _addKategori() {
    print("Tambah kategori diklik");
  }

  void _addSupplier() {
    print("Tambah supplier diklik");
  }

  void _uploadGambar() {
    print("Upload gambar diklik");
  }

  void _simpanBarang() {
    // Contoh pengambilan data
    final kode = _kodeController.text;
    final nama = _namaController.text;
    final stok = _stokController.text;
    final kategori = _kategoriController.text;
    final hargaBeli = _hargaBeliController.text;
    final hargaJual = _hargaJualController.text;
    final stokMin = _stokMinController.text;
    final stokMax = _stokMaxController.text;
    final supplier = _supplierController.text;

    // TODO: Validasi & simpan ke database

    print('Data barang disimpan:');
    print('Kode: $kode');
    print('Nama: $nama');
    print('Stok: $stok');
    print('Kategori: $kategori');
    print('Harga Beli: $hargaBeli');
    print('Harga Jual: $hargaJual');
    print('Stok Min: $stokMin');
    print('Stok Max: $stokMax');
    print('Supplier: $supplier');

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Barang berhasil disimpan')));
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.orange, width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
        foregroundColor: Colors.white, // Ubah warna ikon back dan teks judul
        title: const Text(
          'Tambah Barang',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFFE76F51),
      ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Upload Gambar
              GestureDetector(
                onTap: _uploadGambar,
                child: Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Icon(Icons.camera_alt, size: 40, color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Kode Barang
              TextField(
                controller: _kodeController,
                maxLength: 5,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  counterText: '',
                  labelText: 'Kode Barang',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.qr_code_scanner),
                    onPressed: _scanBarcode,
                  ),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Nama Barang
              TextField(
                controller: _namaController,
                decoration: const InputDecoration(
                  labelText: 'Nama Barang',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Stok dan Kategori
              Row(
                children: [
                  SizedBox(
                    width: 100,
                    child: TextField(
                      controller: _stokController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Stok',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: _kategoriController,
                      decoration: InputDecoration(
                        labelText: 'Kategori',
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: _addKategori,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Harga Beli dan Harga Jual
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _hargaBeliController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Harga Beli',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: _hargaJualController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Harga Jual',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Supplier
              TextField(
                controller: _supplierController,
                decoration: InputDecoration(
                  labelText: 'Supplier',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: _addSupplier,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Stok Minimum dan Maksimum
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _stokMinController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Stok Min',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: _stokMaxController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Stok Max',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _simpanBarang,
                  label: const Text('Simpan',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE76F51),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
