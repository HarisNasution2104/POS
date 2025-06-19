import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'SuccessPage.dart'; // Impor halaman struk

class PaymentPage extends StatefulWidget {
  final int total;
  final List<Map<String, dynamic>> barangDitambahkan;
  const PaymentPage({
    super.key,
    required this.total,
    required this.barangDitambahkan,
  });

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final Color mainColor = const Color(0xFFE76F51);
  final currencyFormat = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  String input = '';

  int get bayar => int.tryParse(input) ?? 0;
  int get kembalian => bayar - widget.total;
  void _simpanSebagaiHutang() async {
    final String transaksiId = _generateTransactionId();
    const String status = 'Bayar Nanti';

    final transaksi = {
      'total': widget.total,
      'bayar': bayar,
      'is_paid': false,
      'barang': widget.barangDitambahkan,
      'tanggal': DateTime.now().toIso8601String(),
      'customer_name': 'Tanpa Nama',
    };

    print("Transaksi hutang: $transaksi");

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder:
            (_) => SuccessPage(
              transaksiId: transaksiId,
              total: widget.total,
              bayar: bayar,
              barangDitambahkan: widget.barangDitambahkan,
              status: status,
            ),
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Transaksi disimpan sebagai hutang')),
    );
  }

  void tambahInput(String value) {
    setState(() {
      input += value;
    });
  }

  void hapus() {
    setState(() {
      if (input.isNotEmpty) {
        input = input.substring(0, input.length - 1);
      }
    });
  }

  void reset() {
    setState(() {
      input = '';
    });
  }

  String _generateTransactionId() {
    final now = DateTime.now();
    return 'TX-${now.microsecondsSinceEpoch}'; // Format: TX-<timestamp>
  }

  void Sukses() {
    final String transaksiId = _generateTransactionId();
    const String status = 'Lunas';

    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => SuccessPage(
              transaksiId: transaksiId,
              total: widget.total,
              bayar: bayar,
              barangDitambahkan: widget.barangDitambahkan,
              status: status,
            ),
      ),
    );
  }

  Widget tombol(String label, {Color? color, VoidCallback? onTap}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color ?? Colors.grey.shade200,
            padding: const EdgeInsets.symmetric(vertical: 18),
          ),
          onPressed: onTap,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 24,
              color: color != null ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        title: const Text(
          'Pembayaran',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Total
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total Belanja:', style: TextStyle(fontSize: 18)),
                Text(
                  currencyFormat.format(widget.total),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Uang Bayar
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Uang Dibayarkan', style: TextStyle(fontSize: 14)),
                  Text(
                    currencyFormat.format(bayar),
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Kembalian
            if (bayar >= widget.total)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Kembalian:', style: TextStyle(fontSize: 18)),
                  Text(
                    currencyFormat.format(kembalian),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: mainColor,
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 24),

            // Kalkulator
            Expanded(
              child: Column(
                children: [
                  for (var row in [
                    ['1', '2', '3'],
                    ['4', '5', '6'],
                    ['7', '8', '9'],
                    ['C', '0', '<'],
                  ])
                    Row(
                      children:
                          row.map((e) {
                            if (e == 'C') {
                              return tombol(e, color: Colors.red, onTap: reset);
                            } else if (e == '<') {
                              return tombol(e, onTap: hapus);
                            } else {
                              return tombol(e, onTap: () => tambahInput(e));
                            }
                          }).toList(),
                    ),
                ],
              ),
            ),

            // Tombol Bayar
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.payment, color: Colors.white),
                label: const Text(
                  'Bayar Sekarang',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      bayar >= widget.total ? mainColor : Colors.grey,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: bayar >= widget.total ? Sukses : null,
              ),
            ),
            SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: mainColor, width: 2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ElevatedButton.icon(
                  icon: Icon(
                    FontAwesomeIcons.clock,
                    color: mainColor.withOpacity(0.7),
                  ),
                  label: Text(
                    'Bayar Nanti',
                    style: TextStyle(
                      fontSize: 16,
                      color: mainColor.withOpacity(0.7),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    _simpanSebagaiHutang();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
