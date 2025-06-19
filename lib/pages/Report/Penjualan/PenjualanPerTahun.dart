import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class PenjualanPertahun extends StatefulWidget {
  const PenjualanPertahun({super.key});

  @override
  State<PenjualanPertahun> createState() => _PenjualanPertahunState();
}

class _PenjualanPertahunState extends State<PenjualanPertahun> {
  late List<Map<String, dynamic>> _allTransactions;
  List<Map<String, dynamic>> _filteredTransactions = [];
  List<_DataPerBulan> _chartData = [];
  int _selectedYear = DateTime.now().year;

  @override
  void initState() {
    super.initState();
    _generateDummyData();
    _filterByYear(_selectedYear);
  }

  void _generateDummyData() {
    final now = DateTime.now();
    _allTransactions = List.generate(300, (index) {
      final year = now.year - (index % 3); // 2025, 2024, 2023
      final month = (index % 12) + 1;
      final day = (index % 28) + 1;
      return {
        'tanggal': DateTime(year, month, day),
        'kode': 'TRX${index + 1}',
        'jumlahBarang': (index % 5) + 1,
        'total': (((index % 5) + 1) * 50000),
      };
    });
  }

  void _filterByYear(int year) {
    final filtered =
        _allTransactions.where((tx) {
          final dt = tx['tanggal'] as DateTime;
          return dt.year == year;
        }).toList();

    final monthlySummary = <int, int>{};
    for (int i = 1; i <= 12; i++) {
      monthlySummary[i] = 0;
    }

    for (var tx in filtered) {
      final dt = tx['tanggal'] as DateTime;
      final jumlah = (tx['jumlahBarang'] as num).toInt();
      monthlySummary.update(dt.month, (value) => value + jumlah);
    }

    setState(() {
      _selectedYear = year;
      _filteredTransactions = filtered;
      _chartData =
          monthlySummary.entries
              .map((e) => _DataPerBulan(e.key, e.value))
              .toList()
            ..sort((a, b) => a.month.compareTo(b.month));
    });
  }

  @override
  Widget build(BuildContext context) {
    final currencyFmt = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp');

    final tahunTersedia =
        _allTransactions
            .map((e) => (e['tanggal'] as DateTime).year)
            .toSet()
            .toList()
          ..sort((a, b) => b.compareTo(a));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Penjualan Pertahun'),
        backgroundColor: const Color(0xFFE76F51),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: DropdownButton<int>(
              value:
                  tahunTersedia.contains(_selectedYear) ? _selectedYear : null,
              isExpanded: true,
              icon: const Icon(Icons.arrow_drop_down),
              underline: Container(height: 2, color: const Color(0xFFE76F51)),
              items:
                  tahunTersedia.map((year) {
                    return DropdownMenuItem(
                      value: year,
                      child: Text('Tahun $year'),
                    );
                  }).toList(),
              onChanged: (value) {
                if (value != null) {
                  _filterByYear(value);
                }
              },
            ),
          ),
          const SizedBox(height: 10),
          _chartData.isEmpty
              ? const Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'Tidak ada data penjualan di tahun ini.',
                  style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                ),
              )
              : SizedBox(
                height: 300,
                child: SfCartesianChart(
                  tooltipBehavior: TooltipBehavior(enable: true),
                  primaryXAxis: CategoryAxis(),
                  primaryYAxis: NumericAxis(minimum: 0, interval: 5),
                  series: <CartesianSeries<_DataPerBulan, String>>[
                    LineSeries<_DataPerBulan, String>(
                      dataSource: _chartData,
                      xValueMapper:
                          (data, _) =>
                              DateFormat('MMM').format(DateTime(0, data.month)),
                      yValueMapper: (data, _) => data.count,
                      markerSettings: const MarkerSettings(isVisible: true),
                      color: const Color(0xFFE76F51),
                      name: 'Jumlah Barang',
                    ),
                    AreaSeries<_DataPerBulan, String>(
                      dataSource: _chartData,
                      xValueMapper:
                          (data, _) =>
                              DateFormat('MMM').format(DateTime(0, data.month)),
                      yValueMapper: (data, _) => data.count,
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFFE76F51).withOpacity(0.4),
                          Colors.transparent,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderColor: const Color(0xFFE76F51),
                      borderWidth: 2,
                      name: 'Jumlah Barang',
                      dataLabelSettings: const DataLabelSettings(
                        isVisible: true,
                      ),
                    ),
                  ],
                ),
              ),
          const SizedBox(height: 10),
          Expanded(
            child:
                _filteredTransactions.isEmpty
                    ? const Center(
                      child: Text('Tidak ada transaksi di tahun ini.'),
                    )
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
                              '${dt.month}',
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

class _DataPerBulan {
  final int month;
  final int count;
  _DataPerBulan(this.month, this.count);
}
