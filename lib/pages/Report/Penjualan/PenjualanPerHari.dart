import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

class PenjualanPerHari extends StatefulWidget {
  const PenjualanPerHari({Key? key}) : super(key: key);

  @override
  State<PenjualanPerHari> createState() => _PenjualanPerHariState();
}

class _PenjualanPerHariState extends State<PenjualanPerHari> {
  DateTime _selectedDate = DateTime.now();
  List<Map<String, dynamic>> _dataPenjualanDetail = [];

  // Dummy data transaksi per tanggal
  final Map<DateTime, List<Map<String, dynamic>>> _dummyDataPerTanggal = {
    DateTime(2025, 6, 17): [
      {
        'kode': 'TRX001',
        'tanggal': DateTime(2025, 6, 17, 8),
        'jumlahBarang': 4,
        'total': 50000,
      },
      {
        'kode': 'TRX002',
        'tanggal': DateTime(2025, 6, 17, 10),
        'jumlahBarang': 2,
        'total': 30000,
      },
      {
        'kode': 'TRX003',
        'tanggal': DateTime(2025, 6, 17, 11),
        'jumlahBarang': 6,
        'total': 75000,
      },
    ],
    DateTime(2025, 6, 16): [
      {
        'kode': 'TRX100',
        'tanggal': DateTime(2025, 6, 16, 7),
        'jumlahBarang': 3,
        'total': 45000,
      },
      {
        'kode': 'TRX101',
        'tanggal': DateTime(2025, 6, 16, 9),
        'jumlahBarang': 1,
        'total': 15000,
      },
    ],
  };

  @override
  void initState() {
    super.initState();
    _loadDataForDate(_selectedDate);
  }

  void _loadDataForDate(DateTime date) {
    final dateKey = DateTime(date.year, date.month, date.day);
    setState(() {
      _dataPenjualanDetail = _dummyDataPerTanggal[dateKey] ?? [];
    });
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != _selectedDate) {
      _selectedDate = picked;
      _loadDataForDate(_selectedDate);
    }
  }

  List<_DataPenjualan> get _listPenjualan {
    final List<_DataPenjualan> list = [ _DataPenjualan(0, 0) ];

    for (var item in _dataPenjualanDetail) {
      final jam = (item['tanggal'] as DateTime).hour;
      list.add(_DataPenjualan(jam, 1));
    }

    list.sort((a, b) => a.jam.compareTo(b.jam));
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Penjualan Hari Ini'),
        centerTitle: true,
        backgroundColor: const Color(0xFFE76F51),
      ),
      backgroundColor: Colors.white.withOpacity(0.5),
      body: Column(
        children: [
          // Bagian header dan grafik
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tanggal dan tombol pilih tanggal
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(_selectedDate),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: _pickDate,
                      child: const Icon(
                        FontAwesomeIcons.calendar,
                        size: 18,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Grafik area + line
                SizedBox(
                  height: 300,
                  child: SfCartesianChart(
                    tooltipBehavior: TooltipBehavior(enable: true),
                    zoomPanBehavior: ZoomPanBehavior(
                      enablePinching: true,
                      enablePanning: true,
                      zoomMode: ZoomMode.x,
                    ),
                    primaryXAxis: NumericAxis(
                      minimum: 0,
                      maximum: 23,
                      interval: 2,
                      axisLabelFormatter: (args) {
                        return ChartAxisLabel(
                          args.value.toInt().toString(),
                          const TextStyle(),
                        );
                      },
                    ),
                    primaryYAxis: NumericAxis(minimum: 0, interval: 1),
                    series: <CartesianSeries<_DataPenjualan, int>>[
                      LineSeries<_DataPenjualan, int>(
                        dataSource: _listPenjualan,
                        xValueMapper: (data, _) => data.jam,
                        yValueMapper: (data, _) => data.transaksi,
                        color: const Color(0xFFE76F51),
                        name: 'Transaksi per Jam',
                        markerSettings: const MarkerSettings(isVisible: true),
                      ),
                      AreaSeries<_DataPenjualan, int>(
                        dataSource: _listPenjualan,
                        xValueMapper: (data, _) => data.jam,
                        yValueMapper: (data, _) => data.transaksi,
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
              ],
            ),
          ),

          const SizedBox(height: 20),

          // List transaksi
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: Colors.white,
              width: double.infinity,
              child: _dataPenjualanDetail.isEmpty
                  ? const Center(child: Text('Tidak ada data transaksi'))
                  : ListView.separated(
                      itemCount: _dataPenjualanDetail.length,
                      separatorBuilder: (_, __) => const Divider(),
                      itemBuilder: (context, index) {
                        final item = _dataPenjualanDetail[index];
                        final dt = item['tanggal'] as DateTime;
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: const Color(0xFFE76F51),
                            child: Text(
                              dt.hour.toString(),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          title: Text('Kode: ${item['kode']}'),
                          subtitle: Text(
                            'Barang: ${item['jumlahBarang']} • ${DateFormat('HH:mm').format(dt)}',
                          ),
                          trailing: Text(
                            currencyFormat.format(item['total']),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFE76F51),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DataPenjualan {
  final int jam;
  final int transaksi;

  _DataPenjualan(this.jam, this.transaksi);
}
