import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:n_leaks/core/data/models/leak_model.dart';

class LeaksGraph extends StatefulWidget {
  const LeaksGraph({super.key, required this.leaks});

  final List<LeakModel> leaks;

  @override
  State<LeaksGraph> createState() => _LeaksGraphState();
}

class _LeaksGraphState extends State<LeaksGraph> {
  @override
  Widget build(BuildContext context) {
    final Map<DateTime, int> aggregatedLeaks = aggregateLeaksByMonth(
      widget.leaks,
    );
    List<DateTime> months = aggregatedLeaks.keys.toList()
      ..sort((a, b) => a.compareTo(b));
    months = buildContinuousMonths(months);
    final List<String> monthLabels = months
        .map((month) => DateFormat('MMM yy').format(month))
        .toList();
    final List<FlSpot> spots = List<FlSpot>.generate(
      months.length,
      (index) => FlSpot(
        index.toDouble(),
        (aggregatedLeaks[months[index]] ?? 0).toDouble(),
      ),
    );
    final int maxLeaks = aggregatedLeaks.values.isEmpty
        ? 0
        : aggregatedLeaks.values.reduce((a, b) => a > b ? a : b);
    final double xInterval = monthLabels.length <= 6
        ? 1
        : (monthLabels.length / 6).ceilToDouble();
    final double yInterval = maxLeaks <= 5
        ? 1
        : (maxLeaks / 5).ceil().toDouble();
    final double maxX = monthLabels.isEmpty
        ? 1
        : (monthLabels.length - 1).toDouble();
    final double maxY = maxLeaks == 0
        ? 5
        : ((maxLeaks / yInterval).ceil() * yInterval + yInterval).toDouble();

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
                minX: 0,
                minY: 0,
                maxX: maxX,
                maxY: maxY,
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
                  horizontalInterval: yInterval,
                  verticalInterval: xInterval,
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
                      interval: yInterval,
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
                      maxIncluded:
                          (monthLabels.length - 1) % xInterval == 0 ||
                          monthLabels.length <= 10,
                      reservedSize: 28.h,
                      interval: xInterval,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        final int monthIndex = value.toInt();
                        if (monthIndex < 0 ||
                            monthIndex >= monthLabels.length) {
                          return const SizedBox.shrink();
                        }
                        return Padding(
                          padding: EdgeInsets.only(top: 8.h),
                          child: Text(
                            monthLabels[monthIndex],
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
                    spots: spots,
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

  Map<DateTime, int> aggregateLeaksByMonth(List<LeakModel> leaks) {
    final Map<DateTime, int> result = <DateTime, int>{};
    for (final leak in leaks) {
      final DateTime month = DateTime(leak.date.year, leak.date.month);
      result.update(month, (value) => value + 1, ifAbsent: () => 1);
    }
    return result;
  }

  List<DateTime> buildContinuousMonths(List<DateTime> sortedMonths) {
    if (sortedMonths.isEmpty) {
      return <DateTime>[];
    }

    final DateTime firstMonth = DateTime(
      sortedMonths.first.year,
      sortedMonths.first.month,
    );
    final DateTime lastMonth = DateTime(
      sortedMonths.last.year,
      sortedMonths.last.month,
    );

    final List<DateTime> result = <DateTime>[];
    DateTime cursor = firstMonth;
    while (!cursor.isAfter(lastMonth)) {
      result.add(cursor);
      cursor = DateTime(cursor.year, cursor.month + 1);
    }

    return result;
  }

  Map<int, int> aggregateLeaksByYear(List<LeakModel> leaks) {
    final Map<int, int> result = <int, int>{};
    for (final leak in leaks) {
      final int year = leak.date.year;
      result.update(year, (value) => value + 1, ifAbsent: () => 1);
    }
    return result;
  }
}
