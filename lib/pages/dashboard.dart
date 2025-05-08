import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';  // Import intl untuk format mata uang

class DashboardTab extends StatefulWidget {
  const DashboardTab({super.key});

  @override
  State<DashboardTab> createState() => _DashboardTabState();
}

class _DashboardTabState extends State<DashboardTab> {
  String _selectedFilter = 'Days';
  List<String> filters = ['Days', 'Weekly', 'Monthly'];

  // Dummy Data untuk Histori Transaksi
  List<Map<String, String>> transactionHistory = [
    {'product': 'Produk A', 'amount': 'Rp 500.000', 'date': '2025-05-01'},
    {'product': 'Produk B', 'amount': 'Rp 350.000', 'date': '2025-05-02'},
    {'product': 'Produk C', 'amount': 'Rp 200.000', 'date': '2025-05-03'},
    {'product': 'Produk D', 'amount': 'Rp 600.000', 'date': '2025-05-04'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Dashboard',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFFE76F51),
      ),
      body: SingleChildScrollView(  // Membuat seluruh body bisa discroll
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            // Kartu saldo tetap menggunakan format Rp
            _DashboardCard(
              title: 'Saldo',
              value: '120',
              icon: FontAwesomeIcons.wallet,
              color: const Color(0xFFF4A261),
              isCurrency: true,  // Menambahkan flag isCurrency
            ),
            const SizedBox(height: 12),
            // Kartu penjualan tetap menggunakan format Rp
            const _DashboardCard(
              title: 'Penjualan',
              value: 'Rp 2.500.000',
              icon: FontAwesomeIcons.scroll,
              color: Color(0xFFF4A261),
              isCurrency: true,
            ),
            const SizedBox(height: 12),
            // Kartu transaksi, tanpa format Rp
            _DashboardCard(
              title: 'Transaksi',
              value: '8',
              icon: FontAwesomeIcons.history,
              color: const Color(0xFFF4A261),
              isCurrency: false,  // Menambahkan flag isCurrency
            ),
            const SizedBox(height: 12),
            // Kartu keuntungan menggunakan format Rp
            _DashboardCard(
              title: 'Keuntungan',
              value: '2',
              icon: FontAwesomeIcons.coins,
              color: const Color(0xFFF4A261),
              isCurrency: true,  // Menambahkan flag isCurrency
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Grafik Transaksi',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                DropdownButton<String>(
                  value: _selectedFilter,
                  items: filters.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedFilter = value!;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Menggunakan Flexible agar grafik tetap sesuai ukuran dan bisa discroll
            SizedBox(
              height: 250,  // Memberikan ukuran pasti untuk grafik agar tidak mengecil
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 30,
                  minY: 0,
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        return BarTooltipItem(
                          '${rod.toY.round()} transaksi',
                          const TextStyle(color: Colors.white),
                        );
                      },
                    ),
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 28,
                        getTitlesWidget: (value, _) => Text(
                          '${value.toInt()}',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, _) {
                          if (_selectedFilter == 'Days') {
                            return value.toInt() % 3 == 0
                                ? Text(
                                    '${value.toInt() + 1}:00',
                                    style: const TextStyle(fontSize: 10),
                                  )
                                : const SizedBox.shrink();
                          } else if (_selectedFilter == 'Monthly') {
                            return [
                                  0,
                                  4,
                                  9,
                                  14,
                                  19,
                                  24,
                                  29,
                                ].contains(value.toInt())
                                ? Text(
                                    'T${value.toInt() + 1}',
                                    style: const TextStyle(fontSize: 10),
                                  )
                                : const SizedBox.shrink();
                          } else {
                            return Text('D${value.toInt() + 1}');
                          }
                        },
                      ),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: Colors.grey.withOpacity(0.2),
                      strokeWidth: 1,
                    ),
                  ),
                  barGroups: _generateBarGroups(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Menampilkan Histori Transaksi
            const Text(
              'Histori Transaksi',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            // ListView untuk menampilkan histori transaksi menggunakan ListTile biasa
            ListView.builder(
              shrinkWrap: true,  // Agar ListView hanya memakan ruang yang diperlukan
              physics: const NeverScrollableScrollPhysics(), // Nonaktifkan scroll internal ListView
              itemCount: transactionHistory.length,
              itemBuilder: (context, index) {
                final transaction = transactionHistory[index];
                return ListTile(
                  title: Text(
                    transaction['product']!,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    'Tanggal: ${transaction['date']}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                  trailing: Text(
                    transaction['amount']!,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  List<BarChartGroupData> _generateBarGroups() {
    List<double> data;

    switch (_selectedFilter) {
      case 'Days':
        data = List.generate(24, (i) => (i % 6 + 1) * 2.0); // Ex: jam 1-24
        break;
      case 'Weekly':
        data = [18, 22, 16, 25, 20, 17, 19];
        break;
      case 'Monthly':
        data = List.generate(31, (i) => (i % 10 + 1) * 1.5); // 31 hari, dummy transaksi
        break;
      default:
        data = [];
    }

    return List.generate(
      data.length,
      (index) => BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: data[index],
            width: 12,
            borderRadius: BorderRadius.circular(6),
            gradient: const LinearGradient(
              colors: [Color(0xFFE76F51), Color(0xFFF4A261)],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
        ],
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final bool isCurrency; // Tambahkan parameter untuk menentukan apakah format mata uang

  const _DashboardCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.isCurrency,
  });

  @override
  Widget build(BuildContext context) {
    String formattedValue;

    // Menggunakan NumberFormat untuk memformat nilai jika isCurrency = true
    if (isCurrency) {
      final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
      formattedValue = currencyFormat.format(int.tryParse(value) ?? 0); // Format saldo sebagai mata uang
    } else {
      formattedValue = value; // Tidak memformat transaksi, tampilkan nilai langsung
    }

    return SizedBox(
      width: double.infinity,
      child: Card(
        color: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Row(
            children: [
              Icon(icon, size: 40, color: Colors.white),
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    formattedValue,  // Menampilkan nilai yang telah diformat
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    title,
                    style: const TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
