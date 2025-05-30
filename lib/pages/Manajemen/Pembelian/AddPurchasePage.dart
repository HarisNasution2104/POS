import 'package:flutter/material.dart';

class Item {
  final String kode;
  final String nama;
  final int harga;

  Item({required this.kode, required this.nama, required this.harga});
}

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

class AddPurchasePage extends StatefulWidget {
  const AddPurchasePage({super.key});

  @override
  State<AddPurchasePage> createState() => _AddPurchasePageState();
}

class _AddPurchasePageState extends State<AddPurchasePage> {
  final _formKey = GlobalKey<FormState>();
  final Color primaryColor = const Color(0xFFE76F51);

  final TextEditingController _kodeController = TextEditingController();
  final TextEditingController _supplierController = TextEditingController();
  final TextEditingController _totalHargaController = TextEditingController();

  DateTime? _selectedDate;

  // Contoh data barang dummy
  final List<Item> availableItems = [
    Item(kode: 'B001', nama: 'Buku Tulis', harga: 15000),
    Item(kode: 'B002', nama: 'Pulpen', harga: 5000),
    Item(kode: 'B003', nama: 'Penghapus', harga: 3000),
    Item(kode: 'B004', nama: 'Pensil', harga: 7000),
  ];

  // Barang terpilih
  final Set<Item> selectedItems = {};

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
    );
    if (date != null) {
      setState(() {
        _selectedDate = date;
      });
    }
  }

  int get totalHargaFromItems {
    return selectedItems.fold(0, (sum, item) => sum + item.harga);
  }

  void _savePurchase() {
    if (_formKey.currentState!.validate()) {
      if (_selectedDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tanggal pembelian harus dipilih')),
        );
        return;
      }

      if (selectedItems.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pilih minimal satu barang')),
        );
        return;
      }

      final kode = _kodeController.text.trim();
      final supplier = _supplierController.text.trim();

      int totalHarga;
      if (_totalHargaController.text.trim().isEmpty) {
        totalHarga = totalHargaFromItems;
      } else {
        totalHarga = int.parse(_totalHargaController.text.trim());
      }

      final newPurchase = Purchase(
        kode: kode,
        supplier: supplier,
        tanggal: _selectedDate!,
        totalHarga: totalHarga,
      );

      Navigator.pop(context, newPurchase);
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Pilih tanggal';
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  void dispose() {
    _kodeController.dispose();
    _supplierController.dispose();
    _totalHargaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Pembelian'),
        backgroundColor: primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _kodeController,
                decoration: InputDecoration(
                  labelText: 'Kode Pembelian',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Kode wajib diisi' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _supplierController,
                decoration: InputDecoration(
                  labelText: 'Nama Supplier',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Supplier wajib diisi' : null,
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: _pickDate,
                child: AbsorbPointer(
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Tanggal Pembelian',
                      hintText: _formatDate(_selectedDate),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      suffixIcon: const Icon(Icons.calendar_today),
                    ),
                    validator: (_) =>
                        _selectedDate == null ? 'Tanggal wajib dipilih' : null,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              Text(
                'Pilih Barang',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),

              ...availableItems.map((item) {
                final isSelected = selectedItems.contains(item);
                return CheckboxListTile(
                  title: Text('${item.nama} (Rp${item.harga})'),
                  value: isSelected,
                  onChanged: (val) {
                    setState(() {
                      if (val == true) {
                        selectedItems.add(item);
                      } else {
                        selectedItems.remove(item);
                      }
                    });
                  },
                );
              }).toList(),

              const SizedBox(height: 16),

              TextFormField(
                controller: TextEditingController(text: 'Rp $totalHargaFromItems'),
                decoration: InputDecoration(
                  labelText: 'Total Harga Otomatis',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                enabled: false,
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _totalHargaController,
                decoration: InputDecoration(
                  labelText: 'Total Harga (Override)',
                  prefixText: 'Rp ',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    if (int.tryParse(value) == null) {
                      return 'Masukkan angka yang valid';
                    }
                  }
                  return null;
                },
              ),

              const SizedBox(height: 32),

              ElevatedButton(
                onPressed: _savePurchase,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Simpan',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
