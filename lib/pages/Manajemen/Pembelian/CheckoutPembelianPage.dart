import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'PurchasePage.dart';

class CheckoutPembelianPage extends StatefulWidget {
  final List<Map<String, dynamic>> barangDitambahkan;

  const CheckoutPembelianPage({super.key, required this.barangDitambahkan});

  @override
  State<CheckoutPembelianPage> createState() => _CheckoutPembelianPageState();
}

class _CheckoutPembelianPageState extends State<CheckoutPembelianPage> {
    final Color mainColor = const Color(0xFFE76F51);
  final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
  String? _selectedSupplier;

  final List<String> supplierList = [
    'Supplier A',
    'Supplier B',
    'Supplier C',
  ];

  int _hitungTotal() {
    return widget.barangDitambahkan.fold(0, (total, item) {
      int harga = item['price_buy'] ?? 0;
      int qty = item['quantity'] ?? 1;
      return total + (harga * qty);
    });
  }

  @override
  void initState() {
    super.initState();
    _selectedSupplier = supplierList.first;
  }

void _showEditDialog(Map<String, dynamic> item) {
  int qty = item['quantity'] ?? 1;
  final TextEditingController qtyController = TextEditingController(text: qty.toString());
  final TextEditingController beliController = TextEditingController(text: item['price_buy'].toString());
  final TextEditingController jualController = TextEditingController(text: item['price_sell'].toString());
  final TextEditingController diskonController = TextEditingController(text: (item['discount_price'] ?? '').toString());

  bool useDiskon = item['discount_price'] != null;

  void updateQtyField(int value) {
    qty = value.clamp(1, 9999);
    qtyController.text = qty.toString();
  }

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setStateDialog) {
          return AlertDialog(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['name'] ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${item['code'] ?? ''}',
                            style: const TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Stok: ${item['quantity_stock'] ?? item['quantity'] ?? 0}',
                            style: const TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Divider(),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Qty
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        iconSize: 32,
                        icon: const Icon(Icons.remove),
                        onPressed: () {
                          int current = int.tryParse(qtyController.text) ?? qty;
                          if (current > 1) {
                            setStateDialog(() {
                              updateQtyField(current - 1);
                            });
                          }
                        },
                      ),
                      Container(
                        width: 80,
                        height: 50,
                        alignment: Alignment.center,
                        child: TextField(
                          controller: qtyController,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          onChanged: (value) {
                            final parsed = int.tryParse(value);
                            if (parsed != null && parsed >= 1) {
                              qty = parsed;
                            }
                          },
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 8),
                          ),
                        ),
                      ),
                      IconButton(
                        iconSize: 32,
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          int current = int.tryParse(qtyController.text) ?? qty;
                          setStateDialog(() {
                            updateQtyField(current + 1);
                          });
                        },
                      ),
                    ],
                  ),
                  const Divider(),

                  // Harga Beli
                  _buildHargaInputField(
                    label: 'Harga Beli',
                    controller: beliController,
                    color: Colors.black,

                  ),

                  const SizedBox(height: 10),

                  // Harga Jual
                  _buildHargaInputField(
                    label: 'Harga Jual',
                    controller: jualController,
                    color: Colors.black,
                  ),
                ],
              ),
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Batal', style: TextStyle(color: Colors.black)),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor:  Color(0xFFE76F51)),
                    onPressed: () {
                      setState(() {
                        item['quantity'] = int.tryParse(qtyController.text) ?? 1;
                        item['price_buy'] = int.tryParse(beliController.text) ?? item['price_buy'];
                        item['price_sell'] = int.tryParse(jualController.text) ?? item['price_sell'];

                        if (useDiskon) {
                          item['discount_price'] = int.tryParse(diskonController.text) ?? 0;
                        } else {
                          item.remove('discount_price');
                        }
                      });
                      Navigator.pop(context);
                    },
                    child: const Text('Simpan', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ],
          );
        },
      );
    },
  );
}

Widget _buildHargaInputField({
  required String label,
  required TextEditingController controller,
  required Color color,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Text(label, style: TextStyle(fontWeight: FontWeight.bold, color: color)),
      const SizedBox(height: 4),
      SizedBox(
        width: 160,
        height: 35,
        child: TextField(
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          controller: controller,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            hintText: '0',
            isDense: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: color),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: color, width: 2),
            ),
          ),
        ),
      ),
    ],
  );
}


  @override
  Widget build(BuildContext context) {
    final totalHarga = _hitungTotal();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        title: const Text('Checkout Pembelian', style: TextStyle(color: Colors.white)),
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Navigator.pop(context)),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Text('Supplier:', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButton<String>(
                    value: _selectedSupplier,
                    isExpanded: true,
                    items: supplierList
                        .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                        .toList(),
                    onChanged: (val) => setState(() => _selectedSupplier = val),
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: widget.barangDitambahkan.length,
              itemBuilder: (context, index) {
                final item = widget.barangDitambahkan[index];
                final qty = item['quantity'] ?? 0;
                final hargaBeli = item['price_buy'] ?? 0;
                final hargaJual = item['price_sell'] ?? 0;

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      onTap: () => _showEditDialog(item),
                      contentPadding: const EdgeInsets.all(12),
                      leading: CircleAvatar(
                        radius: 20,
                        backgroundColor: mainColor,
                        child: Text('$qty', style: const TextStyle(color: Colors.white)),
                      ),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                                const SizedBox(height: 4),
                                Text(item['code'], style: const TextStyle(color: Colors.grey)),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(currencyFormat.format(hargaBeli), style: const TextStyle(color: Colors.green)),
                              const SizedBox(height: 4),
                              Text(currencyFormat.format(hargaJual), style: const TextStyle(color: Colors.blue)),
                            ],
                          ),
                          SizedBox(width: 8,),
                          Icon(Icons.chevron_right),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text(currencyFormat.format(totalHarga), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
          ),
Padding(
  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
  child: SizedBox(
    width: double.infinity,
    child: ElevatedButton.icon(
      onPressed: () {
        if (_selectedSupplier == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Pilih supplier terlebih dahulu')),
          );
          return;
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pembelian berhasil disimpan')),
        );
         Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => PembelianPage()),
                      (route) => false,
                    );
      },
      icon: const Icon(Icons.check_circle, color: Colors.white),
      label: const Text(
        'Selesaikan Transaksi',
        style: TextStyle(fontSize: 16, color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: mainColor,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
      ),
    ),
  ),
),

        ],
      ),
    );
  }
}
