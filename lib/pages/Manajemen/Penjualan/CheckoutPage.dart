import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'PaymentPage.dart';

class CheckoutPage extends StatefulWidget {
  final List<Map<String, dynamic>> barangDitambahkan;

  const CheckoutPage({super.key, required this.barangDitambahkan});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final Color mainColor = const Color(0xFFE76F51);
  final currencyFormat = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  int _hitungTotalHarga() {
    return widget.barangDitambahkan.fold(0, (total, item) {
      int qty = item['quantity'] ?? 0;
      int hargaPerPcs = item['price_temp'] ?? item['price_sell'] ?? 0;
      int subtotal = qty * hargaPerPcs;
      int diskon = item['discount_price'] ?? 0;

      return total + (subtotal - diskon);
    });
  }

  void _showEditDialog(Map<String, dynamic> item) {
    int qty = item['quantity'] ?? 1;
    final TextEditingController qtyController = TextEditingController(
      text: qty.toString(),
    );
    final TextEditingController priceController = TextEditingController(
      text: (item['price_temp'] ?? item['price_sell']).toString(),
    );
    final TextEditingController diskonController = TextEditingController(
      text: (item['discount_price'] ?? '').toString(),
    );

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
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),

                            const SizedBox(height: 4),
                            Text(
                              '${item['code'] ?? ''}',
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.grey,
                              ),
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
                              currencyFormat.format(item['price_sell'] ?? 0),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${item['quantity_stock'] ?? item['quantity'] ?? 0}',
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Qty row with buttons
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
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
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
                  // Harga sementara input
                  Center(
                    child: SizedBox(
                      width: 160,
                      height: 35,
                      child: TextField(
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        controller: priceController,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          hintText: 'Harga',
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 8,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: mainColor, width: 2),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Checkbox diskon
                  Row(
                    children: [
                      Checkbox(
                        value: useDiskon,
                        activeColor: mainColor,
                        onChanged: (value) {
                          setStateDialog(() {
                            useDiskon = value ?? false;
                            if (!useDiskon) {
                              diskonController.text = '';
                            }
                          });
                        },
                      ),
                      const Text("Gunakan Diskon"),
                    ],
                  ),
                  // Input harga diskon muncul jika checkbox aktif
                  if (useDiskon)
                    Center(
                      child: SizedBox(
                        width: 160,
                        height: 35,
                        child: TextField(
                          controller: diskonController,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          decoration: InputDecoration(
                            hintText: '0',
                            isDense: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: mainColor),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: mainColor,
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Batal',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: mainColor,
                      ),
                      onPressed: () {
                        setState(() {
                          item['quantity'] =
                              int.tryParse(qtyController.text) ?? 1;
                          item['price_temp'] =
                              int.tryParse(priceController.text) ??
                              item['price_sell'];
                          if (useDiskon) {
                            int? diskonVal = int.tryParse(
                              diskonController.text,
                            );
                            if (diskonVal != null) {
                              item['discount_price'] = diskonVal;
                            }
                          } else {
                            item.remove('discount_price');
                          }
                        });
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Simpan',
                        style: TextStyle(color: Colors.white),
                      ),
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

  @override
  Widget build(BuildContext context) {
    final totalHarga = _hitungTotalHarga();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        title: const Text(
          'Checkout',
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: ListView.builder(
        itemCount: widget.barangDitambahkan.length,
        itemBuilder: (context, index) {
          final item = widget.barangDitambahkan[index];
          final harga = item['price_temp'] ?? item['price_sell'];
          final qty = item['quantity'] ?? 0;
          final totalItem = qty * harga;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 3,
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                title: Text(
                  item['name'] ?? '',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                subtitle: Text(
                  '$qty x ${currencyFormat.format(harga)} = ${currencyFormat.format(totalItem)}',
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
                trailing: CircleAvatar(
                  radius: 16,
                  backgroundColor: mainColor.withOpacity(0.1),
                  child: Icon(Icons.chevron_right, color: mainColor),
                ),
                onTap: () => _showEditDialog(item),
              ),
            ),
          );
        },
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  currencyFormat.format(totalHarga),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: mainColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => PaymentPage(
                          total: _hitungTotalHarga(),
                          barangDitambahkan: widget.barangDitambahkan,
                        ),
                  ),
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
          ],
        ),
      ),
    );
  }
}
