import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:quickalert/quickalert.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController currentPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool isLoading = false;

  Future<void> _changePassword() async {
    if (!_formKey.currentState!.validate()) return;

    final currentPassword = currentPasswordController.text;
    final newPassword = newPasswordController.text;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');

    if (userId == null) {
      _showAlert(success: false, message: 'User ID tidak ditemukan.');
      return;
    }

    setState(() => isLoading = true);

    final response = await http.post(
      Uri.parse('https://seputar-it.eu.org/POS/User/change_password.php'),
      body: {
        'id': userId.toString(),
        'current_password': currentPassword,
        'new_password': newPassword,
      },
    );

    setState(() => isLoading = false);

    if (response.statusCode == 200) {
      _showAlert(success: true, message: 'Kata sandi berhasil diubah.');
    } else {
      _showAlert(success: false, message: 'Gagal mengubah kata sandi.');
    }
  }

  void _showAlert({required bool success, required String message}) {
    QuickAlert.show(
      context: context,
      type: success ? QuickAlertType.success : QuickAlertType.error,
      title: success ? 'Berhasil' : 'Gagal',
      text: message,
      confirmBtnText: 'OK',
      onConfirmBtnTap: () {
        Navigator.of(context).pop(); // tutup alert
        if (success) Navigator.of(context).pop(); // balik ke page sebelumnya jika sukses
      },
    );
  }

  @override
  void dispose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final borderStyle = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.grey),
    );

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: const Text('Ubah Kata Sandi',style: TextStyle(color: Colors.white),),
        backgroundColor: const Color(0xFFE76F51),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: currentPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Kata Sandi Saat Ini',
                  border: borderStyle,
                  focusedBorder: borderStyle.copyWith(
                    borderSide: const BorderSide(color: Color(0xFFE76F51)),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Harap masukkan kata sandi saat ini';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: newPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Kata Sandi Baru',
                  border: borderStyle,
                  focusedBorder: borderStyle.copyWith(
                    borderSide: const BorderSide(color: Color(0xFF2A9D8F)),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.length < 6) {
                    return 'Kata sandi baru minimal 6 karakter';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Konfirmasi Kata Sandi Baru',
                  border: borderStyle,
                  focusedBorder: borderStyle.copyWith(
                    borderSide: const BorderSide(color: Color(0xFF2A9D8F)),
                  ),
                ),
                validator: (value) {
                  if (value != newPasswordController.text) {
                    return 'Konfirmasi kata sandi tidak cocok';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              isLoading
                  ? const CircularProgressIndicator()
                  : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _changePassword,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2A9D8F),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Simpan Perubahan',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
