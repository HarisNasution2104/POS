import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'Toko/SettingsPage.dart';

class ShopTab extends StatefulWidget {
  const ShopTab({super.key});

  @override
  State<ShopTab> createState() => _ShopTabState();
}

class _ShopTabState extends State<ShopTab> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _logoUrlController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _hoursController = TextEditingController();

  bool _isLoading = true;
  bool _isDataExist = false;
  String? _databaseName;

  final String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://seputar-it.eu.org/POS/Shop',
  );

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _databaseName = prefs.getString('user_db_name');

    if (_databaseName == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Database belum ditemukan. Silakan login ulang.'),
        ),
      );
      setState(() => _isLoading = false);
      return;
    }

    await _loadShopData();
  }

  Future<void> _loadShopData() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/get_shop.php?user_db_name=$_databaseName'),
      );

      if (response.statusCode == 200) {
        final res = json.decode(response.body);
        final data = res['toko'];
        if (data != null && data['nama'] != null) {
          _nameController.text = data['nama'];
          _addressController.text = data['alamat'] ?? '';
          _logoUrlController.text = data['logo_url'] ?? '';
          _phoneController.text = data['telepon'] ?? '';
          _descriptionController.text = data['deskripsi'] ?? '';
          _emailController.text = data['email'] ?? ''; // Kosong karena tidak ada di response
          _hoursController.text = data['jam'] ?? ''; // Kosong juga
          _isDataExist = true;
        }
      }
    } catch (e) {
      print('Gagal ambil data toko: $e');
    }

    setState(() => _isLoading = false);
  }

Future<void> _saveShopData() async {
  if (_databaseName == null) return;

  final name = _nameController.text.trim();
  final address = _addressController.text.trim();
  final logoUrl = _logoUrlController.text.trim();
  final phone = _phoneController.text.trim();
  final email = _emailController.text.trim();
  final description = _descriptionController.text.trim();
  final hours = _hoursController.text.trim();

  if (name.isEmpty || address.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Nama dan alamat toko wajib diisi.')),
    );
    return;
  }

  final uri = Uri.parse(
    _isDataExist ? '$baseUrl/update_shop.php' : '$baseUrl/insert_shop.php',
  );

  final response = await http.post(
    uri,
    headers: {'Content-Type': 'application/json'},
    body: json.encode({
      'user_db_name': _databaseName,  // Sesuaikan dengan parameter yang benar di API
      'nama': name,                   // Sesuaikan dengan parameter yang benar di API
      'alamat': address,
      'logo_url': logoUrl,
      'telepon': phone,
      'email': email,
      'deskripsi': description,
      'jam': hours,
    }),
  );

  if (response.statusCode == 200) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profil toko berhasil disimpan.')),
    );
    setState(() => _isDataExist = true);
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Gagal menyimpan profil toko.')),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    print(_databaseName);
    return Scaffold(
      appBar: AppBar(
  title: const Text(
    'Profile Toko',
    style: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
  ),
  backgroundColor: const Color(0xFFE76F51),
  actions: [
    PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert, color: Colors.white),
      onSelected: (value) {
        if (value == 'settings') {
          // Navigasi ke halaman settings atau tampilkan dialog, dsb
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const Settingspage(), // Ganti dengan halaman kamu
            ),
          );
        }
      },
      itemBuilder: (BuildContext context) {
        return [
          const PopupMenuItem<String>(
            value: 'settings',
            child: Text('Settings'),
          ),
        ];
      },
    ),
  ],
),

      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // LOGO TOKO
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.grey[300],
                      backgroundImage:
                          _logoUrlController.text.isNotEmpty
                              ? NetworkImage(_logoUrlController.text)
                              : null,
                      child:
                          _logoUrlController.text.isEmpty
                              ? const Icon(
                                Icons.store,
                                size: 60,
                                color: Colors.white,
                              )
                              : null,
                    ),
                    const SizedBox(height: 30),

                    _buildTextField(_nameController, 'Nama Toko'),
                    const SizedBox(height: 20),

                    _buildTextField(_addressController, 'Alamat Toko'),
                    const SizedBox(height: 20),

                    _buildTextField(
                      _phoneController,
                      'Nomor Telepon',
                      keyboard: TextInputType.phone,
                    ),
                    const SizedBox(height: 20),

                    _buildTextField(
                      _emailController,
                      'Email Toko',
                      keyboard: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 20),

                    _buildTextField(
                      _descriptionController,
                      'Deskripsi',
                      maxLines: 3,
                    ),
                    const SizedBox(height: 20),

                    _buildTextField(_hoursController, 'Jam Operasional'),
                    const SizedBox(height: 20),

                    _buildTextField(_logoUrlController, 'Logo URL'),
                    const SizedBox(height: 30),

                    ElevatedButton.icon(
                      onPressed: _saveShopData,
                      icon: const Icon(Icons.save, color: Colors.white),
                      label: const Text(
                        'Simpan',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF264653),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    int maxLines = 1,
    TextInputType keyboard = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboard,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFF4A261), width: 2),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _logoUrlController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _descriptionController.dispose();
    _hoursController.dispose();
    super.dispose();
  }
}
