import 'package:flutter/material.dart';

class EditSupplierPage extends StatefulWidget {
  final String name;
  final String email;
  final String contact;
  final String address;

  const EditSupplierPage({
    super.key,
    required this.name,
    required this.email,
    required this.contact,
    required this.address,
  });

  @override
  State<EditSupplierPage> createState() => _EditSupplierPageState();
}

class _EditSupplierPageState extends State<EditSupplierPage> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController contactController;
  late TextEditingController addressController;

  static const Color primaryColor = Color(0xFFE76F51);

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.name);
    emailController = TextEditingController(text: widget.email);
    contactController = TextEditingController(text: widget.contact);
    addressController = TextEditingController(text: widget.address);
  }

  void _saveEdits() {
    final updatedSupplier = {
      'name': nameController.text.trim(),
      'email': emailController.text.trim(),
      'contact': contactController.text.trim(),
      'address': addressController.text.trim(),
    };

    Navigator.pop(context, updatedSupplier);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text(
          'Edit Supplier',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 8),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Nama Supplier'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: contactController,
              decoration: const InputDecoration(labelText: 'No. Telepon'),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: addressController,
              decoration: const InputDecoration(labelText: 'Alamat'),
              keyboardType: TextInputType.multiline,
              maxLines: 2,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
              onPressed: _saveEdits,
              child: const Text(
                'SIMPAN',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
