import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'TransaksiChart.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final currencyFormatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );
  final List<Map<String, dynamic>> produkTerlaris = [
    {'nama': 'Monstera', 'terjual': 120},
    {'nama': 'Lidah Mertua', 'terjual': 95},
    {'nama': 'Kaktus Mini', 'terjual': 80},
    {'nama': 'Pilea', 'terjual': 60},
    {'nama': 'Peace Lily', 'terjual': 50},
  ];

  // Dummy data
  int totalTransaksi = 150;
  int totalPenjualan = 12000000;
  int totalKeuntungan = 5000000;
  int totalProduk = 25;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    final List<Map<String, dynamic>> dashboardCards = [
      {
        'title': 'Transaksi',
        'value': totalTransaksi.toString(),
        'icon': FontAwesomeIcons.receipt,
      },
      {
        'title': 'Penjualan',
        'value': currencyFormatter.format(totalPenjualan),
        'icon': FontAwesomeIcons.scroll,
      },
      {
        'title': 'Keuntungan',
        'value': currencyFormatter.format(totalKeuntungan),
        'icon': FontAwesomeIcons.coins,
      },
      {
        'title': 'Total Produk',
        'value': totalProduk.toString(),
        'icon': FontAwesomeIcons.boxArchive,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFE76F51),
        title: const Text('Dashboard',    style: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color: Colors.white,)),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            Container(
              padding: const EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    width: size.width * .9,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE76F51).withOpacity(.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.search,
                          color: Colors.black54.withOpacity(.8),
                        ),
                        const Expanded(
                          child: TextField(
                            showCursor: false,
                            decoration: InputDecoration(
                              hintText: 'Search Plant',
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                            ),
                          ),
                        ),
                        Icon(Icons.mic, color: Colors.black54.withOpacity(.6)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Horizontal Dashboard Cards
            SizedBox(
              height: size.height * .25,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: dashboardCards.length,
                itemBuilder: (context, index) {
                  final card = dashboardCards[index];
                  return Container(
                    width: 180,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 20,
                    ),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE76F51).withOpacity(0.8),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Icon (circle)
                        Container(
                          height: 50,
                          width: 50,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            card['icon'],
                            color: Color(0xFFE76F51),
                            size: 28,
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              card['title'],
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              card['value'],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // New Plants Title
            Container(
              padding: const EdgeInsets.only(left: 16, bottom: 20, top: 20),
              child: const Text(
                'Produk Terlaris',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
              ),
            ),

            // List Produk Terlaris
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              height: size.height * .5,
              child: ListView.builder(
                itemCount: produkTerlaris.length,
                scrollDirection: Axis.vertical,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  final produk = produkTerlaris[index];
                  return Container(
                    height: 100,
                    margin: const EdgeInsets.only(bottom: 15),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE76F51).withOpacity(.6),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: const Icon(
                            Icons.local_florist,
                            color: Color(0xFFE76F51),
                            size: 30,
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              produk['nama'],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${produk['terjual']} terjual',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            // Tambahkan grafik transaksi
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: TransaksiChart(),
            ),
          ],
        ),
      ),
    );
  }
}
