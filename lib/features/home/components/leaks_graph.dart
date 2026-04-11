import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class LeaksGraph extends StatefulWidget {
  const LeaksGraph({super.key});

  @override
  State<LeaksGraph> createState() => _LeaksGraphState();
}

class _LeaksGraphState extends State<LeaksGraph> {
  final List<String> _months = List.generate(
    13,
    (index) => DateFormat.MMM().format(DateTime(0, (index + 11) % 12 + 1)),
  );

  final List<double> _xLimits = [0, 12];
  final List<double> _yLimits = [0, 50];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Number of Leaks Over Time',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(height: 20.h),
          SizedBox(
            height: 300.h,
            child: LineChart(
              LineChartData(
                minX: _xLimits[0],
                maxX: _xLimits[1],
                minY: _yLimits[0],
                maxY: _yLimits[1],
                lineTouchData: const LineTouchData(enabled: false),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(
                    color: Theme.of(context).colorScheme.surface,
                    width: 0.8.w,
                    style: BorderStyle.solid,
                  ),
                ),
                gridData: FlGridData(
                  drawVerticalLine: true,
                  horizontalInterval: 10,
                  verticalInterval: 1,
                  getDrawingHorizontalLine: (double value) {
                    return FlLine(
                      color: Theme.of(context).colorScheme.surface,
                      strokeWidth: 0.8.w,
                      dashArray: [2.w.toInt(), 2.w.toInt()],
                    );
                  },
                  getDrawingVerticalLine: (double value) {
                    return FlLine(
                      color: Theme.of(context).colorScheme.surface,
                      strokeWidth: 0.8.w,
                      dashArray: [2.h.toInt(), 2.h.toInt()],
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 24.w,
                      interval: 10,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        return Text(
                          value.toInt().toString(),
                          style: Theme.of(context).textTheme.labelMedium!
                              .copyWith(fontWeight: FontWeight.w400),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      maxIncluded: _months.length.isOdd || _months.length < 7,
                      reservedSize: 28.h,
                      interval: _months.length > 7 ? 2 : 1,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        final int monthIndex = value.toInt();
                        if (monthIndex < 0 || monthIndex >= _months.length) {
                          return const SizedBox.shrink();
                        }
                        return Padding(
                          padding: EdgeInsets.only(top: 8.h),
                          child: Text(
                            _months[monthIndex],
                            style: Theme.of(context).textTheme.labelMedium!
                                .copyWith(fontWeight: FontWeight.w400),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                lineBarsData: <LineChartBarData>[
                  LineChartBarData(
                    spots: const <FlSpot>[
                      FlSpot(1, 28),
                      FlSpot(3, 32),
                      FlSpot(5, 38),
                      FlSpot(7, 39),
                      FlSpot(9, 35),
                      FlSpot(11, 18),
                    ],
                    isCurved: true,
                    curveSmoothness: 0.4,
                    barWidth: 3.h,
                    color: Theme.of(context).colorScheme.primary,
                    isStrokeCapRound: true,
                    belowBarData: BarAreaData(show: false),
                    dotData: FlDotData(
                      show: true,
                      getDotPainter:
                          (
                            FlSpot spot,
                            double percent,
                            LineChartBarData barData,
                            int index,
                          ) {
                            return FlDotCirclePainter(
                              radius: 5.r,
                              color: Theme.of(context).colorScheme.primary,
                              strokeWidth: 5.w,
                              strokeColor: Theme.of(
                                context,
                              ).colorScheme.primary.withValues(alpha: 0.25),
                            );
                          },
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
}
