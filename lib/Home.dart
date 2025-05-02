import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Login.dart';  // Import halaman login
import 'pages/people.dart';
import 'pages/profile.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

    final items = const [
    Icon(Icons.people, size: 30,),
    Icon(Icons.person, size: 30,),
    Icon(Icons.add, size: 30,),
    Icon(Icons.search_outlined, size: 30,)
  ];

  int index = 1;
  String? userEmail;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  // Mengecek status login saat aplikasi dimulai
  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userEmail = prefs.getString('email');  // Mengambil email pengguna dari SharedPreferences
    });

    if (userEmail == null) {
      // Jika belum login, arahkan ke halaman login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }
  }

  @override
@override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        title: const Text('Curved Navigation Bar'),
        backgroundColor: Colors.blue[300],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        items: items,
        index: index,
        onTap: (selctedIndex){
          setState(() {
            index = selctedIndex;
          });
        },
        height: 70,
        backgroundColor: Colors.transparent,
        animationDuration: const Duration(milliseconds: 300),
        // animationCurve: ,
      ),
      body: Container(
        color: Colors.blue,
        width: double.infinity,
        height: double.infinity,
        alignment: Alignment.center,
        child: getSelectedWidget(index: index)
      ),
    );
  }

  Widget getSelectedWidget({required int index}){
    Widget widget;
    switch(index){
      case 0:
        widget = const People();
        break;
      case 1:
        widget = const Profile();
        break;
      default:
        widget = const People();
        break;
    }
    return widget;
  }
}