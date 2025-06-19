import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pos4/Constans.dart'; // Ganti sesuai path project-mu
import 'package:syncfusion_flutter_charts/charts.dart';

class PenjualanPerBulan extends StatefulWidget {
  const PenjualanPerBulan({super.key});

  @override
  State<PenjualanPerBulan> createState() => _PenjualanPerBulanState();
}

class _PenjualanPerBulanState extends State<PenjualanPerBulan> {
  late List<Map<String, dynamic>> _allTransactions;
  List<Map<String, dynamic>> _filteredTransactions = [];
  List<_DataPerHari> _chartData = [];
  int _selectedMonth = DateTime.now().month;

  final List<String> _bulan = [
    'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
    'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
  ];

  @override
  void initState() {
    super.initState();
    _generateDummyData();
    _filterByMonth(_selectedMonth);
  }

  void _generateDummyData() {
    final currentYear = DateTime.now().year;
    _allTransactions = List.generate(100, (index) {
      final date = DateTime(currentYear, (index % 12) + 1, (index % 28) + 1);
      return {
        'tanggal': date,
        'kode': 'TRX${index + 1}',
        'jumlahBarang': (index % 5) + 1,
        'total': (((index % 5) + 1) * 50000),
      };
    });
  }

  void _filterByMonth(int month) {
    final currentYear = DateTime.now().year;

    final filtered = _allTransactions.where((tx) {
      final dt = tx['tanggal'] as DateTime;
      return dt.month == month && dt.year == currentYear;
    }).toList();

    final dailySummary = <DateTime, int>{};

    for (var tx in filtered) {
      final dt = DateTime(tx['tanggal'].year, tx['tanggal'].month, tx['tanggal'].day);
      final jumlah = (tx['jumlahBarang'] as num).toInt();
      dailySummary.update(dt, (value) => value + jumlah, ifAbsent: () => jumlah);
    }

    setState(() {
      _selectedMonth = month;
      _filteredTransactions = filtered;
      _chartData = dailySummary.entries
          .map((e) => _DataPerHari(e.key, e.value))
          .toList()
        ..sort((a, b) => a.date.compareTo(b.date));
    });
  }

  @override
  Widget build(BuildContext context) {
    final currencyFmt = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp');
    final int currentMonth = DateTime.now().month;

    if (_selectedMonth > currentMonth) {
      _selectedMonth = currentMonth;
    }

    return Scaffold(
      appBar: customAppBar('Penjualan Per Bulan'),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: DropdownButton<int>(
              value: _selectedMonth,
              isExpanded: true,
              icon: const Icon(Icons.arrow_drop_down),
              underline: Container(height: 2, color: const Color(0xFFE76F51)),
              items: List.generate(currentMonth, (index) {
                return DropdownMenuItem(
                  value: index + 1,
                  child: Text(_bulan[index]),
                );
              }),
              onChanged: (value) {
                if (value != null) {
                  _filterByMonth(value);
                }
              },
            ),
          ),
          const SizedBox(height: 10),
          _chartData.isEmpty
              ? const Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    'Tidak ada data penjualan di bulan ini.',
                    style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                  ),
                )
              : SizedBox(
                  height: 300,
                  child: SfCartesianChart(
                    tooltipBehavior: TooltipBehavior(enable: true),
                    primaryXAxis: DateTimeAxis(
                      intervalType: DateTimeIntervalType.days,
                      dateFormat: DateFormat('dd'),
                      edgeLabelPlacement: EdgeLabelPlacement.shift,
                    ),
                    primaryYAxis: NumericAxis(minimum: 0, interval: 2),
                    series: <CartesianSeries<_DataPerHari, DateTime>>[
                      LineSeries<_DataPerHari, DateTime>(
                        dataSource: _chartData,
                        xValueMapper: (data, _) => data.date,
                        yValueMapper: (data, _) => data.count,
                        markerSettings: const MarkerSettings(isVisible: true),
                        color: const Color(0xFFE76F51),
                        name: 'Jumlah Barang',
                      ),
                      AreaSeries<_DataPerHari, DateTime>(
                        dataSource: _chartData,
                        xValueMapper: (data, _) => data.date,
                        yValueMapper: (data, _) => data.count,
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFFE76F51).withOpacity(0.4),
                            Colors.transparent,
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ],
                  ),
                ),
          const SizedBox(height: 10),
          Expanded(
            child: _filteredTransactions.isEmpty
                ? const Center(child: Text('Tidak ada transaksi di bulan ini.'))
                : ListView.separated(
                    itemCount: _filteredTransactions.length,
                    separatorBuilder: (_, __) => const Divider(),
                    itemBuilder: (_, i) {
                      final tx = _filteredTransactions[i];
                      final dt = tx['tanggal'] as DateTime;
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: const Color(0xFFE76F51),
                          child: Text(
                            '${dt.day}',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        title: Text('Kode: ${tx['kode']}'),
                        subtitle: Text(
                          '${tx['jumlahBarang']} barang • ${DateFormat('dd MMM yyyy').format(dt)}',
                        ),
                        trailing: Text(
                          currencyFmt.format(tx['total']),
                          style: const TextStyle(
                            color: Color(0xFFE76F51),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _DataPerHari {
  final DateTime date;
  final int count;

  _DataPerHari(this.date, this.count);
}
