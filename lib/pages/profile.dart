import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({Key? key}) : super(key: key);

  @override
  _ProfileTabState createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  Map<String, dynamic>? userData;
  bool isLoading = true;

  late TextEditingController nameController;
  late TextEditingController emailController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    emailController = TextEditingController();
    fetchUserData();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  Future<void> fetchUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');

    if (userId == null) {
      setState(() {
        isLoading = false;
      });
      _showMessage('User ID tidak ditemukan');
      return;
    }

    final response = await http.get(
      Uri.parse('https://seputar-it.eu.org/POS/User/get_user.php?id=$userId'),
    );

    if (response.statusCode == 200) {
      final res = json.decode(response.body);
      setState(() {
        userData = res['user'];
        nameController.text = userData?['name'] ?? '';
        emailController.text = userData?['email'] ?? '';
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      _showMessage('Gagal mengambil data user');
    }
  }

  Future<void> updateUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');

    if (userId == null) return;

    final response = await http.post(
      Uri.parse('https://seputar-it.eu.org/POS/User/update_user.php'),
      body: {
        'id': userId.toString(),
        'name': nameController.text,
        'email': emailController.text,
      },
    );

    if (response.statusCode == 200) {
      _showMessage('Data berhasil diperbarui');
      fetchUserData(); // Refresh
    } else {
      _showMessage('Gagal memperbarui data');
    }
  }

  void _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  void _goToChangePasswordPage() {
    Navigator.pushNamed(context, '/change-password');
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFFE76F51),
        actions: [
          IconButton(
            icon: const Icon(FontAwesomeIcons.signOut, color: Colors.white),
            tooltip: 'Logout',
            onPressed: logout,
          ),
        ],
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.grey,
                      child: Icon(Icons.person, size: 80, color: Colors.white),
                    ),
                    const SizedBox(height: 30),
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: 'Nama',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFF4A261),
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFF4A261),
                            width: 2,
                          ),
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton.icon(
                      onPressed: updateUserData,
                      icon: const Icon(Icons.save, color: Colors.white),
                      label: const Text(
                        'Simpan Perubahan',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2A9D8F),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: _goToChangePasswordPage,
                      icon: const Icon(Icons.lock, color: Colors.white),
                      label: const Text(
                        'Ubah Kata Sandi',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF4A261),
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
}
