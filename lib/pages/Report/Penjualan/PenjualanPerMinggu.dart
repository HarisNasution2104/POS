import 'package:flutter/material.dart';
import 'package:pos4/Constans.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
  runApp(
    MaterialApp(
      home: PenjualanPerMinggu(),
      debugShowCheckedModeBanner: false,
      locale: const Locale('id', 'ID'),
    ),
  );
}

class PenjualanPerMinggu extends StatefulWidget {
  @override
  State<PenjualanPerMinggu> createState() => _PenjualanPerMingguState();
}

class _PenjualanPerMingguState extends State<PenjualanPerMinggu> {
  DateTime _startDate = DateTime.now().subtract(const Duration(days: 6));
  DateTime _endDate = DateTime.now();

  // Dummy data transaksi per hari
  final Map<DateTime, List<Map<String, dynamic>>> _dummyDataPerTanggal = {};
  List<Map<String, dynamic>> _filteredTransactions = [];
  List<_DataPerHari> _chartData = [];

  @override
  void initState() {
    super.initState();
    _generateDummyData();
    _filterAndGenerateChart();
  }

  void _generateDummyData() {
    final now = DateTime.now();
    for (int i = 0; i < 14; i++) {
      final day = DateTime(now.year, now.month, now.day).subtract(Duration(days: i));
      _dummyDataPerTanggal[day] = List.generate(3, (j) {
        return {
          'kode': 'TRX${day.day}${j + 1}',
          'tanggal': DateTime(day.year, day.month, day.day, 8 + j * 2),
          'jumlahBarang': 1 + j,
          'total': 20000 + j * 10000,
        };
      });
    }
  }

  void _filterAndGenerateChart() {
    final List<Map<String, dynamic>> tempTransactions = [];

    for (int i = 0; i <= _endDate.difference(_startDate).inDays; i++) {
      final currentDay = _startDate.add(Duration(days: i));
      final dateKey = DateTime(currentDay.year, currentDay.month, currentDay.day);

      if (_dummyDataPerTanggal.containsKey(dateKey)) {
        tempTransactions.addAll(_dummyDataPerTanggal[dateKey]!);
      }
    }

    setState(() {
      _filteredTransactions = tempTransactions;

      // Buat data chart berdasarkan jumlah transaksi per hari
      final Map<DateTime, int> dailyCount = {};
      for (var tx in _filteredTransactions) {
        final dt = tx['tanggal'] as DateTime;
        final dateKey = DateTime(dt.year, dt.month, dt.day);
        dailyCount[dateKey] = (dailyCount[dateKey] ?? 0) + 1;
      }

      final sortedKeys = dailyCount.keys.toList()..sort();
      _chartData = sortedKeys.map((d) => _DataPerHari(d, dailyCount[d]!)).toList();
    });
  }

  void _showRangePicker() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Pilih Rentang Tanggal'),
        content: SizedBox(
          width: 300,
          height: 350,
          child: SfDateRangePicker(
            view: DateRangePickerView.month,
            selectionMode: DateRangePickerSelectionMode.range,
            minDate: DateTime.now().subtract(const Duration(days: 13)),
            maxDate: DateTime.now(),
            initialSelectedRange: PickerDateRange(_startDate, _endDate),
            onSelectionChanged: (args) {
              if (args.value is PickerDateRange) {
                final range = args.value as PickerDateRange;
                final start = range.startDate!;
                final end = range.endDate ?? start;

                if (end.difference(start).inDays > 6) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Rentang maksimal 7 hari')),
                  );
                  return;
                }

                setState(() {
                  _startDate = DateTime(start.year, start.month, start.day);
                  _endDate = DateTime(end.year, end.month, end.day);
                });
              }
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              _filterAndGenerateChart();
              Navigator.pop(context);
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currencyFmt = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp');

    return Scaffold(
      appBar: customAppBar('Penjualan Mingguan'),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white70,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    DateFormat('EE, dd MMM yyyy', 'id_ID').format(_startDate),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: Text(
                    DateFormat('EE, dd MMM yyyy', 'id_ID').format(_endDate),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  onPressed: _showRangePicker,
                  icon: const Icon(Icons.calendar_today),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 300,
            child: SfCartesianChart(
              primaryXAxis: DateTimeAxis(
                intervalType: DateTimeIntervalType.days,
                dateFormat: DateFormat('dd MMM', 'id_ID'),
              ),
              primaryYAxis: NumericAxis(minimum: 0, interval: 1),
              tooltipBehavior: TooltipBehavior(enable: true),
              series: <CartesianSeries<_DataPerHari, DateTime>>[
                LineSeries<_DataPerHari, DateTime>(
                  dataSource: _chartData,
                  xValueMapper: (data, _) => data.date,
                  yValueMapper: (data, _) => data.count,
                  markerSettings: const MarkerSettings(isVisible: true),
                  color: const Color(0xFFE76F51),
                  name: 'Transaksi',
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
            child: ListView.separated(
              itemCount: _filteredTransactions.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (_, i) {
                final tx = _filteredTransactions[i];
                final dt = tx['tanggal'] as DateTime;
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: const Color(0xFFE76F51),
                    child: Text('${dt.day}', style: TextStyle(color: whiteColor)),
                  ),
                  title: Text('Kode: ${tx['kode']}'),
                  subtitle: Text(
                    '${tx['jumlahBarang']} barang • ${DateFormat('EEE, dd MMM yyyy HH:mm', 'id_ID').format(dt)}',
                  ),
                  trailing: Text(
                    currencyFmt.format(tx['total']),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFE76F51),
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
