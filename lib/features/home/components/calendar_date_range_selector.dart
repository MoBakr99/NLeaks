import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_font_weights.dart';

// TODO: Refactor this widget to follow the system design

class CalendarDateRangeSelector extends StatefulWidget {
  final Function(DateTime?, DateTime?) onDateRangeChanged;
  final DateTime? initialStartDate;
  final DateTime? initialEndDate;

  const CalendarDateRangeSelector({
    super.key,
    required this.onDateRangeChanged,
    this.initialStartDate,
    this.initialEndDate,
  });

  @override
  State<CalendarDateRangeSelector> createState() =>
      _CalendarDateRangeSelectorState();
}

class _CalendarDateRangeSelectorState extends State<CalendarDateRangeSelector> {
  late DateTime _currentMonth;
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _startDate = widget.initialStartDate ?? widget.initialEndDate;
    _endDate = widget.initialEndDate ?? widget.initialStartDate;
    _currentMonth = DateTime(
      _startDate?.year ?? now.year,
      _startDate?.month ?? now.month,
    );
  }

  void _updateDateRange(
    DateTime? start,
    DateTime? end, {
    bool jumpToStartMonth = false,
  }) {
    setState(() {
      _startDate = start;
      _endDate = end;
      if (jumpToStartMonth) {
        final monthSource = start ?? DateTime.now();
        _currentMonth = DateTime(monthSource.year, monthSource.month);
      }
    });
    widget.onDateRangeChanged(_startDate, _endDate);
  }

  void _setToday() {
    final now = DateTime.now();
    _updateDateRange(now, now, jumpToStartMonth: true);
  }

  void _setYesterday() {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    _updateDateRange(yesterday, yesterday, jumpToStartMonth: true);
  }

  void _setLastWeek() {
    final now = DateTime.now();
    final startOfThisWeek = now.subtract(Duration(days: now.weekday - 1));
    final startOfLastWeek = startOfThisWeek.subtract(const Duration(days: 7));
    final endOfLastWeek = startOfThisWeek.subtract(const Duration(days: 1));
    _updateDateRange(startOfLastWeek, endOfLastWeek, jumpToStartMonth: true);
  }

  void _setThisWeek() {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    _updateDateRange(startOfWeek, endOfWeek, jumpToStartMonth: true);
  }

  void _setThisMonth() {
    final now = DateTime.now();
    final firstDayOfMonth = DateTime(now.year, now.month, 1);
    final lastDayOfMonth = DateTime(now.year, now.month + 1, 0);
    _updateDateRange(firstDayOfMonth, lastDayOfMonth, jumpToStartMonth: true);
  }

  void _setLastMonth() {
    final now = DateTime.now();
    final firstDayOfLastMonth = DateTime(now.year, now.month - 1, 1);
    final lastDayOfLastMonth = DateTime(now.year, now.month, 0);
    _updateDateRange(
      firstDayOfLastMonth,
      lastDayOfLastMonth,
      jumpToStartMonth: true,
    );
  }

  void _setThisYear() {
    final now = DateTime.now();
    final firstDayOfYear = DateTime(now.year, 1, 1);
    final lastDayOfYear = DateTime(now.year, 12, 31);
    _updateDateRange(firstDayOfYear, lastDayOfYear, jumpToStartMonth: true);
  }

  void _setLastYear() {
    final now = DateTime.now();
    final firstDayOfLastYear = DateTime(now.year - 1, 1, 1);
    final lastDayOfLastYear = DateTime(now.year - 1, 12, 31);
    _updateDateRange(
      firstDayOfLastYear,
      lastDayOfLastYear,
      jumpToStartMonth: true,
    );
  }

  void _reset() {
    _updateDateRange(null, null, jumpToStartMonth: true);
  }

  void _previousMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
    });
  }

  bool _isDateInRange(DateTime date) {
    if (_startDate == null || _endDate == null) {
      return false;
    }

    final startDate = _startDate!;
    final endDate = _endDate!;
    final start = DateTime(startDate.year, startDate.month, startDate.day);
    final end = DateTime(endDate.year, endDate.month, endDate.day);
    final dayToCheck = DateTime(date.year, date.month, date.day);

    if (start.isAfter(end)) {
      return dayToCheck.isAfter(end) && dayToCheck.isBefore(start);
    } else {
      return dayToCheck.isAfter(start) && dayToCheck.isBefore(end);
    }
  }

  bool _isStartDate(DateTime date) {
    if (_startDate == null) {
      return false;
    }

    final startDate = _startDate!;
    return date.year == startDate.year &&
        date.month == startDate.month &&
        date.day == startDate.day;
  }

  bool _isEndDate(DateTime date) {
    if (_endDate == null) {
      return false;
    }

    final endDate = _endDate!;
    return date.year == endDate.year &&
        date.month == endDate.month &&
        date.day == endDate.day;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 426.w,
      height: 344.h,
      child: Container(
        decoration: BoxDecoration(
          color: informationColor,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Left sidebar with quick selection options
            _buildSidebar(),
            // Calendar
            Expanded(child: _buildCalendar()),
          ],
        ),
      ),
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: 140.w,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: onBackgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.r),
          bottomLeft: Radius.circular(16.r),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          _sidebarItem('Today', _setToday),
          SizedBox(height: 7.h),
          _sidebarItem('Yesterday', _setYesterday),
          SizedBox(height: 7.h),
          _sidebarItem('This week', _setThisWeek),
          SizedBox(height: 7.h),
          _sidebarItem('Last week', _setLastWeek),
          SizedBox(height: 7.h),
          _sidebarItem('This month', _setThisMonth),
          SizedBox(height: 7.h),
          _sidebarItem('Last month', _setLastMonth),
          SizedBox(height: 7.h),
          _sidebarItem('This year', _setThisYear),
          SizedBox(height: 7.h),
          _sidebarItem('Last year', _setLastYear),
          const Spacer(),
          GestureDetector(
            onTap: _reset,
            child: Text(
              'Reset',
              style: TextStyle(
                color: primaryColor,
                fontSize: 14.sp,
                fontWeight: FontWeight.normal.semibold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sidebarItem(String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        label,
        style: TextStyle(
          color: lightGrayColor,
          fontSize: 13.sp,
          fontWeight: FontWeight.normal.regular,
        ),
      ),
    );
  }

  Widget _buildCalendar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          // Month header with navigation
          _buildMonthHeader(),
          SizedBox(height: 10.h),
          // Day labels
          _buildDayLabels(),
          SizedBox(height: 8.h),
          // Calendar grid
          Expanded(child: _buildCalendarGrid()),
        ],
      ),
    );
  }

  Widget _buildMonthHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: _previousMonth,
          child: Container(
            width: 28.r,
            height: 28.r,
            decoration: BoxDecoration(
              color: onBackgroundColor,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(Icons.chevron_left, color: primaryColor, size: 18.sp),
          ),
        ),
        Text(
          _getMonthYear(),
          style: TextStyle(
            color: lightGrayColor,
            fontSize: 16.sp,
            fontWeight: FontWeight.normal.semibold,
          ),
        ),
        GestureDetector(
          onTap: _nextMonth,
          child: Container(
            width: 28.r,
            height: 28.r,
            decoration: BoxDecoration(
              color: onBackgroundColor,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(Icons.chevron_right, color: primaryColor, size: 18.sp),
          ),
        ),
      ],
    );
  }

  String _getMonthYear() {
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${months[_currentMonth.month - 1]} ${_currentMonth.year}';
  }

  Widget _buildDayLabels() {
    final dayLabels = ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'];
    return Row(
      children: dayLabels.map((day) {
        return Expanded(
          child: Center(
            child: Text(
              day,
              style: TextStyle(
                color: mutedGrayColor,
                fontSize: 12.sp,
                fontWeight: FontWeight.normal.medium,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCalendarGrid() {
    final firstDay = DateTime(_currentMonth.year, _currentMonth.month, 1);
    final lastDay = DateTime(_currentMonth.year, _currentMonth.month + 1, 0);
    final daysInMonth = lastDay.day;
    final leadingEmptyCells = firstDay.weekday - 1;
    final totalFilledCells = leadingEmptyCells + daysInMonth;
    final rowCount = (totalFilledCells / 7).ceil();
    final totalCells = rowCount * 7;

    return GridView.builder(
      primary: false,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: totalCells,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        crossAxisSpacing: 4.w,
        mainAxisSpacing: 4.h,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) {
        if (index < leadingEmptyCells ||
            index >= leadingEmptyCells + daysInMonth) {
          return const SizedBox.shrink();
        }

        final dayNumber = index - leadingEmptyCells + 1;
        final date = DateTime(
          _currentMonth.year,
          _currentMonth.month,
          dayNumber,
        );
        return _buildDateCell(date);
      },
    );
  }

  Widget _buildDateCell(DateTime date) {
    final isStart = _isStartDate(date);
    final isEnd = _isEndDate(date);
    final isInRange = _isDateInRange(date);

    Color backgroundColor = Colors.transparent;
    Color textColor = lightGrayColor;

    if (isStart || isEnd) {
      backgroundColor = primaryColor;
      textColor = informationColor;
    } else if (isInRange) {
      backgroundColor = primaryColor.withValues(alpha: 0.3);
      textColor = primaryColor;
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          if (_startDate == null || _endDate == null) {
            _startDate = date;
            _endDate = date;
          } else if (_startDate!.year == date.year &&
              _startDate!.month == date.month &&
              _startDate!.day == date.day) {
            _startDate = date;
          } else if (_endDate!.year == date.year &&
              _endDate!.month == date.month &&
              _endDate!.day == date.day) {
            _endDate = date;
          } else if (date.isBefore(_startDate!)) {
            _startDate = date;
          } else if (date.isAfter(_endDate!)) {
            _endDate = date;
          } else {
            _startDate = date;
            _endDate = date;
          }
        });
        widget.onDateRangeChanged(_startDate, _endDate);
      },
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Center(
          child: Text(
            date.day.toString(),
            style: TextStyle(
              color: textColor,
              fontSize: 13.sp,
              fontWeight: FontWeight.normal.semibold,
            ),
          ),
        ),
      ),
    );
  }
}
