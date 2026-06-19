import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:n_leaks/core/constants/app_colors.dart';
import 'package:n_leaks/core/controllers/token_controller.dart';
import 'package:n_leaks/core/services/api_service.dart';
import 'package:n_leaks/features/home/widgets/overview_card.dart';

class LeaksDashboardSection extends StatefulWidget {
  const LeaksDashboardSection({
    super.key,
    required this.totalUsers,
    required this.totalLeaks,
  });

  final int totalUsers;
  final int totalLeaks;

  @override
  State<LeaksDashboardSection> createState() => _LeaksDashboardSectionState();
}

class _LeaksDashboardSectionState extends State<LeaksDashboardSection> {
  Future<_DashboardSummary>? _summaryFuture;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _summaryFuture ??= _loadDashboardSummary();
  }

  Future<_DashboardSummary> _loadDashboardSummary() async {
    final response = await APIService().getLeaks(
      context.read<TokenController>().state!,
      limit: 1000,
    );
    return _DashboardSummary.fromResponse(
      rawLeaks: response.data['data'] as List<dynamic>,
      totalUsers: widget.totalUsers,
      totalLeaks: widget.totalLeaks,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_DashboardSummary>(
      future: _summaryFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final summary = snapshot.data!;
        return Column(
          spacing: 18.h,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 135.h,
              child: ListView.builder(
                itemCount: 3,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(left: index != 0 ? 20.w : 0),
                    child: OverviewCard(
                      cardTitle: [
                        'Total Users',
                        'Total Leaks',
                        'Critical Leaks',
                      ][index],
                      cardValue: [
                        summary.totalUsers,
                        summary.totalLeaks,
                        summary.criticalLeaks,
                      ][index],
                      cardIconPath: [
                        'assets/images/svgs/users_card_icon.svg',
                        'assets/images/svgs/warning_icon.svg',
                        'assets/images/svgs/danger_icon.svg',
                      ][index],
                      scaleUp: index == 0,
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: 120.h,
              child: ListView.builder(
                itemCount: 2,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(left: index != 0 ? 20.w : 0),
                    child: SizedBox(
                      width: 200.w,
                      child: _MetricTile(
                        title: ['Verified leaks', 'Unverified leaks'][index],
                        value: [
                          summary.verifiedLeaks.toString(),
                          summary.unverifiedLeaks.toString(),
                        ][index],
                        icon: [
                          Icons.verified_outlined,
                          Icons.pending_actions_outlined,
                        ][index],
                        accentColor: [safeColorFront, warningColorFront][index],
                      ),
                    ),
                  );
                },
              ),
            ),
            _DashboardCard(
              title: 'Severity breakdown',
              child: _SeverityChart(data: summary.leaksBySeverity),
            ),
            _DashboardCard(
              title: 'Top leak sources',
              child: _SourceBarChart(data: summary.leaksBySource),
            ),
            _DashboardCard(
              title: 'Leak trend by month',
              child: _MonthlyTrendChart(data: summary.leaksByMonth),
            ),
            _DashboardCard(
              title: 'Verification health',
              child: _VerificationTrend(
                verifiedRate: summary.verifiedRate,
                criticalRate: summary.criticalRate,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _LeakEntry {
  const _LeakEntry({
    required this.severity,
    required this.sourceName,
    required this.isVerified,
    required this.createdAt,
  });

  final String severity;
  final String sourceName;
  final bool isVerified;
  final DateTime createdAt;
}

class _DashboardSummary {
  const _DashboardSummary({
    required this.entries,
    required this.totalUsers,
    required this.totalLeaks,
    required this.criticalLeaks,
    required this.verifiedLeaks,
    required this.unverifiedLeaks,
    required this.leaksBySeverity,
    required this.leaksBySource,
    required this.leaksByMonth,
  });

  final List<_LeakEntry> entries;
  final int totalUsers;
  final int totalLeaks;
  final int criticalLeaks;
  final int verifiedLeaks;
  final int unverifiedLeaks;
  final Map<String, int> leaksBySeverity;
  final Map<String, int> leaksBySource;
  final Map<DateTime, int> leaksByMonth;

  factory _DashboardSummary.fromResponse({
    required List<dynamic> rawLeaks,
    required int totalUsers,
    required int totalLeaks,
  }) {
    final entries = rawLeaks
        .map(
          (dynamic leak) => _LeakEntry(
            severity: (leak['severity'] ?? 'unknown').toString(),
            sourceName: (leak['source']?['name'] ?? 'Unknown').toString(),
            isVerified: leak['isVerified'] == true,
            createdAt:
                DateTime.tryParse(
                  (leak['createdAt'] ?? leak['source']?['discoveredAt'])
                      .toString(),
                ) ??
                DateTime.now(),
          ),
        )
        .toList();

    final leaksBySeverity = <String, int>{};
    final leaksBySource = <String, int>{};
    final leaksByMonth = <DateTime, int>{};
    var criticalLeaks = 0;
    var verifiedLeaks = 0;

    for (final entry in entries) {
      leaksBySeverity.update(
        entry.severity,
        (value) => value + 1,
        ifAbsent: () => 1,
      );
      leaksBySource.update(
        entry.sourceName,
        (value) => value + 1,
        ifAbsent: () => 1,
      );
      final month = DateTime(entry.createdAt.year, entry.createdAt.month);
      leaksByMonth.update(month, (value) => value + 1, ifAbsent: () => 1);
      if (entry.severity == 'critical') {
        criticalLeaks++;
      }
      if (entry.isVerified) {
        verifiedLeaks++;
      }
    }

    return _DashboardSummary(
      entries: entries,
      totalUsers: totalUsers,
      totalLeaks: totalLeaks,
      criticalLeaks: criticalLeaks,
      verifiedLeaks: verifiedLeaks,
      unverifiedLeaks: totalLeaks - verifiedLeaks,
      leaksBySeverity: leaksBySeverity,
      leaksBySource: leaksBySource,
      leaksByMonth: leaksByMonth,
    );
  }

  double get verifiedRate => totalLeaks == 0 ? 0 : verifiedLeaks / totalLeaks;
  double get criticalRate => totalLeaks == 0 ? 0 : criticalLeaks / totalLeaks;
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.title,
    required this.value,
    required this.icon,
    required this.accentColor,
  });

  final String title;
  final String value;
  final IconData icon;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title, style: Theme.of(context).textTheme.titleSmall),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                value,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w700),
              ),
              // SizedBox(width: 12.w),
              Container(
                width: 48.w,
                height: 48.w,
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Icon(icon, color: accentColor, size: 24.sp),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  const _DashboardCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSurface,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.05),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          SizedBox(height: 16.h),
          child,
        ],
      ),
    );
  }
}

class _SeverityChart extends StatelessWidget {
  const _SeverityChart({required this.data});

  final Map<String, int> data;

  @override
  Widget build(BuildContext context) {
    final severityOrder = <String>['low', 'medium', 'high', 'critical'];
    final severityColors = <String, Color>{
      'low': safeColorFront,
      'medium': warningColorFront,
      'high': dangerColorFront,
      'critical': Theme.of(context).colorScheme.surface,
    };
    final sections = severityOrder
        .where((severity) => (data[severity] ?? 0) > 0)
        .map(
          (severity) => PieChartSectionData(
            color: severityColors[severity],
            value: (data[severity] ?? 0).toDouble(),
            radius: 70.r,
            title: '${data[severity]}',
            titleStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        )
        .toList();

    if (sections.isEmpty) {
      return const Center(child: Text('No severity data available.'));
    }

    return SizedBox(
      height: 220.h,
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 3,
            child: PieChart(
              PieChartData(
                sectionsSpace: 3,
                centerSpaceRadius: 40.r,
                sections: sections,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: severityOrder
                  .where((severity) => (data[severity] ?? 0) > 0)
                  .map(
                    (severity) => Padding(
                      padding: EdgeInsets.only(bottom: 10.h),
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: 12.w,
                            height: 12.w,
                            decoration: BoxDecoration(
                              color: severityColors[severity],
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: Text(
                              '${severity[0].toUpperCase()}${severity.substring(1)}',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                          Text(
                            '${data[severity]}',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _SourceBarChart extends StatelessWidget {
  const _SourceBarChart({required this.data});

  final Map<String, int> data;

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const Center(child: Text('No source data available.'));
    }

    final entries = data.entries.toList()
      ..sort((left, right) => right.value.compareTo(left.value));
    final topSources = entries.take(4).toList();
    final maxValue = topSources.fold<int>(
      0,
      (max, entry) => entry.value > max ? entry.value : max,
    );
    final colors = <Color>[
      Theme.of(context).colorScheme.primary,
      Theme.of(context).colorScheme.secondary,
      Theme.of(context).colorScheme.tertiary,
      Theme.of(context).colorScheme.surface,
    ];

    return SizedBox(
      height: 250.h,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: (maxValue + 1).toDouble(),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 1,
            getDrawingHorizontalLine: (value) => FlLine(
              color: Theme.of(
                context,
              ).colorScheme.tertiary.withValues(alpha: 0.12),
              strokeWidth: 1,
            ),
          ),
          borderData: FlBorderData(show: false),
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
                reservedSize: 28.w,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  if (value == 0 || value == maxValue.toDouble()) {
                    return Text(
                      value.toInt().toString(),
                      style: Theme.of(context).textTheme.labelMedium,
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 48.h,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index < 0 || index >= topSources.length) {
                    return const SizedBox.shrink();
                  }
                  return Padding(
                    padding: EdgeInsets.only(top: 8.h),
                    child: SizedBox(
                      width: 62.w,
                      child: Text(
                        topSources[index].key,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          barGroups: List<BarChartGroupData>.generate(topSources.length, (
            index,
          ) {
            final entry = topSources[index];
            return BarChartGroupData(
              x: index,
              barRods: <BarChartRodData>[
                BarChartRodData(
                  toY: entry.value.toDouble(),
                  width: 18.w,
                  borderRadius: BorderRadius.circular(8.r),
                  color: colors[index % colors.length],
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}

class _MonthlyTrendChart extends StatelessWidget {
  const _MonthlyTrendChart({required this.data});

  final Map<DateTime, int> data;

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const Center(child: Text('No monthly trend data available.'));
    }

    final months = data.keys.toList()
      ..sort((left, right) => left.compareTo(right));
    final spots = <FlSpot>[
      for (var index = 0; index < months.length; index++)
        FlSpot(index.toDouble(), data[months[index]]!.toDouble()),
    ];
    final maxValue = data.values.reduce(
      (left, right) => left > right ? left : right,
    );
    final labels = months
        .map(
          (month) => '${month.month.toString().padLeft(2, '0')}/${month.year}',
        )
        .toList();

    return SizedBox(
      height: 240.h,
      child: LineChart(
        LineChartData(
          minX: 0,
          maxX: months.length > 1 ? (months.length - 1).toDouble() : 1,
          minY: 0,
          maxY: (maxValue + 1).toDouble(),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 1,
            getDrawingHorizontalLine: (value) => FlLine(
              color: Theme.of(
                context,
              ).colorScheme.tertiary.withValues(alpha: 0.12),
              strokeWidth: 1,
            ),
          ),
          borderData: FlBorderData(show: false),
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
                reservedSize: 28.w,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  if (value == 0 || value == maxValue.toDouble()) {
                    return Text(
                      value.toInt().toString(),
                      style: Theme.of(context).textTheme.labelMedium,
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 44.h,
                interval: months.length <= 4
                    ? 1
                    : (months.length / 4).ceilToDouble(),
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index < 0 || index >= labels.length) {
                    return const SizedBox.shrink();
                  }
                  return Padding(
                    padding: EdgeInsets.only(top: 8.h),
                    child: Text(
                      labels[index],
                      style: Theme.of(context).textTheme.labelMedium,
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
              curveSmoothness: 0.35,
              barWidth: 3.w,
              color: Theme.of(context).colorScheme.primary,
              isStrokeCapRound: true,
              belowBarData: BarAreaData(
                show: true,
                color: Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: 0.12),
              ),
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) {
                  return FlDotCirclePainter(
                    radius: 4.r,
                    color: Theme.of(context).colorScheme.primary,
                    strokeWidth: 2.w,
                    strokeColor: Theme.of(context).colorScheme.surface,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VerificationTrend extends StatelessWidget {
  const _VerificationTrend({
    required this.verifiedRate,
    required this.criticalRate,
  });

  final double verifiedRate;
  final double criticalRate;

  @override
  Widget build(BuildContext context) {
    final verifiedPercent = (verifiedRate * 100).round();
    final criticalPercent = (criticalRate * 100).round();

    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: _StatRing(
                label: 'Verified',
                percent: verifiedRate,
                valueText: '$verifiedPercent%',
                color: safeColorFront,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _StatRing(
                label: 'Critical share',
                percent: criticalRate,
                valueText: '$criticalPercent%',
                color: dangerColorFront,
              ),
            ),
          ],
        ),
        SizedBox(height: 14.h),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Verified leaks help you prioritize confirmed exposure, while the critical share shows how much of the dataset needs immediate attention.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      ],
    );
  }
}

class _StatRing extends StatelessWidget {
  const _StatRing({
    required this.label,
    required this.percent,
    required this.valueText,
    required this.color,
  });

  final String label;
  final double percent;
  final String valueText;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 18.h),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        children: <Widget>[
          SizedBox(
            width: 88.w,
            height: 88.w,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                SizedBox(
                  width: 180.w,
                  height: 180.w,
                  child: CircularProgressIndicator(
                    value: percent,
                    strokeWidth: 10.w,
                    backgroundColor: color.withValues(alpha: 0.12),
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                  ),
                ),
                Text(
                  valueText,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10.h),
          Text(label, style: Theme.of(context).textTheme.titleSmall),
        ],
      ),
    );
  }
}
