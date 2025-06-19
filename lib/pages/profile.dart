import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quickalert/quickalert.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'Profile/ChangePassword.dart';
import '../Constans.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

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
      if (!mounted) return;
      setState(() => isLoading = false);
      _showMessage('User ID tidak ditemukan');
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('https://seputar-it.eu.org/POS/User/get_user.php?id=$userId'),
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
        final res = json.decode(response.body);
        setState(() {
          userData = res['user'];
          nameController.text = userData?['name'] ?? '';
          emailController.text = userData?['email'] ?? '';
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
        _showMessage('Gagal mengambil data user');
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => isLoading = false);
      _showMessage('Terjadi kesalahan saat memuat data');
    }
  }

  Future<void> updateUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');

    if (userId == null) return;

    try {
      final response = await http.post(
        Uri.parse('https://seputar-it.eu.org/POS/User/update_user.php'),
        body: {
          'id': userId.toString(),
          'name': nameController.text,
          'email': emailController.text,
        },
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
        _showMessage('Data berhasil diperbarui');
        fetchUserData(); // Refresh
      } else {
        _showMessage('Gagal memperbarui data');
      }
    } catch (e) {
      if (!mounted) return;
      _showMessage('Terjadi kesalahan saat memperbarui');
    }
  }

Future<void> logout() async {
  QuickAlert.show(
    context: context,
    type: QuickAlertType.confirm,
    title: 'Logout',
    text: 'Apakah kamu yakin ingin keluar?',
    confirmBtnText: 'Ya',
    cancelBtnText: 'Batal',
    confirmBtnColor: Colors.red,
    onConfirmBtnTap: () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      if (!mounted) return;
      Navigator.of(context).pop(); // Tutup dialog
      Navigator.pushReplacementNamed(context, '/login');
    },
  );
}


  void _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar('Profile', centerTitle: true),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Card Profil Pengguna
                    Card(
                      margin: const EdgeInsets.only(bottom: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundImage:
                                  userData?['profile_picture'] != null
                                      ? NetworkImage(
                                        userData!['profile_picture'],
                                      )
                                      : const AssetImage(
                                            'assets/images/default_avatar.png',
                                          )
                                          as ImageProvider,
                            ),

                            const SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  userData?['name'] ?? 'Nama Pengguna',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  userData?['email'] ?? 'email@example.com',
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                            const Spacer(),
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                // Aksi untuk mengedit profil
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Card Pengaturan
                    Card(
                      margin: const EdgeInsets.only(bottom: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
                      child: Column(
                        children: [
                          ListTile(
                            leading: const Icon(Icons.account_circle),
                            title: const Text('My Account'),
                            onTap: () {
                              // Aksi untuk My Account
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.face),
                            title: const Text('Face ID'),
                            onTap: () {
                              // Aksi untuk Face ID
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.notifications),
                            title: const Text('Notifications'),
                            onTap: () {
                              // Aksi untuk Notifications
                            },
                          ),
                          ListTile(
                            leading: Icon(Icons.lock),
                            title: Text('Privacy & Security'),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => const ChangePasswordPage(),
                                ),
                              );
                            },
                          ),
                          ListTile(
                            leading: Icon(Icons.logout),
                            title: Text('Logout'),
                            onTap: logout,
                          ),
                        ],
                      ),
                    ),
                    Text('More'),
                    SizedBox(height: 5,),
                    Card(
                      margin: const EdgeInsets.only(bottom: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
                      child: Column(
                        children: [
                          ListTile(
                            leading: const Icon(Icons.account_circle),
                            title: const Text('Help'),
                            onTap: () {
                              // Aksi untuk My Account
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.face),
                            title: const Text('About'),
                            onTap: () {
                              // Aksi untuk Face ID
                            },
                          ),

                        ],
                      ),
                    ),
                  ],
                ),
              ),
    );
  }
}
