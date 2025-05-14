import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Login.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'pages/dashboard.dart';
import 'pages/service.dart';
import 'pages/toko.dart';
import 'pages/profile.dart';
import 'pages/Report.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final items = const [
    Icon(FontAwesomeIcons.layerGroup, size: 25, color: Colors.white,),
    Icon(FontAwesomeIcons.solidFileLines, size: 25, color: Colors.white,),
    Icon(FontAwesomeIcons.house, size: 25, color: Colors.white,),
    Icon(FontAwesomeIcons.store, size: 25, color: Colors.white,),
    Icon(FontAwesomeIcons.solidUser, size: 25, color: Colors.white,),
  ];

  int index = 0;
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
      bottomNavigationBar: CurvedNavigationBar(
        items: items,
        index: index,
        onTap: (selectedIndex) {
          setState(() {
            index = selectedIndex;
          });
        },
        height: 75,
        color: const Color(0xFFE76F51),
        backgroundColor: Colors.transparent,
        animationDuration: const Duration(milliseconds: 300),
      ),
      body: Container(
        color: Color(0xFFE9C46A),
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
        return const ServiceTab();
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
