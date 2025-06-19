import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'ReceiptPage.dart';
import 'SalesPage.dart';

class SuccessPage extends StatefulWidget {
  final String transaksiId;
  final int total;
  final int bayar;
  final List<Map<String, dynamic>> barangDitambahkan;
final String status;

SuccessPage({
  super.key,
  required this.transaksiId,
  required this.total,
  required this.bayar,
  required this.barangDitambahkan,
  required this.status,
});


  @override
  State<SuccessPage> createState() => _SuccessPageState();
}

class _SuccessPageState extends State<SuccessPage> {
  final Color mainColor = const Color(0xFFE76F51);

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    final int kembalian = widget.bayar - widget.total;
    final bool isLunas = widget.bayar >= widget.total;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: mainColor,
        title: const Text('Transaksi Berhasil'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle_outline, color: Colors.green, size: 100),
            const SizedBox(height: 24),

            Text(
              isLunas ? 'Pembayaran Berhasil!' : 'Transaksi Tersimpan!',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            Text('ID Transaksi: ${widget.transaksiId}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),

            Text(
              'Total: ${currencyFormat.format(widget.total)}\n'
              'Bayar: ${currencyFormat.format(widget.bayar)}\n'
              'Kembalian: ${currencyFormat.format(kembalian)}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 12),

            // 🔖 Status Pembayaran
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: isLunas ? Colors.green[100] : Colors.orange[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
  'Status: ${widget.status}',
  style: TextStyle(
    fontSize: 16,
    color: widget.status == 'Lunas' ? Colors.green : Colors.orange,
    fontWeight: FontWeight.bold,
  ),
),

            ),

            const SizedBox(height: 40),

            // Tombol Lihat Struk
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.receipt_long, color: Colors.white),
                label: const Text('Lihat Struk', style: TextStyle(fontSize: 16, color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: mainColor,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ReceiptPage(
                        total: widget.total,
                        bayar: widget.bayar,
                        status: widget.status,
                        barangDitambahkan: widget.barangDitambahkan,
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 10),

            // Tombol Lanjut Transaksi
            SizedBox(
              width: double.infinity,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: mainColor, width: 2),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: ElevatedButton.icon(
                  icon: Icon(
                    FontAwesomeIcons.cashRegister,
                    color: mainColor.withOpacity(0.7),
                    size: 18,
                  ),
                  label: Text(
                    'Lanjut Transaksi',
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
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => SalesPage()),
                      (route) => false,
                    );
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
