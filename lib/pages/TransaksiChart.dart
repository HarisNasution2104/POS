import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class TransaksiChart extends StatefulWidget {
  const TransaksiChart({super.key});

  @override
  State<TransaksiChart> createState() => _TransaksiChartState();
}

class _TransaksiChartState extends State<TransaksiChart> {
  String _selectedFilter = 'Days';
  final List<String> filters = ['Days', 'Weekly', 'Monthly'];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
        SizedBox(
          height: 250,
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
                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
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
      ],
    );
  }

  List<BarChartGroupData> _generateBarGroups() {
    List<double> data;

    switch (_selectedFilter) {
      case 'Days':
        data = List.generate(24, (i) => (i % 6 + 1) * 2.0);
        break;
      case 'Weekly':
        data = [18, 22, 16, 25, 20, 17, 19];
        break;
      case 'Monthly':
        data = List.generate(31, (i) => (i % 10 + 1) * 1.5);
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
