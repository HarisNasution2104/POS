import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Login.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'pages/dashboard.dart';
import 'pages/kategori.dart';
import 'pages/add.dart';
import 'pages/toko.dart';
import 'pages/profile.dart';
import 'pages/Report.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final items = const [
    Icon(Icons.home, size: 30),
    Icon(Icons.category, size: 30),
    Icon(Icons.add, size: 30),
    Icon(Icons.store, size: 30),
    Icon(Icons.person, size: 30),
  ];

  int index = 2;
  String? userEmail;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userEmail = prefs.getString('email');
    });

    if (userEmail == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        title: const Text('POS System'),
        backgroundColor: Colors.blue[300],
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.remove('email');
              await prefs.setBool('is_logged_in', false);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        items: items,
        index: index,
        onTap: (selectedIndex) {
          setState(() {
            index = selectedIndex;
          });
        },
        height: 70,
        backgroundColor: Colors.transparent,
        animationDuration: const Duration(milliseconds: 300),
      ),
      body: Container(
        color: Colors.blue,
        width: double.infinity,
        height: double.infinity,
        alignment: Alignment.center,
        child: getSelectedWidget(index: index),
      ),
    );
  }

  Widget getSelectedWidget({required int index}) {
    switch (index) {
      case 0:
        return const KategoriTab();
      case 1:
        return const ReportTab();
      case 2:
        return const DashboardTab();
      case 3:
        return const ShopTab();
      case 4:
        return const ProfileTab();
      default:
        return const DashboardTab();
    }
  }
}

