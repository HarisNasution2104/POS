import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class BarcodeScannerPage extends StatefulWidget {
  const BarcodeScannerPage({super.key});

  @override
  State<BarcodeScannerPage> createState() => _BarcodeScannerPageState();
}

class _BarcodeScannerPageState extends State<BarcodeScannerPage> {
  final MobileScannerController controller = MobileScannerController();

  bool _scanned = false;

  void _onDetect(BarcodeCapture capture) {
    if (_scanned) return; // stop double scan

    if (capture.barcodes.isNotEmpty) {
      final code = capture.barcodes.first.rawValue ?? '';
      if (code.isNotEmpty) {
        _scanned = true;
        controller.stop();
        Navigator.pop(context, code);
      }
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Barcode'),
        backgroundColor: Colors.orange.shade900,
      ),
      body: MobileScanner(
        controller: controller,
        onDetect: _onDetect,
      ),
    );
  }
}
