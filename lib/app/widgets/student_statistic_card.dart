import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sakola/data/models/dashboard/GenderBreakdownChartModel.dart';

class StudentStatisticsCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final GenderBreakdownChartModel data;

  const StudentStatisticsCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final total = (data.lakiLaki + data.perempuan).toDouble();

    return Container(
      margin: const EdgeInsets.only(top: 18),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xffECECFA)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.03),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xff7C4DFF).withOpacity(.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.people_outline,
                    color: Color(0xff7C4DFF),
                  ),
                ),

                const SizedBox(height: 14),

                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                Text(subtitle, style: const TextStyle(color: Colors.grey)),

                const SizedBox(height: 28),

                Row(
                  children: [
                    Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        color: const Color(0xff7C4DFF),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),

                    const SizedBox(width: 10),

                    const Text(
                      "Laki-laki",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                Text(
                  data.lakiLaki.toString(),
                  style: const TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 18),

                Row(
                  children: [
                    Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        color: const Color(0xffFDBA45),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),

                    const SizedBox(width: 10),

                    const Text(
                      "Perempuan",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                Text(
                  data.perempuan.toString(),
                  style: const TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            flex: 4,
            child: SizedBox(
              height: 220,
              child: PieChart(
                PieChartData(
                  centerSpaceRadius: 55,
                  sectionsSpace: 3,
                  startDegreeOffset: -90,
                  sections: [
                    PieChartSectionData(
                      value: total == 0 ? 1 : data.lakiLaki.toDouble(),
                      color: const Color(0xff7C4DFF),
                      radius: 34,
                      showTitle: false,
                    ),
                    PieChartSectionData(
                      value: total == 0 ? 1 : data.perempuan.toDouble(),
                      color: const Color(0xffFDBA45),
                      radius: 34,
                      showTitle: false,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
