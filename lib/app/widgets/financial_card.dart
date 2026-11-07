import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FinancialCard extends StatelessWidget {
  final String title;
  final double amount;
  final List<String> months;
  final List<double> values;
  final Color color;
  final IconData icon;

  const FinancialCard({
    super.key,
    required this.title,
    required this.amount,
    required this.months,
    required this.values,
    required this.color,
    required this.icon,
  });

  String rupiah(double value) {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(value);
  }

  @override
  Widget build(BuildContext context) {
    final maxY = _getChartMax(values);
    final interval = _getChartInterval(values);

    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            blurRadius: 20,
            color: Colors.black.withOpacity(.04),
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Text(
                      "Tahun Berjalan",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Text(
            rupiah(amount),
            style: const TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 20),

          SizedBox(
            height: 220,
            child: LineChart(
              LineChartData(
                minY: 0,
                maxY: maxY,

                borderData: FlBorderData(show: false),

                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: interval,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(color: Colors.grey.shade200, strokeWidth: 1);
                  },
                ),

                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(),
                  rightTitles: const AxisTitles(),

                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),

                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() >= months.length) {
                          return const SizedBox();
                        }

                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            months[value.toInt()].substring(0, 3),
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                lineBarsData: [
                  LineChartBarData(
                    isCurved: true,
                    color: color,
                    barWidth: 3,
                    isStrokeCapRound: true,

                    belowBarData: BarAreaData(
                      show: true,
                      color: color.withOpacity(.15),
                    ),

                    dotData: const FlDotData(show: true),

                    spots: List.generate(
                      values.length,
                      (index) => FlSpot(index.toDouble(), values[index]),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  double _getChartMax(List<double> values) {
    if (values.isEmpty) return 100;

    final max = values.reduce((a, b) => a > b ? a : b);

    if (max <= 0) return 100;

    return max * 1.2;
  }

  double _getChartInterval(List<double> values) {
    if (values.isEmpty) return 10;

    final max = values.reduce((a, b) => a > b ? a : b);

    if (max <= 0) return 10;

    return max / 4;
  }
}
